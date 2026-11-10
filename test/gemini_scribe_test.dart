import 'package:flutter_test/flutter_test.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/encounter/domain/encounter_state.dart';
import 'package:jmc_nexus/features/encounter/domain/gemini_scribe_models.dart';
import 'package:jmc_nexus/features/encounter/domain/patient_queue_item.dart';

void main() {
  group('Gemini Voice Scribe & EMR Multi-turn Synthesis', () {
    test('GeminiScribeResult parses structured response and safety alerts', () {
      final json = {
        'transcript': 'Patient has high grade fever 3 days, give Dolo 650 TDS',
        'clinicalSummary': 'Recorded fever and prescribed Dolo 650',
        'complaints': [
          {
            'complaintId': 'pc_fever',
            'complaintName': 'Fever',
            'compiledProse': 'High grade fever since 3 days',
          }
        ],
        'examFindings': [
          {
            'systemId': 'sys_ent',
            'isNormal': false,
            'abnormalFindings': ['Congested posterior pharyngeal wall'],
            'compiledText': 'Throat congested',
          }
        ],
        'diagnoses': [
          {
            'diagnosisId': 'diag_urti',
            'diagnosisName': 'Viral URTI',
            'icd10Code': 'J06.9',
          }
        ],
        'prescription': [
          {
            'drugId': 'drug_pcm_650',
            'brandName': 'Tab. Dolo 650',
            'genericName': 'Paracetamol',
            'drugClass': 'Analgesic',
            'dose': '650 mg',
            'route': 'PO',
            'frequency': 'TID SOS',
            'duration': '5 days',
            'instructions': 'After food for fever',
          }
        ],
        'investigations': ['CBC'],
        'generalAdvice': 'Warm saline gargles',
        'followUpDays': 3,
        'safetyAlerts': [
          {
            'severity': 'warning',
            'category': 'comorbidity_conflict',
            'title': 'Comorbidity Caution',
            'message': 'Patient has known CKD; avoid co-prescribing NSAIDs.',
          }
        ],
      };

      final result = GeminiScribeResult.fromJson(json);

      expect(result.transcript, contains('high grade fever'));
      expect(result.complaints.length, 1);
      expect(result.complaints.first.complaintId, 'pc_fever');
      expect(result.exams.length, 1);
      expect(result.exams.first.systemId, 'sys_ent');
      expect(result.diagnoses.length, 1);
      expect(result.diagnoses.first.diagnosisId, 'diag_urti');
      expect(result.prescriptions.length, 1);
      expect(result.prescriptions.first.brandName, 'Tab. Dolo 650');
      expect(result.investigations, ['CBC']);
      expect(result.followUpDays, 3);
      expect(result.safetyAlerts.length, 1);
      expect(result.safetyAlerts.first.severity, AiAlertSeverity.warning);
    });

    test('Incremental synthesis puts all puzzles together without wiping data', () {
      // 1. Initial Encounter State (Patient with existing complaint from Voice Note 1)
      var encounter = EncounterState(
        activePatient: PatientQueueItem(
          id: 'q_1',
          tokenNumber: 1,
          patientName: 'Kavitha Nair',
          age: 45,
          gender: 'F',
          entryTime: DateTime.now(),
        ),
        selectedComplaints: {
          'pc_fever': const SelectedComplaintState(
            complaintId: 'pc_fever',
            complaintName: 'Fever',
            compiledProse: 'High grade fever since 3 days',
          ),
        },
        selectedDiagnosisIds: ['diag_urti'],
        activePrescription: [
          const PrescriptionItemModel(
            drugId: 'drug_pcm_650',
            brandName: 'Tab. Dolo 650',
            genericName: 'Paracetamol',
            drugClass: 'Analgesic',
            dose: '650 mg',
            route: 'PO',
            frequency: 'TID SOS',
            duration: '5 days',
            instructions: 'After food',
          ),
        ],
      );

      // 2. Doctor sends Voice Note 2: Exam findings + Antibiotic + Advice
      final voiceNote2Result = GeminiScribeResult(
        transcript: 'Throat is congested with tonsillar exudates, add Monticope at bedtime and warm gargles',
        clinicalSummary: 'Added ENT exam findings and Monticope',
        exams: [
          const AiParsedExam(
            systemId: 'sys_ent',
            isNormal: false,
            abnormalFindings: ['Congested posterior pharyngeal wall'],
            compiledText: 'Throat congested with tonsillar exudates',
          ),
        ],
        prescriptions: [
          const PrescriptionItemModel(
            drugId: 'drug_levocet_mont',
            brandName: 'Tab. Monticope',
            genericName: 'Levocetirizine + Montelukast',
            drugClass: 'Antihistamine',
            dose: '5/10 mg',
            route: 'PO',
            frequency: 'OD HS',
            duration: '5 days',
            instructions: 'At bedtime',
          ),
        ],
        generalAdvice: 'Warm saline gargles 4 times daily.',
        followUpDays: 5,
      );

      // Merge Voice Note 2 into Encounter State
      final updatedComplaints = Map<String, SelectedComplaintState>.from(encounter.selectedComplaints);
      final updatedExams = Map<String, ExamSystemState>.from(encounter.examStates);
      for (final e in voiceNote2Result.exams) {
        updatedExams[e.systemId] = ExamSystemState(
          systemId: e.systemId,
          systemName: 'ENT',
          isNormal: e.isNormal,
          selectedAbnormals: e.abnormalFindings,
          compiledText: e.compiledText,
        );
      }

      final updatedRx = List<PrescriptionItemModel>.from(encounter.activePrescription);
      for (final rx in voiceNote2Result.prescriptions) {
        if (!updatedRx.any((p) => p.drugId == rx.drugId)) {
          updatedRx.add(rx);
        }
      }

      encounter = encounter.copyWith(
        selectedComplaints: updatedComplaints,
        examStates: updatedExams,
        activePrescription: updatedRx,
        generalAdvice: voiceNote2Result.generalAdvice ?? '',
        followUpDays: voiceNote2Result.followUpDays,
      );

      // Verify that BOTH Note 1 and Note 2 data are preserved together!
      expect(encounter.selectedComplaints.containsKey('pc_fever'), isTrue);
      expect(encounter.examStates.containsKey('sys_ent'), isTrue);
      expect(encounter.examStates['sys_ent']?.isNormal, isFalse);
      expect(encounter.activePrescription.length, 2);
      expect(encounter.activePrescription[0].brandName, 'Tab. Dolo 650');
      expect(encounter.activePrescription[1].brandName, 'Tab. Monticope');
      expect(encounter.generalAdvice, contains('Warm saline gargles'));
      expect(encounter.followUpDays, 5);
    });
  });
}

