import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Default Gemini model used for AI clinical scribing.
///
/// Google has shut down the older 1.5 / 2.0 model families. As of late 2026,
/// `gemini-3.8-flash` is the model Google explicitly recommends as the
/// replacement for `gemini-2.0-flash`; it supports text/audio input plus
/// structured JSON output.
const kDefaultGeminiModel = 'gemini-3.8-flash';

/// Model IDs that Google has shut down or retired. Any persisted selection
/// pointing at one of these is migrated to [kDefaultGeminiModel] on load.
const kRetiredGeminiModels = <String>{
  'gemini-2.0-flash',
  'gemini-2.0-flash-exp',
  'gemini-2.0-flash-lite',
  'gemini-1.5-flash',
  'gemini-1.5-flash-8b',
  'gemini-1.5-flash-001',
  'gemini-1.5-flash-002',
  'gemini-1.5-pro',
  'gemini-1.5-pro-001',
  'gemini-1.5-pro-002',
};

/// Returns a currently-valid Gemini model for a persisted selection.
String resolveGeminiModel(String? saved) {
  final model = (saved ?? '').trim();
  if (model.isEmpty || kRetiredGeminiModels.contains(model)) {
    return kDefaultGeminiModel;
  }
  return model;
}

class ClinicSettings {
  final String clinicName;
  final String clinicSubtitle;
  final String clinicContact;
  final String doctorName;
  final String doctorQualifications;
  final String registrationNumber;
  final double letterheadTopMarginMm;
  final double consultationFee;
  final double revisitFee;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String geminiApiKey;
  final String geminiModel;

  const ClinicSettings({
    this.clinicName = 'JMC CLINICAL HEALTHCARE & OPD',
    this.clinicSubtitle =
        'Comprehensive Outpatient & Emergency Clinical Center',
    this.clinicContact = 'Phone: +91 98765 43210 | Email: care@jmchealth.org',
    this.doctorName = 'Dr. Rajesh Varma, MD',
    this.doctorQualifications = 'MBBS, MD (General Medicine)',
    this.registrationNumber = 'Reg. No: KMC-49281',
    this.letterheadTopMarginMm = 45.0,
    this.consultationFee = 200.0,
    this.revisitFee = 150.0,
    this.supabaseUrl = 'https://oxvsejnyhsjudrscsadg.supabase.co',
    this.supabaseAnonKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94dnNlam55aHNqdWRyc2NzYWRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg5NjgzMzUsImV4cCI6MjA3NDU0NDMzNX0.7-kBKCUoOJmjCak4fY56ZNBnmhgzywokEpjQJndy1Wo',
    this.geminiApiKey = '',
    this.geminiModel = kDefaultGeminiModel,
  });

  bool get hasSupabaseCredentials =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  bool get hasGeminiApiKey => geminiApiKey.trim().isNotEmpty;

