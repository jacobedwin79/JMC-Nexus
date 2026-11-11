import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/config/clinic_settings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../../catalog_manager/presentation/catalog_manager_screen.dart';
import '../../application/encounter_notifier.dart';
import '../../application/gemini_scribe_notifier.dart';
import '../../domain/gemini_scribe_models.dart';

class GeminiVoiceScribeBar extends ConsumerStatefulWidget {
  const GeminiVoiceScribeBar({super.key});

  @override
  ConsumerState<GeminiVoiceScribeBar> createState() =>
      _GeminiVoiceScribeBarState();
}

class _GeminiVoiceScribeBarState extends ConsumerState<GeminiVoiceScribeBar>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  void _openSettingsOrNotify() {
    final role = ref.read(activeRoleProvider);
    if (role == AppRole.admin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CatalogManagerScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Clinic settings and API keys can only be configured by an Administrator.',
          ),
          backgroundColor: AppTheme.textPrimary,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.9, end: 1.15).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  void _handleSendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    ref.read(geminiScribeProvider.notifier).processTextDictation(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final encounter = ref.watch(encounterProvider);
    final scribeState = ref.watch(geminiScribeProvider);
    final settings = ref.watch(clinicSettingsProvider);
    final hasActivePatient = encounter.hasActivePatient;

    if (!hasActivePatient) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scribeState.isRecording
              ? Colors.redAccent
              : (scribeState.isProcessing
                  ? AppTheme.primaryBlue
                  : AppTheme.borderLight),
          width: scribeState.isRecording ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: scribeState.isRecording
                ? Colors.redAccent.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Gemini AI Voice Scribe',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Multi-note WhatsApp style',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
              const Spacer(),
              if (!settings.hasGeminiApiKey)
                InkWell(
                  onTap: _openSettingsOrNotify,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.slaOverdue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.slaOverdue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.settings,
                          size: 12,
                          color: AppTheme.slaOverdue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Configure API Key in Settings',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.slaOverdue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: _openSettingsOrNotify,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.cpu,
                          size: 12,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          settings.geminiModel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Main Recording & Dictation Controls
          if (scribeState.isRecording) ...[
            // LIVE RECORDING STRIP (WhatsApp Voice Note Mode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatDuration(scribeState.recordingDurationSeconds),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Listening... Dictate complaints, findings, or drugs freely',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Cancel Button
                  IconButton(
                    icon: const Icon(LucideIcons.trash2, color: Colors.grey, size: 18),
                    tooltip: 'Cancel & Discard note',
                    onPressed: () {
                      ref.read(geminiScribeProvider.notifier).cancelRecording();
                    },
                  ),

                  // Send & Process Voice Note
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(geminiScribeProvider.notifier)
                          .stopRecordingAndProcess();
                    },
                    icon: const Icon(LucideIcons.send, size: 14),
                    label: const Text(
                      'Scribe Note',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (scribeState.isProcessing) ...[
            // PROCESSING SHIMMER BAR
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gemini AI is analyzing voice note, mapping to formulary & evaluating safety parameters...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // IDLE INPUT BAR (Mic Button + Text Input)
            Row(
              children: [
                // Voice Record Trigger Button (WhatsApp Style)
                Tooltip(
                  message: 'Record Voice Note (Dictate bit by bit)',
                  child: Material(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        ref
                            .read(geminiScribeProvider.notifier)
                            .startRecording();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.mic, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Voice Note',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Text Dictation Alternative
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _handleSendText(),
                    decoration: InputDecoration(
                      hintText:
                          'Or type clinical notes (e.g. "Fever 3 days, RS clear, Dolo 650 TDS, Monticope HS")...',
                      hintStyle: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppTheme.borderLight),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(LucideIcons.cornerDownLeft, size: 16),
                        tooltip: 'Apply Note',
                        onPressed: _handleSendText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Error Message Display
          if (scribeState.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.slaOverdue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.slaOverdue.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      LucideIcons.alertCircle,
                      color: AppTheme.slaOverdue,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scribeState.errorMessage!,
                      style: const TextStyle(
                        color: AppTheme.slaOverdue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _openSettingsOrNotify,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppTheme.slaOverdue.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.settings,
                            size: 11,
                            color: AppTheme.slaOverdue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.slaOverdue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Voice Note History Snippets ("Put all puzzles together")
          if (scribeState.voiceNotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  LucideIcons.history,
                  size: 12,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Encounter Voice Notes (${scribeState.voiceNotes.length} integrated):',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: scribeState.voiceNotes.asMap().entries.map((entry) {
                final idx = entry.key + 1;
                final note = entry.value;
                return Tooltip(
                  message: 'Transcript: "${note.transcript}"',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.mic,
                          size: 11,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Note #$idx: ${note.summary}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // AI Clinical Safety Alerts & Drug Interaction Warnings
          if (scribeState.aiSafetyAlerts.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.shieldAlert,
                        size: 15,
                        color: Color(0xFFD97706),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Gemini AI Safety & Interaction Insights',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...scribeState.aiSafetyAlerts.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final alert = entry.value;
                    final isCritical = alert.severity == AiAlertSeverity.critical;

                    return Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCritical
                            ? const Color(0xFFFEF2F2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCritical
                              ? const Color(0xFFFECACA)
                              : const Color(0xFFF3F4F6),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isCritical
                                ? LucideIcons.alertTriangle
                                : LucideIcons.info,
                            size: 14,
                            color: isCritical
                                ? AppTheme.slaOverdue
                                : const Color(0xFFD97706),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert.title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCritical
                                        ? AppTheme.slaOverdue
                                        : const Color(0xFF92400E),
                                  ),
                                ),
                                Text(
                                  alert.message,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.x,
                              size: 13,
                              color: AppTheme.textMuted,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Dismiss alert',
                            onPressed: () {
                              ref
                                  .read(geminiScribeProvider.notifier)
                                  .dismissSafetyAlert(idx);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

