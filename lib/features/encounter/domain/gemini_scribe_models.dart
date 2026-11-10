import 'package:flutter/foundation.dart';
import 'clinical_models.dart';

enum AiAlertSeverity {
  critical,
  warning,
  info;

  static AiAlertSeverity fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'critical':
      case 'danger':
        return AiAlertSeverity.critical;
      case 'info':
        return AiAlertSeverity.info;
      case 'warning':
      default:
        return AiAlertSeverity.warning;
    }
  }
}

class AiClinicalAlert {
  final String title;
  final String message;
  final AiAlertSeverity severity;
  final String category; // 'drug_interaction', 'comorbidity_conflict', 'age_precaution', 'allergy_conflict'

  const AiClinicalAlert({
    required this.title,
    required this.message,
    this.severity = AiAlertSeverity.warning,
    this.category = 'general',
  });

  factory AiClinicalAlert.fromJson(Map<String, dynamic> json) {
    return AiClinicalAlert(
      title: json['title'] as String? ?? 'Clinical Notice',
      message: json['message'] as String? ?? '',
      severity: AiAlertSeverity.fromString(json['severity'] as String?),
      category: json['category'] as String? ?? 'general',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'severity': severity.name,
        'category': category,
      };
}

class AiParsedComplaint {
  final String complaintId;
  final String complaintName;
  final String compiledProse;

  const AiParsedComplaint({
    required this.complaintId,
    required this.complaintName,
    required this.compiledProse,
  });

  factory AiParsedComplaint.fromJson(Map<String, dynamic> json) {
    return AiParsedComplaint(
      complaintId: json['complaintId'] as String? ?? '',
      complaintName: json['complaintName'] as String? ?? '',
      compiledProse: json['compiledProse'] as String? ?? '',
    );
  }
}

class AiParsedExam {
  final String systemId;
  final bool isNormal;
  final List<String> abnormalFindings;
  final String compiledText;

  const AiParsedExam({
    required this.systemId,
    required this.isNormal,
    required this.abnormalFindings,
    required this.compiledText,
  });

  factory AiParsedExam.fromJson(Map<String, dynamic> json) {
    final abnormals = json['abnormalFindings'];
    return AiParsedExam(
      systemId: json['systemId'] as String? ?? '',
      isNormal: json['isNormal'] as bool? ?? true,
      abnormalFindings: abnormals is List ? abnormals.cast<String>() : const [],
      compiledText: json['compiledText'] as String? ?? '',
    );
  }
}

class AiParsedDiagnosis {
  final String diagnosisId;
  final String diagnosisName;
  final String? icd10Code;

  const AiParsedDiagnosis({
    required this.diagnosisId,
    required this.diagnosisName,
    this.icd10Code,
  });

  factory AiParsedDiagnosis.fromJson(Map<String, dynamic> json) {
    return AiParsedDiagnosis(
      diagnosisId: json['diagnosisId'] as String? ?? '',
      diagnosisName: json['diagnosisName'] as String? ?? '',
      icd10Code: json['icd10Code'] as String?,
    );
  }
}

class GeminiScribeResult {
  final String transcript;
  final String clinicalSummary;
  final List<AiParsedComplaint> complaints;
  final List<AiParsedExam> exams;
  final List<AiParsedDiagnosis> diagnoses;
  final List<PrescriptionItemModel> prescriptions;
  final List<String> investigations;
  final String? generalAdvice;
  final int? followUpDays;
  final List<AiClinicalAlert> safetyAlerts;

  const GeminiScribeResult({
    required this.transcript,
    required this.clinicalSummary,
    this.complaints = const [],
    this.exams = const [],
    this.diagnoses = const [],
    this.prescriptions = const [],
    this.investigations = const [],
    this.generalAdvice,
    this.followUpDays,
    this.safetyAlerts = const [],
  });

  factory GeminiScribeResult.fromJson(Map<String, dynamic> json) {
    final rawComplaints = json['complaints'] as List? ?? [];
    final rawExams = json['examFindings'] as List? ?? [];
    final rawDiags = json['diagnoses'] as List? ?? [];
    final rawRx = json['prescription'] as List? ?? [];
    final rawInvs = json['investigations'] as List? ?? [];
    final rawAlerts = json['safetyAlerts'] as List? ?? [];

    return GeminiScribeResult(
      transcript: json['transcript'] as String? ?? '',
      clinicalSummary: json['clinicalSummary'] as String? ?? '',
      complaints: rawComplaints
          .whereType<Map<String, dynamic>>()
          .map(AiParsedComplaint.fromJson)
          .toList(),
      exams: rawExams
          .whereType<Map<String, dynamic>>()
          .map(AiParsedExam.fromJson)
          .toList(),
      diagnoses: rawDiags
          .whereType<Map<String, dynamic>>()
          .map(AiParsedDiagnosis.fromJson)
          .toList(),
      prescriptions: rawRx
          .whereType<Map<String, dynamic>>()
          .map(PrescriptionItemModel.fromJson)
          .toList(),
      investigations: rawInvs.map((e) => e.toString()).toList(),
      generalAdvice: json['generalAdvice'] as String?,
      followUpDays: json['followUpDays'] as int?,
      safetyAlerts: rawAlerts
          .whereType<Map<String, dynamic>>()
          .map(AiClinicalAlert.fromJson)
          .toList(),
    );
  }
}

@immutable
class VoiceNoteSnippet {
  final String id;
  final DateTime timestamp;
  final String transcript;
  final String summary;
  final int durationSeconds;

  const VoiceNoteSnippet({
    required this.id,
    required this.timestamp,
    required this.transcript,
    required this.summary,
    required this.durationSeconds,
  });
}

