import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecordingData {
  final Uint8List bytes;
  final String mimeType;
  final String? filePath;

  const AudioRecordingData({
    required this.bytes,
    required this.mimeType,
    this.filePath,
  });
}

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentRecordingPath;

  Future<bool> hasPermission() async {
    try {
      return await _recorder.hasPermission();
    } catch (e) {
      debugPrint('Audio permission check failed: $e');
      return false;
    }
  }

  Future<bool> isRecording() async {
    try {
      return await _recorder.isRecording();
    } catch (_) {
      return false;
    }
  }

  Future<void> start() async {
    final hasPerm = await hasPermission();
    if (!hasPerm) {
      throw StateError('Microphone permission not granted.');
    }

    String path = '';
    if (!kIsWeb) {
      final tempDir = await getTemporaryDirectory();
      path =
          '${tempDir.path}/jmc_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      _currentRecordingPath = path;
    }

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
  }

  Future<AudioRecordingData?> stop() async {
    try {
      final path = await _recorder.stop();
      if (path == null) return null;

      Uint8List bytes;
      if (kIsWeb) {
        final res = await http.get(Uri.parse(path));
        bytes = res.bodyBytes;
      } else {
        final file = File(path);
        if (!await file.exists()) return null;
        bytes = await file.readAsBytes();
      }

      return AudioRecordingData(
        bytes: bytes,
        mimeType: 'audio/m4a',
        filePath: path,
      );
    } catch (e) {
      debugPrint('Audio stop recording error: $e');
      return null;
    }
  }

  Future<void> cancel() async {
    try {
      await _recorder.cancel();
      if (!kIsWeb && _currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete().catchError((_) => file);
        }
      }
    } catch (e) {
      debugPrint('Audio cancel error: $e');
    } finally {
      _currentRecordingPath = null;
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}

