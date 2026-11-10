import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../encounter/application/queue_monitor_notifier.dart';
import 'widgets/quick_reg_form.dart';
import 'widgets/reception_queue_list.dart';

class ReceptionScreen extends ConsumerWidget {
  final VoidCallback onSwitchToDoctor;

  const ReceptionScreen({
    super.key,
    required this.onSwitchToDoctor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueMonitorProvider);
    final todayDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'JMC Nexus • Reception Terminal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                Text(
                  todayDate,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Waiting queue counter pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: queueState.hasOverdue
                  ? AppTheme.slaOverdue.withValues(alpha: 0.12)
                  : AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: queueState.hasOverdue ? AppTheme.slaOverdue : AppTheme.primaryBlue,
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
                    color: queueState.hasOverdue ? AppTheme.slaOverdue : AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Terminal Mode Switcher
          ElevatedButton.icon(
            onPressed: onSwitchToDoctor,
            icon: const Icon(LucideIcons.arrowRightLeft, size: 14),
            label: const Text('Doctor Terminal'),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTabletOrDesktop = constraints.maxWidth >= 768;

          if (isTabletOrDesktop) {
            // Tablet & Desktop Split View
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel: Quick Registration Form (380-450px)
                SizedBox(
                  width: constraints.maxWidth * 0.40 > 460 ? 460 : constraints.maxWidth * 0.40,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppTheme.borderLight, width: 1),
                      ),
                    ),
                    child: const QuickRegForm(),
                  ),
                ),

                // Right Panel: Live Queue Tracker
                const Expanded(
                  child: ReceptionQueueList(),
                ),
              ],
            );
          } else {
            // Mobile Phone Stacked / Tabbed View
            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      const Tab(text: 'New Registration'),
                      Tab(text: 'Live Queue (${queueState.waitingPatients.length})'),
                    ],
                    labelColor: AppTheme.primaryBlue,
                    indicatorColor: AppTheme.primaryBlue,
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        QuickRegForm(),
                        ReceptionQueueList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

