import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  Locale? _locale;

  Locale? get locale => _locale;

  bool get hasSelectedLanguage =>
      _locale != null;

  Future<void> loadLocale() async {
    final prefs =
    await SharedPreferences.getInstance();

    final code = prefs.getString(_languageKey);

    if (code == 'ar' ||
        code == 'fr' ||
        code == 'en') {
      _locale = Locale(code!);
    }

    notifyListeners();
  }

  Future<void> setLocale(
      String languageCode,
      ) async {
    if (![
      'ar',
      'fr',
      'en',
    ].contains(languageCode)) {
      return;
    }

    _locale =
        Locale(languageCode);

    notifyListeners();

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _languageKey,
      languageCode,
    );
  }

  Future<void> setArabic() =>
      setLocale('ar');

  Future<void> setFrench() =>
      setLocale('fr');

  Future<void> setEnglish() =>
      setLocale('en');
}

final localeController =
LocaleController();