import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../config/clinic_settings.dart';
import '../../features/encounter/domain/clinical_models.dart';
import '../../features/encounter/domain/encounter_state.dart';

class MedicalCertificateService {
  /// Generates a standardized Medical Sick Leave Certificate PDF
  static Future<Uint8List> generateSickLeaveCertificate({
    required EncounterState encounter,
    required int leaveDays,
    DateTime? startDate,
    String? diagnosisOverride,
  }) async {
    final pdf = pw.Document(
      title: 'Medical Certificate - Sick Leave',
      author: 'JMC Nexus Health System',
    );

    final patient = encounter.activePatient;
    final now = DateTime.now();
    final start = startDate ?? now;
    final endDate = start.add(Duration(days: leaveDays - 1));
    final resumeDate = endDate.add(const Duration(days: 1));

    final dateFormat = DateFormat('dd MMMM yyyy');

    final primaryDiagnosis =
        diagnosisOverride ??
        (encounter.selectedDiagnosisIds.isNotEmpty
            ? encounter.selectedDiagnosisIds.first
                  .replaceAll('diag_', '')
                  .toUpperCase()
            : 'Acute Illness');

    pw.Font? regularFont;
    pw.Font? boldFont;
    try {
      regularFont = await PdfGoogleFonts.notoSansMalayalamRegular();
      boldFont = await PdfGoogleFonts.notoSansMalayalamBold();
    } catch (_) {}

    final theme = pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      fontFallback: [
        if (regularFont != null) regularFont,
        if (boldFont != null) boldFont,
      ],
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildClinicHeader(),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.blueGrey800,
                      width: 1.5,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    'MEDICAL SICK LEAVE CERTIFICATE',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Date of Issue: ${dateFormat.format(now)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    'Ref No: JMC-MC-${patient?.tokenNumber ?? "00"}/${now.year}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Text(
                'TO WHOMSOEVER IT MAY CONCERN',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Paragraph(
                text:
                    'This is to certify that ${patient?.gender == "F" ? "Ms./Mrs." : "Mr."} '
                    '${patient?.patientName ?? "The patient"}, aged ${patient?.dynamicAgeDisplay ?? "--"}, '
                    'residing at Kerala, has been under my clinical care and medical examination on ${dateFormat.format(start)}.',
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
              pw.SizedBox(height: 10),
              pw.Paragraph(
                text:
                    'The patient was evaluated and diagnosed with $primaryDiagnosis. '
                    'In view of the acute clinical condition and necessary medical convalescence, '
                    'the patient is advised complete rest and absence from duty / classes for a duration of $leaveDays days, '
                    'commencing from ${dateFormat.format(start)} to ${dateFormat.format(endDate)} inclusive.',
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
              pw.SizedBox(height: 10),
              pw.Paragraph(
                text:
                    'The patient is expected to be fit to resume normal duties / school attendance on ${dateFormat.format(resumeDate)}.',
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
              pw.Spacer(),
              _buildDoctorSignatureBlock(now),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a standardized Medical Fitness Certificate PDF
  static Future<Uint8List> generateFitnessCertificate({
    required EncounterState encounter,
    DateTime? effectiveDate,
    String? purpose,
  }) async {
    final pdf = pw.Document(
      title: 'Medical Certificate - Physical Fitness',
      author: 'JMC Nexus Health System',
    );

    final patient = encounter.activePatient;
    final now = DateTime.now();
    final effective = effectiveDate ?? now;
    final dateFormat = DateFormat('dd MMMM yyyy');
    final vitals = patient != null
        ? PatientVitals.fromJson(patient.vitals)
        : const PatientVitals();

    final fitPurpose = purpose ?? 'resumption of employment / academic duties';

    pw.Font? regularFont;
    pw.Font? boldFont;
    try {
      regularFont = await PdfGoogleFonts.notoSansMalayalamRegular();
      boldFont = await PdfGoogleFonts.notoSansMalayalamBold();
    } catch (_) {}

    final theme = pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      fontFallback: [
        if (regularFont != null) regularFont,
        if (boldFont != null) boldFont,
      ],
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildClinicHeader(),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.blueGrey800,
                      width: 1.5,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    'CERTIFICATE OF MEDICAL FITNESS',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Date of Examination: ${dateFormat.format(effective)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    'Ref No: JMC-FIT-${patient?.tokenNumber ?? "00"}/${now.year}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 25),
              pw.Paragraph(
                text:
                    'I have carefully examined ${patient?.gender == "F" ? "Ms./Mrs." : "Mr."} '
                    '${patient?.patientName ?? "The candidate"}, aged ${patient?.dynamicAgeDisplay ?? "--"}, '
                    '${patient?.patientId != null ? "bearing ID ${patient!.patientId}" : ""}.',
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Clinical Observations at Time of Examination:',
                      style: pw.TextStyle(
                        fontSize: 9.5,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '• Blood Pressure: ${vitals.bpDisplay}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      '• Pulse Rate: ${vitals.pulseDisplay} (Regular)',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      '• Systemic Examination: ${encounter.compiledExamSummary}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      '• Communicable Disease Status: Free from active signs of contagious or infectious disease.',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Paragraph(
                text:
                    'Based on clinical history, comprehensive physical examination, and vital status, '
                    'I hereby certify that ${patient?.gender == "F" ? "she" : "he"} is in good physical and mental health '
                    'and is medically FIT for $fitPurpose with immediate effect.',
                style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
              ),
              pw.Spacer(),
              _buildDoctorSignatureBlock(now),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a standardized Clinical Referral Letter PDF
  static Future<Uint8List> generateReferralLetter({
    required EncounterState encounter,
    required String referredToSpecialistOrHospital,
    required String reasonForReferral,
  }) async {
    final pdf = pw.Document(
      title: 'Clinical Referral Letter',
      author: 'JMC Nexus Health System',
    );

    final patient = encounter.activePatient;
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMMM yyyy, h:mm a');
    final vitals = patient != null
        ? PatientVitals.fromJson(patient.vitals)
        : const PatientVitals();

    pw.Font? regularFont;
    pw.Font? boldFont;
    try {
      regularFont = await PdfGoogleFonts.notoSansMalayalamRegular();
      boldFont = await PdfGoogleFonts.notoSansMalayalamBold();
    } catch (_) {}

    final theme = pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      fontFallback: [
        if (regularFont != null) regularFont,
        if (boldFont != null) boldFont,
      ],
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              _buildClinicHeader(),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.blueGrey800,
                      width: 1.5,
                    ),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(4),
                    ),
                  ),
                  child: pw.Text(
                    'CLINICAL REFERRAL LETTER',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 18),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'To:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        referredToSpecialistOrHospital,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Date & Time: ${dateFormat.format(now)}',
                        style: const pw.TextStyle(fontSize: 9.5),
                      ),
                      pw.Text(
                        'UHID / Ref: ${patient?.patientId ?? "#${patient?.tokenNumber}"}',
                        style: const pw.TextStyle(
                          fontSize: 9.5,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),
              // Patient Banner
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Patient: ${patient?.patientName ?? "Unknown"}',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Age/Sex: ${patient?.dynamicAgeDisplay ?? "--"} / ${patient?.gender ?? "--"}',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                    pw.Text(
                      'Vitals: BP ${vitals.bpDisplay} • PR ${vitals.pulseDisplay} • SpO2 ${vitals.spo2Display}',
                      style: const pw.TextStyle(fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Text(
                'Dear Colleague,',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                'Thank you for seeing this patient referred to your clinical service for further evaluation and management.',
                style: const pw.TextStyle(fontSize: 10.5),
              ),
              pw.SizedBox(height: 12),
              // Clinical Details Box
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildReferralField(
                      'Chief Complaints:',
                      encounter.compiledComplaintsSummary,
                    ),
                    pw.SizedBox(height: 6),
                    _buildReferralField(
                      'Examination Findings:',
                      encounter.compiledExamSummary,
                    ),
                    pw.SizedBox(height: 6),
                    _buildReferralField(
                      'Provisional Diagnosis:',
                      encounter.selectedDiagnosisIds
                          .join(', ')
                          .replaceAll('diag_', '')
                          .toUpperCase(),
                    ),
                    pw.SizedBox(height: 6),
                    if (encounter.activePrescription.isNotEmpty)
                      _buildReferralField(
                        'Initial Treatment Given:',
                        encounter.activePrescription
                            .map((m) => '${m.brandName} (${m.dose})')
                            .join('; '),
                      ),
                    if (encounter.investigations.isNotEmpty)
                      _buildReferralField(
                        'Investigations Ordered:',
                        encounter.investigations.join(', '),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  border: pw.Border.all(color: PdfColors.blue200),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                child: _buildReferralField(
                  'Reason for Referral / Opinion Sought:',
                  reasonForReferral,
                ),
              ),
              pw.Spacer(),
              _buildDoctorSignatureBlock(now),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildClinicHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blueGrey800, width: 1.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'JMC CLINICAL HEALTHCARE & OPD',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Comprehensive Outpatient & Emergency Clinical Center',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Text(
                'Phone: +91 98765 43210 | Email: care@jmchealth.org',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Dr. Rajesh Varma, MD',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                ),
              ),
              pw.Text(
                'MBBS, MD (General Medicine)',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey800,
                ),
              ),
              pw.Text(
                'Reg. No: KMC-49281',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReferralField(String title, String content) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$title ',
            style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(
            text: content.isNotEmpty ? content : '--',
            style: const pw.TextStyle(fontSize: 9.5),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDoctorSignatureBlock(DateTime date) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Date: ${DateFormat("dd/MM/yyyy").format(date)}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.Text(
              'Place: JMC Clinic, Kerala',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              width: 140,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(color: PdfColors.grey700, width: 1.0),
                ),
              ),
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Dr. Rajesh Varma, MD',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Reg. No: KMC-49281',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Text(
                    '(Signature & Clinical Stamp)',
                    style: const pw.TextStyle(
                      fontSize: 7.5,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
