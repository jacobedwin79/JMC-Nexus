import '../domain/clinical_models.dart';

class SafetyEngine {
  /// Evaluates active prescription against:
  /// 1. Patient allergies (blocks/warns on matching drug name, generic name, or class)
  /// 2. Selected patient comorbidities (contraindicated drug classes)
  /// 3. Paediatric / Geriatric age-specific safety constraints
  /// 4. Pregnancy status
  static List<SafetyAlert> evaluate({
    required List<String> selectedComorbidityIds,
    required List<PrescriptionItemModel> activePrescription,
    required List<ComorbidityModel> comorbiditiesCatalog,
    List<String> allergies = const [],
    int? patientAge,
    double? patientWeight,
    bool isPregnant = false,
  }) {
    if (activePrescription.isEmpty) {
      return const [];
    }

    final alerts = <SafetyAlert>[];

    // --- 1. ALLERGY CHECKS (HIGHEST PRIORITY) ---
    for (final allergy in allergies) {
      final allergyClean = allergy.trim();
      if (allergyClean.isEmpty) continue;

      for (final rx in activePrescription) {
        if (_matchesAllergy(allergyClean, rx)) {
          alerts.add(
            SafetyAlert(
              drugName: rx.brandName.isNotEmpty ? '${rx.brandName} (${rx.genericName})' : rx.genericName,
              drugClass: rx.drugClass,
              comorbidityName: 'Allergy: $allergyClean',
              message: 'CRITICAL ALLERGY CONFLICT: Patient is allergic to "$allergyClean". '
                  'Do not administer ${rx.brandName.isNotEmpty ? rx.brandName : rx.genericName} (${rx.genericName}).',
              severity: AlertSeverity.critical,
            ),
          );
        }
      }
    }

    // --- 2. COMORBIDITY CONTRAINDICATION CHECKS ---
    final comorbMap = {for (final c in comorbiditiesCatalog) c.id: c};
    final effectiveComorbIds = List<String>.from(selectedComorbidityIds);
    if (isPregnant && !effectiveComorbIds.contains('comorb_pregnant')) {
      effectiveComorbIds.add('comorb_pregnant');
    }

    for (final comorbId in effectiveComorbIds) {
      final comorb = comorbMap[comorbId];
      if (comorb == null || comorb.contraindicatedDrugClasses.isEmpty) continue;

      for (final rx in activePrescription) {
        final drugClassUpper = rx.drugClass.trim().toUpperCase();

        for (final contraClass in comorb.contraindicatedDrugClasses) {
          final contraClassUpper = contraClass.trim().toUpperCase();

          if (_classesConflict(drugClassUpper, contraClassUpper)) {
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

    // --- 3. PAEDIATRIC (<12y) SAFETY & DOSING ---
    if (patientAge != null && patientAge < 12) {
      if (patientWeight == null || patientWeight <= 0) {
        alerts.add(
          const SafetyAlert(
            drugName: 'Paediatric Dosing',
            drugClass: 'Clinical Protocol',
            comorbidityName: 'Patient Age < 12 Y',
            message: 'PAEDIATRIC DOSING WARNING: Weight is not recorded. In children, verify mg/kg dosage calculations.',
            severity: AlertSeverity.warning,
          ),
        );
      }

      for (final rx in activePrescription) {
        final genericUpper = rx.genericName.toUpperCase();
        final classUpper = rx.drugClass.toUpperCase();

        if (genericUpper.contains('ASPIRIN')) {
          alerts.add(
            SafetyAlert(
              drugName: rx.brandName,
              drugClass: rx.drugClass,
              comorbidityName: 'Child < 12 Y',
              message: 'CRITICAL CONTRAINDICATION: Aspirin is contraindicated in children due to risk of Reye\'s Syndrome.',
              severity: AlertSeverity.critical,
            ),
          );
        }

        if (classUpper.contains('FLUOROQUINOLONE') || genericUpper.contains('OFLOXACIN') || genericUpper.contains('CIPROFLOXACIN')) {
          alerts.add(
            SafetyAlert(
              drugName: rx.brandName,
              drugClass: rx.drugClass,
              comorbidityName: 'Child < 12 Y',
              message: 'PAEDIATRIC CAUTION: Fluoroquinolones generally restricted in children due to potential cartilage toxicity.',
              severity: AlertSeverity.warning,
            ),
          );
        }
      }
    }

    // --- 4. GERIATRIC (>=65y) SAFETY ---
    if (patientAge != null && patientAge >= 65) {
      for (final rx in activePrescription) {
        final classUpper = rx.drugClass.toUpperCase();
        if (classUpper.contains('NSAID')) {
          alerts.add(
            SafetyAlert(
              drugName: rx.brandName,
              drugClass: rx.drugClass,
              comorbidityName: 'Geriatric (Age $patientAge)',
              message: 'GERIATRIC CAUTION: High risk of GI bleeding, acute kidney injury, and fluid retention with NSAIDs.',
              severity: AlertSeverity.warning,
            ),
          );
        }
      }
    }

    return alerts;
  }

  /// Evaluates whether an allergy string conflicts with a prescribed medication
  static bool _matchesAllergy(String allergy, PrescriptionItemModel rx) {
    final allergyUpper = allergy.toUpperCase().trim();
    final genericUpper = rx.genericName.toUpperCase().trim();
    final brandUpper = rx.brandName.toUpperCase().trim();
    final classUpper = rx.drugClass.toUpperCase().trim();

    // Direct token match
    if (genericUpper.contains(allergyUpper) ||
        brandUpper.contains(allergyUpper) ||
        classUpper.contains(allergyUpper) ||
        allergyUpper.contains(genericUpper)) {
      return true;
    }

    // Penicillin / Beta-lactam family
    if (allergyUpper.contains('PENICILLIN') || allergyUpper.contains('BETA-LACTAM')) {
      if (genericUpper.contains('AMOXICILLIN') ||
          genericUpper.contains('AMPICILLIN') ||
          genericUpper.contains('PENICILLIN') ||
          brandUpper.contains('MOX') ||
          brandUpper.contains('AUGMENTIN')) {
        return true;
      }
    }

    // Sulfa / Sulfonamides
    if (allergyUpper.contains('SULFA') || allergyUpper.contains('SULFONAMIDE')) {
      if (genericUpper.contains('COTRIMOXAZOLE') ||
          genericUpper.contains('SULFA') ||
          brandUpper.contains('BACTRIM') ||
          brandUpper.contains('SEPTRA')) {
        return true;
      }
    }

    // NSAIDs & Aspirin
    if (allergyUpper.contains('NSAID') || allergyUpper.contains('ASPIRIN') || allergyUpper.contains('IBUPROFEN')) {
      if (classUpper.contains('NSAID') ||
          genericUpper.contains('IBUPROFEN') ||
          genericUpper.contains('DICLOFENAC') ||
          genericUpper.contains('ACECLOFENAC') ||
          genericUpper.contains('ASPIRIN') ||
          genericUpper.contains('KETOROLAC') ||
          brandUpper.contains('VOVERAN') ||
          brandUpper.contains('ZERODOL')) {
        return true;
      }
    }

    // Paracetamol / Acetaminophen
    if (allergyUpper.contains('PARACETAMOL') || allergyUpper.contains('PCM') || allergyUpper.contains('ACETAMINOPHEN')) {
      if (genericUpper.contains('PARACETAMOL') ||
          brandUpper.contains('DOLO') ||
          brandUpper.contains('CALPOL') ||
          brandUpper.contains('CROCIN')) {
        return true;
      }
    }

    // Fluoroquinolones
    if (allergyUpper.contains('CIPRO') || allergyUpper.contains('FLUOROQUINOLONE') || allergyUpper.contains('OFLOX')) {
      if (classUpper.contains('FLUOROQUINOLONE') ||
          genericUpper.contains('OFLOXACIN') ||
          genericUpper.contains('CIPROFLOXACIN') ||
          genericUpper.contains('LEVOFLOXACIN')) {
        return true;
      }
    }

    // Cephalosporins
    if (allergyUpper.contains('CEPHALOSPORIN') || allergyUpper.contains('CEF')) {
      if (genericUpper.startsWith('CEF') || genericUpper.contains('CEFIXIME') || genericUpper.contains('CEFPODOXIME')) {
        return true;
      }
    }

    return false;
  }

  /// Checks if drug class and contraindicated class conflict, normalizing aliases
  static bool _classesConflict(String drugClassUpper, String contraClassUpper) {
    if (drugClassUpper == contraClassUpper) return true;
    if (drugClassUpper.contains(contraClassUpper) || contraClassUpper.contains(drugClassUpper)) {
      return true;
    }

    // Steroid alias normalization
    final isDrugSteroid = drugClassUpper.contains('STEROID') || drugClassUpper.contains('CORTICOSTEROID');
    final isContraSteroid = contraClassUpper.contains('STEROID') || contraClassUpper.contains('CORTICOSTEROID');
    if (isDrugSteroid && isContraSteroid) return true;

    // Beta-blocker normalization
    final isDrugBB = drugClassUpper.contains('BETA BLOCKER');
    final isContraBB = contraClassUpper.contains('BETA BLOCKER');
    if (isDrugBB && isContraBB) return true;

    return false;
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
