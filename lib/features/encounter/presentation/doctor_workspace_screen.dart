import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';
import '../../../core/printing/a4_laser_print_service.dart';
import '../../../core/printing/medical_certificate_service.dart';
import '../../../core/theme/app_theme.dart';
import '../application/encounter_notifier.dart';
import '../application/queue_monitor_notifier.dart';
import '../domain/clinical_models.dart';
import '../domain/encounter_state.dart';
import 'widgets/a4_live_preview_pane.dart';
import 'widgets/complaint_grid_section.dart';
import 'widgets/diagnosis_section.dart';
import 'widgets/examination_section.dart';
import 'widgets/gemini_voice_scribe_bar.dart';
import 'widgets/investigations_section.dart';
import 'widgets/live_queue_drawer.dart';
import 'widgets/patient_header_bar.dart';
import 'widgets/prescription_section.dart';

class DoctorWorkspaceScreen extends ConsumerStatefulWidget {
  final VoidCallback onSwitchToReception;

  const DoctorWorkspaceScreen({super.key, required this.onSwitchToReception});

  @override
  ConsumerState<DoctorWorkspaceScreen> createState() =>
      _DoctorWorkspaceScreenState();
}

class _DoctorWorkspaceScreenState extends ConsumerState<DoctorWorkspaceScreen> {
  bool _isQueueCollapsed = false;

  /// Modal dialog forcing doctor to enter a text-based justification to override critical safety alerts.
  Future<String?> _showCriticalAlertOverrideModal(
    BuildContext context,
    EncounterState encounter,
  ) async {
    final controller = TextEditingController();
    final criticalAlerts = encounter.safetyAlerts
        .where((a) => a.severity == AlertSeverity.critical)
        .toList();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? localError;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    LucideIcons.alertOctagon,
                    color: AppTheme.slaOverdue,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Critical Safety Alert Override',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.slaOverdue,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'The following critical contraindications were detected by the Clinical Safety Engine. '
                      'Completion is hard-blocked unless a clinical justification is documented:',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    ...criticalAlerts.map((alert) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.slaOverdue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.slaOverdue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              LucideIcons.alertTriangle,
                              size: 16,
                              color: AppTheme.slaOverdue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                alert.message,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.slaOverdue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Clinical Override Justification *',
                        hintText:
                            'Enter clinical rationale (e.g. Benefit outweighs risk, single dose administered under direct observation)...',
                        errorText: localError,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        if (localError != null) {
                          setDialogState(() => localError = null);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel & Review Prescription'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final reason = controller.text.trim();
                    if (reason.isEmpty) {
                      setDialogState(
                        () => localError =
                            'Please enter an override reason to proceed.',
                      );
                      return;
                    }
                    Navigator.pop(context, reason);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.slaOverdue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirm Override & Complete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Displays One-Tap standard document templates (Sick Leave, Fitness, Referral)
  Future<void> _showOutputTemplatesDialog(
    BuildContext context,
    EncounterState encounter,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                LucideIcons.fileCheck2,
                color: AppTheme.primaryBlue,
                size: 22,
              ),
              SizedBox(width: 8),
              Text('One-Tap Output Documents & Certificates'),
            ],
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Sick Leave Certificate
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.bedDouble,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Sick Leave Certificate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Standard medical rest certificate with diagnosis and dates',
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, size: 16),
                  onTap: () async {
                    Navigator.pop(context);
                    final pdfBytes =
                        await MedicalCertificateService.generateSickLeaveCertificate(
                          encounter: encounter,
                          leaveDays: encounter.followUpDays ?? 3,
                        );
                    await Printing.layoutPdf(
                      onLayout: (_) => pdfBytes,
                      name:
                          'Sick_Leave_Certificate_${encounter.activePatient?.patientName}.pdf',
                    );
                  },
                ),
                const Divider(),

