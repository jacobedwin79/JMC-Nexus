import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/clinical_catalog_providers.dart';
import '../../application/encounter_notifier.dart';
import '../../domain/clinical_models.dart';

class PrescriptionSection extends ConsumerStatefulWidget {
  const PrescriptionSection({super.key});

  @override
  ConsumerState<PrescriptionSection> createState() =>
      _PrescriptionSectionState();
}

class _PrescriptionSectionState extends ConsumerState<PrescriptionSection> {
  final _adviceController = TextEditingController();
  final List<String> _frequencies = ['OD', 'BD', 'TID', 'QID', 'SOS', 'HS'];
  final List<int> _followUpOptions = [3, 5, 7, 10, 14];

  @override
  void dispose() {
    _adviceController.dispose();
    super.dispose();
  }

  void _showAddDrugDialog(BuildContext context, List<DrugModel> allDrugs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = allDrugs.where((d) {
              final query = searchQuery.toLowerCase();
              return d.brandName.toLowerCase().contains(query) ||
                  d.genericName.toLowerCase().contains(query) ||
                  d.drugClass.toLowerCase().contains(query);
            }).toList();

            return Container(
              padding: const EdgeInsets.all(16),
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Drug from Formulary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search brand, generic, or drug class...',
                      prefixIcon: Icon(LucideIcons.search),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final drug = filtered[idx];
                        return ListTile(
                          title: Text(
                            drug.brandName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${drug.genericName} • ${drug.drugClass}',
                          ),
                          trailing: const Icon(
                            LucideIcons.plusCircle,
                            color: AppTheme.primaryBlue,
                          ),
                          onTap: () {
                            ref
                                .read(encounterProvider.notifier)
                                .addPrescriptionItem(
                                  PrescriptionItemModel(
                                    drugId: drug.id,
                                    genericName: drug.genericName,
                                    brandName: drug.brandName,
                                    drugClass: drug.drugClass,
                                    dose: drug.defaultDose,
                                    route: drug.defaultRoute,
                                    frequency: drug.defaultFrequency,
                                    duration: drug.defaultDuration,
                                    instructions: drug.defaultInstructions,
                                  ),
                                );
                            Navigator.pop(context);
                          },
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

  @override
  Widget build(BuildContext context) {
    final encounter = ref.watch(encounterProvider);
    final activeRx = encounter.activePrescription;
    final allDrugsAsync = ref.watch(drugsCatalogProvider);
    final topMedicationsAsync = ref.watch(topMedicationsProvider);

    // Keep advice controller synced
    if (_adviceController.text != encounter.generalAdvice) {
      _adviceController.text = encounter.generalAdvice;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title & Add Drug Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.pill,
                    size: 16,
                    color: AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Prescription Builder (Rx)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${activeRx.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (encounter.activePatient?.patientId != null &&
                      encounter.activePatient!.patientId!.isNotEmpty) ...[
                    OutlinedButton.icon(
                      onPressed: () async {
                        final success = await ref
                            .read(encounterProvider.notifier)
                            .repeatLastPrescription();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Re-prescribed previous visit medications.'
                                    : 'No previous prescription found for this patient.',
                              ),
                              backgroundColor: success
                                  ? AppTheme.primaryBlue
                                  : AppTheme.slaWarning,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(LucideIcons.repeat, size: 14),
                      label: const Text(
                        'Repeat Last Rx',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  allDrugsAsync.maybeWhen(
                    data: (drugs) => ElevatedButton.icon(
                      onPressed: () => _showAddDrugDialog(context, drugs),
                      icon: const Icon(LucideIcons.plus, size: 14),
                      label: const Text(
                        'Add Drug',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        elevation: 0,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Top 20 Most Frequent Medications (1-Tap Add)
          topMedicationsAsync.maybeWhen(
            data: (topDrugs) {
              if (topDrugs.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(LucideIcons.sparkles, size: 13, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        'Top Formulary Medications (1-Tap Add):',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: topDrugs.map((drug) {
                        final isPrescribed = activeRx.any(
                          (rx) => rx.drugId == drug.id,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ActionChip(
                            avatar: isPrescribed
                                ? const Icon(
                                    LucideIcons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    LucideIcons.plus,
                                    size: 12,
                                    color: AppTheme.primaryBlue,
                                  ),
                            label: Text(
                              drug.brandName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isPrescribed
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            backgroundColor: isPrescribed
                                ? AppTheme.primaryBlue
                                : Colors.grey.shade100,
                            side: BorderSide(
                              color: isPrescribed
                                  ? AppTheme.primaryBlue
                                  : AppTheme.borderLight,
                            ),
                            onPressed: () {
                              if (!isPrescribed) {
                                ref
                                    .read(encounterProvider.notifier)
                                    .addPrescriptionItem(
                                      PrescriptionItemModel(
                                        drugId: drug.id,
                                        genericName: drug.genericName,
                                        brandName: drug.brandName,
                                        drugClass: drug.drugClass,
                                        dose: drug.defaultDose,
                                        route: drug.defaultRoute,
                                        frequency: drug.defaultFrequency,
                                        duration: drug.defaultDuration,
                                        instructions: drug.defaultInstructions,
                                      ),
                                    );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),

          // Prescription items list
          if (activeRx.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    LucideIcons.filePlus,
                    size: 36,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No medications prescribed yet.\nTap a Diagnosis above to auto-load protocol medications.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeRx.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final rx = activeRx[idx];
                final hasConflict = encounter.safetyAlerts.any(
                  (a) => a.drugClass == rx.drugClass,
                );

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasConflict
                        ? AppTheme.slaOverdue.withValues(alpha: 0.05)
                        : AppTheme.surfaceBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasConflict
                          ? AppTheme.slaOverdue
                          : AppTheme.borderLight,
                      width: hasConflict ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    rx.brandName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    '(${rx.genericName})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasConflict
                                        ? AppTheme.slaOverdue.withValues(
                                            alpha: 0.15,
                                          )
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    rx.drugClass,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: hasConflict
                                          ? AppTheme.slaOverdue
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.trash2,
                              size: 16,
                              color: AppTheme.slaOverdue,
                            ),
                            tooltip: 'Remove',
                            onPressed: () {
                              ref
                                  .read(encounterProvider.notifier)
                                  .removePrescriptionItem(rx.drugId);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Inline dose & frequency chips
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: Text(
                              'Dose: ${rx.dose}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Frequency selector chips
                          Row(
                            children: _frequencies.map((freq) {
                              final isSelected =
                                  rx.frequency.toUpperCase() == freq;
                              return InkWell(
                                onTap: () {
                                  ref
                                      .read(encounterProvider.notifier)
                                      .updatePrescriptionItem(
                                        rx.copyWith(frequency: freq),
                                      );
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : AppTheme.borderLight,
                                    ),
                                  ),
                                  child: Text(
                                    freq,
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

                          const SizedBox(width: 8),
                          // Duration editor (tap to edit)
                          InkWell(
                            onTap: () =>
                                _showEditDurationDialog(context, ref, rx),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppTheme.borderLight),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    rx.duration,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    LucideIcons.edit2,
                                    size: 10,
                                    color: AppTheme.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Text(
                        'Instructions: ${rx.instructions}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 16),
          const Divider(color: AppTheme.borderLight),
          const SizedBox(height: 8),

          // General Advice Field with Kerala Malayalam Presets & Voice Dictation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'General Advice / Dietary Instructions',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Voice Dictation ready. Connect Gemini API key in settings for real-time clinical speech parsing.',
                      ),
                      backgroundColor: AppTheme.primaryBlue,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.mic,
                        size: 13,
                        color: AppTheme.primaryBlue,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Voice Dictate (AI)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Malayalam Quick Presets for Kerala OPD
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAdviceChip('ധാരാളം വെള്ളം കുടിക്കുക (Plenty of fluids)'),
                _buildAdviceChip('ഭക്ഷണത്തിന് ശേഷം മരുന്ന് (Take after food)'),
                _buildAdviceChip('എണ്ണയും എരിവും ഒഴിവാക്കുക (Avoid oil/spice)'),
                _buildAdviceChip('3 ദിവസത്തിന് ശേഷം കാണിക്കുക (Review in 3d)'),
                _buildAdviceChip(
                  'പനി കൂടിയാൽ ഉടൻ വരിക (Emergency if fever spikes)',
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          TextField(
            controller: _adviceController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'e.g. Bland diet, avoid spices, plenty of hydration...',
            ),
            onChanged: (val) {
              ref.read(encounterProvider.notifier).setGeneralAdvice(val);
            },
          ),
          const SizedBox(height: 14),

          // Mandatory Follow-up Days Selector
          Row(
            children: [
              const Text(
                'Follow-up in: *',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              if (encounter.followUpDays == null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.slaOverdue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.slaOverdue),
                  ),
                  child: const Text(
                    'Selection Mandatory',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.slaOverdue,
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _followUpOptions.map((days) {
                      final isSelected = encounter.followUpDays == days;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(encounterProvider.notifier)
                                .setFollowUpDays(isSelected ? null : days);
                          },
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.surfaceBackground,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryBlue
                                    : (encounter.followUpDays == null
                                          ? AppTheme.slaOverdue.withValues(
                                              alpha: 0.5,
                                            )
                                          : AppTheme.borderLight),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Text(
                              '$days Days',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to edit prescription duration with number + unit selector
  Future<void> _showEditDurationDialog(
    BuildContext context,
    WidgetRef ref,
    PrescriptionItemModel rx,
  ) async {
    // Parse current duration to extract number and unit
    int number = 1;
    DurationUnit selectedUnit = _durationUnits.first;

    final parts = rx.duration.trim().split(' ');
    if (parts.length >= 2) {
      final parsedNum = int.tryParse(parts[0]);
      final unitStr = parts[1].toLowerCase();
      if (parsedNum != null && parsedNum > 0) {
        number = parsedNum;
        for (final unit in _durationUnits) {
          if (unitStr.contains(unit.label.toLowerCase())) {
            selectedUnit = unit;
            break;
          }
        }
      }
    }

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
                  Text(
                    'Edit Duration: ${rx.brandName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                    controller: TextEditingController(text: number.toString()),
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
                          .updatePrescriptionItem(
                            rx.copyWith(duration: durationText),
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

  Widget _buildAdviceChip(String adviceText) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ActionChip(
        label: Text(
          adviceText,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.teal.shade50,
        side: BorderSide(color: Colors.teal.shade200),
        onPressed: () {
          final current = _adviceController.text.trim();
          final updated = current.isEmpty
              ? adviceText
              : '$current; $adviceText';
          _adviceController.text = updated;
          ref.read(encounterProvider.notifier).setGeneralAdvice(updated);
        },
      ),
    );
  }
}

/// Represents a duration unit for custom entry
class DurationUnit {
  final String label;
  final int factor; // days multiplier

  const DurationUnit({required this.label, required this.factor});
}

/// Duration unit options for custom entry
const List<DurationUnit> _durationUnits = [
  DurationUnit(label: 'Days', factor: 1),
  DurationUnit(label: 'Weeks', factor: 7),
  DurationUnit(label: 'Months', factor: 30),
];
