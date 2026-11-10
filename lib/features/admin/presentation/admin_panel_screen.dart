import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/theme/app_theme.dart';
import '../../catalog_manager/presentation/catalog_manager_screen.dart';
import '../../encounter/domain/patient_queue_item.dart';
import '../application/admin_notifier.dart';
import '../domain/admin_metrics.dart';

class AdminPanelScreen extends ConsumerWidget {
  final VoidCallback onSwitchToReception;
  final VoidCallback onSwitchToDoctor;

  const AdminPanelScreen({
    super.key,
    required this.onSwitchToReception,
    required this.onSwitchToDoctor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminState = ref.watch(adminPanelProvider);
    final clinicSettings = ref.watch(clinicSettingsProvider);
    final currencyFormat = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.shieldCheck,
                color: AppTheme.primaryBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          clinicSettings.clinicName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'ADMIN PANEL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Clinical Operations, Revisit Analytics & Financial Audit',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
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
          // Clinic Settings button
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CatalogManagerScreen()),
              );
            },
            icon: const Icon(LucideIcons.settings, size: 16),
            label: const Text('Clinic Settings & Rates'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 6),

          // Switch to Reception Desk
          OutlinedButton.icon(
            onPressed: onSwitchToReception,
            icon: const Icon(LucideIcons.users, size: 15),
            label: const Text('Reception Desk'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Switch to Doctor Terminal
          ElevatedButton.icon(
            onPressed: onSwitchToDoctor,
            icon: const Icon(LucideIcons.stethoscope, size: 15),
            label: const Text('Doctor Terminal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: adminState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filter Bar & Header Controls
                  _buildFilterBar(context, ref, adminState),
                  const SizedBox(height: 20),

                  // 4 Executive KPI Cards
                  _buildKpiMetricsSection(
                    context,
                    adminState.summary,
                    currencyFormat,
                  ),
                  const SizedBox(height: 24),

                  // Daily Income & Patient Volume Analytics Table
                  _buildDailyIncomeSection(
                    context,
                    adminState.dailyIncomeList,
                    currencyFormat,
                  ),
                  const SizedBox(height: 24),

                  // Middle Row: Top Diagnoses & Demographics
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTopDiagnosesCard(
                          context,
                          adminState.topDiagnoses,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildDemographicsCard(
                          context,
                          adminState.demographics,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Patient Ledger & Revisit History (Audit Log)
                  _buildPatientLedgerSection(
                    context,
                    ref,
                    adminState,
                    currencyFormat,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    WidgetRef ref,
    AdminPanelState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 10,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(
                LucideIcons.calendar,
                size: 16,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 4),
              const Text(
                'Reporting Period:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(width: 4),
              ...AdminDateRangeFilter.values.map((filter) {
                final isSelected = state.selectedFilter == filter;
                return ChoiceChip(
                  label: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.primaryBlue,
                  backgroundColor: Colors.grey.shade100,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected: (val) {
                    if (val) {
                      ref
                          .read(adminPanelProvider.notifier)
                          .setDateFilter(filter);
                    }
                  },
                );
              }),
            ],
          ),
          Text(
            'Showing ${state.summary.totalPatients} Patients Recorded',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetricsSection(
    BuildContext context,
    AdminSummaryMetrics summary,
    NumberFormat currencyFormat,
  ) {
    return Row(
      children: [
        // KPI 1: Total Patients
        Expanded(
          child: _buildMetricCard(
            title: 'TOTAL PATIENTS',
            value: summary.totalPatients.toString(),
            subtitle: 'Today: ${summary.todayIncome > 0 ? "Active" : "Ready"}',
            icon: LucideIcons.users,
            iconColor: const Color(0xFF2563EB),
            iconBg: const Color(0xFFEFF6FF),
            badgeText: '${summary.completedConsultations} Completed',
            badgeColor: const Color(0xFF059669),
            details: [
              'Waiting: ${summary.waitingPatients}',
              'In Consult: ${summary.inConsultationPatients}',
              'Cancelled: ${summary.cancelledPatients}',
            ],
          ),
        ),
        const SizedBox(width: 16),

        // KPI 2: Revisit & Retention Analytics
        Expanded(
          child: _buildMetricCard(
            title: 'PATIENT REVISITS',
            value: '${summary.revisitPatients} Revisits',
            subtitle:
                '${summary.revisitPercentage.toStringAsFixed(1)}% Revisit Rate',
            icon: LucideIcons.repeat,
            iconColor: const Color(0xFF0D9488),
            iconBg: const Color(0xFFCCFBF1),
            badgeText: '${summary.newPatients} New Patients',
            badgeColor: const Color(0xFF0D9488),
            customProgress: summary.revisitPercentage / 100,
            details: [
              'New: ${summary.newPatients}',
              'Revisits: ${summary.revisitPatients}',
              'Retention: ${summary.revisitPercentage.toStringAsFixed(0)}%',
            ],
          ),
        ),
        const SizedBox(width: 16),

        // KPI 3: Total Income & Revenue
        Expanded(
          child: _buildMetricCard(
            title: 'TOTAL REVENUE',
            value: currencyFormat.format(summary.totalIncome),
            subtitle:
                'Today: ${currencyFormat.format(summary.todayIncome)}',
            icon: LucideIcons.indianRupee,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFD1FAE5),
            badgeText: 'Avg ${currencyFormat.format(summary.avgIncomePerPatient)}/pt',
            badgeColor: const Color(0xFF059669),
            details: [
              'New Pt: ${currencyFormat.format(summary.newPatientIncome)}',
              'Revisit: ${currencyFormat.format(summary.revisitPatientIncome)}',
              'Avg: ${currencyFormat.format(summary.avgIncomePerPatient)}',
            ],
          ),
        ),
        const SizedBox(width: 16),

        // KPI 4: Operational SLA & Wait Times
        Expanded(
          child: _buildMetricCard(
            title: 'EFFICIENCY & WAIT TIME',
            value: '${summary.avgWaitTimeMinutes.toStringAsFixed(0)} mins',
            subtitle: 'Average Patient Wait Duration',
            icon: LucideIcons.clock,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            badgeText:
                '${summary.avgConsultationMinutes.toStringAsFixed(0)}m Consult',
            badgeColor: const Color(0xFFD97706),
            details: [
              'Avg Wait: ${summary.avgWaitTimeMinutes.toStringAsFixed(0)}m',
              'Avg Rx: ${summary.avgConsultationMinutes.toStringAsFixed(0)}m',
              'Status: Active',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String badgeText,
    required Color badgeColor,
    double? customProgress,
    required List<String> details,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          if (customProgress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: customProgress.clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                minHeight: 6,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: details
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Daily Income & Patient Volume Analytics Table ("Total income per day")
  Widget _buildDailyIncomeSection(
    BuildContext context,
    List<DailyIncomeMetric> dailyList,
    NumberFormat currencyFormat,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      LucideIcons.barChart2,
                      size: 18,
                      color: AppTheme.primaryBlue,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Daily Income & Patient Volume Breakdown',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${dailyList.length} Reporting Days',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),
          if (dailyList.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No patient visits recorded in the selected period.',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(2.0),
              },
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade50),
                  children: const [
                    _TableHeaderCell('Date'),
                    _TableHeaderCell('Total Patients'),
                    _TableHeaderCell('New Patients'),
                    _TableHeaderCell('Revisits'),
                    _TableHeaderCell('Completed'),
                    _TableHeaderCell('Total Income (₹)'),
                  ],
                ),
                // Data Rows
                ...dailyList.map((d) {
                  final isToday = DateFormat('yyyy-MM-dd').format(d.date) ==
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final dateLabel = isToday
                      ? 'Today (${DateFormat("dd MMM yyyy").format(d.date)})'
                      : DateFormat('EEEE, dd MMM yyyy').format(d.date);

                  return TableRow(
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.primaryBlue.withValues(alpha: 0.04)
                          : Colors.white,
                      border: const Border(
                        bottom: BorderSide(color: AppTheme.borderLight),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            if (isToday)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Text(
                              dateLabel,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    isToday ? FontWeight.bold : FontWeight.w500,
                                color: isToday
                                    ? AppTheme.primaryBlue
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          d.totalPatients.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          d.newPatients.toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.slaNormal.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${d.revisitPatients} Revisits',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.slaNormal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          d.completedPatients.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Text(
                          currencyFormat.format(d.totalIncome),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.slaNormal,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTopDiagnosesCard(
    BuildContext context,
    List<DiagnosisStatMetric> diags,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.activity, size: 18, color: AppTheme.primaryBlue),
              SizedBox(width: 10),
              Text(
                'Top Diagnoses & Disease Surveillance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (diags.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No diagnosis data recorded in this period.',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            ...diags.map((d) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            d.diagnosisName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${d.count} cases (${d.percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (d.percentage / 100).clamp(0.05, 1.0),
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryBlue,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDemographicsCard(
    BuildContext context,
    DemographicsMetric demo,
  ) {
    final total = demo.total > 0 ? demo.total : 1;
    final pedPct = (demo.pediatric / total) * 100;
    final adultPct = (demo.adult / total) * 100;
    final gerPct = (demo.geriatric / total) * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.pieChart, size: 18, color: AppTheme.primaryBlue),
              SizedBox(width: 10),
              Text(
                'Patient Demographics',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDemoRow(
            'Paediatric (< 12 years)',
            demo.pediatric,
            pedPct,
            Colors.amber.shade600,
          ),
          const SizedBox(height: 14),
          _buildDemoRow(
            'Adults (12 - 59 years)',
            demo.adult,
            adultPct,
            AppTheme.primaryBlue,
          ),
          const SizedBox(height: 14),
          _buildDemoRow(
            'Geriatric (60+ years)',
            demo.geriatric,
            gerPct,
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoRow(
    String label,
    int count,
    double pct,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$count pts (${pct.toStringAsFixed(1)}%)',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (pct / 100).clamp(0.02, 1.0),
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientLedgerSection(
    BuildContext context,
    WidgetRef ref,
    AdminPanelState state,
    NumberFormat currencyFormat,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Search & Filter Tabs
          Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.fileSpreadsheet,
                          size: 18,
                          color: AppTheme.primaryBlue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Patient Visit Ledger & Audit Log',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    // Status Tabs
                    Wrap(
                      spacing: 6,
                      children:
                          ['ALL', 'COMPLETED', 'WAITING', 'REVISITS'].map((status) {
                        final isSelected = state.statusFilter == status;
                        return InkWell(
                          onTap: () => ref
                              .read(adminPanelProvider.notifier)
                              .setStatusFilter(status),
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                // Search Input
                SizedBox(
                  width: 280,
                  height: 38,
                  child: TextField(
                    onChanged: (val) => ref
                        .read(adminPanelProvider.notifier)
                        .setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search by name, UHID, phone...',
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: const Icon(LucideIcons.search, size: 16),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),
          if (state.filteredPatients.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  'No patient records match the selected filter.',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(1.4),
                3: FlexColumnWidth(1.4),
                4: FlexColumnWidth(1.8),
                5: FlexColumnWidth(1.5),
                6: FlexColumnWidth(1.0),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade50),
                  children: const [
                    _TableHeaderCell('Token / UHID'),
                    _TableHeaderCell('Patient Name'),
                    _TableHeaderCell('Visit Type'),
                    _TableHeaderCell('Queue Status'),
                    _TableHeaderCell('Entry & Wait'),
                    _TableHeaderCell('Fee (₹)'),
                    _TableHeaderCell('Action'),
                  ],
                ),
                ...state.filteredPatients.map((patient) {
                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.borderLight),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${patient.tokenNumber}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            if (patient.patientId != null)
                              Text(
                                patient.patientId!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patient.patientName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${patient.dynamicAgeDisplay} • ${patient.gender == "M" ? "Male" : (patient.gender == "F" ? "Female" : "Other")}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: patient.isRevisit
                                  ? AppTheme.slaNormal.withValues(alpha: 0.12)
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              patient.isRevisit ? 'REVISIT' : 'NEW PATIENT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: patient.isRevisit
                                    ? AppTheme.slaNormal
                                    : AppTheme.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _buildStatusBadge(patient.queueStatus),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('dd/MM h:mm a')
                                  .format(patient.entryTime),
                              style: const TextStyle(fontSize: 12),
                            ),
                            if (patient.consultationStartTime != null)
                              Text(
                                'Waited ${patient.consultationStartTime!.difference(patient.entryTime).inMinutes}m',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Text(
                          currencyFormat.format(
                            patient.consultationFee > 0
                                ? patient.consultationFee
                                : (patient.isRevisit ? 150 : 200),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.slaNormal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: IconButton(
                          icon: const Icon(LucideIcons.eye, size: 16),
                          tooltip: 'View Visit Summary',
                          onPressed: () =>
                              _showPatientDetailsDialog(context, patient),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(QueueStatus status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case QueueStatus.waiting:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'WAITING';
        break;
      case QueueStatus.inConsultation:
        bg = const Color(0xFFEFF6FF);
        fg = const Color(0xFF2563EB);
        label = 'IN CONSULT';
        break;
      case QueueStatus.completed:
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF059669);
        label = 'COMPLETED';
        break;
      case QueueStatus.cancelled:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }

  void _showPatientDetailsDialog(
    BuildContext context,
    PatientQueueItem patient,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Visit Details • Token #${patient.tokenNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(LucideIcons.x, size: 18),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailRow('Patient Name:', patient.patientName),
                  _detailRow('Patient ID (UHID):', patient.patientId ?? '--'),
                  _detailRow('Age & Gender:', '${patient.dynamicAgeDisplay} • ${patient.gender}'),
                  _detailRow('Contact Phone:', patient.phone ?? '--'),
                  _detailRow('Visit Type:', patient.isRevisit ? 'Revisit / Follow-up' : 'First Visit (New)'),
                  _detailRow('Queue Status:', patient.status),
                  _detailRow('Check-in Time:', DateFormat('dd MMM yyyy, h:mm a').format(patient.entryTime)),
                  if (patient.consultationStartTime != null)
                    _detailRow('Consultation Start:', DateFormat('h:mm a').format(patient.consultationStartTime!)),
                  if (patient.completionTime != null)
                    _detailRow('Completion Time:', DateFormat('h:mm a').format(patient.completionTime!)),
                  _detailRow('Consultation Fee:', '₹ ${(patient.consultationFee > 0 ? patient.consultationFee : (patient.isRevisit ? 150 : 200)).toStringAsFixed(0)}'),
                  if (patient.vitals.isNotEmpty) ...[
                    const Divider(height: 24),
                    const Text('Recorded Vitals:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(patient.vitals.toString(), style: const TextStyle(fontSize: 12)),
                  ],
                  if (patient.compiledPrescriptionJson != null) ...[
                    const Divider(height: 24),
                    const Text('Prescription Snapshot:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      patient.compiledPrescriptionJson!,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String text;
  const _TableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
