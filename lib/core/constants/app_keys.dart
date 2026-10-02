/// Clés globales de stockage Hive et SharedPreferences
abstract final class AppKeys {
  // ── Hive Box names ─────────────────────────────────────────
  static const String userStateBox = 'userStateBox';
  static const String appointmentsBox = 'appointmentsBox';
  static const String measuresBox = 'measuresBox';
  static const String healthRecordsBox = 'healthRecordsBox';
  static const String babyBox = 'babyBox';
  static const String babyLogBox = 'babyLogBox';
  static const String chatHistoryBox = 'chatHistoryBox';

  // ── Hive Keys dans userStateBox ────────────────────────────
  static const String keyName = 'name';
  static const String keyContact = 'contact';
  static const String keyLmp = 'lmp';
  static const String keyFirstPregnancy = 'firstPregnancy';
  static const String keyCenter = 'center';
  static const String keyConsent = 'consent';
  static const String keyAiPrivacy = 'aiPrivacy';
  static const String keyPartner = 'partner';
  static const String keyBaby = 'baby';
  static const String keyCountry = 'country';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyOnboarded = 'onboarded';
}
