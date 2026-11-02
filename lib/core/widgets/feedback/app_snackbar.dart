import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_colors.dart';

void showErrorSnackBar(BuildContext context, String message) =>
    _show(context, message, AppColors.errorStrong);

void showSuccessSnackBar(BuildContext context, String message) =>
    _show(context, message, const Color(0xFF1F6B3A));

void _show(BuildContext context, String message, Color background) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: background,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
}
