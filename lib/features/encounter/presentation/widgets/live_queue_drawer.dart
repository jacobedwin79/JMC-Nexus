import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/wait_timer_badge.dart';
import '../../application/encounter_notifier.dart';
import '../../application/queue_monitor_notifier.dart';
import '../../domain/clinical_models.dart';
import '../../domain/patient_queue_item.dart';

class LiveQueueDrawer extends ConsumerWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const LiveQueueDrawer({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueMonitorProvider);
    final activePatient = ref.watch(encounterProvider).activePatient;

    final waitingList = List<PatientQueueItem>.from(queueState.waitingPatients);
    // Sort: overdue patients (>45 mins) first, then by token number
    waitingList.sort((a, b) {
      if (a.isOverdue() && !b.isOverdue()) return -1;
      if (!a.isOverdue() && b.isOverdue()) return 1;
      return a.tokenNumber.compareTo(b.tokenNumber);
    });

    if (isCollapsed) {
      return Container(
        width: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: AppTheme.borderLight)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            IconButton(
              icon: const Icon(LucideIcons.panelLeftOpen, size: 20),
              tooltip: 'Expand Queue',
              onPressed: onToggleCollapse,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: queueState.hasOverdue
                    ? AppTheme.slaOverdue.withValues(alpha: 0.12)
                    : AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${waitingList.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: queueState.hasOverdue
                      ? AppTheme.slaOverdue
                      : AppTheme.primaryBlue,
                ),
              ),
            ),
            const Divider(color: AppTheme.borderLight),
            Expanded(
              child: ListView.builder(
                itemCount: waitingList.length,
                itemBuilder: (context, index) {
                  final patient = waitingList[index];
                  final isSelected = activePatient?.id == patient.id;
                  final isOverdue = patient.isOverdue();

                  return InkWell(
                    onTap: () => ref
                        .read(encounterProvider.notifier)
                        .loadPatient(patient),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : (isOverdue
                                  ? AppTheme.slaOverdue.withValues(alpha: 0.1)
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : (isOverdue
                                    ? AppTheme.slaOverdue
                                    : AppTheme.borderLight),
                          width: isOverdue ? 1.5 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '#${patient.tokenNumber}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? Colors.white
                              : (isOverdue
                                    ? AppTheme.slaOverdue
                                    : AppTheme.textPrimary),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTheme.borderLight)),
      ),
      child: Column(
        children: [
          // Queue Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.users,
                        size: 18,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Waiting Queue',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${waitingList.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.panelLeftClose, size: 18),
                  tooltip: 'Collapse',
                  onPressed: onToggleCollapse,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Overdue Warning Banner if any
          if (queueState.hasOverdue) ...[
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.1),
                border: Border.all(color: AppTheme.slaOverdue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.alertTriangle,
                    color: AppTheme.slaOverdue,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${queueState.overdueCount} Overdue (>45m)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.slaOverdue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // In-Consultation (Active / Resumable) Strip
          if (queueState.inConsultationPatients.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.stethoscope,
                    size: 13,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'IN CONSULTATION (${queueState.inConsultationPatients.length})',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            ...queueState.inConsultationPatients.map((patient) {
              final isSelected = activePatient?.id == patient.id;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                      : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : Colors.amber.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${patient.tokenNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        patient.patientName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => ref
                          .read(encounterProvider.notifier)
                          .loadPatient(patient),
                      child: Text(
                        isSelected ? 'Active' : 'Resume',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : Colors.amber.shade900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        LucideIcons.undo2,
                        size: 14,
                        color: Colors.grey,
                      ),
                      tooltip: 'Release back to Waiting queue',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await ref
                            .read(appDatabaseProvider)
                            .releaseConsultation(patient.id);
                        if (isSelected) {
                          ref
                              .read(encounterProvider.notifier)
                              .clearEncounter(releaseToQueue: false);
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 1, color: AppTheme.borderLight),
          ],

          // Patient Token List
          Expanded(
            child: waitingList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.checkCircle2,
                          size: 40,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Waiting queue is empty',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    itemCount: waitingList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      final patient = waitingList[index];
                      final isSelected = activePatient?.id == patient.id;
                      final isOverdue = patient.isOverdue();
                      final isWarning = patient.isWarning();
                      final vitals = PatientVitals.fromJson(patient.vitals);

                      Color cardBorder = AppTheme.borderLight;
                      if (isSelected) {
                        cardBorder = AppTheme.primaryBlue;
                      } else if (isOverdue) {
                        cardBorder = AppTheme.slaOverdue;
                      } else if (isWarning) {
                        cardBorder = AppTheme.slaWarning;
                      }

                      return InkWell(
                        onTap: () => ref
                            .read(encounterProvider.notifier)
                            .loadPatient(patient),
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                                : (isOverdue
                                      ? AppTheme.slaOverdue.withValues(
                                          alpha: 0.04,
                                        )
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cardBorder,
                              width: isSelected || isOverdue ? 1.8 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOverdue
                                              ? AppTheme.slaOverdue
                                              : AppTheme.primaryBlue,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '#${patient.tokenNumber}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SizedBox(
                                        width: 110,
                                        child: Text(
                                          patient.patientName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  WaitTimerBadge(
                                    entryTime: patient.entryTime,
                                    compact: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '${patient.compactAgeDisplay}/${patient.gender}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  if (vitals.bpSys != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '• BP ${vitals.bpDisplay}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: vitals.isHypertensive
                                            ? AppTheme.slaOverdue
                                            : AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
