import 'package:flutter/material.dart';

abstract final class AppColors {
  static const gold = Color(0xFFE5C158);
  static const goldLight = Color(0xFFF0D16F);
  static const goldDark = Color(0xFFD4A843);
  static const goldContainer = Color(0xFF292314);

  static const background = Color(0xFF0A0A0A);
  static const surfaceLow = Color(0xFF121212);
  static const surface = Color(0xFF151515);
  static const surfaceHigh = Color(0xFF1B1B1B);
  static const surfaceHighest = Color(0xFF252525);

  static const border = Color(0xFF2A2A2A);
  static const borderStrong = Color(0xFF3A3A3A);

  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xB3FFFFFF);
  static const textMuted = Color(0x8AFFFFFF);
  static const textDisabled = Color(0x61FFFFFF);

  static const error = Color(0xFFFF6B6B);
  static const errorStrong = Color(0xFFE24444);
  static const errorContainer = Color(0xFF3D1C1C);
  static const success = Color(0xFF4ADE80);
  static const warning = Color(0xFFF59E0B);
  static const info = Color(0xFF5C8DFF);
  static const accentPurple = Color(0xFFB477FF);

  static const goldGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [goldLight, gold],
  );
}
