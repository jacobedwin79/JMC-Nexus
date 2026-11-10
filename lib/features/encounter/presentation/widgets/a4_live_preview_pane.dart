import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../../core/printing/a4_laser_print_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/encounter_notifier.dart';

class A4LivePreviewPane extends ConsumerWidget {
  final VoidCallback onPrintedAndCompleted;

  const A4LivePreviewPane({super.key, required this.onPrintedAndCompleted});

  static Future<void> showPreviewDialog(
    BuildContext context, {
    required VoidCallback onPrintedAndCompleted,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 850,
            height: 900,
            padding: const EdgeInsets.all(16),
            child: A4LivePreviewPane(
              onPrintedAndCompleted: () {
                Navigator.of(context).pop();
                onPrintedAndCompleted();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final encounter = ref.watch(encounterProvider);
    final patient = encounter.activePatient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Preview Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.fileText,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'A4 Laser Prescription Preview • Token #${patient?.tokenNumber ?? ""}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x, size: 14),
                  label: const Text('Close'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await A4LaserPrintService.printA4Prescription(encounter);
                    onPrintedAndCompleted();
                  },
                  icon: const Icon(LucideIcons.printer, size: 16),
                  label: const Text('Dispatch to Laser Printer & Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppTheme.borderLight),
        const SizedBox(height: 12),

        // Live PDF Preview
        Expanded(
          child: PdfPreview(
            build: (format) =>
                A4LaserPrintService.buildA4Prescription(encounter),
            initialPageFormat: PdfPageFormat.a4,
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            previewPageMargin: const EdgeInsets.all(8),
            onPrinted: (context) => onPrintedAndCompleted(),
          ),
        ),
      ],
    );
  }
}
