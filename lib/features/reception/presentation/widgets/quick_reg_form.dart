import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/clinical_chip.dart';
import '../../../encounter/domain/clinical_models.dart';
import '../../application/reception_notifier.dart';

class QuickRegForm extends ConsumerStatefulWidget {
  const QuickRegForm({super.key});

  @override
  ConsumerState<QuickRegForm> createState() => _QuickRegFormState();
}

class _QuickRegFormState extends ConsumerState<QuickRegForm> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  final _bpSysController = TextEditingController();
  final _bpDiaController = TextEditingController();
  final _pulseController = TextEditingController();
  final _spo2Controller = TextEditingController();
  final _tempController = TextEditingController();
  final _weightController = TextEditingController();

  bool _showVitals = false;

  final List<Map<String, String>> _commonComorbs = [
    {'id': 'comorb_dm', 'label': 'Type 2 DM'},
    {'id': 'comorb_htn', 'label': 'HTN'},
    {'id': 'comorb_asthma', 'label': 'Asthma'},
    {'id': 'comorb_ckd', 'label': 'CKD'},
    {'id': 'comorb_pregnant', 'label': 'Pregnancy'},
    {'id': 'comorb_cad', 'label': 'CAD'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _bpSysController.dispose();
    _bpDiaController.dispose();
    _pulseController.dispose();
    _spo2Controller.dispose();
    _tempController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameController.clear();
    _ageController.clear();
    _phoneController.clear();
    _bpSysController.clear();
    _bpDiaController.clear();
    _pulseController.clear();
    _spo2Controller.clear();
    _tempController.clear();
    _weightController.clear();
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

          // Phone Field (Optional)
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (val) => ref.read(receptionProvider.notifier).setPhone(val),
            decoration: const InputDecoration(
              labelText: 'Phone Number (Optional)',
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonComorbs.map((c) {
                  final isSelected = formState.selectedComorbIds.contains(c['id']);
                  return ClinicalChip(
                    label: c['label']!,
                    isSelected: isSelected,
                    onTap: () => ref.read(receptionProvider.notifier).toggleComorbidity(c['id']!),
                    activeColor: AppTheme.primaryAccent,
                  );
                }).toList(),
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
                      _showVitals ? 'Hide Entry Vitals' : '+ Entry Vitals (BP, Pulse, SpO2)',
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
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                bpSys: int.tryParse(val),
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _bpDiaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'BP Dia', hintText: '80'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                bpDia: int.tryParse(val),
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _pulseController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Pulse', hintText: '72'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                pulse: int.tryParse(val),
                              ),
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
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                spo2: int.tryParse(val),
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _tempController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Temp °F', hintText: '98.6'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                temp: double.tryParse(val),
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Wt (kg)', hintText: '65'),
                          onChanged: (val) => ref.read(receptionProvider.notifier).updateVitals(
                                weight: double.tryParse(val),
                              ),
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
