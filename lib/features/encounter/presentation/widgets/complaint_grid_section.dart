import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';
import '../../domain/clinical_models.dart';

/// Represents a duration unit for custom entry
class DurationUnit {
  final String label;
  final int factor; // days multiplier

  const DurationUnit({required this.label, required this.factor});
}

class ComplaintGridSection extends ConsumerStatefulWidget {
  const ComplaintGridSection({super.key});

  /// Duration unit options for custom duration entry
  static const List<DurationUnit> _durationUnits = [
    DurationUnit(label: 'Days', factor: 1),
    DurationUnit(label: 'Weeks', factor: 7),
    DurationUnit(label: 'Months', factor: 30),
  ];

  @override
  ConsumerState<ComplaintGridSection> createState() =>
      _ComplaintGridSectionState();
}

class _ComplaintGridSectionState extends ConsumerState<ComplaintGridSection> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<DurationUnit> _durationUnits =
      ComplaintGridSection._durationUnits;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complaintsAsync = ref.watch(complaintsCatalogProvider);
    final encounter = ref.watch(encounterProvider);
    final selectedComplaints = encounter.selectedComplaints;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    LucideIcons.messageSquarePlus,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Presenting Complaints',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              if (selectedComplaints.isNotEmpty)
                Text(
                  '${selectedComplaints.length} Selected',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Search / Typeahead box for filtering presenting complaints
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText:
                  'Search complaints or type custom (e.g. fever, cough)...',
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
                          tooltip: 'Add "$_searchQuery" as custom complaint',
                          onPressed: () {
                            ref
                                .read(encounterProvider.notifier)
                                .addCustomComplaint(_searchQuery);
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
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
            onChanged: (value) => setState(() => _searchQuery = value),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                ref.read(encounterProvider.notifier).addCustomComplaint(value);
                _searchController.clear();
                setState(() => _searchQuery = '');
              }
            },
          ),
          if (_searchQuery.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            InkWell(
              onTap: () {
                ref
                    .read(encounterProvider.notifier)
                    .addCustomComplaint(_searchQuery);
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
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
                      'Add "$_searchQuery" as custom complaint',
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

          // Complaints Chips Grid
          complaintsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading complaints: $err'),
            data: (complaints) {
              final customSelected = selectedComplaints.values
                  .where(
                    (c) => !complaints.any((cat) => cat.id == c.complaintId),
                  )
                  .toList();

              // Always keep selected complaints visible, even if filtered out.
              final filtered = query.isEmpty
                  ? complaints
                  : complaints
                        .where(
                          (c) =>
                              selectedComplaints.containsKey(c.id) ||
                              c.name.toLowerCase().contains(query) ||
                              c.category.toLowerCase().contains(query),
                        )
                        .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (customSelected.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: customSelected.map((c) {
                        return Chip(
                          label: Text(
                            c.complaintName,
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
                              .removeComplaint(c.complaintId),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (filtered.isEmpty && customSelected.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No complaints match "$_searchQuery". Tap "+ Add" above to add it as custom.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filtered.map((complaint) {
                        final isSelected = selectedComplaints.containsKey(
                          complaint.id,
                        );
                        return ClinicalChip(
                          label: complaint.name,
                          isSelected: isSelected,
                          onTap: () => ref
                              .read(encounterProvider.notifier)
                              .toggleComplaint(complaint),
                          activeColor: AppTheme.primaryBlue,
                        );
                      }).toList(),
                    ),
                ],
              );
            },
          ),

          // Sub-Questions for Selected Complaints
          if (selectedComplaints.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: AppTheme.borderLight),
            const SizedBox(height: 8),
            complaintsAsync.maybeWhen(
              data: (complaints) {
                final selectedModels = complaints
                    .where((c) => selectedComplaints.containsKey(c.id))
                    .toList();

                return Column(
                  children: selectedModels.map((complaint) {
                    final complaintState = selectedComplaints[complaint.id]!;
                    return _buildComplaintSubQuestionsCard(
                      context,
                      ref,
                      complaint,
                      complaintState,
                    );
                  }).toList(),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComplaintSubQuestionsCard(
    BuildContext context,
    WidgetRef ref,
    PresentingComplaintModel complaint,
    SelectedComplaintState state,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                complaint.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
              InkWell(
                onTap: () => ref
                    .read(encounterProvider.notifier)
                    .toggleComplaint(complaint),
                child: const Icon(
                  LucideIcons.x,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Sub-questions options
          ...complaint.subQuestions.map((sq) {
            final selectedList = state.selectedOptions[sq.id] ?? [];
            final isDurationQuestion = sq.questionLabel.toLowerCase().contains(
              'duration',
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sq.questionLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: sq.options.map((option) {
                      final isSelected = selectedList.contains(option);

                      // Handle "Custom..." option for duration questions
                      if (isDurationQuestion && option == 'Custom...') {
                        return InkWell(
                          onTap: () => _showCustomDurationDialog(
                            context,
                            ref,
                            complaint.id,
                            sq.id,
                            sq.sentenceTemplate,
                            sq.isMultiSelect,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryAccent
                                    : AppTheme.borderLight,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.edit3,
                                  size: 12,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primaryAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Custom Duration',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.primaryAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ClinicalChip(
                        label: option,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(encounterProvider.notifier)
                              .selectSubQuestionOption(
                                complaintId: complaint.id,
                                subQuestionId: sq.id,
                                option: option,
                                sentenceTemplate: sq.sentenceTemplate,
                                isMultiSelect: sq.isMultiSelect,
                              );
                        },
                        activeColor: AppTheme.primaryAccent,
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),

          // Compiled Clinical Prose
          if (state.compiledProse.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.fileText,
                    size: 14,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      state.compiledProse,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Shows a dialog for custom duration entry with number input and unit selector
  Future<void> _showCustomDurationDialog(
    BuildContext context,
    WidgetRef ref,
    String complaintId,
    String subQuestionId,
    String sentenceTemplate,
    bool isMultiSelect,
  ) async {
    int number = 1;
    DurationUnit selectedUnit = _durationUnits.first;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Enter Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Number input
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: '1',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null && parsed > 0) {
                        setModalState(() {
                          number = parsed;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Unit selector
                  const Text(
                    'Unit',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _durationUnits.map((unit) {
                      final isSelected = selectedUnit == unit;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedUnit = unit;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : AppTheme.surfaceBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.borderLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                unit.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Preview
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Preview: "$number ${selectedUnit.label.toLowerCase()}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confirm button
                  ElevatedButton(
                    onPressed: () {
                      final durationText =
                          '$number ${selectedUnit.label.toLowerCase()}';
                      ref
                          .read(encounterProvider.notifier)
                          .selectSubQuestionOption(
                            complaintId: complaintId,
                            subQuestionId: subQuestionId,
                            option: durationText,
                            sentenceTemplate: sentenceTemplate,
                            isMultiSelect: isMultiSelect,
                          );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
