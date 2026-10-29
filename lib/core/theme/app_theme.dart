import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_motion.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/app_typography.dart';

abstract final class AppTheme {
  static final ThemeData dark = _build(AppPalette.dark);
  static final ThemeData light = _build(AppPalette.light);

  static ThemeData _build(AppPalette p) {
    final isDark = p.brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: p.brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.goldFill,
      onSecondary: p.onGoldFill,
      tertiary: p.info,
      onTertiary: p.onPrimary,
      error: p.error,
      onError: p.onError,
      errorContainer: p.errorContainer,
      onErrorContainer: p.onErrorContainer,
      surface: p.background,
      onSurface: p.textPrimary,
      onSurfaceVariant: p.textSecondary,
      surfaceContainerLowest: p.background,
      surfaceContainerLow: p.surfaceLow,
      surfaceContainer: p.surface,
      surfaceContainerHigh: p.surfaceHigh,
      surfaceContainerHighest: p.surfaceHighest,
      outline: p.borderStrong,
      outlineVariant: p.border,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: p.textPrimary,
      onInverseSurface: p.background,
      inversePrimary: isDark ? AppPalette.light.primary : AppPalette.dark.primary,
    );

    final text = AppTypography.textTheme(p);

    OutlineInputBorder outline(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: AppRadius.lgAll,
          borderSide: BorderSide(color: color, width: width),
        );

    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.lgAll);
    const buttonSize = Size.fromHeight(56);

    bool selected(Set<WidgetState> states) => states.contains(WidgetState.selected);

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      extensions: [p],
      splashFactory: NoSplash.splashFactory,
      highlightColor: p.primary.withValues(alpha: 0.06),
      hoverColor: p.primary.withValues(alpha: 0.04),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: p.brightness,
        primaryColor: p.primary,
        primaryContrastingColor: p.onPrimary,
        scaffoldBackgroundColor: p.background,
        barBackgroundColor: p.background.withValues(alpha: 0.85),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleMedium,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: text.bodyMedium?.copyWith(
          color: p.textDisabled,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: text.bodyMedium?.copyWith(color: p.textSecondary),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: p.primary),
        prefixIconColor: p.textMuted,
        suffixIconColor: p.textMuted,
        errorStyle: text.bodySmall?.copyWith(
          color: p.error,
          fontWeight: FontWeight.w500,
        ),
        errorMaxLines: 2,
        border: outline(p.border),
        enabledBorder: outline(p.border),
        disabledBorder: outline(p.border.withValues(alpha: 0.5)),
        focusedBorder: outline(p.primary, 1.4),
        errorBorder: outline(p.error),
        focusedErrorBorder: outline(p.error, 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          animationDuration: AppMotion.fast,
          backgroundColor: p.goldFill,
          foregroundColor: p.onGoldFill,
          disabledBackgroundColor: p.goldFill.withValues(alpha: 0.4),
          disabledForegroundColor: p.onGoldFill.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          textStyle: text.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          animationDuration: AppMotion.fast,
          backgroundColor: p.goldFill,
          foregroundColor: p.onGoldFill,
          disabledBackgroundColor: p.goldFill.withValues(alpha: 0.4),
          disabledForegroundColor: p.onGoldFill.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          animationDuration: AppMotion.fast,
          foregroundColor: p.primary,
          minimumSize: buttonSize,
          shape: buttonShape,
          side: BorderSide(color: p.primary),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          animationDuration: AppMotion.fast,
          foregroundColor: p.primary,
          textStyle: text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlAll,
          side: BorderSide(color: p.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.surfaceHighest,
        contentTextStyle: text.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xxlAll),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        modalBackgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.surfaceLow,
        selectedItemColor: p.primary,
        unselectedItemColor: p.textDisabled,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.primary,
        textColor: p.textPrimary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surfaceHigh,
        selectedColor: p.primaryContainer,
        side: BorderSide(color: p.border),
        labelStyle: text.labelMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? p.primary : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(p.onPrimary),
        side: BorderSide(color: p.borderStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? p.primary : p.borderStrong,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? p.onGoldFill : p.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? p.goldFill : p.surfaceHighest,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.primary,
        selectionColor: p.primary.withValues(alpha: 0.3),
        selectionHandleColor: p.primary,
      ),
    );
  }
}
