import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/wait_timer_badge.dart';
import '../../../encounter/application/queue_monitor_notifier.dart';
import '../../../encounter/domain/clinical_models.dart';
import '../../../encounter/domain/patient_queue_item.dart';

class ReceptionQueueList extends ConsumerStatefulWidget {
  final ValueChanged<PatientQueueItem>? onSelectPatient;

  const ReceptionQueueList({super.key, this.onSelectPatient});

  @override
  ConsumerState<ReceptionQueueList> createState() => _ReceptionQueueListState();
}

class _ReceptionQueueListState extends ConsumerState<ReceptionQueueList> {
  int _selectedFilterIndex = 0; // 0: Waiting, 1: In Cabin, 2: Completed, 3: All

  @override
  Widget build(BuildContext context) {
    final queueState = ref.watch(queueMonitorProvider);

    if (queueState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final waiting = queueState.waitingPatients;
    final inCabin = queueState.inConsultationPatients;
    final completed = queueState.completedPatients;
    final all = queueState.allPatients;

    List<PatientQueueItem> displayedList;
    switch (_selectedFilterIndex) {
      case 0:
        displayedList = waiting;
        break;
      case 1:
        displayedList = inCabin;
        break;
      case 2:
        displayedList = completed;
        break;
      case 3:
      default:
        displayedList = all;
        break;
    }

    return Column(
      children: [
        // Persistent Overdue SLA Banner if any waiting patient >45m
        if (queueState.hasOverdue) ...[
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.slaOverdue.withValues(alpha: 0.12),
              border: Border.all(color: AppTheme.slaOverdue, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.alertOctagon,
                  color: AppTheme.slaOverdue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    queueState.overdueBannerText ??
                        'Patients waiting > 45 mins!',
                    style: const TextStyle(
                      color: AppTheme.slaOverdue,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Filter Tabs Strip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterTab(
                  0,
                  'Waiting',
                  waiting.length,
                  AppTheme.slaNormal,
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  1,
                  'In Cabin',
                  inCabin.length,
                  AppTheme.primaryAccent,
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  2,
                  'Completed',
                  completed.length,
                  AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                _buildFilterTab(
                  3,
                  'All Today',
                  all.length,
                  AppTheme.textPrimary,
                ),
              ],
            ),
          ),
        ),

        const Divider(height: 1, color: AppTheme.borderLight),

        // Patient List
        Expanded(
          child: displayedList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.users,
                        size: 48,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedFilterIndex == 0
                            ? 'No patients waiting in queue'
                            : 'No patients in this category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayedList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final patient = displayedList[index];
                    return _buildPatientQueueCard(patient);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(
    int index,
    String label,
    int count,
    Color indicatorColor,
  ) {
    final isSelected = _selectedFilterIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilterIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : indicatorColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : indicatorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientQueueCard(PatientQueueItem patient) {
    final isOverdue = patient.isOverdue();
    final isWarning = patient.isWarning();
    final isWaiting = patient.queueStatus == QueueStatus.waiting;
    final timeFormat = DateFormat('h:mm a');

    Color borderColor = AppTheme.borderLight;
    if (isWaiting) {
      if (isOverdue) {
        borderColor = AppTheme.slaOverdue;
      } else if (isWarning) {
        borderColor = AppTheme.slaWarning;
      }
    }

    final vitals = PatientVitals.fromJson(patient.vitals);

    return InkWell(
      onTap: widget.onSelectPatient != null
          ? () => widget.onSelectPatient!(patient)
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isOverdue && isWaiting
              ? AppTheme.slaOverdue.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isOverdue && isWaiting ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Token Badge
            Container(
              width: 52,
              height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isOverdue && isWaiting
                    ? AppTheme.slaOverdue
                    : (isWaiting ? AppTheme.primaryBlue : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TOKEN',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isWaiting ? Colors.white70 : Colors.black45,
                    ),
                  ),
                  Text(
                    '#${patient.tokenNumber}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: isWaiting ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Patient Demographics & Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          patient.patientName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Live wait timer badge
                      WaitTimerBadge(
                        entryTime: patient.entryTime,
                        isCompleted:
                            patient.queueStatus == QueueStatus.completed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Demographics strip: Age / Gender, Entry time
                  Row(
                    children: [
                      Text(
                        '${patient.dynamicAgeDisplay} • ${patient.gender == "M" ? "Male" : (patient.gender == "F" ? "Female" : "Other")}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•  Entry: ${timeFormat.format(patient.entryTime.toLocal())}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      if (patient.patientId != null &&
                          patient.patientId!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '•  ID: ${patient.patientId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (patient.phone != null &&
                          patient.phone!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '•  ${patient.phone}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Vitals row if recorded
                  if (vitals.hasAnyVitals) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (vitals.bpSys != null)
                          _buildVitalPill(
                            'BP: ${vitals.bpDisplay}',
                            vitals.isHypertensive,
                          ),
                        if (vitals.pulse != null)
                          _buildVitalPill(
                            'HR: ${vitals.pulse} bpm',
                            vitals.isTachycardic,
                          ),
                        if (vitals.spo2 != null)
                          _buildVitalPill(
                            'SpO2: ${vitals.spo2}%',
                            vitals.isHypoxemic,
                          ),
                        if (vitals.temp != null)
                          _buildVitalPill('${vitals.temp}°F', vitals.isFebrile),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalPill(String text, bool isAbnormal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAbnormal
            ? AppTheme.slaOverdue.withValues(alpha: 0.1)
            : AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isAbnormal ? AppTheme.slaOverdue : AppTheme.borderLight,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isAbnormal ? FontWeight.w700 : FontWeight.w500,
          color: isAbnormal ? AppTheme.slaOverdue : AppTheme.textSecondary,
        ),
      ),
    );
  }
}
