import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_colors.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brightness,
    required this.background,
    required this.surfaceLow,
    required this.surface,
    required this.surfaceHigh,
    required this.surfaceHighest,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.goldFill,
    required this.onGoldFill,
    required this.goldGradient,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.success,
    required this.warning,
    required this.info,
    required this.accent,
  });

  static const dark = AppPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0B0A08),
    surfaceLow: Color(0xFF12100C),
    surface: Color(0xFF17140F),
    surfaceHigh: Color(0xFF1E1A14),
    surfaceHighest: Color(0xFF29241B),
    border: Color(0xFF2E281E),
    borderStrong: Color(0xFF433A2B),
    textPrimary: Color(0xFFF6F1E7),
    textSecondary: Color(0xFFC9C1B1),
    textMuted: Color(0xFF9C9383),
    textDisabled: Color(0xFF6B6355),
    primary: AppColors.metallicGold,
    onPrimary: AppColors.goldInk,
    primaryContainer: Color(0xFF2A2210),
    onPrimaryContainer: Color(0xFFF1D98A),
    goldFill: AppColors.metallicGold,
    onGoldFill: AppColors.goldInk,
    goldGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [AppColors.champagneGold, AppColors.metallicGold, AppColors.deepGold],
    ),
    error: Color(0xFFFF6B6B),
    onError: Color(0xFF1A0505),
    errorContainer: Color(0xFF3A1A18),
    onErrorContainer: Color(0xFFFFB4AB),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFF5B042),
    info: Color(0xFF6EA8FF),
    accent: Color(0xFFB98AFF),
  );

  static const light = AppPalette(
    brightness: Brightness.light,
    background: Color(0xFFFBF8F1),
    surfaceLow: Color(0xFFF7F2E7),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFF3EDE0),
    surfaceHighest: Color(0xFFEAE2D0),
    border: Color(0xFFE7DDC8),
    borderStrong: Color(0xFFCDBF9F),
    textPrimary: Color(0xFF1B1812),
    textSecondary: Color(0xFF574F42),
    textMuted: Color(0xFF7E7462),
    textDisabled: Color(0xFFADA28D),
    primary: AppColors.antiqueGold,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFF6EBCB),
    onPrimaryContainer: Color(0xFF5A4410),
    goldFill: AppColors.richGold,
    onGoldFill: AppColors.goldInk,
    goldGradient: LinearGradient(
      begin: AlignmentDirectional.topStart,
      end: AlignmentDirectional.bottomEnd,
      colors: [Color(0xFFE8CB72), AppColors.richGold, AppColors.antiqueGold],
    ),
    error: Color(0xFFC62828),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFCE8E6),
    onErrorContainer: Color(0xFF8C1D18),
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    info: Color(0xFF2563EB),
    accent: Color(0xFF7C3AED),
  );

  final Brightness brightness;
  final Color background;
  final Color surfaceLow;
  final Color surface;
  final Color surfaceHigh;
  final Color surfaceHighest;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color goldFill;
  final Color onGoldFill;
  final LinearGradient goldGradient;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color success;
  final Color warning;
  final Color info;
  final Color accent;

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(covariant AppPalette? other, double t) {
    if (other == null) {
      return this;
    }
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: mix(background, other.background),
      surfaceLow: mix(surfaceLow, other.surfaceLow),
      surface: mix(surface, other.surface),
      surfaceHigh: mix(surfaceHigh, other.surfaceHigh),
      surfaceHighest: mix(surfaceHighest, other.surfaceHighest),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textMuted: mix(textMuted, other.textMuted),
      textDisabled: mix(textDisabled, other.textDisabled),
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      primaryContainer: mix(primaryContainer, other.primaryContainer),
      onPrimaryContainer: mix(onPrimaryContainer, other.onPrimaryContainer),
      goldFill: mix(goldFill, other.goldFill),
      onGoldFill: mix(onGoldFill, other.onGoldFill),
      goldGradient: LinearGradient.lerp(goldGradient, other.goldGradient, t)!,
      error: mix(error, other.error),
      onError: mix(onError, other.onError),
      errorContainer: mix(errorContainer, other.errorContainer),
      onErrorContainer: mix(onErrorContainer, other.onErrorContainer),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      info: mix(info, other.info),
      accent: mix(accent, other.accent),
    );
  }
}
