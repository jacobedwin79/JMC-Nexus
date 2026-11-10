import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../../../core/widgets/wait_timer_badge.dart';
import '../../application/encounter_notifier.dart';
import '../../domain/clinical_models.dart';

class PatientHeaderBar extends ConsumerWidget {
  const PatientHeaderBar({super.key});

  static const List<Map<String, String>> _commonComorbidities = [
    {'id': 'comorb_dm', 'label': 'Type 2 DM'},
    {'id': 'comorb_htn', 'label': 'HTN'},
    {'id': 'comorb_asthma', 'label': 'Asthma'},
    {'id': 'comorb_ckd', 'label': 'CKD'},
    {'id': 'comorb_pregnant', 'label': 'Pregnancy'},
    {'id': 'comorb_pud', 'label': 'PUD'},
    {'id': 'comorb_cad', 'label': 'CAD'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encounter = ref.watch(encounterProvider);
    final patient = encounter.activePatient;

    if (patient == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          border: Border.all(color: Colors.amber.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.arrowLeftCircle, color: Colors.amber, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Select a patient from the waiting queue on the left to start consultation.',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    final vitals = PatientVitals.fromJson(patient.vitals);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: Token Badge, Name/Demographics, Vitals
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Token Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TOKEN',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white70),
                      ),
                      Text(
                        '#${patient.tokenNumber}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Name & Demographics
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              patient.patientName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          WaitTimerBadge(
                            entryTime: patient.entryTime,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient.age} Yrs • ${patient.gender == "M" ? "Male" : (patient.gender == "F" ? "Female" : "Other")}${patient.phone != null ? " • ${patient.phone}" : ""}',
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                // Vitals Strip
                if (vitals.hasAnyVitals) ...[
                  Row(
                    children: [
                      if (vitals.bpSys != null)
                        _buildVitalCard('BP', vitals.bpDisplay, vitals.isHypertensive),
                      if (vitals.pulse != null)
                        _buildVitalCard('Pulse', vitals.pulseDisplay, vitals.isTachycardic),
                      if (vitals.spo2 != null)
                        _buildVitalCard('SpO2', vitals.spo2Display, vitals.isHypoxemic),
                      if (vitals.temp != null)
                        _buildVitalCard('Temp', vitals.tempDisplay, vitals.isFebrile),
                      if (vitals.weight != null)
                        _buildVitalCard('Weight', vitals.weightDisplay, false),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.borderLight),

          // Comorbidities Selector Strip
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            child: Row(
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.heartPulse, size: 16, color: AppTheme.primaryAccent),
                    SizedBox(width: 6),
                    Text(
                      'Comorbidities:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _commonComorbidities.map((c) {
                        final isSelected = encounter.selectedComorbidityIds.contains(c['id']);
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ClinicalChip(
                            label: c['label']!,
                            isSelected: isSelected,
                            onTap: () => ref.read(encounterProvider.notifier).toggleComorbidity(c['id']!),
                            activeColor: AppTheme.primaryAccent,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // High-Visibility Safety Alert Banner if any alerts exist
          if (encounter.safetyAlerts.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.12),
                border: const Border(
                  top: BorderSide(color: AppTheme.slaOverdue, width: 1.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: encounter.safetyAlerts.map((alert) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.alertOctagon, color: AppTheme.slaOverdue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${alert.message} [Drug: ${alert.drugName}]',
                            style: const TextStyle(
                              color: AppTheme.slaOverdue,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVitalCard(String label, String value, bool isAlert) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAlert ? AppTheme.slaOverdue.withValues(alpha: 0.1) : AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAlert ? AppTheme.slaOverdue : AppTheme.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isAlert ? AppTheme.slaOverdue : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isAlert ? AppTheme.slaOverdue : AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
