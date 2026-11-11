import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/config/clinic_settings.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/realtime_queue_service.dart';
import '../../../core/sync/supabase_drug_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';
import '../../encounter/application/clinical_catalog_providers.dart';
import '../../encounter/domain/clinical_models.dart';

class CatalogManagerScreen extends ConsumerStatefulWidget {
  final bool isReadOnlyFormulary;
  final int? initialTab;

  const CatalogManagerScreen({
    super.key,
    this.isReadOnlyFormulary = false,
    this.initialTab,
  });

  @override
  ConsumerState<CatalogManagerScreen> createState() =>
      _CatalogManagerScreenState();
}

class _CatalogManagerScreenState extends ConsumerState<CatalogManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabCount = 5;

  @override
  void initState() {
    super.initState();
    // Default 5 tabs for Admin; will be rechecked in build for non-admins
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _syncAllCatalogs() async {
    try {
      final summary = await ref
          .read(supabaseCatalogSyncProvider.notifier)
          .syncAllCatalogs();
      ref.invalidate(drugsCatalogProvider);
      ref.invalidate(complaintsCatalogProvider);
      ref.invalidate(comorbiditiesCatalogProvider);
      ref.invalidate(diagnosesCatalogProvider);
      ref.invalidate(examSystemsCatalogProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Synced ${summary.totalRecords} records (${summary.drugCount} drugs, ${summary.complaintCount} complaints, ${summary.comorbidityCount} comorbs, ${summary.diagnosisCount} diags) from Supabase.',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.slaNormal,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Catalog sync failed: $e')),
            ],
          ),
          backgroundColor: AppTheme.slaOverdue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);
    final isAdmin = activeRole == AppRole.admin && !widget.isReadOnlyFormulary;
    final syncState = ref.watch(supabaseCatalogSyncProvider);

    // If non-admin or read-only formulary requested, only show Master Formulary
    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(LucideIcons.pill, color: AppTheme.primaryBlue, size: 20),
              SizedBox(width: 10),
              Text(
                'Master Formulary (Read Only)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: const _DrugsFormularyTab(),
      );
    }

    // Admin view with 5 management tabs
    final expectedLength = 5;
    if (_tabCount != expectedLength || _tabController.length != expectedLength) {
      _tabController.dispose();
      _tabController = TabController(
        length: expectedLength,
        vsync: this,
        initialIndex: (widget.initialTab ?? 0).clamp(0, expectedLength - 1),
      );
      _tabCount = expectedLength;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(LucideIcons.database, color: AppTheme.primaryBlue, size: 20),
            SizedBox(width: 10),
            Text(
              'Clinical Catalog & Clinic Settings (Admin)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Master Supabase Sync Button for Admin
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: syncState.isLoading ? null : _syncAllCatalogs,
              icon: syncState.isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(LucideIcons.refreshCw, size: 14),
              label: Text(
                syncState.isLoading ? 'Syncing...' : 'Sync All Catalogs',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          indicatorColor: AppTheme.primaryBlue,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.pill, size: 16),
              text: 'Master Formulary',
            ),
            Tab(
              icon: Icon(LucideIcons.stethoscope, size: 16),
              text: 'Complaints',
            ),
            Tab(
              icon: Icon(LucideIcons.shieldAlert, size: 16),
              text: 'Comorbidities',
            ),
            Tab(
              icon: Icon(LucideIcons.fileSpreadsheet, size: 16),
              text: 'Diagnoses & Protocols',
            ),
            Tab(
              icon: Icon(LucideIcons.settings, size: 16),
              text: 'Clinic & Print Setup',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _DrugsFormularyTab(),
          _ComplaintsManagerTab(),
          _ComorbiditiesManagerTab(),
          _DiagnosesManagerTab(),
          _ClinicSettingsTab(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: MASTER DRUGS FORMULARY (READ ONLY)
// -----------------------------------------------------------------------------
class _DrugsFormularyTab extends ConsumerStatefulWidget {
  const _DrugsFormularyTab();

  @override
  ConsumerState<_DrugsFormularyTab> createState() => _DrugsFormularyTabState();
}

class _DrugsFormularyTabState extends ConsumerState<_DrugsFormularyTab> {
  String _searchQuery = '';

  Future<void> _handleSync() async {
    final count = await ref
        .read(supabaseDrugSyncProvider.notifier)
        .syncFromSupabase();
    ref.invalidate(drugsCatalogProvider);
    if (!mounted) return;

    final syncState = ref.read(supabaseDrugSyncProvider);
    if (syncState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.alertCircle, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text('Sync failed: ${syncState.error}')),
            ],
          ),
          backgroundColor: AppTheme.slaOverdue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Successfully synced $count drugs from Supabase public.drugmaster.'),
            ],
          ),
          backgroundColor: AppTheme.slaNormal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final drugsAsync = ref.watch(drugsCatalogProvider);
    final syncState = ref.watch(supabaseDrugSyncProvider);

    return Column(
      children: [
        // Read-Only & Supabase Source Notice Banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.lock, size: 16, color: AppTheme.primaryBlue),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Master Formulary • Read Only (Supabase public.drugmaster)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Centrally managed on cloud Supabase. Clinical staff cannot add or edit drugs locally to ensure formulary integrity and inventory synchronization.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.shieldCheck, size: 12, color: AppTheme.primaryBlue),
                    SizedBox(width: 4),
                    Text(
                      'READ ONLY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Bar & Supabase Sync Button
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
                onPressed: syncState.isLoading ? null : _handleSync,
                icon: syncState.isLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(LucideIcons.refreshCw, size: 16),
                label: Text(
                  syncState.isLoading ? 'Syncing...' : 'Sync from Supabase',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: drugsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.alertTriangle,
                    size: 36,
                    color: AppTheme.slaOverdue,
                  ),
                  const SizedBox(height: 10),
                  Text('Failed to load formulary: $err'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _handleSync,
                    icon: const Icon(LucideIcons.refreshCw, size: 14),
                    label: const Text('Retry Sync'),
                  ),
                ],
              ),
            ),
            data: (drugs) {
              final query = _searchQuery.toLowerCase();
              final filtered = drugs.where((d) {
                return d.brandName.toLowerCase().contains(query) ||
                    d.genericName.toLowerCase().contains(query) ||
                    d.drugClass.toLowerCase().contains(query);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.pill,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No drugs loaded in Master Formulary.'
                            : 'No drugs matching "$_searchQuery"',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (drugs.isEmpty)
                        ElevatedButton.icon(
                          onPressed: _handleSync,
                          icon: const Icon(LucideIcons.downloadCloud, size: 14),
                          label: const Text(
                            'Download from Supabase public.drugmaster',
                          ),
                        ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      drug.brandName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    LucideIcons.lock,
                                    size: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ],
                              ),
                              Text(
                                '${drug.genericName} • ${drug.drugClass}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${drug.defaultDose} | ${drug.defaultRoute} | ${drug.defaultFrequency} | ${drug.defaultDuration} (${drug.defaultInstructions})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            drug.drugClass,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
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
// TAB 2: PRESENTING COMPLAINTS (ADMIN EDITABLE)
// -----------------------------------------------------------------------------
class _ComplaintsManagerTab extends ConsumerStatefulWidget {
  const _ComplaintsManagerTab();

  @override
  ConsumerState<_ComplaintsManagerTab> createState() =>
      _ComplaintsManagerTabState();
}

class _ComplaintsManagerTabState extends ConsumerState<_ComplaintsManagerTab> {
  String _searchQuery = '';

  void _showEditDialog({PresentingComplaintModel? complaint}) {
    final nameController =
        TextEditingController(text: complaint?.name ?? '');
    final categoryController =
        TextEditingController(text: complaint?.category ?? 'General');
    final orderController =
        TextEditingController(text: (complaint?.displayOrder ?? 10).toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              complaint == null ? LucideIcons.plusCircle : LucideIcons.edit,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(complaint == null ? 'Add Presenting Complaint' : 'Edit Complaint'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Complaint Name',
                  hintText: 'e.g. Fever, Cough, Chest Pain',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'General, RS, CVS, GI, Renal, ENT, MSK, Skin, Eye, CNS',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: orderController,
                decoration: const InputDecoration(
                  labelText: 'Display Order',
                  hintText: 'e.g. 1',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final category = categoryController.text.trim();
              final order = int.tryParse(orderController.text.trim()) ?? 0;
              if (name.isEmpty) return;

              final id = complaint?.id ??
                  'pc_${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

              final db = ref.read(appDatabaseProvider);
              await db.insertOrUpdateComplaint(
                PresentingComplaintsTableCompanion(
                  id: Value(id),
                  name: Value(name),
                  category: Value(category.isEmpty ? 'General' : category),
                  displayOrder: Value(order),
                  updatedAt: Value(DateTime.now()),
                ),
              );

              // Push to Supabase nexus.presenting_complaints
              try {
                await ref
                    .read(supabaseCatalogSyncProvider.notifier)
                    .upsertInSupabase('presenting_complaints', {
                  'id': id,
                  'name': name,
                  'category': category.isEmpty ? 'General' : category,
                  'display_order': order,
                  'updated_at': DateTime.now().toIso8601String(),
                });
              } catch (e) {
                debugPrint('Supabase complaint sync warning: $e');
              }

              ref.invalidate(complaintsCatalogProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final complaintsAsync = ref.watch(complaintsCatalogProvider);

    return Column(
      children: [
        // Admin Management Banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.shieldCheck, size: 16, color: Colors.amber),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Presenting Complaints Catalog • Admin Editable (nexus.presenting_complaints)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEditDialog(),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text('Add Complaint', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search complaints by name or category...',
              prefixIcon: Icon(LucideIcons.search, size: 18),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),

        Expanded(
          child: complaintsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (complaints) {
              final query = _searchQuery.toLowerCase();
              final filtered = complaints.where((c) {
                return c.name.toLowerCase().contains(query) ||
                    c.category.toLowerCase().contains(query);
              }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final complaint = filtered[index];
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaint.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Category: ${complaint.category} • Order: ${complaint.displayOrder} • ${complaint.subQuestions.length} sub-questions',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(LucideIcons.edit2, size: 16),
                              color: AppTheme.primaryBlue,
                              tooltip: 'Edit Complaint',
                              onPressed: () => _showEditDialog(complaint: complaint),
                            ),
                          ],
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
// TAB 3: COMORBIDITIES (ADMIN EDITABLE)
// -----------------------------------------------------------------------------
class _ComorbiditiesManagerTab extends ConsumerStatefulWidget {
  const _ComorbiditiesManagerTab();

  @override
  ConsumerState<_ComorbiditiesManagerTab> createState() =>
      _ComorbiditiesManagerTabState();
}

class _ComorbiditiesManagerTabState
    extends ConsumerState<_ComorbiditiesManagerTab> {
  String _searchQuery = '';

  void _showEditDialog({ComorbidityModel? comorbidity}) {
    final nameController =
        TextEditingController(text: comorbidity?.name ?? '');
    final classesController = TextEditingController(
      text: comorbidity?.contraindicatedDrugClasses.join(', ') ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              comorbidity == null ? LucideIcons.plusCircle : LucideIcons.edit,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(comorbidity == null ? 'Add Comorbidity' : 'Edit Comorbidity'),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Comorbidity Name',
                  hintText: 'e.g. Chronic Kidney Disease (CKD)',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: classesController,
                decoration: const InputDecoration(
                  labelText: 'Contraindicated Drug Classes (comma-separated)',
                  hintText: 'e.g. NSAID, Metformin, Fluoroquinolones',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final classes = classesController.text
                  .split(',')
                  .map((c) => c.trim())
                  .where((c) => c.isNotEmpty)
                  .toList();

              final id = comorbidity?.id ??
                  'comorb_${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

              final db = ref.read(appDatabaseProvider);
              await db.insertOrUpdateComorbidity(
                ComorbiditiesTableCompanion(
                  id: Value(id),
                  name: Value(name),
                  contraindicatedDrugClasses: Value(jsonEncode(classes)),
                  updatedAt: Value(DateTime.now()),
                ),
              );

              // Push to Supabase nexus.comorbidities
              try {
                await ref
                    .read(supabaseCatalogSyncProvider.notifier)
                    .upsertInSupabase('comorbidities', {
                  'id': id,
                  'name': name,
                  'contraindicated_drug_classes': classes,
                  'updated_at': DateTime.now().toIso8601String(),
                });
              } catch (e) {
                debugPrint('Supabase comorbidity sync warning: $e');
              }

              ref.invalidate(comorbiditiesCatalogProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comorbsAsync = ref.watch(comorbiditiesCatalogProvider);

    return Column(
      children: [
        // Admin Management Banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.shieldCheck, size: 16, color: Colors.amber),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Comorbidities & Safety Rules • Admin Editable (nexus.comorbidities)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEditDialog(),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text('Add Comorbidity', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search comorbidities or contraindicated classes...',
              prefixIcon: Icon(LucideIcons.search, size: 18),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),

        Expanded(
          child: comorbsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (comorbs) {
              final query = _searchQuery.toLowerCase();
              final filtered = comorbs.where((c) {
                return c.name.toLowerCase().contains(query) ||
                    c.contraindicatedDrugClasses.any(
                      (dc) => dc.toLowerCase().contains(query),
                    );
              }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final comorb = filtered[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comorb.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contraindications: ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.slaOverdue,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      comorb.contraindicatedDrugClasses.isEmpty
                                          ? 'None defined'
                                          : comorb.contraindicatedDrugClasses
                                              .join(', '),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: comorb.contraindicatedDrugClasses
                                                .isEmpty
                                            ? AppTheme.textMuted
                                            : Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.edit2, size: 16),
                          color: AppTheme.primaryBlue,
                          tooltip: 'Edit Comorbidity',
                          onPressed: () => _showEditDialog(comorbidity: comorb),
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
// TAB 4: DIAGNOSES & PROTOCOLS (ADMIN EDITABLE)
// -----------------------------------------------------------------------------
class _DiagnosesManagerTab extends ConsumerStatefulWidget {
  const _DiagnosesManagerTab();

  @override
  ConsumerState<_DiagnosesManagerTab> createState() =>
      _DiagnosesManagerTabState();
}

class _DiagnosesManagerTabState extends ConsumerState<_DiagnosesManagerTab> {
  String _searchQuery = '';

  void _showEditDialog({DiagnosisModel? diagnosis}) {
    final nameController =
        TextEditingController(text: diagnosis?.name ?? '');
    final icdController =
        TextEditingController(text: diagnosis?.icd10Code ?? '');
    final complaintsController = TextEditingController(
      text: diagnosis?.linkedComplaintIds.join(', ') ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              diagnosis == null ? LucideIcons.plusCircle : LucideIcons.edit,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(diagnosis == null ? 'Add Diagnosis' : 'Edit Diagnosis'),
          ],
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis Name',
                  hintText: 'e.g. Acute Gastroenteritis',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: icdController,
                decoration: const InputDecoration(
                  labelText: 'ICD-10 Code',
                  hintText: 'e.g. A09, J06.9',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: complaintsController,
                decoration: const InputDecoration(
                  labelText: 'Pre-linked Complaint IDs (comma-separated)',
                  hintText: 'e.g. pc_fever, pc_cough',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final icd = icdController.text.trim();
              final linked = complaintsController.text
                  .split(',')
                  .map((c) => c.trim())
                  .where((c) => c.isNotEmpty)
                  .toList();

              final id = diagnosis?.id ??
                  'diag_${name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

              final db = ref.read(appDatabaseProvider);
              await db.insertOrUpdateDiagnosis(
                DiagnosesTableCompanion(
                  id: Value(id),
                  name: Value(name),
                  icd10Code: Value(icd.isEmpty ? null : icd),
                  linkedComplaintIds: Value(jsonEncode(linked)),
                  updatedAt: Value(DateTime.now()),
                ),
              );

              // Push to Supabase nexus.diagnoses
              try {
                await ref
                    .read(supabaseCatalogSyncProvider.notifier)
                    .upsertInSupabase('diagnoses', {
                  'id': id,
                  'name': name,
                  'icd10_code': icd.isEmpty ? null : icd,
                  'linked_complaint_ids': linked,
                  'updated_at': DateTime.now().toIso8601String(),
                });
              } catch (e) {
                debugPrint('Supabase diagnosis sync warning: $e');
              }

              ref.invalidate(diagnosesCatalogProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diagnosesAsync = ref.watch(diagnosesCatalogProvider);

    return Column(
      children: [
        // Admin Management Banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.shieldCheck, size: 16, color: Colors.amber),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Diagnoses & Evidence-Based Regimens • Admin Editable (nexus.diagnoses)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF92400E),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showEditDialog(),
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text('Add Diagnosis', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search diagnoses by name or ICD-10 code...',
              prefixIcon: Icon(LucideIcons.search, size: 18),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),

        Expanded(
          child: diagnosesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (diagnoses) {
              final query = _searchQuery.toLowerCase();
              final filtered = diagnoses.where((d) {
                return d.name.toLowerCase().contains(query) ||
                    (d.icd10Code?.toLowerCase().contains(query) ?? false);
              }).toList();

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final diag = filtered[index];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      diag.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceBackground,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppTheme.borderLight),
                                    ),
                                    child: Text(
                                      diag.icd10Code ?? 'ICD-10',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pre-linked Complaints: ${diag.linkedComplaintIds.map((c) => c.replaceAll("pc_", "").toUpperCase()).join(", ")}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.edit2, size: 16),
                          color: AppTheme.primaryBlue,
                          tooltip: 'Edit Diagnosis',
                          onPressed: () => _showEditDialog(diagnosis: diag),
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
// TAB 5: CLINIC & PRINT SETTINGS (ADMIN ONLY)
// -----------------------------------------------------------------------------
class _ClinicSettingsTab extends ConsumerStatefulWidget {
  const _ClinicSettingsTab();

  @override
  ConsumerState<_ClinicSettingsTab> createState() => _ClinicSettingsTabState();
}

class _ClinicSettingsTabState extends ConsumerState<_ClinicSettingsTab> {
  final _clinicNameController = TextEditingController();
  final _clinicSubtitleController = TextEditingController();
  final _clinicContactController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _qualsController = TextEditingController();
  final _regController = TextEditingController();
  final _marginController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _revisitFeeController = TextEditingController();
  final _supabaseUrlController = TextEditingController();
  final _supabaseKeyController = TextEditingController();
  final _geminiApiKeyController = TextEditingController();
  bool _obscureGeminiKey = true;
  String _selectedGeminiModel = kDefaultGeminiModel;

  bool _isLoaded = false;

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicSubtitleController.dispose();
    _clinicContactController.dispose();
    _doctorNameController.dispose();
    _qualsController.dispose();
    _regController.dispose();
    _marginController.dispose();
    _consultationFeeController.dispose();
    _revisitFeeController.dispose();
    _supabaseUrlController.dispose();
    _supabaseKeyController.dispose();
    _geminiApiKeyController.dispose();
    super.dispose();
  }

  void _loadValues(ClinicSettings settings) {
    if (!_isLoaded) {
      _clinicNameController.text = settings.clinicName;
      _clinicSubtitleController.text = settings.clinicSubtitle;
      _clinicContactController.text = settings.clinicContact;
      _doctorNameController.text = settings.doctorName;
      _qualsController.text = settings.doctorQualifications;
      _regController.text = settings.registrationNumber;
      _marginController.text = settings.letterheadTopMarginMm.toString();
      _consultationFeeController.text =
          settings.consultationFee.toStringAsFixed(0);
      _revisitFeeController.text = settings.revisitFee.toStringAsFixed(0);
      _supabaseUrlController.text = settings.supabaseUrl;
      _supabaseKeyController.text = settings.supabaseAnonKey;
      _geminiApiKeyController.text = settings.geminiApiKey;
      _selectedGeminiModel = resolveGeminiModel(settings.geminiModel);
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
                const Text(
                  'Doctor & Clinic Letterhead Profile',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _clinicNameController,
                  decoration: const InputDecoration(
                    labelText: 'Clinic / Hospital Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _clinicSubtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Clinic Subtitle / Tagline',
                    hintText:
                        'e.g. Comprehensive Outpatient & Emergency Clinical Center',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _clinicContactController,
                  decoration: const InputDecoration(
                    labelText: 'Clinic Address & Contact Information',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _doctorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Doctor Name',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _qualsController,
                        decoration: const InputDecoration(
                          labelText: 'Qualifications',
                          hintText: 'e.g. MBBS, MD (General Medicine)',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _regController,
                        decoration: const InputDecoration(
                          labelText: 'Reg. Number',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rates & Printing Margins
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
                const Text(
                  'Rates & Print Geometry',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _consultationFeeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Standard Consultation Fee (₹)',
                          prefixText: '₹ ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _revisitFeeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Revisit Fee within 7 Days (₹)',
                          prefixText: '₹ ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _marginController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Pre-printed Letterhead Margin (mm)',
                          suffixText: 'mm',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Cloud Supabase Sync Configuration
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
                    const Text(
                      'Supabase Cloud & Live Queue Sync',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: syncState.isConnected
                            ? AppTheme.slaNormal.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            syncState.isConnected
                                ? LucideIcons.checkCircle
                                : LucideIcons.circle,
                            size: 12,
                            color: syncState.isConnected
                                ? AppTheme.slaNormal
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            syncState.isConnected
                                ? 'Realtime Connected'
                                : 'Offline / Standalone',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: syncState.isConnected
                                  ? AppTheme.slaNormal
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _supabaseUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Supabase Project URL',
                    hintText: 'https://xyzcompany.supabase.co',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _supabaseKeyController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Supabase Anonymous Key (JWT)',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Gemini 2.5 Voice Scribe Configuration
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
                    const Row(
                      children: [
                        Icon(
                          LucideIcons.sparkles,
                          size: 18,
                          color: Color(0xFF7C3AED),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Google Gemini Voice Scribe Engine',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: settings.hasGeminiApiKey
                            ? const Color(0xFF7C3AED).withValues(alpha: 0.1)
                            : Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: settings.hasGeminiApiKey
                              ? const Color(0xFF7C3AED).withValues(alpha: 0.3)
                              : Colors.amber.shade300,
                        ),
                      ),
                      child: Text(
                        settings.hasGeminiApiKey ? 'API Key Active' : 'Key Missing',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: settings.hasGeminiApiKey
                              ? const Color(0xFF7C3AED)
                              : Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Powers zero-keyboard clinical dictation, transcribing natural Indian doctor-patient encounters directly into discrete complaints, exam findings, diagnoses, and prescriptions.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _geminiApiKeyController,
                  obscureText: _obscureGeminiKey,
                  decoration: InputDecoration(
                    labelText: 'Gemini API Key',
                    hintText: 'AIzaSy...',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureGeminiKey ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 16,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureGeminiKey = !_obscureGeminiKey;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGeminiModel,
                  decoration: const InputDecoration(
                    labelText: 'Gemini Medical Inference Model',
                  ),
                  items: const [
                    'gemini-3.8-flash',
                    'gemini-2.5-flash',
                    'gemini-2.5-pro',
                  ]
                      .map(
                        (m) => DropdownMenuItem(
                          value: m,
                          child: Text(
                            m == kDefaultGeminiModel
                                ? '$m (Recommended • Fast & High Accuracy)'
                                : m,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedGeminiModel = val;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Save Settings Button
          ElevatedButton.icon(
            onPressed: () async {
              final updated = settings.copyWith(
                clinicName: _clinicNameController.text.trim(),
                clinicSubtitle: _clinicSubtitleController.text.trim(),
                clinicContact: _clinicContactController.text.trim(),
                doctorName: _doctorNameController.text.trim(),
                doctorQualifications: _qualsController.text.trim(),
                registrationNumber: _regController.text.trim(),
                letterheadTopMarginMm:
                    double.tryParse(_marginController.text) ?? 45.0,
                consultationFee:
                    double.tryParse(_consultationFeeController.text) ?? 200.0,
                revisitFee:
                    double.tryParse(_revisitFeeController.text) ?? 150.0,
                supabaseUrl: _supabaseUrlController.text.trim(),
                supabaseAnonKey: _supabaseKeyController.text.trim(),
                geminiApiKey: _geminiApiKeyController.text.trim(),
                geminiModel: _selectedGeminiModel,
              );

              await ref
                  .read(clinicSettingsProvider.notifier)
                  .updateSettings(updated);

              if (updated.hasSupabaseCredentials) {
                await ref
                    .read(realtimeQueueServiceProvider.notifier)
                    .initialize(
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
            label: const Text(
              'Save Settings & Apply Profile',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
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