                // 2. Medical Fitness Certificate
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.award,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Medical Fitness Certificate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Certified physically fit for work, school, or sports resumption',
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, size: 16),
                  onTap: () async {
                    Navigator.pop(context);
                    final pdfBytes =
                        await MedicalCertificateService.generateFitnessCertificate(
                          encounter: encounter,
                        );
                    await Printing.layoutPdf(
                      onLayout: (_) => pdfBytes,
                      name:
                          'Fitness_Certificate_${encounter.activePatient?.patientName}.pdf',
                    );
                  },
                ),
                const Divider(),

                // 3. Clinical Referral Letter
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.send,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Clinical Referral Letter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Inter-hospital or specialist referral with complaints and treatment given',
                  ),
                  trailing: const Icon(LucideIcons.arrowRight, size: 16),
                  onTap: () async {
                    Navigator.pop(context);
                    final specialistController = TextEditingController(
                      text: 'General Medicine / Emergency Dept',
                    );
                    final reasonController = TextEditingController(
                      text:
                          'Further clinical evaluation and specialized management.',
                    );

                    final proceed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Referral Details'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: specialistController,
                              decoration: const InputDecoration(
                                labelText:
                                    'Referred To (Specialist/Hospital) *',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: reasonController,
                              decoration: const InputDecoration(
                                labelText: 'Reason for Referral *',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Generate Referral'),
                          ),
                        ],
                      ),
                    );

                    if (proceed == true) {
                      final pdfBytes =
                          await MedicalCertificateService.generateReferralLetter(
                            encounter: encounter,
                            referredToSpecialistOrHospital: specialistController
                                .text
                                .trim(),
                            reasonForReferral: reasonController.text.trim(),
                          );
                      await Printing.layoutPdf(
                        onLayout: (_) => pdfBytes,
                        name:
                            'Referral_Letter_${encounter.activePatient?.patientName}.pdf',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleCompleteAndAdvance({bool triggerPrint = false}) async {
    final encounter = ref.read(encounterProvider);
    final patient = encounter.activePatient;
    if (patient == null) return;

    // 1. Mandatory Follow-up Validation Check
    if (encounter.followUpDays == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(LucideIcons.alertCircle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Follow-up selection is mandatory before completing encounter.',
                ),
              ],
            ),
            backgroundColor: AppTheme.slaOverdue,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // 2. Hard-Block Critical Safety Alert Check with Mandatory Justification
    if (encounter.hasCriticalSafetyAlert &&
        (encounter.overrideReason == null ||
            encounter.overrideReason!.trim().isEmpty)) {
      final overrideReason = await _showCriticalAlertOverrideModal(
        context,
        encounter,
      );
      if (overrideReason == null || overrideReason.trim().isEmpty) {
        // Aborted by doctor
        return;
      }
      ref.read(encounterProvider.notifier).setOverrideReason(overrideReason);
    }

    final token = patient.tokenNumber;
    await ref.read(encounterProvider.notifier).completeEncounter();

    if (triggerPrint) {
      try {
        await A4LaserPrintService.printA4Prescription(encounter);
      } catch (e) {
        debugPrint('Print dispatch: $e');
      }
    }

    // Auto-advance: load next waiting patient if any
    final queueState = ref.read(queueMonitorProvider);
    final nextWaiting = queueState.waitingPatients.firstOrNull;

    if (nextWaiting != null) {
      await ref.read(encounterProvider.notifier).loadPatient(nextWaiting);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Token #$token marked COMPLETED (Seen). Loaded next patient.',
          ),
          backgroundColor: AppTheme.slaNormal,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final encounter = ref.watch(encounterProvider);
    final patient = encounter.activePatient;
    final queueState = ref.watch(queueMonitorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.stethoscope,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JMC Nexus • Doctor Workspace',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Zero-Keyboard Clinical Decision Canvas',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Switch to Reception
          TextButton.icon(
            onPressed: widget.onSwitchToReception,
            icon: const Icon(LucideIcons.users, size: 16),
            label: const Text('Reception Desk'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.textPrimary),
          ),
          const SizedBox(width: 8),

          // Waiting Count Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: queueState.hasOverdue
                  ? AppTheme.slaOverdue.withValues(alpha: 0.12)
                  : AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: queueState.hasOverdue
                    ? AppTheme.slaOverdue
                    : AppTheme.primaryBlue,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  queueState.hasOverdue
                      ? LucideIcons.alertTriangle
                      : LucideIcons.clock,
                  size: 14,
                  color: queueState.hasOverdue
                      ? AppTheme.slaOverdue
                      : AppTheme.primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  '${queueState.waitingPatients.length} Waiting',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: queueState.hasOverdue
                        ? AppTheme.slaOverdue
                        : AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Collapsible Queue Rail
          LiveQueueDrawer(
            isCollapsed: _isQueueCollapsed,
            onToggleCollapse: () {
              setState(() {
                _isQueueCollapsed = !_isQueueCollapsed;
              });
            },
          ),

          // Main Clinical Center Canvas
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Patient Header & Vitals Bar
                        const PatientHeaderBar(),
                        const SizedBox(height: 14),

                        if (patient != null) ...[
                          // 1.5 Gemini AI Voice Scribe Bar (WhatsApp Style Voice Note Dictation)
                          const GeminiVoiceScribeBar(),

                          // 2. Presenting Complaints Grid + Sub-questions
                          const ComplaintGridSection(),
                          const SizedBox(height: 14),

                          // 3. Systemic Examination (Default Normal)
                          const ExaminationSection(),
                          const SizedBox(height: 14),

                          // 4. Predictive Diagnosis & Protocol Auto-Load
                          const DiagnosisSection(),
                          const SizedBox(height: 14),

                          // 5. Dedicated Investigations Section (CBC, RBS, ECG, Imaging)
                          const InvestigationsSection(),
                          const SizedBox(height: 14),

                          // 6. Prescription Builder & Follow-up
                          const PrescriptionSection(),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),

                // Sticky Action Bottom Bar
                if (patient != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppTheme.borderLight),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row 1: Toggles & Clinical Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: encounter.isLetterheadMode,
                                  onChanged: (_) {
                                    ref
                                        .read(encounterProvider.notifier)
                                        .toggleLetterheadMode();
                                  },
                                ),
                                const Text(
                                  'Pre-printed Letterhead',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Privacy Toggle (print_diagnosis)
                                Checkbox(
                                  value: encounter.printDiagnosis,
                                  onChanged: (val) {
                                    ref
                                        .read(encounterProvider.notifier)
                                        .setPrintDiagnosis(val ?? true);
                                  },
                                ),
                                const Text(
                                  'Print Diagnosis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${encounter.selectedDiagnosisIds.length} Diag • ${encounter.activePrescription.length} Rx • ${encounter.investigations.length} Lab Orders',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Row 2: Action CTAs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showOutputTemplatesDialog(
                                context,
                                encounter,
                              ),
                              icon: const Icon(
                                LucideIcons.fileCheck2,
                                size: 15,
                              ),
                              label: const Text(
                                'Templates & Certs',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                A4LivePreviewPane.showPreviewDialog(
                                  context,
                                  onPrintedAndCompleted: () =>
                                      _handleCompleteAndAdvance(),
                                );
                              },
                              icon: const Icon(LucideIcons.eye, size: 15),
                              label: const Text(
                                'Preview A4',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                ref
                                    .read(encounterProvider.notifier)
                                    .clearEncounter();
                              },
                              icon: const Icon(LucideIcons.xCircle, size: 15),
                              label: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _handleCompleteAndAdvance(triggerPrint: true),
                              icon: const Icon(LucideIcons.printer, size: 16),
                              label: Text(
                                'Print A4 & Mark Seen (Token #${patient.tokenNumber})',
                                style: const TextStyle(fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    encounter.hasCriticalSafetyAlert
                                    ? AppTheme.slaOverdue
                                    : AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
