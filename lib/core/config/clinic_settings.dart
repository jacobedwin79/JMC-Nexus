import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClinicSettings {
  final String clinicName;
  final String clinicSubtitle;
  final String clinicContact;
  final String doctorName;
  final String doctorQualifications;
  final String registrationNumber;
  final double letterheadTopMarginMm;
  final String supabaseUrl;
  final String supabaseAnonKey;

  const ClinicSettings({
    this.clinicName = 'JMC CLINICAL HEALTHCARE & OPD',
    this.clinicSubtitle = 'Comprehensive Outpatient & Emergency Clinical Center',
    this.clinicContact = 'Phone: +91 98765 43210 | Email: care@jmchealth.org',
    this.doctorName = 'Dr. Rajesh Varma, MD',
    this.doctorQualifications = 'MBBS, MD (General Medicine)',
    this.registrationNumber = 'Reg. No: KMC-49281',
    this.letterheadTopMarginMm = 45.0,
    this.supabaseUrl = '',
    this.supabaseAnonKey = '',
  });

  bool get hasSupabaseCredentials =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  ClinicSettings copyWith({
    String? clinicName,
    String? clinicSubtitle,
    String? clinicContact,
    String? doctorName,
    String? doctorQualifications,
    String? registrationNumber,
    double? letterheadTopMarginMm,
    String? supabaseUrl,
    String? supabaseAnonKey,
  }) {
    return ClinicSettings(
      clinicName: clinicName ?? this.clinicName,
      clinicSubtitle: clinicSubtitle ?? this.clinicSubtitle,
      clinicContact: clinicContact ?? this.clinicContact,
      doctorName: doctorName ?? this.doctorName,
      doctorQualifications: doctorQualifications ?? this.doctorQualifications,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      letterheadTopMarginMm: letterheadTopMarginMm ?? this.letterheadTopMarginMm,
      supabaseUrl: supabaseUrl ?? this.supabaseUrl,
      supabaseAnonKey: supabaseAnonKey ?? this.supabaseAnonKey,
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
  static const _kSupabaseUrl = 'supabase_url';
  static const _kSupabaseKey = 'supabase_key';

  @override
  ClinicSettings build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    if (prefs != null) {
      return _fromPrefs(prefs);
    }
    _loadFromPrefsAsync();
    return const ClinicSettings();
  }

  ClinicSettings _fromPrefs(SharedPreferences prefs) {
    return ClinicSettings(
      clinicName: prefs.getString(_kClinicName) ?? 'JMC CLINICAL HEALTHCARE & OPD',
      clinicSubtitle: prefs.getString(_kClinicSubtitle) ?? 'Comprehensive Outpatient & Emergency Clinical Center',
      clinicContact: prefs.getString(_kClinicContact) ?? 'Phone: +91 98765 43210 | Email: care@jmchealth.org',
      doctorName: prefs.getString(_kDoctorName) ?? 'Dr. Rajesh Varma, MD',
      doctorQualifications: prefs.getString(_kDoctorQuals) ?? 'MBBS, MD (General Medicine)',
      registrationNumber: prefs.getString(_kRegNumber) ?? 'Reg. No: KMC-49281',
      letterheadTopMarginMm: prefs.getDouble(_kLetterheadMargin) ?? 45.0,
      supabaseUrl: prefs.getString(_kSupabaseUrl) ?? '',
      supabaseAnonKey: prefs.getString(_kSupabaseKey) ?? '',
    );
  }

  Future<void> _loadFromPrefsAsync() async {
    final prefs = await SharedPreferences.getInstance();
    state = _fromPrefs(prefs);
  }

  Future<void> updateSettings(ClinicSettings updated) async {
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kClinicName, updated.clinicName);
    await prefs.setString(_kClinicSubtitle, updated.clinicSubtitle);
    await prefs.setString(_kClinicContact, updated.clinicContact);
    await prefs.setString(_kDoctorName, updated.doctorName);
    await prefs.setString(_kDoctorQuals, updated.doctorQualifications);
    await prefs.setString(_kRegNumber, updated.registrationNumber);
    await prefs.setDouble(_kLetterheadMargin, updated.letterheadTopMarginMm);
    await prefs.setString(_kSupabaseUrl, updated.supabaseUrl);
    await prefs.setString(_kSupabaseKey, updated.supabaseAnonKey);
  }
}

final clinicSettingsProvider =
    NotifierProvider<ClinicSettingsNotifier, ClinicSettings>(ClinicSettingsNotifier.new);

