import '../domain/clinical_models.dart';

class SafetyEngine {
  /// Evaluates active prescription against selected patient comorbidities
  static List<SafetyAlert> evaluate({
    required List<String> selectedComorbidityIds,
    required List<PrescriptionItemModel> activePrescription,
    required List<ComorbidityModel> comorbiditiesCatalog,
  }) {
    if (selectedComorbidityIds.isEmpty || activePrescription.isEmpty) {
      return const [];
    }

    final alerts = <SafetyAlert>[];

    // Build map of comorbidity ID -> ComorbidityModel
    final comorbMap = {for (final c in comorbiditiesCatalog) c.id: c};

    for (final comorbId in selectedComorbidityIds) {
      final comorb = comorbMap[comorbId];
      if (comorb == null || comorb.contraindicatedDrugClasses.isEmpty) continue;

      for (final rx in activePrescription) {
        final drugClassUpper = rx.drugClass.trim().toUpperCase();

        for (final contraClass in comorb.contraindicatedDrugClasses) {
          final contraClassUpper = contraClass.trim().toUpperCase();

          // Match exact drug class or substring match (e.g. NSAID, Steroids)
          if (drugClassUpper == contraClassUpper ||
              drugClassUpper.contains(contraClassUpper) ||
              contraClassUpper.contains(drugClassUpper)) {
            final isCritical = _isStrictlyCritical(comorbId, drugClassUpper);

            alerts.add(
              SafetyAlert(
                drugName: rx.brandName.isNotEmpty ? '${rx.brandName} (${rx.genericName})' : rx.genericName,
                drugClass: rx.drugClass,
                comorbidityName: comorb.name,
                message: isCritical
                    ? 'CRITICAL CONTRAINDICATION: ${rx.drugClass} is strictly contraindicated in ${comorb.name}.'
                    : 'WARNING: Caution advised using ${rx.drugClass} in ${comorb.name}.',
                severity: isCritical ? AlertSeverity.critical : AlertSeverity.warning,
              ),
            );
          }
        }
      }
    }

    return alerts;
  }

  static bool _isStrictlyCritical(String comorbidityId, String drugClassUpper) {
    // High-risk clinical contraindications
    if (comorbidityId == 'comorb_ckd' && drugClassUpper.contains('NSAID')) return true;
    if (comorbidityId == 'comorb_ckd' && drugClassUpper.contains('METFORMIN')) return true;
    if (comorbidityId == 'comorb_pregnant' && drugClassUpper.contains('FLUOROQUINOLONES')) return true;
    if (comorbidityId == 'comorb_pregnant' && drugClassUpper.contains('NSAID')) return true;
    if (comorbidityId == 'comorb_pud' && drugClassUpper.contains('NSAID')) return true;
    if (comorbidityId == 'comorb_asthma' && drugClassUpper.contains('BETA BLOCKER')) return true;
    return false;
  }
}

