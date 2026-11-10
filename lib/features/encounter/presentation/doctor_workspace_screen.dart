import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/printing/a4_laser_print_service.dart';
import '../../../core/theme/app_theme.dart';
import '../application/encounter_notifier.dart';
import '../application/queue_monitor_notifier.dart';
import 'widgets/a4_live_preview_pane.dart';
import 'widgets/complaint_grid_section.dart';
import 'widgets/diagnosis_section.dart';
import 'widgets/examination_section.dart';
import 'widgets/live_queue_drawer.dart';
import 'widgets/patient_header_bar.dart';
import 'widgets/prescription_section.dart';

class DoctorWorkspaceScreen extends ConsumerStatefulWidget {
  final VoidCallback onSwitchToReception;

  const DoctorWorkspaceScreen({
    super.key,
    required this.onSwitchToReception,
  });

  @override
  ConsumerState<DoctorWorkspaceScreen> createState() => _DoctorWorkspaceScreenState();
}

class _DoctorWorkspaceScreenState extends ConsumerState<DoctorWorkspaceScreen> {
  bool _isQueueCollapsed = false;

  Future<void> _handleCompleteAndAdvance({bool triggerPrint = false}) async {
    final encounter = ref.read(encounterProvider);
    final patient = encounter.activePatient;
    if (patient == null) return;

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
          content: Text('Token #$token marked COMPLETED (Seen). Loaded next patient.'),
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
              child: const Icon(LucideIcons.stethoscope, color: AppTheme.primaryBlue, size: 20),
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
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Queue count pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: queueState.hasOverdue
                  ? AppTheme.slaOverdue.withValues(alpha: 0.12)
                  : AppTheme.surfaceBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: queueState.hasOverdue ? AppTheme.slaOverdue : AppTheme.borderLight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  queueState.hasOverdue ? LucideIcons.alertTriangle : LucideIcons.users,
                  size: 14,
                  color: queueState.hasOverdue ? AppTheme.slaOverdue : AppTheme.primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  '${queueState.waitingPatients.length} Waiting',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: queueState.hasOverdue ? AppTheme.slaOverdue : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Switch to Reception
          ElevatedButton.icon(
            onPressed: widget.onSwitchToReception,
            icon: const Icon(LucideIcons.arrowRightLeft, size: 14),
            label: const Text('Reception Terminal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
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
                          // 2. Presenting Complaints Grid + Sub-questions
                          const ComplaintGridSection(),
                          const SizedBox(height: 14),

                          // 3. Systemic Examination (Default Normal)
                          const ExaminationSection(),
                          const SizedBox(height: 14),

                          // 4. Predictive Diagnosis & Protocol Auto-Load
                          const DiagnosisSection(),
                          const SizedBox(height: 14),

                          // 5. Prescription Builder & Follow-up
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppTheme.borderLight),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Encounter quick summary & letterhead toggle
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: encounter.isLetterheadMode,
                                  onChanged: (_) {
                                    ref.read(encounterProvider.notifier).toggleLetterheadMode();
                                  },
                                ),
                                const Text(
                                  'Pre-printed Letterhead',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${encounter.selectedDiagnosisIds.length} Diag • ${encounter.activePrescription.length} Rx',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right: Actions - Preview A4 & Print CTA
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                A4LivePreviewPane.showPreviewDialog(
                                  context,
                                  onPrintedAndCompleted: () => _handleCompleteAndAdvance(),
                                );
                              },
                              icon: const Icon(LucideIcons.eye, size: 16),
                              label: const Text('Preview A4'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {
                                ref.read(encounterProvider.notifier).clearEncounter();
                              },
                              icon: const Icon(LucideIcons.xCircle, size: 16),
                              label: const Text('Cancel'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () => _handleCompleteAndAdvance(triggerPrint: true),
                              icon: const Icon(LucideIcons.printer, size: 18),
                              label: Text('Print A4 & Mark Seen (Token #${patient.tokenNumber})'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: encounter.hasCriticalSafetyAlert
                                    ? AppTheme.slaOverdue
                                    : AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
