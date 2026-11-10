import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../application/encounter_notifier.dart';

class InvestigationsSection extends ConsumerStatefulWidget {
  const InvestigationsSection({super.key});

  static const List<String> commonInvestigations = [
    'CBC',
    'RBS',
    'Serum Creatinine',
    'LFT',
    'Lipid Profile',
    'Urine Routine',
    'ECG (12-Lead)',
    'Chest X-Ray PA',
    'USG Abdomen & Pelvis',
    'HbA1c',
    'Dengue NS1 / IgM',
    'Widal Test',
    'TSH / Thyroid Profile',
    'Serum Electrolytes',
    'ESR / CRP',
    'S. Uric Acid',
  ];

  @override
  ConsumerState<InvestigationsSection> createState() =>
      _InvestigationsSectionState();
}

class _InvestigationsSectionState extends ConsumerState<InvestigationsSection> {
  final _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _handleAddCustom(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    ref.read(encounterProvider.notifier).addCustomInvestigation(trimmed);
    _customController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final encounter = ref.watch(encounterProvider);
    final selectedInvestigations = encounter.investigations;

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
                    LucideIcons.flaskConical,
                    size: 18,
                    color: AppTheme.primaryBlue,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Investigations & Diagnostic Orders',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              if (selectedInvestigations.isNotEmpty)
                Text(
                  '${selectedInvestigations.length} Ordered',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Common Quick Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: InvestigationsSection.commonInvestigations.map((
              testName,
            ) {
              final isSelected = selectedInvestigations.contains(testName);
              return ClinicalChip(
                label: testName,
                isSelected: isSelected,
                activeColor: AppTheme.primaryBlue,
                onTap: () {
                  ref
                      .read(encounterProvider.notifier)
                      .toggleInvestigation(testName);
                },
              );
            }).toList(),
          ),

          // Custom Investigations selected that are not in common list
          if (selectedInvestigations.any(
            (inv) => !InvestigationsSection.commonInvestigations.contains(inv),
          )) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedInvestigations
                  .where(
                    (inv) => !InvestigationsSection.commonInvestigations
                        .contains(inv),
                  )
                  .map((customTest) {
                    return Chip(
                      label: Text(
                        customTest,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppTheme.primaryBlue,
                      deleteIcon: const Icon(
                        LucideIcons.x,
                        size: 14,
                        color: Colors.white,
                      ),
                      onDeleted: () {
                        ref
                            .read(encounterProvider.notifier)
                            .removeInvestigation(customTest);
                      },
                    );
                  })
                  .toList(),
            ),
          ],

          const SizedBox(height: 12),

          // Typeahead / Autocomplete for adding custom investigation
          RawAutocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              final query = textEditingValue.text.trim().toLowerCase();
              if (query.isEmpty) return const Iterable<String>.empty();
              final matches = InvestigationsSection.commonInvestigations.where((
                item,
              ) {
                return item.toLowerCase().contains(query);
              });
              if (matches.isEmpty) {
                return [textEditingValue.text.trim()];
              }
              return matches;
            },
            onSelected: (String selection) {
              _handleAddCustom(selection);
            },
            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText:
                            'Search or type custom investigation (e.g. CT Brain, 2D Echo)...',
                        prefixIcon: const Icon(LucideIcons.search, size: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            LucideIcons.plusCircle,
                            size: 18,
                            color: AppTheme.primaryBlue,
                          ),
                          tooltip: 'Add Investigation',
                          onPressed: () {
                            _handleAddCustom(controller.text);
                            controller.clear();
                          },
                        ),
                      ),
                      onSubmitted: (val) {
                        _handleAddCustom(val);
                        controller.clear();
                      },
                    ),
                  ),
                ],
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 320,
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return ListTile(
                          dense: true,
                          title: Text(
                            option,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: const Icon(
                            LucideIcons.plus,
                            size: 14,
                            color: AppTheme.primaryBlue,
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
