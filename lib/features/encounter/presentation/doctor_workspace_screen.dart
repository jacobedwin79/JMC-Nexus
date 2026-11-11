import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/printing/a4_laser_print_service.dart';
import '../../../core/printing/medical_certificate_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../catalog_manager/presentation/catalog_manager_screen.dart';
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
  final VoidCallback? onSwitchToAdmin;

  const DoctorWorkspaceScreen({
    super.key,
    required this.onSwitchToReception,
    this.onSwitchToAdmin,
  });

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
                    final settings = ref.read(clinicSettingsProvider);
                    final pdfBytes =
                        await MedicalCertificateService.generateSickLeaveCertificate(
                          encounter: encounter,
                          leaveDays: encounter.followUpDays ?? 3,
                          settings: settings,
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
                    final settings = ref.read(clinicSettingsProvider);
                    final pdfBytes =
                        await MedicalCertificateService.generateFitnessCertificate(
                          encounter: encounter,
                          settings: settings,
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
                      final settings = ref.read(clinicSettingsProvider);
                      final pdfBytes =
                          await MedicalCertificateService.generateReferralLetter(
                            encounter: encounter,
                            referredToSpecialistOrHospital: specialistController
                                .text
                                .trim(),
                            reasonForReferral: reasonController.text.trim(),
                            settings: settings,
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
        final settings = ref.read(clinicSettingsProvider);
        await A4LaserPrintService.printA4Prescription(encounter, settings);
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
    final clinicName = ref.watch(clinicSettingsProvider).clinicName;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                LucideIcons.stethoscope,
                color: Colors.white,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  clinicName == 'JMC CLINICAL HEALTHCARE & OPD'
                      ? 'JMC Doctor'
                      : clinicName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Text(
                  'Zero-Keyboard Clinical Decision Canvas',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Master Formulary (Read-Only) icon-button
          Tooltip(
            message: 'Master Formulary (Read Only)',
            child: IconButton(
              icon: const Icon(LucideIcons.pill, size: 18),
              color: AppTheme.textSecondary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CatalogManagerScreen(isReadOnlyFormulary: true),
                  ),
                );
              },
            ),
          ),

          // Admin icon-button
          if (widget.onSwitchToAdmin != null)
            Tooltip(
              message: 'Admin Panel',
              child: IconButton(
                icon: const Icon(LucideIcons.shieldCheck, size: 18),
                color: AppTheme.textSecondary,
                onPressed: widget.onSwitchToAdmin,
              ),
            ),

          // Reception icon-button
          Tooltip(
            message: 'Reception Desk',
            child: IconButton(
              icon: const Icon(LucideIcons.monitorSmartphone, size: 18),
              color: AppTheme.textSecondary,
              onPressed: widget.onSwitchToReception,
            ),
          ),

          const SizedBox(width: 4),

          // Waiting Count Badge — compact pill
          GestureDetector(
            onTap: () {
              setState(() => _isQueueCollapsed = !_isQueueCollapsed);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: queueState.hasOverdue
                    ? AppTheme.slaOverdue
                    : AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    queueState.hasOverdue
                        ? LucideIcons.alertTriangle
                        : LucideIcons.users,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${queueState.waitingPatients.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Patient Header & Vitals Bar
                        const PatientHeaderBar(),
                        const SizedBox(height: 10),

                        if (patient != null) ...[
                          // 1.5 Gemini AI Voice Scribe Bar
                          const GeminiVoiceScribeBar(),

                          // 2. Presenting Complaints Grid + Sub-questions
                          const ComplaintGridSection(),
                          const SizedBox(height: 10),

                          // 3. Systemic Examination (Default Normal)
                          const ExaminationSection(),
                          const SizedBox(height: 10),

                          // 4. Predictive Diagnosis & Protocol Auto-Load
                          const DiagnosisSection(),
                          const SizedBox(height: 10),

                          // 5. Dedicated Investigations Section
                          const InvestigationsSection(),
                          const SizedBox(height: 10),

                          // 6. Prescription Builder & Follow-up
                          const PrescriptionSection(),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),

                // ── Sticky Bottom Action Bar ──────────────────────────────
                if (patient != null)
                  _BottomActionBar(
                    encounter: encounter,
                    patient: patient,
                    onTemplates: () =>
                        _showOutputTemplatesDialog(context, encounter),
                    onPreview: () => A4LivePreviewPane.showPreviewDialog(
                      context,
                      onPrintedAndCompleted: () => _handleCompleteAndAdvance(),
                    ),
                    onCancel: () =>
                        ref.read(encounterProvider.notifier).clearEncounter(),
                    onPrintAndComplete: () =>
                        _handleCompleteAndAdvance(triggerPrint: true),
                    onComplete: () => _handleCompleteAndAdvance(),
                    onToggleLetterhead: () => ref
                        .read(encounterProvider.notifier)
                        .toggleLetterheadMode(),
                    onTogglePrintDiagnosis: (val) => ref
                        .read(encounterProvider.notifier)
                        .setPrintDiagnosis(val ?? true),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Extracted Bottom Action Bar ───────────────────────────────────────────────
class _BottomActionBar extends StatelessWidget {
  final dynamic encounter;
  final dynamic patient;
  final VoidCallback onTemplates;
  final VoidCallback onPreview;
  final VoidCallback onCancel;
  final VoidCallback onPrintAndComplete;
  final VoidCallback onComplete;
  final VoidCallback onToggleLetterhead;
  final ValueChanged<bool?> onTogglePrintDiagnosis;

  const _BottomActionBar({
    required this.encounter,
    required this.patient,
    required this.onTemplates,
    required this.onPreview,
    required this.onCancel,
    required this.onPrintAndComplete,
    required this.onComplete,
    required this.onToggleLetterhead,
    required this.onTogglePrintDiagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final hasCritical = encounter.hasCriticalSafetyAlert as bool;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          // ── Left: Compact toggles & summary pill ──────────────────
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              _CompactToggle(
                label: 'Letterhead',
                value: encounter.isLetterheadMode as bool,
                onChanged: (_) => onToggleLetterhead(),
              ),
              _CompactToggle(
                label: 'Print Dx',
                value: encounter.printDiagnosis as bool,
                onChanged: onTogglePrintDiagnosis,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(encounter.selectedDiagnosisIds as List).length} Dx · '
                  '${(encounter.activePrescription as List).length} Rx · '
                  '${(encounter.investigations as List).length} Labs',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),

          // ── Right: Action buttons ────────────────────────────────────
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              _ActionBtn(
                icon: LucideIcons.fileCheck2,
                label: 'Certs',
                onTap: onTemplates,
              ),
              _ActionBtn(
                icon: LucideIcons.eye,
                label: 'Preview',
                onTap: onPreview,
              ),
              _ActionBtn(
                icon: LucideIcons.xCircle,
                label: 'Cancel',
                onTap: onCancel,
                danger: true,
              ),
              FilledButton.icon(
                onPressed: onPrintAndComplete,
                icon: Icon(
                  hasCritical ? LucideIcons.alertTriangle : LucideIcons.printer,
                  size: 15,
                ),
                label: Text(
                  'Print A4 & Mark Seen (Token #${patient.tokenNumber})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      hasCritical ? AppTheme.slaOverdue : AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CompactToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppTheme.slaOverdue : AppTheme.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


