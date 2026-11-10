import 'dart:convert';
import 'app_database.dart';
import '../../features/encounter/domain/clinical_models.dart';
import '../../features/encounter/domain/patient_queue_item.dart';

extension PatientQueueEntryMapper on PatientQueueEntry {
  PatientQueueItem toDomain() {
    Map<String, dynamic> vitalsMap = {};
    if (vitalsJson != null && vitalsJson!.isNotEmpty) {
      try {
        vitalsMap = jsonDecode(vitalsJson!) as Map<String, dynamic>;
      } catch (_) {}
    }

    List<String> comorbs = [];
    if (initialComorbIds != null && initialComorbIds!.isNotEmpty) {
      try {
        comorbs = (jsonDecode(initialComorbIds!) as List).cast<String>();
      } catch (_) {}
    }

    List<String> patientAllergies = [];
    if (allergies != null && allergies!.isNotEmpty) {
      try {
        patientAllergies = (jsonDecode(allergies!) as List).cast<String>();
      } catch (_) {}
    }

    return PatientQueueItem(
      id: id,
      patientId: patientId,
      tokenNumber: tokenNumber,
      patientName: patientName,
      age: age,
      dateOfBirth: dateOfBirth,
      gender: gender,
      phone: phone,
      vitals: vitalsMap,
      initialComorbIds: comorbs,
      allergies: patientAllergies,
      lmp: lmp,
      isPregnant: isPregnant,
      status: status,
      entryTime: entryTime,
      consultationStartTime: consultationStartTime,
      completionTime: completionTime,
      compiledPrescriptionJson: compiledPrescriptionJson,
      overrideReason: overrideReason,
      consultationFee: consultationFee,
      isRevisit: isRevisit,
    );
  }
}

extension ComorbidityEntryMapper on ComorbidityEntry {
  ComorbidityModel toDomain() {
    List<String> contra = [];
    try {
      contra = (jsonDecode(contraindicatedDrugClasses) as List).cast<String>();
    } catch (_) {}

    return ComorbidityModel(
      id: id,
      name: name,
      contraindicatedDrugClasses: contra,
    );
  }
}

extension PresentingComplaintEntryMapper on PresentingComplaintEntry {
  PresentingComplaintModel toDomain([
    List<ComplaintSubQuestionModel> subQuestions = const [],
  ]) {
    return PresentingComplaintModel(
      id: id,
      name: name,
      category: category,
      displayOrder: displayOrder,
      subQuestions: subQuestions,
    );
  }
}

extension ComplaintSubQuestionEntryMapper on ComplaintSubQuestionEntry {
  ComplaintSubQuestionModel toDomain() {
    List<String> opts = [];
    try {
      opts = (jsonDecode(optionsJson) as List).cast<String>();
    } catch (_) {}

    return ComplaintSubQuestionModel(
      id: id,
      complaintId: complaintId,
      questionLabel: questionLabel,
      options: opts,
      sentenceTemplate: sentenceTemplate,
      isMultiSelect: isMultiSelect,
      sequenceOrder: sequenceOrder,
    );
  }
}

extension ExaminationSystemEntryMapper on ExaminationSystemEntry {
  ExamSystemModel toDomain() {
    List<String> abnormals = [];
    try {
      abnormals = (jsonDecode(abnormalFindingsJson) as List).cast<String>();
    } catch (_) {}

    return ExamSystemModel(
      id: id,
      systemName: systemName,
      defaultNormalText: defaultNormalText,
      abnormalFindings: abnormals,
    );
  }
}

extension DiagnosisEntryMapper on DiagnosisEntry {
  DiagnosisModel toDomain() {
    List<String> linked = [];
    try {
      linked = (jsonDecode(linkedComplaintIds) as List).cast<String>();
    } catch (_) {}

    return DiagnosisModel(
      id: id,
      name: name,
      icd10Code: icd10Code,
      linkedComplaintIds: linked,
    );
  }
}

extension DrugEntryMapper on DrugEntry {
  DrugModel toDomain() {
    return DrugModel(
      id: id,
      genericName: genericName,
      brandName: brandName,
      drugClass: drugClass,
      defaultDose: defaultDose,
      defaultRoute: defaultRoute,
      defaultFrequency: defaultFrequency,
      defaultDuration: defaultDuration,
      defaultInstructions: defaultInstructions,
    );
  }
}

extension PrescriptionProtocolEntryMapper on PrescriptionProtocolEntry {
  PrescriptionProtocolModel toDomain() {
    List<ProtocolItemEntry> items = [];
    try {
      final list = jsonDecode(protocolItemsJson) as List;
      items = list
          .map(
            (item) => ProtocolItemEntry.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {}

    return PrescriptionProtocolModel(
      id: id,
      diagnosisId: diagnosisId,
      protocolItems: items,
      generalAdvice: generalAdvice,
    );
  }
}
