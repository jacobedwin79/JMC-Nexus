import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/config/clinic_settings.dart';
import '../domain/clinical_models.dart';
import '../domain/encounter_state.dart';
import '../domain/gemini_scribe_models.dart';

class GeminiScribeService {
  final String apiKey;
  final String modelName;

  GeminiScribeService({
    required this.apiKey,
    this.modelName = kDefaultGeminiModel,
  });

  /// Processes either multimodal audio bytes OR text dictation into an incremental EMR update
  Future<GeminiScribeResult> processClinicalDictation({
    Uint8List? audioBytes,
    String? audioMimeType,
    String? textDictation,
    required EncounterState currentState,
    List<ComorbidityModel> comorbiditiesCatalog = const [],
    List<DiagnosisModel> diagnosesCatalog = const [],
    List<DrugModel> drugsCatalog = const [],
  }) async {
    if (apiKey.trim().isEmpty) {
      throw StateError(
        'Gemini API key is not configured. Please add your Gemini API key in Clinic Settings.',
      );
    }

    if ((audioBytes == null || audioBytes.isEmpty) &&
        (textDictation == null || textDictation.trim().isEmpty)) {
      throw ArgumentError('Either audioBytes or textDictation must be provided.');
    }

    final patient = currentState.activePatient;
    final patientInfo = StringBuffer();
    if (patient != null) {
      patientInfo.writeln('PATIENT PROFILE:');
      patientInfo.writeln('- Name: ${patient.patientName}');
      final ageCategory = patient.calculatedAge < 12
          ? 'Paediatric'
          : (patient.calculatedAge >= 65 ? 'Geriatric' : 'Adult');
      patientInfo.writeln(
          '- Age: ${patient.calculatedAge} years ($ageCategory, dynamic: ${patient.dynamicAgeDisplay})');
      patientInfo.writeln('- Gender: ${patient.gender}');
      patientInfo.writeln('- Pregnant: ${currentState.isPregnant ? "YES" : "NO"}');
      patientInfo.writeln('- Known Allergies: ${currentState.allergies.isEmpty ? "None recorded" : currentState.allergies.join(", ")}');
      patientInfo.writeln('- Selected Comorbidities: ${currentState.selectedComorbidityIds.isEmpty ? "None" : currentState.selectedComorbidityIds.join(", ")}');
    }

    // Build Current State snapshot (the existing pieces of the puzzle)
    final existingState = StringBuffer();
    existingState.writeln('EXISTING ENCOUNTER STATE (Merge new dictation into this; DO NOT ERASE):');
    existingState.writeln('- Current Complaints: ${currentState.selectedComplaints.values.map((c) => "${c.complaintName}: ${c.compiledProse}").toList()}');
    existingState.writeln('- Current Exam States: ${currentState.examStates.values.map((e) => "${e.systemName}: isNormal=${e.isNormal}, findings=${e.selectedAbnormals}, note=${e.compiledText}").toList()}');
    existingState.writeln('- Current Diagnoses: ${currentState.selectedDiagnosisIds}');
    existingState.writeln('- Current Prescriptions: ${currentState.activePrescription.map((p) => "${p.brandName} (${p.genericName}) ${p.dose} ${p.frequency} x ${p.duration}").toList()}');
    existingState.writeln('- Current Investigations: ${currentState.investigations}');
    existingState.writeln('- Current General Advice: "${currentState.generalAdvice}"');
    existingState.writeln('- Current Follow-up Days: ${currentState.followUpDays}');

    final promptText = '''
You are the JMC Nexus AI Clinical Scribe & Medical Safety Co-Pilot for an Indian Outpatient Clinic (OPD).
The consulting doctor is dictating clinical observations incrementally (like sending WhatsApp voice notes during the consultation).

$patientInfo

$existingState

CLINICAL CATALOG CODES REFERENCE:
- Common Diagnoses: diag_urti (Viral URTI), diag_age (Acute Gastroenteritis), diag_uti (Acute UTI), diag_apd (Acid Peptic Disease/GERD), diag_asthma (Bronchial Asthma), diag_allergic_rhinitis (Allergic Rhinitis), diag_acute_pharyngitis (Acute Pharyngitis/Tonsillitis), diag_acute_bronchitis (Acute Bronchitis), diag_migraine (Migraine), diag_mechanical_lbp (Low Back Strain), diag_acute_urticaria (Urticaria), diag_acute_conjunctivitis (Conjunctivitis), diag_t2dm (Type 2 DM), diag_essential_htn (Hypertension), diag_osteoarthritis_knee (Knee OA).
- Common Drugs: drug_pcm_650 (Tab. Dolo 650, Paracetamol 650mg, Analgesic), drug_pan_d (Cap. Pan-D, Pantoprazole+Domperidone, PPI), drug_levocet_mont (Tab. Monticope, Levocetirizine+Montelukast, Antihistamine), drug_cough_syp (Syp. Ascoril-D, Antitussive), drug_vit_c_zinc (Tab. Limcee, Vitamin C+Zinc), drug_ondansetron (Tab. Emeset 4mg, Ondansetron), drug_oflox_oz (Tab. Oflox-OZ, Ofloxacin+Ornidazole), drug_dicyclomine_pcm (Tab. Meftal-Spas, Dicyclomine+PCM, NSAID), drug_ors (Oral Rehydration Salts), drug_probiotic (Cap. Vizylac), drug_nitrofurantoin (Tab. Martifur-MR), drug_citrate_alkalizer (Syp. Citralka), drug_duolin_resp (Duolin Respules), drug_foracort_200 (Foracort 200 Inhaler), drug_prednisolone_20 (Tab. Omnacortil 20).
- Exam System IDs: sys_cvs (CVS), sys_rs (RS), sys_pa (Per Abdomen), sys_cns (CNS), sys_ent (ENT), sys_eye (Eye), sys_msk (Musculoskeletal/Spine), sys_skin (Skin).
- Safety Matrix Rules:
  * CKD contraindicates NSAIDs (Meftal-Spas, Diclofenac, Ibuprofen) & Metformin.
  * Peptic Ulcer Disease (PUD) contraindicates NSAIDs & Systemic Steroids.
  * Asthma contraindicates Non-selective Beta Blockers & NSAIDs/Aspirin.
  * Pregnancy contraindicates Fluoroquinolones (Ofloxacin, Ciprofloxacin), Tetracyclines, ACE inhibitors, and NSAIDs.
  * Liver Cirrhosis contraindicates High-dose Paracetamol (> 2g/day) & NSAIDs.
  * Drug-Drug Interactions: Beware duplicate NSAIDs, combined CNS depressants, or QT-prolonging drugs.

${textDictation != null ? 'DOCTOR TEXT DICTATION:\n"""\n$textDictation\n"""' : 'DOCTOR AUDIO NOTE: Please listen to the provided audio file.'}

YOUR TASK:
1. INCREMENTAL SYNTHESIS ("Put all the puzzles together"):
   - Accurately transcribe what the doctor said in "transcript".
   - Merge the new dictation with the existing encounter state.
   - PRESERVE existing valid complaints, exams, diagnoses, and prescriptions unless the doctor explicitly corrects or cancels them.
   - Format any newly mentioned complaints with prose, exam findings under the appropriate system ID, diagnoses with ICD-10 if known, medications with dose/route/frequency/duration/instructions, investigations (e.g. CBC, RBS, Urine Routine, X-Ray), advice, and follow-up days.
   - For medications: Map to our clinic formulary drugs whenever recognizable.

2. CLINICAL SAFETY & DRUG INTERACTION ANALYSIS:
   - Thoroughly screen the accumulated prescription for:
     a) Contraindications with patient's comorbidities (e.g. NSAID given to patient with CKD, PUD, or Pregnancy).
     b) Patient's recorded allergies.
     c) Drug-Drug Interactions (e.g. duplicate analgesic classes, sedatives).
     d) Age precautions (Paediatric dosing check, Geriatric cautions).
   - In "safetyAlerts", output any detected concerns with severity ("critical", "warning", or "info"), a concise "title", and actionable "message".

OUTPUT FORMAT:
Return strictly a JSON object matching this schema:
{
  "transcript": "Verbatim transcript of this voice note",
  "clinicalSummary": "1-sentence summary of what was added or updated",
  "complaints": [
    {
      "complaintId": "pc_fever",
      "complaintName": "Fever",
      "compiledProse": "High grade fever since 3 days"
    }
  ],
  "examFindings": [
    {
      "systemId": "sys_ent",
      "isNormal": false,
      "abnormalFindings": ["Congested posterior pharyngeal wall"],
      "compiledText": "Throat congested with tonsillar erythema"
    }
  ],
  "diagnoses": [
    {
      "diagnosisId": "diag_acute_pharyngitis",
      "diagnosisName": "Acute Pharyngitis",
      "icd10Code": "J02.9"
    }
  ],
  "prescription": [
    {
      "drugId": "drug_pcm_650",
      "brandName": "Tab. Dolo 650",
      "genericName": "Paracetamol",
      "drugClass": "Analgesic",
      "dose": "650 mg",
      "route": "PO",
      "frequency": "TID SOS",
      "duration": "5 days",
      "instructions": "Take after food for fever > 100°F"
    }
  ],
  "investigations": ["CBC", "CRP"],
  "generalAdvice": "Warm saline gargles 4 times daily. Drink warm fluids.",
  "followUpDays": 3,
  "safetyAlerts": [
    {
      "severity": "critical|warning|info",
      "category": "drug_interaction|comorbidity_conflict|age_precaution|allergy_conflict",
      "title": "Short title",
      "message": "Clear clinical safety explanation"
    }
  ]
}
''';

    final List<Part> contentParts = [];
    if (audioBytes != null && audioBytes.isNotEmpty) {
      contentParts.add(DataPart(audioMimeType ?? 'audio/m4a', audioBytes));
    }
    contentParts.add(TextPart(promptText));

    final candidateModels = {
      if (modelName.trim().isNotEmpty &&
          !kRetiredGeminiModels.contains(modelName.trim()))
        modelName.trim(),
      kDefaultGeminiModel,
      'gemini-3.5-flash-lite',
      'gemini-3.1-flash-lite',
      'gemini-2.5-flash-lite',
    }.toList();

    GenerateContentResponse? response;
    dynamic lastError;

    for (final candidate in candidateModels) {
      try {
        final model = GenerativeModel(
          model: candidate,
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.2,
          ),
        );

        final res = await model.generateContent([
          Content.multi(contentParts),
        ]);

        if (res.text != null && res.text!.trim().isNotEmpty) {
          response = res;
          break;
        }
      } catch (e) {
        lastError = e;
        final errStr = e.toString().toLowerCase();
        debugPrint('Gemini attempt with $candidate failed: $e');

        if (errStr.contains('402') || errStr.contains('payment required')) {
          throw StateError(
            'Google AI API (HTTP 402): Payment/Billing required or free quota exhausted on this project. Visit https://aistudio.google.com to verify your tier or billing.',
          );
        }

        // If not found (404) or unsupported on v1beta, proceed to next candidate
        if (errStr.contains('not found') ||
            errStr.contains('not supported') ||
            errStr.contains('404')) {
          continue;
        }
      }
    }

