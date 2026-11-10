import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';

class DiagnosisSection extends ConsumerStatefulWidget {
  const DiagnosisSection({super.key});

  @override
  ConsumerState<DiagnosisSection> createState() => _DiagnosisSectionState();
}

class _DiagnosisSectionState extends ConsumerState<DiagnosisSection> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleAddCustom(String customName) {
    final trimmed = customName.trim();
    if (trimmed.isEmpty) return;
    ref.read(encounterProvider.notifier).addCustomDiagnosis(trimmed);
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  @override
  Widget build(BuildContext context) {
    final diagnosesAsync = ref.watch(diagnosesCatalogProvider);
    final encounter = ref.watch(encounterProvider);
    final selectedDiagnoses = encounter.selectedDiagnosisIds;
    final selectedComplaints = encounter.selectedComplaints.keys.toSet();
    final query = _searchQuery.trim().toLowerCase();

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
                    LucideIcons.stethoscope,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Clinical Diagnosis & Protocol Loading',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                '1-tap auto-loads pre-set Rx',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search / Typeahead Input for Diagnoses
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText:
                  'Search diagnoses or enter custom (e.g. URTI, Bronchitis)...',
              prefixIcon: const Icon(LucideIcons.search, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            LucideIcons.plusCircle,
                            color: AppTheme.primaryBlue,
                          ),
                          tooltip: 'Add "$_searchQuery" as custom diagnosis',
                          onPressed: () => _handleAddCustom(_searchQuery),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 16),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                      ],
                    )
                  : null,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
            onSubmitted: (val) => _handleAddCustom(val),
          ),
          if (_searchQuery.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () => _handleAddCustom(_searchQuery),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.plus,
                      size: 14,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add "$_searchQuery" as custom diagnosis',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          diagnosesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading diagnoses: $err'),
            data: (diagnoses) {
              // Custom selected diagnoses not in master catalog
              final customSelected = selectedDiagnoses
                  .where((id) => !diagnoses.any((d) => d.id == id))
                  .toList();

              // Smart Diagnosis Ranking:
              // Sort dynamically by match count against currently selected complaints.
              // Diagnoses with more matching complaints rank higher (e.g. Cough + Fever -> URTI bumps to the top)
              final sortedDiagnoses = List.of(diagnoses)
                ..sort((a, b) {
                  final aMatchCount = a.linkedComplaintIds
                      .where(selectedComplaints.contains)
                      .length;
                  final bMatchCount = b.linkedComplaintIds
                      .where(selectedComplaints.contains)
                      .length;

                  if (aMatchCount != bMatchCount) {
                    return bMatchCount.compareTo(
                      aMatchCount,
                    ); // Higher match count first
                  }
                  return a.name.compareTo(b.name);
                });

              final filtered = query.isEmpty
                  ? sortedDiagnoses
                  : sortedDiagnoses.where((d) {
                      return selectedDiagnoses.contains(d.id) ||
                          d.name.toLowerCase().contains(query) ||
                          (d.icd10Code != null &&
                              d.icd10Code!.toLowerCase().contains(query));
                    }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (customSelected.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: customSelected.map((id) {
                        return Chip(
                          label: Text(
                            id.replaceAll('diag_custom_', '').toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: AppTheme.primaryBlue,
                          deleteIcon: const Icon(
                            LucideIcons.x,
                            size: 14,
                            color: Colors.white,
                          ),
                          onDeleted: () => ref
                              .read(encounterProvider.notifier)
                              .removeDiagnosis(id),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filtered.map((diag) {
                      final isSelected = selectedDiagnoses.contains(diag.id);
                      final matchCount = diag.linkedComplaintIds
                          .where(selectedComplaints.contains)
                          .length;
                      final isRecommended = matchCount > 0;

                      return ClinicalChip(
                        label:
                            diag.name +
                            (diag.icd10Code != null
                                ? ' (${diag.icd10Code})'
                                : '') +
                            (isRecommended && matchCount > 1
                                ? ' ★$matchCount'
                                : ''),
                        isSelected: isSelected,
                        icon: isRecommended && !isSelected
                            ? LucideIcons.sparkles
                            : null,
                        onTap: () {
                          if (isSelected) {
                            ref
                                .read(encounterProvider.notifier)
                                .removeDiagnosis(diag.id);
                          } else {
                            ref
                                .read(encounterProvider.notifier)
                                .selectDiagnosis(diag.id);
                          }
                        },
                        activeColor: AppTheme.primaryBlue,
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
