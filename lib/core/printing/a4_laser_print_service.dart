import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../config/clinic_settings.dart';
import '../../features/encounter/domain/clinical_models.dart';
import '../../features/encounter/domain/encounter_state.dart';

class A4LaserPrintService {
  static const double letterheadTopMarginMm =
      45.0; // Default blank margin for physical letterheads
  static const double standardMarginMm = 10.0;

  /// Generates the crisp vector A4 PDF bytes
  static Future<Uint8List> buildA4Prescription(
    EncounterState encounter, [
    ClinicSettings? settings,
  ]) async {
    final s = settings ?? const ClinicSettings();
    final pdf = pw.Document(
      title:
          'Prescription - ${encounter.activePatient?.patientName ?? "Patient"}',
      author: s.clinicName,
    );

    final isLetterhead = encounter.isLetterheadMode;
    final topMarginMm = isLetterhead
        ? s.letterheadTopMarginMm
        : standardMarginMm;
    final pageFormat = PdfPageFormat.a4.copyWith(
      marginTop: topMarginMm * PdfPageFormat.mm,
      marginBottom: standardMarginMm * PdfPageFormat.mm,
      marginLeft: standardMarginMm * PdfPageFormat.mm,
      marginRight: standardMarginMm * PdfPageFormat.mm,
    );

    final patient = encounter.activePatient;
    final patientIdLabel =
        (patient?.patientId != null && patient!.patientId!.trim().isNotEmpty)
        ? ' [ID: ${patient.patientId}]'
        : '';
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy');

    final vitals = patient != null
        ? PatientVitals.fromJson(patient.vitals)
        : const PatientVitals();

    pw.Font? malayalamFont;
    pw.Font? malayalamBoldFont;
    try {
      malayalamFont = await PdfGoogleFonts.notoSansMalayalamRegular();
      malayalamBoldFont = await PdfGoogleFonts.notoSansMalayalamBold();
    } catch (_) {
      // Offline or testing fallback
    }

    final theme = pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      fontFallback: [
        if (malayalamFont != null) malayalamFont,
        if (malayalamBoldFont != null) malayalamBoldFont,
      ],
    );

