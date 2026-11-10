import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../../../core/widgets/wait_timer_badge.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';
import '../../domain/clinical_models.dart';

class PatientHeaderBar extends ConsumerWidget {
  const PatientHeaderBar({super.key});

  Future<void> _showVisitHistorySheet(
    BuildContext context,
    WidgetRef ref,
    String patientId,
  ) async {
    final db = ref.read(appDatabaseProvider);
    final history = await db.getVisitHistoryForPatient(patientId);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.history, color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          Text(
                            'Past Visit History ($patientId)',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (history.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text('No previous completed visits found for this patient.'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];
                          final completedAt = item.completionTime != null
                              ? DateFormat('dd MMM yyyy, h:mm a').format(item.completionTime!.toLocal())
                              : 'Date unknown';
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Visit #Token ${item.tokenNumber}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        completedAt,
                                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  if (item.compiledPrescriptionJson != null)
                                    Text(
                                      'Prescription Snapshot: ${item.compiledPrescriptionJson!}',
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
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
          },
        );
      },
    );
  }

  Future<void> _showAddCustomComorbidityDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Comorbidity'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Comorbidity name',
              hintText: 'e.g. Hypothyroidism',
            ),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (name != null && name.trim().isNotEmpty) {
      await ref.read(encounterProvider.notifier).addCustomComorbidity(name);
      ref.invalidate(comorbiditiesCatalogProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encounter = ref.watch(encounterProvider);
    final patient = encounter.activePatient;
    final comorbiditiesAsync = ref.watch(comorbiditiesCatalogProvider);

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
                          const SizedBox(width: 8),
                          if (patient.age < 12)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue.shade300),
                              ),
                              child: const Text(
                                'Paediatric',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            )
                          else if (patient.age >= 65)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.purple.shade300),
                              ),
                              child: const Text(
                                'Geriatric',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple),
                              ),
                            ),
                          const SizedBox(width: 8),
                          WaitTimerBadge(
                            entryTime: patient.entryTime,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${patient.patientId != null && patient.patientId!.trim().isNotEmpty ? "MRN: ${patient.patientId} • " : ""}${patient.age} Yrs • ${patient.gender == "M" ? "Male" : (patient.gender == "F" ? "Female" : "Other")}${patient.phone != null ? " • ${patient.phone}" : ""}',
                            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                          ),
                          if (patient.patientId != null && patient.patientId!.trim().isNotEmpty) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _showVisitHistorySheet(context, ref, patient.patientId!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LucideIcons.history, size: 12, color: AppTheme.primaryBlue),
                                    SizedBox(width: 4),
                                    Text(
                                      'Past Rx',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryBlue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Vitals Strip (Evaluated against Age)
                if (vitals.hasAnyVitals) ...[
                  Row(
                    children: [
                      if (vitals.bpSys != null)
                        _buildVitalCard('BP', vitals.bpDisplay, vitals.isHypertensiveForAge(patient.age)),
                      if (vitals.pulse != null)
                        _buildVitalCard('Pulse', vitals.pulseDisplay, vitals.isTachycardicForAge(patient.age) || vitals.isBradycardicForAge(patient.age)),
                      if (vitals.spo2 != null)
                        _buildVitalCard('SpO2', vitals.spo2Display, vitals.isHypoxemic),
                      if (vitals.temp != null)
                        _buildVitalCard('Temp', vitals.tempDisplay, vitals.isFebrile),
                      if (vitals.rbs != null)
                        _buildVitalCard('RBS', vitals.rbsDisplay, vitals.isHypoglycemic || vitals.isHyperglycemic),
                      if (vitals.weight != null)
                        _buildVitalCard('Weight', vitals.weightDisplay, false),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Allergies & Pregnancy Alert Strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
            color: encounter.allergies.isNotEmpty
                ? AppTheme.emergencyRed.withValues(alpha: 0.1)
                : Colors.grey.shade50,
            child: Row(
              children: [
                Icon(
                  LucideIcons.shieldAlert,
                  size: 15,
                  color: encounter.allergies.isNotEmpty ? AppTheme.emergencyRed : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    encounter.allergies.isNotEmpty
                        ? 'ALLERGIES: ${encounter.allergies.join(", ")}'
                        : 'ALLERGIES: No Known Drug Allergies (NKDA)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: encounter.allergies.isNotEmpty ? AppTheme.emergencyRed : Colors.grey.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (encounter.isPregnant || encounter.lmp != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Pregnant ${encounter.lmp != null ? "• LMP: ${encounter.lmp}" : ""}',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
                    ),
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
                    child: comorbiditiesAsync.when(
                      loading: () => const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (err, _) => Text(
                        'Could not load comorbidities',
                        style: TextStyle(fontSize: 12, color: AppTheme.slaOverdue),
                      ),
                      data: (comorbidities) {
                        return Row(
                          children: [
                            ...comorbidities.map((c) {
                              final isSelected =
                                  encounter.selectedComorbidityIds.contains(c.id);
                              return Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: ClinicalChip(
                                  label: comorbidityDisplayLabel(c),
                                  isSelected: isSelected,
                                  onTap: () => ref
                                      .read(encounterProvider.notifier)
                                      .toggleComorbidity(c.id),
                                  activeColor: AppTheme.primaryAccent,
                                ),
                              );
                            }),
                            InkWell(
                              onTap: () => _showAddCustomComorbidityDialog(context, ref),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppTheme.primaryAccent),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(LucideIcons.plus,
                                        size: 12, color: AppTheme.primaryAccent),
                                    SizedBox(width: 4),
                                    Text(
                                      'Custom',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
