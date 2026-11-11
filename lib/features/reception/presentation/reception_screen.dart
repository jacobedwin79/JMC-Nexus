import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../encounter/application/queue_monitor_notifier.dart';
import 'widgets/quick_reg_form.dart';
import 'widgets/reception_queue_list.dart';

class ReceptionScreen extends ConsumerWidget {
  final VoidCallback onSwitchToDoctor;
  final VoidCallback? onSwitchToAdmin;

  const ReceptionScreen({
    super.key,
    required this.onSwitchToDoctor,
    this.onSwitchToAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueMonitorProvider);
    final clinicSettings = ref.watch(clinicSettingsProvider);
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
              child: const Icon(
                LucideIcons.stethoscope,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicSettings.clinicName == 'JMC CLINICAL HEALTHCARE & OPD'
                        ? 'JMC Nexus • Reception Terminal'
                        : '${clinicSettings.clinicName} • Reception',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    todayDate,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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
                      : LucideIcons.users,
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
                    fontWeight: FontWeight.w700,
                    color: queueState.hasOverdue
                        ? AppTheme.slaOverdue
                        : AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Admin Panel Switcher
          if (onSwitchToAdmin != null) ...[
            OutlinedButton.icon(
              onPressed: onSwitchToAdmin,
              icon: const Icon(LucideIcons.shieldCheck, size: 14),
              label: const Text('Admin Panel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Terminal Mode Switcher
          ElevatedButton.icon(
            onPressed: onSwitchToDoctor,
            icon: const Icon(LucideIcons.arrowRightLeft, size: 14),
            label: const Text('Doctor Terminal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                  width: constraints.maxWidth * 0.40 > 460
                      ? 460
                      : constraints.maxWidth * 0.40,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: AppTheme.borderLight,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const QuickRegForm(),
                  ),
                ),

                // Right Panel: Live Queue Tracker
                const Expanded(child: ReceptionQueueList()),
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
                      Tab(
                        text:
                            'Live Queue (${queueState.waitingPatients.length})',
                      ),
                    ],
                    labelColor: AppTheme.primaryBlue,
                    indicatorColor: AppTheme.primaryBlue,
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [QuickRegForm(), ReceptionQueueList()],
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
