import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';

class DiagnosisSection extends ConsumerWidget {
  const DiagnosisSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosesAsync = ref.watch(diagnosesCatalogProvider);
    final encounter = ref.watch(encounterProvider);
    final selectedDiagnoses = encounter.selectedDiagnosisIds;
    final selectedComplaints = encounter.selectedComplaints.keys.toSet();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.stethoscope, size: 18, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text(
                    'Clinical Diagnosis & Protocol Loading',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                '1-tap auto-loads pre-set Rx',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 12),

          diagnosesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading diagnoses: $err'),
            data: (diagnoses) {
              // Sort suggested diagnoses first if linked to any active complaint
              final sortedDiagnoses = List.of(diagnoses)..sort((a, b) {
                  final aMatches = a.linkedComplaintIds.any(selectedComplaints.contains);
                  final bMatches = b.linkedComplaintIds.any(selectedComplaints.contains);
                  if (aMatches && !bMatches) return -1;
                  if (!aMatches && bMatches) return 1;
                  return a.name.compareTo(b.name);
                });

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sortedDiagnoses.map((diag) {
                  final isSelected = selectedDiagnoses.contains(diag.id);
                  final isRecommended = diag.linkedComplaintIds.any(selectedComplaints.contains);

                  return ClinicalChip(
                    label: diag.name + (diag.icd10Code != null ? ' (${diag.icd10Code})' : ''),
                    isSelected: isSelected,
                    icon: isRecommended && !isSelected ? LucideIcons.sparkles : null,
                    onTap: () {
                      if (isSelected) {
                        ref.read(encounterProvider.notifier).removeDiagnosis(diag.id);
                      } else {
                        ref.read(encounterProvider.notifier).selectDiagnosis(diag.id);
                      }
                    },
                    activeColor: AppTheme.primaryBlue,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

