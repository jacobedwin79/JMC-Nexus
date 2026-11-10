import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_mappers.dart';
import '../../../core/database/database_provider.dart';
import '../domain/clinical_models.dart';

/// Short, compact labels for built-in comorbidities shown in chip strips.
/// Any comorbidity not listed here falls back to its full catalog name.
const Map<String, String> comorbidityShortLabels = {
  'comorb_dm': 'Type 2 DM',
  'comorb_htn': 'HTN',
  'comorb_asthma': 'Asthma',
  'comorb_ckd': 'CKD',
  'comorb_pregnant': 'Pregnancy',
  'comorb_pud': 'PUD',
  'comorb_cad': 'CAD',
  'comorb_copd': 'COPD',
};

String comorbidityDisplayLabel(ComorbidityModel model) =>
    comorbidityShortLabels[model.id] ?? model.name;

final comorbiditiesCatalogProvider = FutureProvider<List<ComorbidityModel>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  final comorbs = await db.getAllComorbidities();
  return comorbs.map((c) => c.toDomain()).toList();
});

final complaintsCatalogProvider =
    FutureProvider<List<PresentingComplaintModel>>((ref) async {
      final db = ref.watch(appDatabaseProvider);
      final complaints = await db.getAllComplaints();

      final fullComplaints = <PresentingComplaintModel>[];
      for (final c in complaints) {
        final subQuestions = await db.getSubQuestionsForComplaint(c.id);
        fullComplaints.add(
          c.toDomain(subQuestions.map((sq) => sq.toDomain()).toList()),
        );
      }

      return fullComplaints;
    });

final examSystemsCatalogProvider = FutureProvider<List<ExamSystemModel>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  final systems = await db.getAllExaminationSystems();
  return systems.map((s) => s.toDomain()).toList();
});

final diagnosesCatalogProvider = FutureProvider<List<DiagnosisModel>>((
  ref,
) async {
  final db = ref.watch(appDatabaseProvider);
  final diagnoses = await db.getAllDiagnoses();
  return diagnoses.map((d) => d.toDomain()).toList();
});

final drugsCatalogProvider = FutureProvider<List<DrugModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final drugs = await db.getAllDrugs();
  return drugs.map((d) => d.toDomain()).toList();
});

final topMedicationsProvider = FutureProvider<List<DrugModel>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final drugs = await db.getTopMedications(limit: 20);
  return drugs.map((d) => d.toDomain()).toList();
});
