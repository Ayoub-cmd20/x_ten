import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppPreferences {
  bool get isFirstLaunch;
  Future<void> markLaunched();
  String? get languageCode;
  Future<void> setLanguageCode(String code);
  String? get lastEmail;
  Future<void> setLastEmail(String email);
  String? get themeMode;
  Future<void> setThemeMode(String mode);
  bool get hasSeenOnboarding;
  Future<void> markOnboardingSeen();
}

class SharedAppPreferences implements AppPreferences {
  SharedAppPreferences(this._prefs);

  static const _launchedKey = 'has_launched';
  static const _languageKey = 'language_code';
  static const _lastEmailKey = 'last_email';
  static const _themeModeKey = 'theme_mode';
  static const _onboardingKey = 'onboarding_seen';

  final SharedPreferencesWithCache _prefs;

  static Future<SharedAppPreferences> create() async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {_launchedKey, _languageKey, _lastEmailKey, _themeModeKey, _onboardingKey},
      ),
    );
    return SharedAppPreferences(prefs);
  }

  @override
  bool get isFirstLaunch => !(_prefs.getBool(_launchedKey) ?? false);

  @override
  Future<void> markLaunched() => _prefs.setBool(_launchedKey, true);

  @override
  String? get languageCode => _prefs.getString(_languageKey);

  @override
  Future<void> setLanguageCode(String code) => _prefs.setString(_languageKey, code);

  @override
  String? get lastEmail => _prefs.getString(_lastEmailKey);

  @override
  Future<void> setLastEmail(String email) => _prefs.setString(_lastEmailKey, email);

  @override
  String? get themeMode => _prefs.getString(_themeModeKey);

  @override
  Future<void> setThemeMode(String mode) => _prefs.setString(_themeModeKey, mode);

  @override
  bool get hasSeenOnboarding => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> markOnboardingSeen() => _prefs.setBool(_onboardingKey, true);
}