  ClinicSettings copyWith({
    String? clinicName,
    String? clinicSubtitle,
    String? clinicContact,
    String? doctorName,
    String? doctorQualifications,
    String? registrationNumber,
    double? letterheadTopMarginMm,
    double? consultationFee,
    double? revisitFee,
    String? supabaseUrl,
    String? supabaseAnonKey,
    String? geminiApiKey,
    String? geminiModel,
  }) {
    return ClinicSettings(
      clinicName: clinicName ?? this.clinicName,
      clinicSubtitle: clinicSubtitle ?? this.clinicSubtitle,
      clinicContact: clinicContact ?? this.clinicContact,
      doctorName: doctorName ?? this.doctorName,
      doctorQualifications: doctorQualifications ?? this.doctorQualifications,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      letterheadTopMarginMm:
          letterheadTopMarginMm ?? this.letterheadTopMarginMm,
      consultationFee: consultationFee ?? this.consultationFee,
      revisitFee: revisitFee ?? this.revisitFee,
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      supabaseAnonKey: supabaseAnonKey ?? this.supabaseAnonKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      geminiModel: geminiModel ?? this.geminiModel,
    );
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

class ClinicSettingsNotifier extends Notifier<ClinicSettings> {
  static const _kClinicName = 'clinic_name';
  static const _kClinicSubtitle = 'clinic_subtitle';
  static const _kClinicContact = 'clinic_contact';
  static const _kDoctorName = 'doctor_name';
  static const _kDoctorQuals = 'doctor_quals';
  static const _kRegNumber = 'doctor_reg';
  static const _kLetterheadMargin = 'letterhead_margin';
  static const _kConsultationFee = 'consultation_fee';
  static const _kRevisitFee = 'revisit_fee';
  static const _kSupabaseUrl = 'supabase_url';
  static const _kSupabaseKey = 'supabase_key';
  static const _kGeminiKey = 'gemini_api_key';
  static const _kGeminiModel = 'gemini_model';

  @override
  ClinicSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (prefs != null) {
      return _fromPrefs(prefs);
    }
    _loadFromPrefsAsync();
    return const ClinicSettings();
  }

  static const _kDefaultSupabaseUrl = 'https://oxvsejnyhsjudrscsadg.supabase.co';
  static const _kDefaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94dnNlam55aHNqdWRyc2NzYWRnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg5NjgzMzUsImV4cCI6MjA3NDU0NDMzNX0.7-kBKCUoOJmjCak4fY56ZNBnmhgzywokEpjQJndy1Wo';

  ClinicSettings _fromPrefs(SharedPreferences prefs) {
    final savedSupabaseUrl = prefs.getString(_kSupabaseUrl);
    final savedSupabaseKey = prefs.getString(_kSupabaseKey);

    return ClinicSettings(
      clinicName:
          prefs.getString(_kClinicName) ?? 'JMC CLINICAL HEALTHCARE & OPD',
      clinicSubtitle:
          prefs.getString(_kClinicSubtitle) ??
          'Comprehensive Outpatient & Emergency Clinical Center',
      clinicContact:
          prefs.getString(_kClinicContact) ??
          'Phone: +91 98765 43210 | Email: care@jmchealth.org',
      doctorName: prefs.getString(_kDoctorName) ?? 'Dr. Rajesh Varma, MD',
      doctorQualifications:
          prefs.getString(_kDoctorQuals) ?? 'MBBS, MD (General Medicine)',
      registrationNumber: prefs.getString(_kRegNumber) ?? 'Reg. No: KMC-49281',
      letterheadTopMarginMm: prefs.getDouble(_kLetterheadMargin) ?? 45.0,
      consultationFee: prefs.getDouble(_kConsultationFee) ?? 200.0,
      revisitFee: prefs.getDouble(_kRevisitFee) ?? 150.0,
      supabaseUrl: (savedSupabaseUrl != null && savedSupabaseUrl.trim().isNotEmpty)
          ? savedSupabaseUrl
          : _kDefaultSupabaseUrl,
      supabaseAnonKey: (savedSupabaseKey != null && savedSupabaseKey.trim().isNotEmpty)
          ? savedSupabaseKey
          : _kDefaultSupabaseAnonKey,
      geminiApiKey: prefs.getString(_kGeminiKey) ?? '',
      geminiModel: resolveGeminiModel(prefs.getString(_kGeminiModel)),
    );
  }

  Future<void> _loadFromPrefsAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = _fromPrefs(prefs);
    } catch (_) {
      // SharedPreferences not mocked in test environment
    }
  }

  Future<void> updateSettings(ClinicSettings updated) async {
    state = updated;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kClinicName, updated.clinicName);
      await prefs.setString(_kClinicSubtitle, updated.clinicSubtitle);
      await prefs.setString(_kClinicContact, updated.clinicContact);
      await prefs.setString(_kDoctorName, updated.doctorName);
      await prefs.setString(_kDoctorQuals, updated.doctorQualifications);
      await prefs.setString(_kRegNumber, updated.registrationNumber);
      await prefs.setDouble(_kLetterheadMargin, updated.letterheadTopMarginMm);
      await prefs.setDouble(_kConsultationFee, updated.consultationFee);
      await prefs.setDouble(_kRevisitFee, updated.revisitFee);
      await prefs.setString(_kSupabaseUrl, updated.supabaseUrl);
      await prefs.setString(_kSupabaseKey, updated.supabaseAnonKey);
      await prefs.setString(_kGeminiKey, updated.geminiApiKey);
      await prefs.setString(_kGeminiModel, updated.geminiModel);
    } catch (_) {
      // SharedPreferences not mocked in test environment
    }
  }
}

final clinicSettingsProvider =
    NotifierProvider<ClinicSettingsNotifier, ClinicSettings>(
      ClinicSettingsNotifier.new,
    );
