import 'package:flutter/foundation.dart';

@immutable
class AdminSummaryMetrics {
  final int totalPatients;
  final int newPatients;
  final int revisitPatients;
  final double revisitPercentage;
  final int completedConsultations;
  final int waitingPatients;
  final int inConsultationPatients;
  final int cancelledPatients;
  final double totalIncome;
  final double todayIncome;
  final double newPatientIncome;
  final double revisitPatientIncome;
  final double avgIncomePerPatient;
  final double avgWaitTimeMinutes;
  final double avgConsultationMinutes;

  const AdminSummaryMetrics({
    this.totalPatients = 0,
    this.newPatients = 0,
    this.revisitPatients = 0,
    this.revisitPercentage = 0.0,
    this.completedConsultations = 0,
    this.waitingPatients = 0,
    this.inConsultationPatients = 0,
    this.cancelledPatients = 0,
    this.totalIncome = 0.0,
    this.todayIncome = 0.0,
    this.newPatientIncome = 0.0,
    this.revisitPatientIncome = 0.0,
    this.avgIncomePerPatient = 0.0,
    this.avgWaitTimeMinutes = 0.0,
    this.avgConsultationMinutes = 0.0,
  });
}

@immutable
class DailyIncomeMetric {
  final DateTime date;
  final int totalPatients;
  final int newPatients;
  final int revisitPatients;
  final int completedPatients;
  final double totalIncome;

  const DailyIncomeMetric({
    required this.date,
    required this.totalPatients,
    required this.newPatients,
    required this.revisitPatients,
    required this.completedPatients,
    required this.totalIncome,
  });
}

@immutable
class DiagnosisStatMetric {
  final String diagnosisName;
  final int count;
  final double percentage;

  const DiagnosisStatMetric({
    required this.diagnosisName,
    required this.count,
    required this.percentage,
  });
}

@immutable
class DemographicsMetric {
  final int pediatric; // < 12
  final int adult; // 12 - 59
  final int geriatric; // >= 60

  const DemographicsMetric({
    this.pediatric = 0,
    this.adult = 0,
    this.geriatric = 0,
  });

  int get total => pediatric + adult + geriatric;
}

