import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_typography.dart';

abstract final class AppTheme {
  static final ThemeData dark = _buildDark();

  static ThemeData _buildDark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.gold,
      onPrimary: AppColors.background,
      primaryContainer: AppColors.goldContainer,
      onPrimaryContainer: AppColors.goldLight,
      secondary: AppColors.goldDark,
      onSecondary: AppColors.background,
      tertiary: AppColors.info,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: AppColors.background,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.error,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surfaceLow,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHighest,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.border,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Colors.white,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.goldDark,
    );

    final text = AppTypography.textTheme();

    OutlineInputBorder outline(Color color, [double width = 1]) => OutlineInputBorder(
          borderRadius: AppRadius.lgAll,
          borderSide: BorderSide(color: color, width: width),
        );

    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.lgAll);
    const buttonSize = Size.fromHeight(56);

    bool selected(Set<WidgetState> states) => states.contains(WidgetState.selected);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: text.bodyMedium?.copyWith(
          color: AppColors.textDisabled,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: AppColors.gold),
        prefixIconColor: AppColors.textDisabled,
        suffixIconColor: AppColors.textDisabled,
        errorStyle: text.bodySmall?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        errorMaxLines: 2,
        border: outline(AppColors.border),
        enabledBorder: outline(AppColors.border),
        disabledBorder: outline(AppColors.border.withValues(alpha: 0.5)),
        focusedBorder: outline(AppColors.gold, 1.4),
        errorBorder: outline(AppColors.error),
        focusedErrorBorder: outline(AppColors.error, 1.4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.gold.withValues(alpha: 0.4),
          disabledForegroundColor: AppColors.background.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          textStyle: text.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.gold.withValues(alpha: 0.4),
          disabledForegroundColor: AppColors.background.withValues(alpha: 0.7),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          minimumSize: buttonSize,
          shape: buttonShape,
          side: const BorderSide(color: AppColors.gold),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlAll,
          side: BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHighest,
        contentTextStyle: text.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xxlAll),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        modalBackgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.borderStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLow,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.textDisabled,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.gold,
        textColor: AppColors.textPrimary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceHigh,
        selectedColor: AppColors.goldContainer,
        side: const BorderSide(color: AppColors.border),
        labelStyle: text.labelMedium,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? AppColors.gold : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(AppColors.background),
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? AppColors.gold : AppColors.borderStrong,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? AppColors.background : AppColors.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => selected(states) ? AppColors.gold : AppColors.surfaceHighest,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.gold),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.gold,
        selectionColor: AppColors.gold.withValues(alpha: 0.3),
        selectionHandleColor: AppColors.gold,
      ),
    );
  }
}
