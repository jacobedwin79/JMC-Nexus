/// Helper utility for pediatric and dynamic clinical age formatting.
class AgeCalculator {
  /// Calculates age dynamically and formats as:
  /// - Days for neonates (< 30 days)
  /// - Weeks/Months for infants (< 1 year)
  /// - Years for older children and adults
  static String formatAge(DateTime dateOfBirth, [DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    if (now.isBefore(dateOfBirth)) return '0 days';

    final totalDays = now.difference(dateOfBirth).inDays;

    if (totalDays < 30) {
      return '$totalDays ${totalDays == 1 ? "day" : "days"}';
    }

    if (totalDays < 365) {
      final months =
          (now.year - dateOfBirth.year) * 12 +
          now.month -
          dateOfBirth.month -
          (now.day < dateOfBirth.day ? 1 : 0);
      if (months <= 2) {
        final weeks = totalDays ~/ 7;
        return '$weeks ${weeks == 1 ? "week" : "weeks"}';
      }
      return '$months ${months == 1 ? "month" : "months"}';
    }

    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return '$years ${years == 1 ? "year" : "years"}';
  }

  /// Returns numeric age in years (used for clinical thresholds)
  static int calculateYears(DateTime dateOfBirth, [DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Compact display for patient cards e.g. "12d", "5m", "42y"
  static String formatAgeCompact(
    DateTime dateOfBirth, [
    DateTime? referenceDate,
  ]) {
    final now = referenceDate ?? DateTime.now();
    final totalDays = now.difference(dateOfBirth).inDays;

    if (totalDays < 30) return '${totalDays}d';
    if (totalDays < 365) {
      final months =
          (now.year - dateOfBirth.year) * 12 +
          now.month -
          dateOfBirth.month -
          (now.day < dateOfBirth.day ? 1 : 0);
      if (months <= 2) {
        return '${totalDays ~/ 7}w';
      }
      return '${months}m';
    }
    return '${calculateYears(dateOfBirth, now)}y';
  }

  /// Approximates date of birth given integer age in years
  static DateTime dobFromAgeInYears(int ageInYears) {
    final now = DateTime.now();
    return DateTime(now.year - ageInYears, now.month, now.day);
  }

  /// Parses date string in yyyy-MM-dd or dd/MM/yyyy
  static DateTime? tryParseDob(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    try {
      if (trimmed.contains('-')) {
        return DateTime.parse(trimmed);
      }
      if (trimmed.contains('/')) {
        final parts = trimmed.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }
}
