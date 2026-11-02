import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/storage/app_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(_initial(_prefs));

  static const supportedCodes = ['ar', 'en', 'fr'];
  static const fallback = Locale('ar');

  final AppPreferences _prefs;

  static Locale _initial(AppPreferences prefs) {
    final code = prefs.languageCode;
    return code != null && supportedCodes.contains(code) ? Locale(code) : fallback;
  }

  bool get hasSelectedLanguage => supportedCodes.contains(_prefs.languageCode);

  Locale get locale => state;

  Future<void> setLocale(String code) async {
    if (!supportedCodes.contains(code)) return;
    await _prefs.setLanguageCode(code);
    emit(Locale(code));
  }

  Future<void> setArabic() => setLocale('ar');

  Future<void> setEnglish() => setLocale('en');

  Future<void> setFrench() => setLocale('fr');
}
