import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/config/clinic_settings.dart';
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
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _feeController = TextEditingController();

  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  List<PatientQueueItem> _searchResults = const [];
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
    _dobController.dispose();
    _phoneController.dispose();
    _feeController.dispose();
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
    _dobController.clear();
    _phoneController.clear();
    _feeController.clear();
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
      final results = await ref
          .read(receptionProvider.notifier)
          .searchPreviousPatients(query);
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
    if (patient.dateOfBirth != null) {
      _dobController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(patient.dateOfBirth!);
    } else {
      _dobController.clear();
    }
    _phoneController.text = patient.phone ?? '';
    final clinicSettings = ref.read(clinicSettingsProvider);
    _feeController.text = clinicSettings.revisitFee.toStringAsFixed(0);
    _bpSysController.text = vitals.bpSys?.toString() ?? '';
    _bpDiaController.text = vitals.bpDia?.toString() ?? '';
    _pulseController.text = vitals.pulse?.toString() ?? '';
    _spo2Controller.text = vitals.spo2?.toString() ?? '';
    _tempController.text = vitals.temp?.toString() ?? '';
    _weightController.text = vitals.weight?.toString() ?? '';
    _rbsController.text = vitals.rbs?.toString() ?? '';

    ref.read(receptionProvider.notifier).prefillFromPreviousPatient(patient);

    setState(() {
      _searchResults = const [];
      _searchController.clear();
      _showVitals = vitals.hasAnyVitals;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded record for ${patient.patientName}'),
        backgroundColor: Colors.grey.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add Drug Allergy',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: _minimalInputDecoration('Allergen / Drug Name', null),
            onSubmitted: (val) => Navigator.of(context).pop(val),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppTheme.emergencyRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add'),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add Comorbidity',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: _minimalInputDecoration('Comorbidity name', null),
            onSubmitted: (value) => Navigator.pop(context, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
    final token = await ref
        .read(receptionProvider.notifier)
        .registerAndGenerateToken();
    if (token != null && mounted) {
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Token #$token issued successfully',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.grey.shade900,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _seedDemoOverduePatient() async {
    await ref
        .read(receptionProvider.notifier)
        .registerMockPatientWithElapsedWait(
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
        SnackBar(
          content: const Text(
            'Simulated Patient added. Overdue alert triggered.',
          ),
          backgroundColor: AppTheme.slaOverdue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // MINIMAL DESIGN SYSTEM HELPER
  InputDecoration _minimalInputDecoration(
    String label,
    IconData? icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      prefixIcon: icon != null
          ? Icon(icon, size: 18, color: Colors.grey.shade500)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppTheme.primaryBlue.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(receptionProvider);
    final settings = ref.watch(clinicSettingsProvider);
    final comorbiditiesAsync = ref.watch(comorbiditiesCatalogProvider);

    if (_feeController.text.isEmpty) {
      _feeController.text = (formState.consultationFee ??
              (formState.isRevisit ? settings.revisitFee : settings.consultationFee))
          .toStringAsFixed(0);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Minimal Next Token Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT TOKEN',
                      style: TextStyle(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${formState.nextTokenNumber}',
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _seedDemoOverduePatient,
                  tooltip: 'Add >45m Test Patient',
                  icon: const Icon(LucideIcons.flaskConical, size: 20),
                  color: AppTheme.textSecondary,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Integrated Search (Seamless)
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: _minimalInputDecoration(
              'Search previous patient...',
              LucideIcons.search,
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults = const [];
                          _isSearching = false;
                        });
                      },
                    )
                  : null,
            ),
          ),

          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade100),
                itemBuilder: (context, index) {
                  final p = _searchResults[index];
                  final dateLabel = DateFormat(
                    'MMM d, yyyy',
                  ).format(p.entryTime.toLocal());
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      p.patientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${p.age}Y ${p.gender} • $dateLabel',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () => _loadPreviousPatient(p),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Error banner minimal
          if (formState.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.info,
                    color: AppTheme.slaOverdue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      formState.errorMessage!,
                      style: const TextStyle(
                        color: AppTheme.slaOverdue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Core Info Section
          const Text(
            'PATIENT DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            onChanged: (val) =>
                ref.read(receptionProvider.notifier).setPatientName(val),
            decoration: _minimalInputDecoration(
              'Patient Full Name *',
              LucideIcons.user,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (val) {
                    final age = int.tryParse(val);
                    ref.read(receptionProvider.notifier).setAge(age);
                    if (ref.read(receptionProvider).isPaediatric) {
                      setState(() => _showVitals = true);
                    }
                  },
                  decoration: _minimalInputDecoration(
                    'Age *',
                    LucideIcons.calendar,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Container(
                  height: 52, // Match TextField height
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: ['M', 'F', 'O'].map((g) {
                      final isSelected = formState.gender == g;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              ref.read(receptionProvider.notifier).setGender(g),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            margin: const EdgeInsets.all(4),
                            child: Text(
                              g == 'M'
                                  ? 'Male'
                                  : (g == 'F' ? 'Female' : 'Other'),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppTheme.textPrimary
                                    : Colors.grey.shade600,
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

          if (formState.dynamicAgeDisplay.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
              child: Text(
                'Clinical Age: ${formState.dynamicAgeDisplay}${formState.isPaediatric ? " (Weight Req.)" : ""}',
                style: TextStyle(
                  fontSize: 11,
                  color: formState.isPaediatric
                      ? Colors.amber.shade700
                      : Colors.grey.shade600,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (val) {
              ref.read(receptionProvider.notifier).setPhone(val);
              if (val.trim().length >= 4) _onSearchChanged(val);
            },
            decoration: _minimalInputDecoration(
              'Phone Number',
              LucideIcons.phone,
            ),
          ),
          const SizedBox(height: 12),

          // Visit Type & Consultation Fee
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(receptionProvider.notifier)
                                .setIsRevisit(false);
                            _feeController.text =
                                settings.consultationFee.toStringAsFixed(0);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !formState.isRevisit
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: !formState.isRevisit
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            margin: const EdgeInsets.all(4),
                            child: Text(
                              'New Patient',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: !formState.isRevisit
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: !formState.isRevisit
                                    ? AppTheme.primaryBlue
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(receptionProvider.notifier)
                                .setIsRevisit(true);
                            _feeController.text =
                                settings.revisitFee.toStringAsFixed(0);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: formState.isRevisit
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: formState.isRevisit
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                            margin: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  LucideIcons.repeat,
                                  size: 12,
                                  color: AppTheme.slaNormal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Revisit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: formState.isRevisit
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: formState.isRevisit
                                        ? AppTheme.slaNormal
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _feeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (val) {
                    final fee = double.tryParse(val);
                    ref
                        .read(receptionProvider.notifier)
                        .setConsultationFee(fee);
                  },
                  decoration: _minimalInputDecoration(
                    'Fee (₹)',
                    LucideIcons.indianRupee,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Clinical Info Section
          const Text(
            'CLINICAL PROFILE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Reproductive Screen (Minimal)
          if (formState.gender == 'F' &&
              formState.age != null &&
              formState.age! >= 12 &&
              formState.age! <= 55) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.baby, size: 18, color: Colors.purple),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Pregnancy Screen',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: formState.isPregnant,
                    activeTrackColor: Colors.purple,
                    onChanged: (val) =>
                        ref.read(receptionProvider.notifier).setIsPregnant(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Comorbidities
          const Text(
            'Comorbidities',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          comorbiditiesAsync.when(
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (err, _) => Text(
              'Error: $err',
              style: const TextStyle(fontSize: 12, color: AppTheme.slaOverdue),
            ),
            data: (comorbidities) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...comorbidities.map((c) {
                    final isSelected = formState.selectedComorbIds.contains(
                      c.id,
                    );
                    return ClinicalChip(
                      label: comorbidityDisplayLabel(c),
                      isSelected: isSelected,
                      onTap: () => ref
                          .read(receptionProvider.notifier)
                          .toggleComorbidity(c.id),
                      activeColor: AppTheme.textPrimary,
                    );
                  }),
                  ActionChip(
                    label: const Text(
                      '+ Custom',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: _showAddCustomComorbidityDialog,
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Allergies
          const Text(
            'Allergies',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.emergencyRed,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...['Penicillin', 'Sulfa', 'NSAIDs / Aspirin', 'Paracetamol'].map(
                (allergy) {
                  final isSelected = formState.selectedAllergies.contains(
                    allergy,
                  );
                  return ClinicalChip(
                    label: allergy,
                    isSelected: isSelected,
                    onTap: () => ref
                        .read(receptionProvider.notifier)
                        .toggleAllergy(allergy),
                    activeColor: AppTheme.emergencyRed,
                  );
                },
              ),
              ...formState.selectedAllergies
                  .where(
                    (a) => ![
                      'Penicillin',
                      'Sulfa',
                      'NSAIDs / Aspirin',
                      'Paracetamol',
                    ].contains(a),
                  )
                  .map((customAllergy) {
                    return ClinicalChip(
                      label: customAllergy,
                      isSelected: true,
                      onTap: () => ref
                          .read(receptionProvider.notifier)
                          .toggleAllergy(customAllergy),
                      activeColor: AppTheme.emergencyRed,
                    );
                  }),
              ActionChip(
                label: const Text(
                  '+ Add',
                  style: TextStyle(fontSize: 12, color: AppTheme.emergencyRed),
                ),
                onPressed: _showAddCustomAllergyDialog,
                backgroundColor: AppTheme.emergencyRed.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Vitals Toggle (Minimal)
          InkWell(
            onTap: () => setState(() => _showVitals = !_showVitals),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.activity,
                    size: 16,
                    color: _showVitals ? AppTheme.primaryBlue : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Vitals (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _showVitals
                          ? AppTheme.primaryBlue
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showVitals
                        ? LucideIcons.chevronUp
                        : LucideIcons.chevronDown,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          if (_showVitals) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bpSysController,
                    keyboardType: TextInputType.number,
                    decoration: _minimalInputDecoration('BP Sys', null),
                    onChanged: (val) => ref
                        .read(receptionProvider.notifier)
                        .setBpSys(int.tryParse(val)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _bpDiaController,
                    keyboardType: TextInputType.number,
                    decoration: _minimalInputDecoration('BP Dia', null),
                    onChanged: (val) => ref
                        .read(receptionProvider.notifier)
                        .setBpDia(int.tryParse(val)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pulseController,
                    keyboardType: TextInputType.number,
                    decoration: _minimalInputDecoration('Pulse', null),
                    onChanged: (val) => ref
                        .read(receptionProvider.notifier)
                        .setPulse(int.tryParse(val)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _minimalInputDecoration(
                      formState.isPaediatric ? 'Wt (kg) *' : 'Wt (kg)',
                      null,
                    ),
                    onChanged: (val) => ref
                        .read(receptionProvider.notifier)
                        .setWeight(double.tryParse(val)),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 32),

          // Primary CTA (Flat and Soft)
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: formState.isSubmitting ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppTheme
                    .textPrimary, // Changed to a sleek dark color or use standard primary
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: formState.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Issue Token #${formState.nextTokenNumber}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
