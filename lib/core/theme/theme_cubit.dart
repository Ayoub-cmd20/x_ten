import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/storage/app_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs) : super(_initial(_prefs));

  final AppPreferences _prefs;

  static ThemeMode _initial(AppPreferences prefs) =>
      ThemeMode.values.asNameMap()[prefs.themeMode] ?? ThemeMode.system;

  Future<void> setMode(ThemeMode mode) async {
    await _prefs.setThemeMode(mode.name);
    emit(mode);
  }

  Future<void> toggle(Brightness current) =>
      setMode(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
}
