import 'package:flutter/foundation.dart';

/// Centralized service providing server-synchronized timestamps.
///
/// Prevents SLA wait time color skewing across terminals with divergent system clocks.
class ServerTimeService {
  static Duration _clockOffset = Duration.zero;
  static bool _hasSynced = false;

  /// Current clock offset (serverTime - localDeviceTime)
  static Duration get clockOffset => _clockOffset;
  static bool get hasSynced => _hasSynced;

  /// Returns current estimated server time.
  static DateTime get now {
    return DateTime.now().add(_clockOffset);
  }

  /// Sets clock offset based on an authoritative server or DB timestamp.
  static void updateServerTime(
    DateTime serverTimestamp, {
    DateTime? localRequestTime,
  }) {
    final localNow = DateTime.now();
    // If request time is provided, account for round-trip latency
    final latency = localRequestTime != null
        ? localNow.difference(localRequestTime) ~/ 2
        : Duration.zero;

    final adjustedServerTime = serverTimestamp.add(latency);
    _clockOffset = adjustedServerTime.difference(localNow);
    _hasSynced = true;
    debugPrint(
      '[ServerTimeService] Synced offset: ${_clockOffset.inMilliseconds}ms',
    );
  }

  /// Manually reset offset for tests
  @visibleForTesting
  static void resetOffset() {
    _clockOffset = Duration.zero;
    _hasSynced = false;
  }
}
