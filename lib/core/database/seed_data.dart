import 'dart:convert';
import 'package:drift/drift.dart';
import 'app_database.dart';

class DatabaseSeeder {
  static Future<void> seedAll(AppDatabase db) async {
    await db.batch((batch) {
      // 1. Seed Comorbidities
      batch.insertAll(db.comorbiditiesTable, [
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_ckd',
          name: 'Chronic Kidney Disease (CKD)',
          contraindicatedDrugClasses: jsonEncode(['NSAID', 'Metformin']),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_dm',
          name: 'Type 2 Diabetes Mellitus',
          contraindicatedDrugClasses: jsonEncode([
            'Systemic Steroids',
            'Corticosteroids',
          ]),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_htn',
          name: 'Hypertension',
          contraindicatedDrugClasses: jsonEncode(['Decongestants', 'NSAID']),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_asthma',
          name: 'Bronchial Asthma',
          contraindicatedDrugClasses: jsonEncode([
            'Non-selective Beta Blockers',
            'Aspirin',
            'NSAID',
          ]),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_pregnant',
          name: 'Pregnancy',
          contraindicatedDrugClasses: jsonEncode([
            'Fluoroquinolones',
            'Tetracyclines',
            'ACE Inhibitors',
            'NSAID',
          ]),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_pud',
          name: 'Peptic Ulcer Disease',
          contraindicatedDrugClasses: jsonEncode([
            'NSAID',
            'Aspirin',
            'Systemic Steroids',
            'Corticosteroids',
          ]),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_cad',
          name: 'Coronary Artery Disease (CAD)',
          contraindicatedDrugClasses: jsonEncode(['NSAID']),
        ),
        ComorbiditiesTableCompanion.insert(
          id: 'comorb_copd',
          name: 'COPD',
          contraindicatedDrugClasses: jsonEncode([
            'Non-selective Beta Blockers',
            'Sedatives',
          ]),
        ),
      ], mode: InsertMode.insertOrReplace);

      // 2. Seed Presenting Complaints
      batch.insertAll(db.presentingComplaintsTable, [
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_fever',
          name: 'Fever',
          category: 'General',
          displayOrder: const Value(1),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_cough',
          name: 'Cough',
          category: 'RS',
          displayOrder: const Value(2),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_sob',
          name: 'Shortness of Breath',
          category: 'RS',
          displayOrder: const Value(3),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_chest_pain',
          name: 'Chest Pain',
          category: 'CVS',
          displayOrder: const Value(4),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_abd_pain',
          name: 'Abdominal Pain',
          category: 'GI',
          displayOrder: const Value(5),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_vomiting',
          name: 'Vomiting',
          category: 'GI',
          displayOrder: const Value(6),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_loose_stools',
          name: 'Loose Stools / Diarrhea',
          category: 'GI',
          displayOrder: const Value(7),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_dysuria',
          name: 'Dysuria (Burning Urination)',
          category: 'Renal',
          displayOrder: const Value(8),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_heartburn',
          name: 'Heartburn / Acid Regurgitation',
          category: 'GI',
          displayOrder: const Value(9),
        ),
        PresentingComplaintsTableCompanion.insert(
          id: 'pc_headache',
          name: 'Headache',
          category: 'CNS',
          displayOrder: const Value(10),
        ),
      ], mode: InsertMode.insertOrReplace);

      // 3. Seed Complaint Sub-Questions
      batch.insertAll(db.complaintSubQuestionsTable, [
        // Fever
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_fever_dur',
          complaintId: 'pc_fever',
          questionLabel: 'Duration',
          optionsJson: jsonEncode(['Custom...']),
          sentenceTemplate: const Value('Duration: {option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_fever_grade',
          complaintId: 'pc_fever',
          questionLabel: 'Grade / Type',
          optionsJson: jsonEncode([
            'Low grade',
            'High grade',
            'Intermittent with chills',
          ]),
          sentenceTemplate: const Value('{option} fever'),
          sequenceOrder: const Value(2),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_fever_assoc',
          complaintId: 'pc_fever',
          questionLabel: 'Associated Symptoms',
          optionsJson: jsonEncode([
            'Body aches',
            'Chills & rigors',
            'Sweating',
            'Headache',
          ]),
          sentenceTemplate: const Value('associated with {option}'),
          isMultiSelect: const Value(true),
          sequenceOrder: const Value(3),
        ),

        // Loose Stools
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_diarrhea_dur',
          complaintId: 'pc_loose_stools',
          questionLabel: 'Duration',
          optionsJson: jsonEncode(['Custom...']),
          sentenceTemplate: const Value('since {option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_diarrhea_freq',
          complaintId: 'pc_loose_stools',
          questionLabel: 'Frequency',
          optionsJson: jsonEncode([
            '2-3 episodes/day',
            '4-6 episodes/day',
            '>6 episodes/day',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(2),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_diarrhea_char',
          complaintId: 'pc_loose_stools',
          questionLabel: 'Consistency',
          optionsJson: jsonEncode(['Watery', 'Semi-solid', 'Mucoid', 'Bloody']),
          sentenceTemplate: const Value('{option} consistency'),
          sequenceOrder: const Value(3),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_diarrhea_cramps',
          complaintId: 'pc_loose_stools',
          questionLabel: 'Cramping',
          optionsJson: jsonEncode([
            'Mild cramping',
            'Severe colicky pain',
            'No cramps',
          ]),
          sentenceTemplate: const Value('with {option}'),
          sequenceOrder: const Value(4),
        ),

        // Vomiting
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_vomiting_freq',
          complaintId: 'pc_vomiting',
          questionLabel: 'Duration',
          optionsJson: jsonEncode(['Custom...']),
          sentenceTemplate: const Value('for {option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_vomiting_nature',
          complaintId: 'pc_vomiting',
          questionLabel: 'Content',
          optionsJson: jsonEncode([
            'Food particles',
            'Bilious/yellowish',
            'Watery non-bilious',
          ]),
          sentenceTemplate: const Value('{option} vomitus'),
          sequenceOrder: const Value(2),
        ),

        // Dysuria
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_dysuria_dur',
          complaintId: 'pc_dysuria',
          questionLabel: 'Duration',
          optionsJson: jsonEncode(['Custom...']),
          sentenceTemplate: const Value('for {option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_dysuria_assoc',
          complaintId: 'pc_dysuria',
          questionLabel: 'Associated Urinary Symptoms',
          optionsJson: jsonEncode([
            'Increased frequency',
            'Urgency',
            'Hesitancy',
            'Suprapubic pain',
          ]),
          sentenceTemplate: const Value('with {option}'),
          isMultiSelect: const Value(true),
          sequenceOrder: const Value(2),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_dysuria_hem',
          complaintId: 'pc_dysuria',
          questionLabel: 'Hematuria',
          optionsJson: jsonEncode([
            'No hematuria',
            'Pinkish tinge',
            'Frank blood',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(3),
        ),

        // Heartburn / APD
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_heartburn_time',
          complaintId: 'pc_heartburn',
          questionLabel: 'Timing / Trigger',
          optionsJson: jsonEncode([
            'After spicy meals',
            'Empty stomach (fasting)',
            'Night / recumbent',
          ]),
          sentenceTemplate: const Value('worse {option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_heartburn_rad',
          complaintId: 'pc_heartburn',
          questionLabel: 'Radiation',
          optionsJson: jsonEncode([
            'Retrosternal burning',
            'Throat irritation',
            'Localized epigastric',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(2),
        ),

        // Shortness of Breath (Asthma)
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_sob_onset',
          complaintId: 'pc_sob',
          questionLabel: 'Onset',
          optionsJson: jsonEncode([
            'Sudden onset',
            'Gradual worsening over days',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_sob_triggers',
          complaintId: 'pc_sob',
          questionLabel: 'Trigger Exposure',
          optionsJson: jsonEncode([
            'Cold air',
            'Dust / smoke',
            'Physical exertion',
            'Night exacerbation',
          ]),
          sentenceTemplate: const Value('triggered by {option}'),
          isMultiSelect: const Value(true),
          sequenceOrder: const Value(2),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_sob_wheeze',
          complaintId: 'pc_sob',
          questionLabel: 'Wheezing',
          optionsJson: jsonEncode([
            'Audible wheeze present',
            'Chest tightness without wheeze',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(3),
        ),

        // Cough
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_cough_type',
          complaintId: 'pc_cough',
          questionLabel: 'Cough Type',
          optionsJson: jsonEncode([
            'Dry irritating cough',
            'Productive / mucoid',
            'Yellowish sputum',
          ]),
          sentenceTemplate: const Value('{option}'),
          sequenceOrder: const Value(1),
        ),
        ComplaintSubQuestionsTableCompanion.insert(
          id: 'sq_cough_dur',
          complaintId: 'pc_cough',
          questionLabel: 'Duration',
          optionsJson: jsonEncode(['Custom...']),
          sentenceTemplate: const Value('for {option}'),
          sequenceOrder: const Value(2),
        ),
      ], mode: InsertMode.insertOrReplace);

      // 4. Seed Examination Systems
      batch.insertAll(db.examinationSystemsTable, [
        ExaminationSystemsTableCompanion.insert(
          id: 'sys_cvs',
          systemName: 'CVS',
          defaultNormalText: 'S1 S2 heard, regular rate & rhythm, no murmurs',
          abnormalFindingsJson: jsonEncode([
            'Tachycardia',
            'Bradycardia',
            'Systolic Murmur',
            'Muffled heart sounds',
          ]),
        ),
        ExaminationSystemsTableCompanion.insert(
          id: 'sys_rs',
          systemName: 'RS',
          defaultNormalText:
              'Bilateral Normal Vesicular Breath Sounds (NVBS), no added sounds',
          abnormalFindingsJson: jsonEncode([
            'Bilateral diffuse polyphonic wheeze',
            'Basal fine crepitations',
            'Coarse crackles',
            'Decreased air entry Right',
            'Decreased air entry Left',
            'Prolonged expiratory phase',
          ]),
        ),
        ExaminationSystemsTableCompanion.insert(
          id: 'sys_pa',
          systemName: 'Per Abdomen',
          defaultNormalText:
              'Soft, non-tender, normal bowel sounds, no organomegaly',
          abnormalFindingsJson: jsonEncode([
            'Mild epigastric tenderness',
            'Suprapubic tenderness',
            'Diffuse tenderness, hyperactive bowel sounds',
            'Guarding / rigidity present',
            'Right iliac fossa (McBurney) tenderness',
            'Renal angle tenderness',
          ]),
        ),
        ExaminationSystemsTableCompanion.insert(
          id: 'sys_cns',
          systemName: 'CNS',
          defaultNormalText:
              'Conscious, oriented to time, place, and person, no focal deficits',
          abnormalFindingsJson: jsonEncode([
            'Anxious / restless',
            'Lethargic / drowsy',
            'Neck stiffness / meningeal signs present',
            'Disoriented',
          ]),
        ),
      ], mode: InsertMode.insertOrReplace);

      // 5. Seed Diagnoses (5 Master Protocols)
      batch.insertAll(db.diagnosesTable, [
        DiagnosesTableCompanion.insert(
          id: 'diag_age',
          name: 'Acute Gastroenteritis',
          icd10Code: const Value('A09'),
          linkedComplaintIds: jsonEncode([
            'pc_loose_stools',
            'pc_vomiting',
            'pc_abd_pain',
            'pc_fever',
          ]),
        ),
        DiagnosesTableCompanion.insert(
          id: 'diag_urti',
          name: 'Viral Upper Respiratory Tract Infection (URTI)',
          icd10Code: const Value('J06.9'),
          linkedComplaintIds: jsonEncode([
            'pc_fever',
            'pc_cough',
            'pc_headache',
          ]),
        ),
        DiagnosesTableCompanion.insert(
          id: 'diag_uti',
          name: 'Acute Uncomplicated Urinary Tract Infection (UTI)',
          icd10Code: const Value('N30.0'),
          linkedComplaintIds: jsonEncode([
            'pc_dysuria',
            'pc_abd_pain',
            'pc_fever',
          ]),
        ),
        DiagnosesTableCompanion.insert(
          id: 'diag_apd',
          name: 'Acid Peptic Disease / GERD',
          icd10Code: const Value('K21.9'),
          linkedComplaintIds: jsonEncode([
            'pc_heartburn',
            'pc_abd_pain',
            'pc_vomiting',
          ]),
        ),
        DiagnosesTableCompanion.insert(
          id: 'diag_asthma',
          name: 'Bronchial Asthma (Acute Exacerbation)',
          icd10Code: const Value('J45.901'),
          linkedComplaintIds: jsonEncode(['pc_sob', 'pc_cough']),
        ),
      ], mode: InsertMode.insertOrReplace);

      // 6. Master Formulary Baseline (Connected to Supabase public.drugmaster)
      batch.insertAll(db.drugsTable, [
        DrugsTableCompanion.insert(
          id: 'a641c7b6-6be5-4e88-be6f-86cf21720e92',
          genericName: 'Ondansetron 4 mg Mouth dissolving Tab',
          brandName: 'ONDAR-MD Tab. [DPCO]',
          drugClass: 'Antiemetic',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'TID SOS',
          defaultDuration: '3 days',
          defaultInstructions:
              'Dissolve in mouth before food or vomiting episode',
        ),
        DrugsTableCompanion.insert(
          id: '9722420b-be6e-4337-91d7-cabc66a6516b',
          genericName: 'Ofloxacin 200mg',
          brandName: 'ROMBIFLOX-200 Tab.',
          drugClass: 'Fluoroquinolones / Antibiotic',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'BD',
          defaultDuration: '5 days',
          defaultInstructions: 'Take after food with plenty of water',
        ),
        DrugsTableCompanion.insert(
          id: 'f558a76a-030a-4d35-b61a-a8694409e0c7',
          genericName: 'Ibuprofen IP 400 mg, Paracetamol IP 325 mg',
          brandName: 'ACHO Tab.',
          drugClass: 'NSAID',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'SOS (Max TID)',
          defaultDuration: '3 days',
          defaultInstructions: 'Take after food only',
        ),
        DrugsTableCompanion.insert(
          id: 'eaea9d78-e25c-4763-89a2-87b82dca2913',
          genericName: 'Paracetamol I.P. 500mg, Dicyclomine Hcl I.P. 20mg',
          brandName: 'ANTICA Tab.',
          drugClass: 'Antispasmodic / Analgesic',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'BD SOS',
          defaultDuration: '3 days',
          defaultInstructions: 'For spasmodic abdominal pain after meals',
        ),
        DrugsTableCompanion.insert(
          id: '0f844e3a-88e5-43b9-b667-ea3bf54e8554',
          genericName:
              'Phenylephrine Hcl 5 mg, CPM 4mg, Paracetamol 500mg, Caffeine 30mg',
          brandName: 'LARY Tab.',
          drugClass: 'Antipyretic / Antihistamine',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'TID',
          defaultDuration: '5 days',
          defaultInstructions: 'Take after food for fever and body ache',
        ),
        DrugsTableCompanion.insert(
          id: '924e83b7-0ae8-4ea2-a609-4edb2d300812',
          genericName:
              'Ambroxol HCl 30 mg, Levosalbutamol 1 mg & Guaiphenasin 50 mg/5 ml',
          brandName: 'LARYBRO-LS Syrup',
          drugClass: 'Antitussive / Bronchodilator',
          defaultDose: '5 ml',
          defaultRoute: 'PO',
          defaultFrequency: 'TID',
          defaultDuration: '5 days',
          defaultInstructions: 'Take after food',
        ),
        DrugsTableCompanion.insert(
          id: 'f8edcd91-9060-468b-9aca-9a40a50a22ef',
          genericName: 'Azithromycin-500mg',
          brandName: 'AZIROM-500 Tab. [DPCO]',
          drugClass: 'Antibiotic',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD',
          defaultDuration: '3 days',
          defaultInstructions: 'Take 1 hour before or 2 hours after food',
        ),
        DrugsTableCompanion.insert(
          id: '2c48b8d4-f4f6-48ca-abf7-ee03e3d9e9e2',
          genericName: 'Pantoprazole 40mg + Domperidone 30mg SR',
          brandName: 'PENTRA-DSR Cap.',
          drugClass: 'Antacid',
          defaultDose: '1 cap',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '14 days',
          defaultInstructions:
              'Take 30 minutes before breakfast on empty stomach',
        ),
        DrugsTableCompanion.insert(
          id: 'f3171128-90ca-43d9-8a8c-a92a49ec34f5',
          genericName: 'Rabeprazole Sodi. 20mg',
          brandName: 'ROMBIPRA Tab.',
          drugClass: 'Antacid',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '14 days',
          defaultInstructions: 'Take before breakfast',
        ),
        DrugsTableCompanion.insert(
          id: '14f1c9d8-7bd1-405a-930e-196523d384e7',
          genericName: 'Atorvastatin 10 mg',
          brandName: 'ATOROM-10 Tab. [DPCO]',
          drugClass: 'Statin / Lipid Lowering',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD HS',
          defaultDuration: '30 days',
          defaultInstructions: 'Take at bedtime',
        ),
        DrugsTableCompanion.insert(
          id: 'a5203bab-3184-47af-bced-b4b00edc0110',
          genericName: 'Amlodipine Besylate 5mg',
          brandName: 'CARDIC-5 Tab. [DPCO]',
          drugClass: 'Antihypertensive',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '30 days',
          defaultInstructions: 'Take in the morning',
        ),
        DrugsTableCompanion.insert(
          id: 'a7e86ccd-a153-4f07-9187-293e2242000b',
          genericName: 'Atenolol IP 50mg, Amlodipine BP 5mg',
          brandName: 'CARDIC-AT Tab.',
          drugClass: 'Beta Blockers / Antihypertensive',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '30 days',
          defaultInstructions: 'Take in the morning',
        ),
        DrugsTableCompanion.insert(
          id: '9d82064c-e131-49d1-9a87-552f63a924c1',
          genericName: 'Clopidogrel 75mg',
          brandName: 'CLOPIROM-75 Tab. [DPCO]',
          drugClass: 'Antiplatelet',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD',
          defaultDuration: '30 days',
          defaultInstructions: 'Take after food',
        ),
        DrugsTableCompanion.insert(
          id: '522359aa-45d6-4796-94ca-2e20eea0abca',
          genericName: 'Losartan Potassium 50mg, Hydrochlorothiazide 12.5mg',
          brandName: 'LOZIROM-H Tab.',
          drugClass: 'ACE Inhibitors / Antihypertensive',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '30 days',
          defaultInstructions: 'Take in the morning',
        ),
        DrugsTableCompanion.insert(
          id: 'c06a8dc2-0edd-4f8c-a904-447836fa409b',
          genericName: 'Metoprolol Succinate 25mg',
          brandName: 'METOROM-XL 25  Tab.',
          drugClass: 'Beta Blockers',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '30 days',
          defaultInstructions: 'Take with or after breakfast',
        ),
        DrugsTableCompanion.insert(
          id: '8c946ae3-4030-4565-81fc-0f1f915f38b4',
          genericName: 'Diclofenac Sodium 50mg, Paracetamol 325 mg, Serratiopeptidase 15mg',
          brandName: 'DAC-SP Tab.',
          drugClass: 'NSAID / Analgesic',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'BD',
          defaultDuration: '5 days',
          defaultInstructions: 'Take after food',
        ),
        DrugsTableCompanion.insert(
          id: 'ce6e4c6a-f0eb-4395-841b-3ffd7284e592',
          genericName: 'Pantoprazole-40mg',
          brandName: 'PENTRA-40 Tab.',
          drugClass: 'Antacid',
          defaultDose: '1 tab',
          defaultRoute: 'PO',
          defaultFrequency: 'OD Morning',
          defaultDuration: '14 days',
          defaultInstructions: 'Take 30 minutes before breakfast',
        ),
      ], mode: InsertMode.insertOrReplace);

      // 7. Seed Prescription Protocols (Mapped to Supabase Master Formulary)
      batch.insertAll(db.prescriptionProtocolsTable, [
        // Protocol 1: Acute Gastroenteritis
        PrescriptionProtocolsTableCompanion.insert(
          id: 'proto_age',
          diagnosisId: 'diag_age',
          protocolItemsJson: jsonEncode([
            {'drugId': 'a641c7b6-6be5-4e88-be6f-86cf21720e92'}, // ONDAR-MD Tab. (Ondansetron 4mg)
            {'drugId': '9722420b-be6e-4337-91d7-cabc66a6516b'}, // ROMBIFLOX-200 Tab. (Ofloxacin 200mg)
            {
              'drugId': 'f558a76a-030a-4d35-b61a-a8694409e0c7', // ACHO Tab. (Ibuprofen + Paracetamol - NSAID)
              'doseOverride': '1 tab SOS',
              'instructionsOverride':
                  'Take only for severe pain or fever after meals',
            },
            {
              'drugId': 'eaea9d78-e25c-4763-89a2-87b82dca2913', // ANTICA Tab. (Paracetamol + Dicyclomine)
              'doseOverride': '1 tab SOS',
              'instructionsOverride':
                  'Take only for severe cramping spasms after meals',
            },
          ]),
          generalAdvice: const Value(
            'Hydrate well with ORS, coconut water, and rice kanji. Bland diet (curd rice, bananas, toast). Strictly avoid dairy milk, spicy, and outside food. Return immediately if inability to retain liquids, severe dehydration, or high fever.',
          ),
        ),

        // Protocol 2: Viral Fever / URTI
        PrescriptionProtocolsTableCompanion.insert(
          id: 'proto_urti',
          diagnosisId: 'diag_urti',
          protocolItemsJson: jsonEncode([
            {'drugId': '0f844e3a-88e5-43b9-b667-ea3bf54e8554'}, // LARY Tab. (Paracetamol + CPM + Phenylephrine)
            {'drugId': '924e83b7-0ae8-4ea2-a609-4edb2d300812'}, // LARYBRO-LS Syrup (Ambroxol + Levosalbutamol + Guaiphenesin)
            {'drugId': 'f8edcd91-9060-468b-9aca-9a40a50a22ef'}, // AZIROM-500 Tab. (Azithromycin 500mg)
          ]),
          generalAdvice: const Value(
            'Warm saline gargles 3-4 times daily. Steam inhalation twice daily. Adequate bed rest and oral hydration. Monitor temperature every 6 hours.',
          ),
        ),

        // Protocol 3: Uncomplicated UTI
        PrescriptionProtocolsTableCompanion.insert(
          id: 'proto_uti',
          diagnosisId: 'diag_uti',
          protocolItemsJson: jsonEncode([
            {'drugId': '9722420b-be6e-4337-91d7-cabc66a6516b'}, // ROMBIFLOX-200 Tab. (Ofloxacin 200mg)
            {
              'drugId': 'eaea9d78-e25c-4763-89a2-87b82dca2913', // ANTICA Tab. (Paracetamol + Dicyclomine)
              'doseOverride': '1 tab SOS',
              'instructionsOverride': 'For pelvic pain or fever',
            },
          ]),
          generalAdvice: const Value(
            'Drink minimum 3 to 4 liters of water daily. Do not suppress or delay urination. Urinate post-coitus. Complete full 5-day antibiotic course even if symptoms subside earlier.',
          ),
        ),

        // Protocol 4: Acid Peptic Disease / GERD
        PrescriptionProtocolsTableCompanion.insert(
          id: 'proto_apd',
          diagnosisId: 'diag_apd',
          protocolItemsJson: jsonEncode([
            {'drugId': '2c48b8d4-f4f6-48ca-abf7-ee03e3d9e9e2'}, // PENTRA-DSR Cap. (Pantoprazole + Domperidone)
            {'drugId': 'f3171128-90ca-43d9-8a8c-a92a49ec34f5'}, // ROMBIPRA Tab. (Rabeprazole 20mg)
          ]),
          generalAdvice: const Value(
            'Small, frequent meals on fixed timings. Avoid spicy, citrus, coffee, tea, and deep-fried foods. Avoid lying down for 2 hours post meals. Elevate head end of bed by 6 inches.',
          ),
        ),

        // Protocol 5: Acute Exacerbation of Bronchial Asthma
        PrescriptionProtocolsTableCompanion.insert(
          id: 'proto_asthma',
          diagnosisId: 'diag_asthma',
          protocolItemsJson: jsonEncode([
            {'drugId': '924e83b7-0ae8-4ea2-a609-4edb2d300812'}, // LARYBRO-LS Syrup (Ambroxol + Levosalbutamol + Guaiphenesin)
          ]),
          generalAdvice: const Value(
            'Use inhaler strictly with a spacer. Always rinse mouth thoroughly after steroid inhaler to prevent candidiasis. Avoid known triggers (dust, smoke, cold air). Visit Emergency Room immediately if acute breathlessness worsens or chest tightness is severe.',
          ),
        ),
      ], mode: InsertMode.insertOrReplace);
    });
  }
}
