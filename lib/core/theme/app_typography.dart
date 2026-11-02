import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_palette.dart';

abstract final class AppTypography {
  static const fontFamily = 'Cairo';

  static TextTheme textTheme(AppPalette palette) {
    const base = TextTheme(
      displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.25),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.3),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, height: 1.3),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.35),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.4),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.4),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.6),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.6),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
    );

    final themed = base.apply(
      fontFamily: fontFamily,
      bodyColor: palette.textPrimary,
      displayColor: palette.textPrimary,
    );

    return themed.copyWith(
      bodySmall: themed.bodySmall?.copyWith(color: palette.textMuted),
    );
  }
}
