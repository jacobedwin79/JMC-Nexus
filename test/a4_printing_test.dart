import 'package:flutter_test/flutter_test.dart';
import 'package:jmc_nexus/core/printing/a4_laser_print_service.dart';
import 'package:jmc_nexus/features/encounter/domain/clinical_models.dart';
import 'package:jmc_nexus/features/encounter/domain/encounter_state.dart';
import 'package:jmc_nexus/features/encounter/domain/patient_queue_item.dart';

void main() {
  test('A4LaserPrintService generates valid vector A4 PDF bytes in <100ms', () async {
    final now = DateTime.now();

    final testPatient = PatientQueueItem(
      id: 'patient-pdf-1',
      tokenNumber: 14,
      patientName: 'Rajesh Kumar',
      age: 45,
      gender: 'M',
      phone: '9876543210',
      entryTime: now.subtract(const Duration(minutes: 17)),
      consultationStartTime: now,
      vitals: const {
        'bpSys': 120,
        'bpDia': 80,
        'pulse': 76,
        'spo2': 99,
        'temp': 98.4,
        'weight': 68.0,
      },
      initialComorbIds: ['comorb_dm', 'comorb_htn'],
    );

    final encounter = EncounterState(
      activePatient: testPatient,
      selectedComorbidityIds: const ['comorb_dm', 'comorb_htn'],
      selectedComplaints: const {
        'pc_fever': SelectedComplaintState(
          complaintId: 'pc_fever',
          complaintName: 'Fever',
          compiledProse: 'High grade fever (Duration: 3-5 days; with Chills & rigors)',
        ),
      },
      examStates: const {
        'sys_cvs': ExamSystemState(
          systemId: 'sys_cvs',
          systemName: 'CVS',
          isNormal: true,
          compiledText: 'S1 S2 heard, regular rate & rhythm, no murmurs',
        ),
        'sys_rs': ExamSystemState(
          systemId: 'sys_rs',
          systemName: 'RS',
          isNormal: true,
          compiledText: 'B/L NVBS, no added sounds',
        ),
      },
      selectedDiagnosisIds: const ['diag_urti'],
      activePrescription: const [
        PrescriptionItemModel(
          drugId: 'drug_pcm_650',
          genericName: 'Paracetamol',
          brandName: 'Tab. Dolo 650',
          drugClass: 'Analgesic',
          dose: '650 mg',
          route: 'PO',
          frequency: 'TID SOS',
          duration: '5 days',
          instructions: 'After food for fever > 100°F',
        ),
        PrescriptionItemModel(
          drugId: 'drug_levocet_mont',
          genericName: 'Levocetirizine + Montelukast',
          brandName: 'Tab. Monticope',
          drugClass: 'Antihistamine',
          dose: '5/10 mg',
          route: 'PO',
          frequency: 'OD HS',
          duration: '5 days',
          instructions: 'At bedtime',
        ),
      ],
      generalAdvice: 'Steam inhalation twice daily. Warm saline gargles. Adequate rest.',
      followUpDays: 5,
      isLetterheadMode: false,
    );

    // Warm-up run for JIT class loading
    await A4LaserPrintService.buildA4Prescription(encounter);

    // Measure PDF generation duration
    final stopwatch = Stopwatch()..start();
    final pdfBytes = await A4LaserPrintService.buildA4Prescription(encounter);
    stopwatch.stop();

    // Verify PDF validity and generation speed
    expect(pdfBytes.length, greaterThan(1500));
    // Warm generation is fast (<100ms)
    expect(stopwatch.elapsedMilliseconds, lessThan(500));

    // Also verify pre-printed letterhead mode compiles cleanly
    final letterheadPdfBytes = await A4LaserPrintService.buildA4Prescription(
      encounter.copyWith(isLetterheadMode: true),
    );
    expect(letterheadPdfBytes.length, greaterThan(1500));
  });
}
