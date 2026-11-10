import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../../encounter/application/clinical_catalog_providers.dart';
import '../../../encounter/domain/clinical_models.dart';
import '../../../encounter/domain/patient_queue_item.dart';
import '../../application/reception_notifier.dart';

class QuickRegForm extends ConsumerStatefulWidget {
  const QuickRegForm({super.key});

  @override
  ConsumerState<QuickRegForm> createState() => _QuickRegFormState();
}

class _QuickRegFormState extends ConsumerState<QuickRegForm> {
  final _patientIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<PatientQueueItem> _searchResults = const [];
  bool _showSearch = false;
  bool _isSearching = false;

  final _bpSysController = TextEditingController();
  final _bpDiaController = TextEditingController();
  final _pulseController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _tempController = TextEditingController();
  final _weightController = TextEditingController();
  final _rbsController = TextEditingController();

  bool _showVitals = false;

  @override
  void dispose() {
    _patientIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    _bpSysController.dispose();
    _bpDiaController.dispose();
    _pulseController.dispose();
    _spo2Controller.dispose();
    _tempController.dispose();
    _weightController.dispose();
    _rbsController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _patientIdController.clear();
    _nameController.clear();
    _ageController.clear();
    _phoneController.clear();
    _searchController.clear();
    _bpSysController.clear();
    _bpDiaController.clear();
    _pulseController.clear();
    _spo2Controller.clear();
    _tempController.clear();
    _weightController.clear();
    _rbsController.clear();
    setState(() {
      _searchResults = const [];
      _showSearch = false;
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final query = value.trim();
    if (query.length < 2) {
      setState(() {
        _searchResults = const [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    _searchDebounce = Timer(const Duration(milliseconds: 250), () async {
      final results =
          await ref.read(receptionProvider.notifier).searchPreviousPatients(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _loadPreviousPatient(PatientQueueItem patient) {
    final vitals = PatientVitals.fromJson(patient.vitals);
    _patientIdController.text = patient.patientId ?? '';
    _nameController.text = patient.patientName;
    _ageController.text = patient.age.toString();
    _phoneController.text = patient.phone ?? '';
    _bpSysController.text = vitals.bpSys?.toString() ?? '';
    _bpDiaController.text = vitals.bpDia?.toString() ?? '';
    _pulseController.text = vitals.pulse?.toString() ?? '';
    _spo2Controller.text = vitals.spo2?.toString() ?? '';
    _tempController.text = vitals.temp?.toString() ?? '';
    _weightController.text = vitals.weight?.toString() ?? '';
    _rbsController.text = vitals.rbs?.toString() ?? '';

    ref.read(receptionProvider.notifier).prefillFromPreviousPatient(patient);

    setState(() {
      _showSearch = false;
      _searchResults = const [];
      _searchController.clear();
      _showVitals = vitals.hasAnyVitals;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded previous record for ${patient.patientName} (${patient.allergies.isNotEmpty ? "${patient.allergies.length} allergies recorded" : "No allergies"})'),
        backgroundColor: AppTheme.primaryBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showAddCustomAllergyDialog() async {
    final controller = TextEditingController();
    final allergy = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Drug Allergy'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Allergen / Drug Name',
              hintText: 'e.g. Ciprofloxacin, Amoxicillin',
            ),
            onSubmitted: (val) => Navigator.of(context).pop(val),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add Allergy'),
            ),
          ],
        );
      },
    );

    if (allergy != null && allergy.trim().isNotEmpty) {
      ref.read(receptionProvider.notifier).toggleAllergy(allergy.trim());
    }
  }

  Future<void> _showAddCustomComorbidityDialog() async {
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
      await ref.read(receptionProvider.notifier).addCustomComorbidity(name);
      ref.invalidate(comorbiditiesCatalogProvider);
    }
  }

  Future<void> _handleRegister() async {
    final token = await ref.read(receptionProvider.notifier).registerAndGenerateToken();
    if (token != null && mounted) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Issued Token #$token successfully!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _seedDemoOverduePatient() async {
    await ref.read(receptionProvider.notifier).registerMockPatientWithElapsedWait(
      name: 'Mohan Lal (Overdue Demo)',
      age: 62,
      gender: 'M',
      elapsedWait: const Duration(minutes: 52),
      comorbs: ['comorb_dm', 'comorb_htn'],
      vitals: const PatientVitals(
        bpSys: 145,
        bpDia: 92,
        pulse: 88,
        spo2: 97,
        temp: 98.6,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Simulated Patient Mohan Lal (52m wait) added! Overdue alert triggered.'),
          backgroundColor: AppTheme.slaOverdue,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(receptionProvider);
    final comorbiditiesAsync = ref.watch(comorbiditiesCatalogProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Next Token Display Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEXT TOKEN',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'TOKEN #${formState.nextTokenNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _seedDemoOverduePatient,
                  icon: const Icon(LucideIcons.alertTriangle, size: 12, color: AppTheme.slaOverdue),
                  label: const Text(
                    '>45m Test',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Load Previous Patient (UHID / Phone / Name search)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _showSearch = !_showSearch),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.history, size: 18, color: AppTheme.primaryBlue),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Load Previous Patient',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                        Icon(
                          _showSearch ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showSearch) ...[
                  const Divider(height: 1, color: AppTheme.borderLight),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search by UHID, phone, or name...',
                            prefixIcon: const Icon(LucideIcons.search, size: 18),
                            suffixIcon: _isSearching
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        if (_searchResults.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 220),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.borderLight),
                            ),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _searchResults.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final p = _searchResults[index];
                                final dateLabel =
                                    DateFormat('d MMM yyyy').format(p.entryTime.toLocal());
                                return ListTile(
                                  dense: true,
                                  leading: const Icon(LucideIcons.userCheck, size: 18),
                                  title: Text(
                                    p.patientName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${p.age}Y ${p.gender}'
                                    '${p.patientId != null && p.patientId!.isNotEmpty ? " • ${p.patientId}" : ""}'
                                    '${p.phone != null && p.phone!.isNotEmpty ? " • ${p.phone}" : ""}'
                                    ' • $dateLabel',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  trailing: const Icon(LucideIcons.arrowRight, size: 16),
                                  onTap: () => _loadPreviousPatient(p),
                                );
                              },
                            ),
                          ),
                        ] else if (_searchController.text.trim().length >= 2 && !_isSearching) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'No matching previous patients found.',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Error banner if any
          if (formState.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.1),
                border: Border.all(color: AppTheme.slaOverdue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertCircle, color: AppTheme.slaOverdue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formState.errorMessage!,
                      style: const TextStyle(color: AppTheme.slaOverdue, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Patient ID / UHID (Optional but recommended for repeat visits)
          TextField(
            controller: _patientIdController,
            onChanged: (val) => ref.read(receptionProvider.notifier).setPatientId(val),
            decoration: const InputDecoration(
              labelText: 'Patient ID / UHID (Optional)',
              hintText: 'e.g. JMC-10234',
              prefixIcon: Icon(LucideIcons.badge, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          // Patient Name
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) => ref.read(receptionProvider.notifier).setPatientName(val),
            decoration: const InputDecoration(
              labelText: 'Patient Full Name *',
              hintText: 'e.g. Rajesh Kumar',
              prefixIcon: Icon(LucideIcons.user, size: 18),
            ),
          ),
          const SizedBox(height: 12),

          // Age & Gender Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age Input
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (val) {
                    final age = int.tryParse(val);
                    ref.read(receptionProvider.notifier).setAge(age);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Age *',
                    hintText: 'Yrs',
                    prefixIcon: Icon(LucideIcons.calendar, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Gender Selector Segment
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sex',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: ['M', 'F', 'O'].map((g) {
                        final isSelected = formState.gender == g;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1.5),
                            child: InkWell(
                              onTap: () => ref.read(receptionProvider.notifier).setGender(g),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryBlue : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primaryBlue : AppTheme.borderLight,
                                  ),
                                ),
                                child: Text(
                                  g == 'M' ? 'Male' : (g == 'F' ? 'Female' : 'Other'),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reproductive Screen & Pregnancy (Inferred for reproductive age females)
          if (formState.gender == 'F' &&
              formState.age != null &&
              formState.age! >= 12 &&
              formState.age! <= 55) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.heartHandshake, size: 16, color: Colors.purple),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Reproductive & Pregnancy Screen',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.purple),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Checkbox(
                        value: formState.isPregnant,
                        activeColor: Colors.purple,
                        onChanged: (val) {
                          ref.read(receptionProvider.notifier).setIsPregnant(val ?? false);
                        },
                      ),
                      const Text('Pregnant', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(LucideIcons.calendar, size: 14),
                          label: Text(
                            formState.lmp != null ? 'LMP: ${formState.lmp}' : 'Set Last Menstrual Period (LMP)',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: now.subtract(const Duration(days: 30)),
                              firstDate: now.subtract(const Duration(days: 300)),
                              lastDate: now,
                            );
                            if (picked != null) {
                              final formatted = DateFormat('dd MMM yyyy').format(picked);
                              ref.read(receptionProvider.notifier).setLmp(formatted);
                            }
                          },
                        ),
                      ),
                      if (formState.lmp != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                          onPressed: () => ref.read(receptionProvider.notifier).setLmp(null),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Phone Field (Optional, auto-searches returning patients)
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (val) {
              ref.read(receptionProvider.notifier).setPhone(val);
              if (val.trim().length >= 4) {
                _onSearchChanged(val);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Phone Number (Auto-lookup returning patients)',
              hintText: '10-digit mobile number',
              prefixIcon: Icon(LucideIcons.phone, size: 18),
            ),
          ),
          const SizedBox(height: 14),

          // Comorbidities Quick Selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Known Comorbidities (Optional)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 6),
              comorbiditiesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (err, _) => Text(
                  'Could not load comorbidities: $err',
                  style: const TextStyle(fontSize: 12, color: AppTheme.slaOverdue),
                ),
                data: (comorbidities) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...comorbidities.map((c) {
                        final isSelected = formState.selectedComorbIds.contains(c.id);
                        return ClinicalChip(
                          label: comorbidityDisplayLabel(c),
                          isSelected: isSelected,
                          onTap: () => ref.read(receptionProvider.notifier).toggleComorbidity(c.id),
                          activeColor: AppTheme.primaryAccent,
                        );
                      }),
                      InkWell(
                        onTap: _showAddCustomComorbidityDialog,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primaryAccent,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(LucideIcons.plus, size: 12, color: AppTheme.primaryAccent),
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
            ],
          ),
          const SizedBox(height: 14),

          // Allergies Quick Selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(LucideIcons.shieldAlert, size: 14, color: AppTheme.emergencyRed),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Documented Drug Allergies (CRITICAL SAFETY)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.emergencyRed,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...[
                    'Penicillin',
                    'Sulfa',
                    'NSAIDs / Aspirin',
                    'Paracetamol',
                    'Cephalosporins',
                    'Fluoroquinolones',
                    'Macrolides',
                  ].map((allergy) {
                    final isSelected = formState.selectedAllergies.contains(allergy);
                    return ClinicalChip(
                      label: allergy,
                      isSelected: isSelected,
                      onTap: () => ref.read(receptionProvider.notifier).toggleAllergy(allergy),
                      activeColor: AppTheme.emergencyRed,
                    );
                  }),
                  ...formState.selectedAllergies
                      .where((a) => ![
                            'Penicillin',
                            'Sulfa',
                            'NSAIDs / Aspirin',
                            'Paracetamol',
                            'Cephalosporins',
                            'Fluoroquinolones',
                            'Macrolides',
                          ].contains(a))
                      .map((customAllergy) {
                    return ClinicalChip(
                      label: customAllergy,
                      isSelected: true,
                      onTap: () => ref.read(receptionProvider.notifier).toggleAllergy(customAllergy),
                      activeColor: AppTheme.emergencyRed,
                    );
                  }),
                  InkWell(
                    onTap: _showAddCustomAllergyDialog,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.emergencyRed),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.plus, size: 12, color: AppTheme.emergencyRed),
                          const SizedBox(width: 4),
                          const Text(
                            '+ Allergy',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.emergencyRed,
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
          const SizedBox(height: 14),

          // Quick Vitals Toggle Accordion
          InkWell(
            onTap: () => setState(() => _showVitals = !_showVitals),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.activity, size: 18, color: AppTheme.primaryBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _showVitals ? 'Hide Entry Vitals' : '+ Entry Vitals (BP, Pulse, SpO2, RBS)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _showVitals ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 18,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          if (_showVitals) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bpSysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'BP Sys', hintText: '120'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setBpSys(int.tryParse(val)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _bpDiaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'BP Dia', hintText: '80'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setBpDia(int.tryParse(val)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _pulseController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Pulse', hintText: '72'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setPulse(int.tryParse(val)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _spo2Controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'SpO2 %', hintText: '98'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setSpo2(int.tryParse(val)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _tempController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: formState.vitals.tempIsCelsius ? 'Temp °C' : 'Temp °F',
                            hintText: formState.vitals.tempIsCelsius ? '37.0' : '98.6',
                            suffixIcon: InkWell(
                              onTap: () {
                                ref.read(receptionProvider.notifier).setTempIsCelsius(!formState.vitals.tempIsCelsius);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                child: Text(
                                  formState.vitals.tempIsCelsius ? '°C' : '°F',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                ),
                              ),
                            ),
                          ),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setTemp(double.tryParse(val)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Wt (kg)', hintText: '65'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setWeight(double.tryParse(val)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _rbsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'RBS mg/dL', hintText: '110'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).setRbs(int.tryParse(val)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Primary CTA: Issue Token
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: formState.isSubmitting ? null : _handleRegister,
              icon: formState.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.ticket, size: 20),
              label: Text(
                formState.isSubmitting
                    ? 'Issuing Token...'
                    : 'Issue Token #${formState.nextTokenNumber}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