    pdf.addPage(
      pw.Page(
        theme: theme,
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // 1. Clinic Header (Suppressed if pre-printed letterhead paper is used)
              if (!isLetterhead) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(
                        color: PdfColors.blueGrey800,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            s.clinicName,
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blue900,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            s.clinicSubtitle,
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey700,
                            ),
                          ),
                          pw.Text(
                            s.clinicContact,
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
                            s.doctorName,
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.blueGrey900,
                            ),
                          ),
                          pw.Text(
                            s.doctorQualifications,
                            style: const pw.TextStyle(
                              fontSize: 9,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.Text(
                            s.registrationNumber,
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
                ),
                pw.SizedBox(height: 6),
              ],

              // 2. Patient Demographics & Token Strip
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
                  border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOKEN: #${patient?.tokenNumber ?? "--"}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      'Patient: ${patient?.patientName ?? "Unknown"}$patientIdLabel (${patient?.dynamicAgeDisplay ?? "--"} / ${patient?.gender ?? "--"})',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Date: ${dateFormat.format(now)}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),

              // 3. Two-Column Clinical Body (30% Left Summary / 70% Right Rx)
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // --- LEFT COLUMN (30% Width - Clinical Notes) ---
                    pw.Container(
                      width: 175,
                      padding: const pw.EdgeInsets.only(right: 10),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          right: pw.BorderSide(
                            color: PdfColors.grey300,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Vitals Box
                          if (vitals.hasAnyVitals) ...[
                            _buildPdfSectionHeader('Vitals at Entry'),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              margin: const pw.EdgeInsets.only(bottom: 8),
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey50,
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(3),
                                ),
                                border: pw.Border.all(
                                  color: PdfColors.grey300,
                                  width: 0.5,
                                ),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  if (vitals.bpSys != null)
                                    _buildPdfVitalRow('BP', vitals.bpDisplay),
                                  if (vitals.pulse != null)
                                    _buildPdfVitalRow(
                                      'Pulse',
                                      vitals.pulseDisplay,
                                    ),
                                  if (vitals.spo2 != null)
                                    _buildPdfVitalRow(
                                      'SpO2',
                                      vitals.spo2Display,
                                    ),
                                  if (vitals.temp != null)
                                    _buildPdfVitalRow(
                                      'Temp',
                                      vitals.tempDisplay,
                                    ),
                                  if (vitals.weight != null)
                                    _buildPdfVitalRow(
                                      'Weight',
                                      vitals.weightDisplay,
                                    ),
                                ],
                              ),
                            ),
                          ],

                          // Comorbidities
                          if (encounter.selectedComorbidityIds.isNotEmpty) ...[
                            _buildPdfSectionHeader('Comorbidities'),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Text(
                                encounter.selectedComorbidityIds
                                    .map(
                                      (id) => id
                                          .replaceAll('comorb_', '')
                                          .toUpperCase(),
                                    )
                                    .join(', '),
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ],

                          // Drug Allergies
                          _buildPdfSectionHeader('Drug Allergies'),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 3,
                              ),
                              decoration: pw.BoxDecoration(
                                color: encounter.allergies.isNotEmpty
                                    ? PdfColors.red50
                                    : PdfColors.grey100,
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(3),
                                ),
                              ),
                              child: pw.Text(
                                encounter.allergies.isNotEmpty
                                    ? 'ALLERGIC: ${encounter.allergies.join(", ").toUpperCase()}'
                                    : 'NKDA (Nil Known Drug Allergies)',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  fontWeight: encounter.allergies.isNotEmpty
                                      ? pw.FontWeight.bold
                                      : pw.FontWeight.normal,
                                  color: encounter.allergies.isNotEmpty
                                      ? PdfColors.red900
                                      : PdfColors.grey700,
                                ),
                              ),
                            ),
                          ),

                          // Presenting Complaints
                          _buildPdfSectionHeader('Chief Complaints'),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Text(
                              encounter.compiledComplaintsSummary,
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                          ),

                          // Examination Findings
                          _buildPdfSectionHeader('Systemic Examination'),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(bottom: 8),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: encounter.examStates.values.map((exam) {
                                return pw.Padding(
                                  padding: const pw.EdgeInsets.only(bottom: 2),
                                  child: pw.RichText(
                                    text: pw.TextSpan(
                                      children: [
                                        pw.TextSpan(
                                          text: '${exam.systemName}: ',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        pw.TextSpan(
                                          text: exam.compiledText,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          // Final Diagnoses (Respects Privacy Toggle)
                          if (encounter.printDiagnosis) ...[
                            _buildPdfSectionHeader('Diagnosis'),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: encounter.selectedDiagnosisIds.map((
                                  d,
                                ) {
                                  return pw.Text(
                                    '- ${d.replaceAll("diag_", "").toUpperCase()}',
                                    style: pw.TextStyle(
                                      fontSize: 8.5,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.blue900,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ] else ...[
                            _buildPdfSectionHeader('Diagnosis'),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Text(
                                '(Withheld on request - Confidential)',
                                style: pw.TextStyle(
                                  fontSize: 7.5,
                                  fontStyle: pw.FontStyle.italic,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ),
                          ],

                          // Ordered Investigations Section
                          if (encounter.investigations.isNotEmpty) ...[
                            _buildPdfSectionHeader('Investigations / Orders'),
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 8),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: encounter.investigations.map((inv) {
                                  return pw.Text(
                                    '• $inv',
                                    style: pw.TextStyle(
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.blueGrey800,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // --- RIGHT COLUMN (70% Width - Rx Medications) ---
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // Large Rx Symbol
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Rx',
                                  style: pw.TextStyle(
                                    fontSize: 22,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.blue900,
                                  ),
                                ),
                                pw.Text(
                                  '${encounter.activePrescription.length} Medications',
                                  style: const pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 6),

                            // Structured Medications Table
                            pw.Table(
                              border: pw.TableBorder.all(
                                color: PdfColors.grey300,
                                width: 0.5,
                              ),
                              columnWidths: {
                                0: const pw.FlexColumnWidth(0.5), // #
                                1: const pw.FlexColumnWidth(3.0), // Medicine
                                2: const pw.FlexColumnWidth(1.2), // Dose
                                3: const pw.FlexColumnWidth(1.2), // Frequency
                                4: const pw.FlexColumnWidth(1.2), // Duration
                                5: const pw.FlexColumnWidth(
                                  2.5,
                                ), // Instructions
                              },
                              children: [
                                // Table Header
                                pw.TableRow(
                                  decoration: const pw.BoxDecoration(
                                    color: PdfColors.grey200,
                                  ),
                                  children: [
                                    _buildTableHeader('#'),
                                    _buildTableHeader('Medicine Name'),
                                    _buildTableHeader('Dose'),
                                    _buildTableHeader('Freq'),
                                    _buildTableHeader('Duration'),
                                    _buildTableHeader('Instructions'),
                                  ],
                                ),
                                // Table Rows
                                ...List.generate(
                                  encounter.activePrescription.length,
                                  (idx) {
                                    final rx =
                                        encounter.activePrescription[idx];
                                    final isEven = idx % 2 == 0;
                                    return pw.TableRow(
                                      decoration: pw.BoxDecoration(
                                        color: isEven
                                            ? PdfColors.white
                                            : PdfColors.grey50,
                                      ),
                                      children: [
                                        _buildTableCell(
                                          '${idx + 1}',
                                          isBold: true,
                                          align: pw.TextAlign.center,
                                        ),
                                        pw.Padding(
                                          padding: const pw.EdgeInsets.all(4),
                                          child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                rx.brandName,
                                                style: pw.TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.Text(
                                                rx.genericName,
                                                style: const pw.TextStyle(
                                                  fontSize: 7.5,
                                                  color: PdfColors.grey700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        _buildTableCell(rx.dose),
                                        _buildTableCell(
                                          rx.frequency,
                                          isBold: true,
                                          align: pw.TextAlign.center,
                                        ),
                                        _buildTableCell(
                                          rx.duration,
                                          align: pw.TextAlign.center,
                                        ),
                                        _buildTableCell(rx.instructions),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 12),

                            // General Advice & Dietary Guidelines
                            if (encounter.generalAdvice.isNotEmpty) ...[
                              _buildPdfSectionHeader(
                                'General Advice & Dietary Instructions',
                              ),
                              pw.Container(
                                width: double.infinity,
                                padding: const pw.EdgeInsets.all(6),
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.grey50,
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(3),
                                  ),
                                  border: pw.Border.all(
                                    color: PdfColors.grey300,
                                    width: 0.5,
                                  ),
                                ),
                                child: pw.Text(
                                  encounter.generalAdvice,
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                            ],

                            // Follow-up Notice
                            if (encounter.followUpDays != null) ...[
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.blue50,
                                  borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(3),
                                  ),
                                  border: pw.Border.all(
                                    color: PdfColors.blue200,
                                    width: 0.5,
                                  ),
                                ),
                                child: pw.Text(
                                  'Follow-up / Review: In ${encounter.followUpDays} days or SOS if symptoms aggravate.',
                                  style: pw.TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.blue900,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Footer & Signature
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 8),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfColors.grey300, width: 0.8),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Generated via JMC Nexus | Valid Medical Electronic Prescription',
                      style: const pw.TextStyle(
                        fontSize: 7.5,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          width: 120,
                          decoration: const pw.BoxDecoration(
                            border: pw.Border(
                              bottom: pw.BorderSide(
                                color: PdfColors.grey700,
                                width: 0.8,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Doctor\'s Signature / Stamp',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Sends document to system print spooler for Wi-Fi / Bluetooth / Network Laser Printer
  static Future<void> printA4Prescription(
    EncounterState encounter, [
    ClinicSettings? settings,
  ]) async {
    final pdfBytes = await buildA4Prescription(encounter, settings);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Prescription_${encounter.activePatient?.tokenNumber ?? "OPD"}',
      format: PdfPageFormat.a4,
    );
  }

  static pw.Widget _buildPdfSectionHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static pw.Widget _buildPdfVitalRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 7.5, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey900,
        ),
        textAlign: pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isBold = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }
}
