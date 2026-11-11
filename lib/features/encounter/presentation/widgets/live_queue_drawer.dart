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
        width: 48,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: AppTheme.borderLight)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(LucideIcons.panelLeftOpen, size: 18),
              tooltip: 'Expand Queue',
              onPressed: onToggleCollapse,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 4),
            Container(
              width: 32,
              height: 22,
              decoration: BoxDecoration(
                color: queueState.hasOverdue
                    ? AppTheme.slaOverdue
                    : AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(11),
              ),
              alignment: Alignment.center,
              child: Text(
                '${waitingList.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppTheme.borderLight, indent: 6, endIndent: 6),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                itemCount: waitingList.length,
                itemBuilder: (context, index) {
                  final patient = waitingList[index];
                  final isSelected = activePatient?.id == patient.id;
                  final isOverdue = patient.isOverdue();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: InkWell(
                      onTap: () => ref
                          .read(encounterProvider.notifier)
                          .loadPatient(patient),
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : (isOverdue
                                    ? AppTheme.slaOverdue.withValues(alpha: 0.1)
                                    : Colors.transparent),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : (isOverdue
                                      ? AppTheme.slaOverdue
                                      : AppTheme.borderLight),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${patient.tokenNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : (isOverdue
                                      ? AppTheme.slaOverdue
                                      : AppTheme.textSecondary),
                          ),
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
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppTheme.borderLight)),
      ),
      child: Column(
        children: [
          // ── Queue Header ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.users, size: 15, color: AppTheme.primaryBlue),
                const SizedBox(width: 6),
                const Text(
                  'Queue',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: queueState.hasOverdue
                        ? AppTheme.slaOverdue
                        : AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${waitingList.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.panelLeftClose, size: 16),
                  tooltip: 'Collapse',
                  onPressed: onToggleCollapse,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
          ),

          // ── Overdue Warning Banner ───────────────────────────────────
          if (queueState.hasOverdue)
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.slaOverdue.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, color: AppTheme.slaOverdue, size: 13),
                  const SizedBox(width: 5),
                  Text(
                    '${queueState.overdueCount} overdue',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.slaOverdue,
                    ),
                  ),
                ],
              ),
            ),

          // ── In-Consultation Strip ────────────────────────────────────
          if (queueState.inConsultationPatients.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
              child: Text(
                'IN CONSULT (${queueState.inConsultationPatients.length})',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.amber.shade800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...queueState.inConsultationPatients.map((patient) {
              final isSelected = activePatient?.id == patient.id;
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: InkWell(
                  onTap: () => ref
                      .read(encounterProvider.notifier)
                      .loadPatient(patient),
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryBlue.withValues(alpha: 0.07)
                          : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : Colors.amber.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#${patient.tokenNumber}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            patient.patientName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.undo2, size: 12, color: Colors.grey),
                          tooltip: 'Release to waiting',
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
                  ),
                ),
              );
            }),
            const Divider(height: 1, color: AppTheme.borderLight, indent: 8, endIndent: 8),
            const SizedBox(height: 2),
          ],

          // ── Patient Token List ───────────────────────────────────────
          Expanded(
            child: waitingList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.checkCircle2, size: 32, color: Colors.grey.shade300),
                        const SizedBox(height: 6),
                        Text(
                          'Queue clear',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                    itemCount: waitingList.length,
                    itemBuilder: (context, index) {
                      final patient = waitingList[index];
                      final isSelected = activePatient?.id == patient.id;
                      final isOverdue = patient.isOverdue();
                      final isWarning = patient.isWarning();
                      final vitals = PatientVitals.fromJson(patient.vitals);

                      Color borderColor = AppTheme.borderLight;
                      Color bgColor = Colors.white;
                      if (isSelected) {
                        borderColor = AppTheme.primaryBlue;
                        bgColor = AppTheme.primaryBlue.withValues(alpha: 0.06);
                      } else if (isOverdue) {
                        borderColor = AppTheme.slaOverdue;
                        bgColor = AppTheme.slaOverdue.withValues(alpha: 0.04);
                      } else if (isWarning) {
                        borderColor = AppTheme.slaWarning;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          onTap: () => ref
                              .read(encounterProvider.notifier)
                              .loadPatient(patient),
                          borderRadius: BorderRadius.circular(8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected || isOverdue ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isOverdue
                                            ? AppTheme.slaOverdue
                                            : (isSelected
                                                ? AppTheme.primaryBlue
                                                : AppTheme.primaryBlue.withValues(alpha: 0.85)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '#${patient.tokenNumber}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        patient.patientName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: AppTheme.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    WaitTimerBadge(
                                      entryTime: patient.entryTime,
                                      compact: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Text(
                                      '${patient.compactAgeDisplay}/${patient.gender}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    if (vitals.bpSys != null) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        'BP ${vitals.bpDisplay}',
                                        style: TextStyle(
                                          fontSize: 10,
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
