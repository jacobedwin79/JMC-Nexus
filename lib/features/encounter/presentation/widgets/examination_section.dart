import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';

class ExaminationSection extends ConsumerWidget {
  const ExaminationSection({super.key});

  Future<void> _showAddCustomFindingDialog(
    BuildContext context,
    WidgetRef ref,
    String systemId,
    String systemName,
  ) async {
    final controller = TextEditingController();
    final finding = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                LucideIcons.activity,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Custom Finding ($systemName)'),
            ],
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Abnormal Clinical Finding',
              hintText: 'e.g. Wheezing on left base, Clubbing grade 2',
            ),
            onSubmitted: (val) => Navigator.pop(context, val),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add Finding'),
            ),
          ],
        );
      },
    );

    if (finding != null && finding.trim().isNotEmpty) {
      await ref
          .read(encounterProvider.notifier)
          .addCustomExamFinding(systemId, finding.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examSystemsAsync = ref.watch(examSystemsCatalogProvider);
    final encounter = ref.watch(encounterProvider);
    final examStates = encounter.examStates;

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
                  Icon(
                    LucideIcons.activity,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Systemic Examination (Default-Normal)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                '0 taps if normal',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Examination Systems Accordions
          examSystemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading systems: $err'),
            data: (systems) {
              return Column(
                children: systems.map((sys) {
                  final sysState = examStates[sys.id];
                  final isNormal = sysState?.isNormal ?? true;

                  // Custom abnormals not in the master catalog for this system
                  final customAbnormals = (sysState?.selectedAbnormals ?? [])
                      .where((f) => !sys.abnormalFindings.contains(f))
                      .toList();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isNormal
                          ? AppTheme.surfaceBackground
                          : AppTheme.slaWarning.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isNormal
                            ? AppTheme.borderLight
                            : AppTheme.slaWarning,
                        width: isNormal ? 1.0 : 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  sys.systemName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isNormal
                                        ? AppTheme.slaNormal.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppTheme.slaWarning.withValues(
                                            alpha: 0.15,
                                          ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isNormal ? 'Normal' : 'Abnormal Findings',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: isNormal
                                          ? AppTheme.slaNormal
                                          : AppTheme.slaWarning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!isNormal)
                              TextButton.icon(
                                onPressed: () => ref
                                    .read(encounterProvider.notifier)
                                    .toggleExamSystemNormal(sys.id),
                                icon: const Icon(
                                  LucideIcons.rotateCcw,
                                  size: 12,
                                ),
                                label: const Text(
                                  'Reset Normal',
                                  style: TextStyle(fontSize: 11),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Current finding text preview
                        Text(
                          sysState?.compiledText ?? sys.defaultNormalText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isNormal
                                ? FontWeight.normal
                                : FontWeight.w600,
                            color: isNormal
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Abnormal findings chips to override
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ...sys.abnormalFindings.map((finding) {
                              final isSelected =
                                  sysState?.selectedAbnormals.contains(
                                    finding,
                                  ) ??
                                  false;
                              return ClinicalChip(
                                label: finding,
                                isSelected: isSelected,
                                onTap: () {
                                  ref
                                      .read(encounterProvider.notifier)
                                      .toggleExamAbnormalFinding(
                                        sys.id,
                                        finding,
                                      );
                                },
                                activeColor: AppTheme.slaWarning,
                                isAlert: isSelected,
                              );
                            }),
                            ...customAbnormals.map((finding) {
                              return Chip(
                                label: Text(
                                  finding,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppTheme.slaWarning,
                                deleteIcon: const Icon(
                                  LucideIcons.x,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                onDeleted: () {
                                  ref
                                      .read(encounterProvider.notifier)
                                      .toggleExamAbnormalFinding(
                                        sys.id,
                                        finding,
                                      );
                                },
                              );
                            }),
                            // + Custom Finding Typeahead button
                            InkWell(
                              onTap: () => _showAddCustomFindingDialog(
                                context,
                                ref,
                                sys.id,
                                sys.systemName,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppTheme.borderLight,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.plus,
                                      size: 12,
                                      color: AppTheme.primaryBlue,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Custom Finding',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
