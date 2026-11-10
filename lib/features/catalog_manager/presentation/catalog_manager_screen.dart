import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:uuid/uuid.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/realtime_queue_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../encounter/application/clinical_catalog_providers.dart';

class CatalogManagerScreen extends ConsumerStatefulWidget {
  const CatalogManagerScreen({super.key});

  @override
  ConsumerState<CatalogManagerScreen> createState() => _CatalogManagerScreenState();
}

class _CatalogManagerScreenState extends ConsumerState<CatalogManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(LucideIcons.database, color: AppTheme.primaryBlue, size: 20),
            SizedBox(width: 10),
            Text('Clinical Catalog & Clinic Settings', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          indicatorColor: AppTheme.primaryBlue,
          tabs: const [
            Tab(icon: Icon(LucideIcons.pill, size: 16), text: 'Master Formulary'),
            Tab(icon: Icon(LucideIcons.fileSpreadsheet, size: 16), text: 'Clinical Protocols'),
            Tab(icon: Icon(LucideIcons.settings, size: 16), text: 'Clinic & Print Setup'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DrugsFormularyTab(),
          _ProtocolsTab(),
          _ClinicSettingsTab(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: MASTER DRUGS FORMULARY
// -----------------------------------------------------------------------------
class _DrugsFormularyTab extends ConsumerStatefulWidget {
  const _DrugsFormularyTab();

  @override
  ConsumerState<_DrugsFormularyTab> createState() => _DrugsFormularyTabState();
}

class _DrugsFormularyTabState extends ConsumerState<_DrugsFormularyTab> {
  String _searchQuery = '';

  void _showAddDrugDialog() {
    final brandController = TextEditingController();
    final genericController = TextEditingController();
    final classController = TextEditingController();
    final doseController = TextEditingController(text: '1 tab');
    final routeController = TextEditingController(text: 'PO');
    final freqController = TextEditingController(text: 'BD');
    final durController = TextEditingController(text: '5 days');
    final instController = TextEditingController(text: 'After food');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(LucideIcons.plusCircle, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Add Drug to Formulary'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand Name (e.g. Tab. Augmentin 625)')),
                  const SizedBox(height: 8),
                  TextField(controller: genericController, decoration: const InputDecoration(labelText: 'Generic Name (e.g. Amoxicillin + Clavulanic Acid)')),
                  const SizedBox(height: 8),
                  TextField(controller: classController, decoration: const InputDecoration(labelText: 'Drug Class (e.g. Antibiotic, NSAID, Antacid)')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: doseController, decoration: const InputDecoration(labelText: 'Default Dose'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: routeController, decoration: const InputDecoration(labelText: 'Route'))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: freqController, decoration: const InputDecoration(labelText: 'Frequency'))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: durController, decoration: const InputDecoration(labelText: 'Duration'))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: instController, decoration: const InputDecoration(labelText: 'Instructions')),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (brandController.text.trim().isEmpty || genericController.text.trim().isEmpty) return;
                final db = ref.read(appDatabaseProvider);
                await db.into(db.drugsTable).insert(
                      DrugsTableCompanion.insert(
                        id: 'drug_${const Uuid().v4().substring(0, 8)}',
                        brandName: brandController.text.trim(),
                        genericName: genericController.text.trim(),
                        drugClass: classController.text.trim(),
                        defaultDose: doseController.text.trim(),
                        defaultRoute: routeController.text.trim(),
                        defaultFrequency: freqController.text.trim(),
                        defaultDuration: durController.text.trim(),
                        defaultInstructions: instController.text.trim(),
                      ),
                    );
                ref.invalidate(drugsCatalogProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save Drug'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final drugsAsync = ref.watch(drugsCatalogProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search formulary by brand, generic, or drug class...',
                    prefixIcon: Icon(LucideIcons.search, size: 18),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showAddDrugDialog,
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Add Drug'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: drugsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (drugs) {
              final query = _searchQuery.toLowerCase();
              final filtered = drugs.where((d) {
                return d.brandName.toLowerCase().contains(query) ||
                    d.genericName.toLowerCase().contains(query) ||
                    d.drugClass.toLowerCase().contains(query);
              }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final drug = filtered[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(drug.brandName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('${drug.genericName} • ${drug.drugClass}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            const SizedBox(height: 4),
                            Text('${drug.defaultDose} | ${drug.defaultRoute} | ${drug.defaultFrequency} | ${drug.defaultDuration} (${drug.defaultInstructions})',
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            drug.drugClass,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: CLINICAL PROTOCOLS
// -----------------------------------------------------------------------------
class _ProtocolsTab extends ConsumerWidget {
  const _ProtocolsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosesAsync = ref.watch(diagnosesCatalogProvider);

    return diagnosesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (diagnoses) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: diagnoses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final diag = diagnoses[index];
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        diag.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.primaryBlue),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceBackground,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderLight),
                        ),
                        child: Text(
                          diag.icd10Code ?? 'ICD-10',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pre-linked Complaints: ${diag.linkedComplaintIds.map((c) => c.replaceAll("pc_", "").toUpperCase()).join(", ")}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Auto-loads corresponding evidence-based regimen into Rx builder upon 1-tap selection.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: CLINIC & PRINT SETTINGS
// -----------------------------------------------------------------------------
class _ClinicSettingsTab extends ConsumerStatefulWidget {
  const _ClinicSettingsTab();

  @override
  ConsumerState<_ClinicSettingsTab> createState() => _ClinicSettingsTabState();
}

class _ClinicSettingsTabState extends ConsumerState<_ClinicSettingsTab> {
  final _clinicNameController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _qualsController = TextEditingController();
  final _regController = TextEditingController();
  final _marginController = TextEditingController();
  final _supabaseUrlController = TextEditingController();
  final _supabaseKeyController = TextEditingController();

  bool _isLoaded = false;

  @override
  void dispose() {
    _clinicNameController.dispose();
    _doctorNameController.dispose();
    _qualsController.dispose();
    _regController.dispose();
    _marginController.dispose();
    _supabaseUrlController.dispose();
    _supabaseKeyController.dispose();
    super.dispose();
  }

  void _loadValues(ClinicSettings settings) {
    if (!_isLoaded) {
      _clinicNameController.text = settings.clinicName;
      _doctorNameController.text = settings.doctorName;
      _qualsController.text = settings.doctorQualifications;
      _regController.text = settings.registrationNumber;
      _marginController.text = settings.letterheadTopMarginMm.toString();
      _supabaseUrlController.text = settings.supabaseUrl;
      _supabaseKeyController.text = settings.supabaseAnonKey;
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(clinicSettingsProvider);
    _loadValues(settings);

    final syncState = ref.watch(realtimeQueueServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Clinic & Letterhead Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Doctor & Clinic Letterhead Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(controller: _clinicNameController, decoration: const InputDecoration(labelText: 'Clinic / Hospital Name')),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _doctorNameController, decoration: const InputDecoration(labelText: 'Doctor Name'))),
                    const SizedBox(width: 10),
                    Expanded(child: TextField(controller: _regController, decoration: const InputDecoration(labelText: 'Medical Reg. No.'))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: _qualsController, decoration: const InputDecoration(labelText: 'Qualifications (e.g. MBBS, MD)')),
                const SizedBox(height: 10),
                TextField(
                  controller: _marginController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Pre-printed Letterhead Top Margin (mm)',
                    hintText: '45.0',
                    helperText: 'Standard physical letterhead margin to keep printed content strictly below pre-printed graphics.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Supabase Real-Time Cloud Sync
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Supabase Multi-Device Cloud Sync', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: syncState.isConnected
                            ? AppTheme.slaNormal.withValues(alpha: 0.15)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        syncState.isConnected ? '● Connected' : '○ Offline Mode (SQLite Active)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: syncState.isConnected ? AppTheme.slaNormal : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(controller: _supabaseUrlController, decoration: const InputDecoration(labelText: 'Supabase Project URL', hintText: 'https://xyz.supabase.co')),
                const SizedBox(height: 10),
                TextField(controller: _supabaseKeyController, decoration: const InputDecoration(labelText: 'Supabase Anon / Publishable Key')),
                if (syncState.syncError != null) ...[
                  const SizedBox(height: 8),
                  Text(syncState.syncError!, style: const TextStyle(color: AppTheme.slaOverdue, fontSize: 12)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Save Settings Button
          ElevatedButton.icon(
            onPressed: () async {
              final updated = settings.copyWith(
                clinicName: _clinicNameController.text.trim(),
                doctorName: _doctorNameController.text.trim(),
                doctorQualifications: _qualsController.text.trim(),
                registrationNumber: _regController.text.trim(),
                letterheadTopMarginMm: double.tryParse(_marginController.text) ?? 45.0,
                supabaseUrl: _supabaseUrlController.text.trim(),
                supabaseAnonKey: _supabaseKeyController.text.trim(),
              );

              await ref.read(clinicSettingsProvider.notifier).updateSettings(updated);

              if (updated.hasSupabaseCredentials) {
                await ref.read(realtimeQueueServiceProvider.notifier).initialize(
                      supabaseUrl: updated.supabaseUrl,
                      supabaseAnonKey: updated.supabaseAnonKey,
                    );
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Clinic settings saved successfully!'),
                    backgroundColor: AppTheme.slaNormal,
                  ),
                );
              }
            },
            icon: const Icon(LucideIcons.save, size: 18),
            label: const Text('Save Settings & Apply Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