    if (response == null ||
        response.text == null ||
        response.text!.trim().isEmpty) {
      throw StateError(
        'Gemini could not generate a response with any available model '
        '(${candidateModels.join(", ")}). This usually means the API key is '
        'invalid, the Generative Language API is not enabled for the key\'s '
        'project, or the models are unavailable in your region. '
        'Last error: $lastError',
      );
    }

    final rawText = response.text;
    if (rawText == null || rawText.trim().isEmpty) {
      throw StateError('Gemini returned an empty response.');
    }

    // Clean up codeblock markers if present
    String cleanJson = rawText.trim();
    if (cleanJson.startsWith('```json')) {
      cleanJson = cleanJson.substring(7);
    } else if (cleanJson.startsWith('```')) {
      cleanJson = cleanJson.substring(3);
    }
    if (cleanJson.endsWith('```')) {
      cleanJson = cleanJson.substring(0, cleanJson.length - 3);
    }
    cleanJson = cleanJson.trim();

    try {
      final decoded = jsonDecode(cleanJson) as Map<String, dynamic>;
      return GeminiScribeResult.fromJson(decoded);
    } catch (e) {
      debugPrint('Gemini JSON decode error: $e\nRaw: $rawText');
      throw FormatException('Failed to parse Gemini clinical scribe response: $e');
    }
  }
}
