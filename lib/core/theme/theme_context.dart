import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_palette.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  AppPalette get palette => Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
