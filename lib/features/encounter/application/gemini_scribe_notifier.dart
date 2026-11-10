import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/audio/audio_recorder_service.dart';
import '../../../core/config/clinic_settings.dart';
import 'clinical_catalog_providers.dart';
import 'encounter_notifier.dart';
import '../domain/gemini_scribe_models.dart';
import 'gemini_scribe_service.dart';

class GeminiScribeState {
  final bool isRecording;
  final int recordingDurationSeconds;
  final bool isProcessing;
  final List<VoiceNoteSnippet> voiceNotes;
  final List<AiClinicalAlert> aiSafetyAlerts;
  final String? lastTranscript;
  final String? lastSummary;
  final String? errorMessage;

  const GeminiScribeState({
    this.isRecording = false,
    this.recordingDurationSeconds = 0,
    this.isProcessing = false,
    this.voiceNotes = const [],
    this.aiSafetyAlerts = const [],
    this.lastTranscript,
    this.lastSummary,
    this.errorMessage,
  });

  GeminiScribeState copyWith({
    bool? isRecording,
    int? recordingDurationSeconds,
    bool? isProcessing,
    List<VoiceNoteSnippet>? voiceNotes,
    List<AiClinicalAlert>? aiSafetyAlerts,
    String? lastTranscript,
    String? lastSummary,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GeminiScribeState(
      isRecording: isRecording ?? this.isRecording,
      recordingDurationSeconds:
          recordingDurationSeconds ?? this.recordingDurationSeconds,
      isProcessing: isProcessing ?? this.isProcessing,
      voiceNotes: voiceNotes ?? this.voiceNotes,
      aiSafetyAlerts: aiSafetyAlerts ?? this.aiSafetyAlerts,
      lastTranscript: lastTranscript ?? this.lastTranscript,
      lastSummary: lastSummary ?? this.lastSummary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GeminiScribeNotifier extends Notifier<GeminiScribeState> {
  static const _uuid = Uuid();
  final _recorderService = AudioRecorderService();
  Timer? _durationTimer;

  @override
  GeminiScribeState build() {
    ref.onDispose(() {
      _durationTimer?.cancel();
      _recorderService.dispose();
    });
    return const GeminiScribeState();
  }

  void clearSession() {
    _durationTimer?.cancel();
    state = const GeminiScribeState();
  }

  void dismissSafetyAlert(int index) {
    if (index < 0 || index >= state.aiSafetyAlerts.length) return;
    final current = List<AiClinicalAlert>.from(state.aiSafetyAlerts)
      ..removeAt(index);
    state = state.copyWith(aiSafetyAlerts: current);
  }

  Future<void> startRecording() async {
    final settings = ref.read(clinicSettingsProvider);
    if (!settings.hasGeminiApiKey) {
      state = state.copyWith(
        errorMessage:
            'Gemini API key is required. Please configure it in Clinical Catalog & Settings.',
      );
      return;
    }

    try {
      state = state.copyWith(
        isRecording: true,
        recordingDurationSeconds: 0,
        clearError: true,
      );

      await _recorderService.start();

      _durationTimer?.cancel();
      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(
          recordingDurationSeconds: state.recordingDurationSeconds + 1,
        );
      });
    } catch (e) {
      _durationTimer?.cancel();
      state = state.copyWith(
        isRecording: false,
        errorMessage: 'Microphone error: $e',
      );
    }
  }

  Future<void> cancelRecording() async {
    _durationTimer?.cancel();
    await _recorderService.cancel();
    state = state.copyWith(
      isRecording: false,
      recordingDurationSeconds: 0,
      clearError: true,
    );
  }

  Future<void> stopRecordingAndProcess() async {
    _durationTimer?.cancel();
    final durationSecs = state.recordingDurationSeconds;

    state = state.copyWith(
      isRecording: false,
      isProcessing: true,
      recordingDurationSeconds: 0,
      clearError: true,
    );

    try {
      final recordingData = await _recorderService.stop();
      if (recordingData == null || recordingData.bytes.isEmpty) {
        state = state.copyWith(
          isProcessing: false,
          errorMessage: 'No audio captured. Please try recording again.',
        );
        return;
      }

      await _processWithGemini(
        audioBytes: recordingData.bytes,
        audioMimeType: recordingData.mimeType,
        durationSeconds: durationSecs,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to process voice note: $e',
      );
    }
  }

  Future<void> processTextDictation(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final settings = ref.read(clinicSettingsProvider);
    if (!settings.hasGeminiApiKey) {
      state = state.copyWith(
        errorMessage:
            'Gemini API key is required. Please configure it in Clinical Catalog & Settings.',
      );
      return;
    }

    state = state.copyWith(isProcessing: true, clearError: true);

    try {
      await _processWithGemini(
        textDictation: trimmed,
        durationSeconds: 0,
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to process dictation: $e',
      );
    }
  }

  Future<void> _processWithGemini({
    Uint8List? audioBytes,
    String? audioMimeType,
    String? textDictation,
    required int durationSeconds,
  }) async {
    final settings = ref.read(clinicSettingsProvider);
    final currentState = ref.read(encounterProvider);

    final comorbs = await ref.read(comorbiditiesCatalogProvider.future);
    final diags = await ref.read(diagnosesCatalogProvider.future);
    final drugs = await ref.read(drugsCatalogProvider.future);

    final scribeService = GeminiScribeService(
      apiKey: settings.geminiApiKey,
      modelName: 'gemini-1.5-flash',
    );

    final result = await scribeService.processClinicalDictation(
      audioBytes: audioBytes,
      audioMimeType: audioMimeType,
      textDictation: textDictation,
      currentState: currentState,
      comorbiditiesCatalog: comorbs,
      diagnosesCatalog: diags,
      drugsCatalog: drugs,
    );

    // Apply incremental EMR update
    await ref.read(encounterProvider.notifier).applyAiScribeUpdate(result);

    // Record voice note snippet
    final newSnippet = VoiceNoteSnippet(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      transcript: result.transcript.isNotEmpty
          ? result.transcript
          : (textDictation ?? 'Voice dictation'),
      summary: result.clinicalSummary.isNotEmpty
          ? result.clinicalSummary
          : 'Processed clinical dictation',
      durationSeconds: durationSeconds,
    );

    final updatedNotes = List<VoiceNoteSnippet>.from(state.voiceNotes)
      ..add(newSnippet);

    // Merge safety alerts
    final mergedAlerts = List<AiClinicalAlert>.from(state.aiSafetyAlerts);
    for (final alert in result.safetyAlerts) {
      if (!mergedAlerts.any((a) => a.title == alert.title && a.message == alert.message)) {
        mergedAlerts.add(alert);
      }
    }

    state = state.copyWith(
      isProcessing: false,
      voiceNotes: updatedNotes,
      aiSafetyAlerts: mergedAlerts,
      lastTranscript: result.transcript,
      lastSummary: result.clinicalSummary,
    );
  }
}

final geminiScribeProvider =
    NotifierProvider<GeminiScribeNotifier, GeminiScribeState>(
  GeminiScribeNotifier.new,
);

