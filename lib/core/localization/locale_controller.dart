import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  Locale _locale = const Locale('ar');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode =
    prefs.getString(_languageKey);

    if (languageCode == null) {
      return;
    }

    if (languageCode == 'ar' ||
        languageCode == 'fr' ||
        languageCode == 'en') {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(
      String languageCode,
      ) async {
    if (![
      'ar',
      'fr',
      'en',
    ].contains(languageCode)) {
      return;
    }

    if (_locale.languageCode ==
        languageCode) {
      return;
    }

    _locale = Locale(languageCode);

    notifyListeners();

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      _languageKey,
      languageCode,
    );
  }

  Future<void> setArabic() =>
      changeLanguage('ar');

  Future<void> setFrench() =>
      changeLanguage('fr');

  Future<void> setEnglish() =>
      changeLanguage('en');
}

final localeController =
LocaleController();