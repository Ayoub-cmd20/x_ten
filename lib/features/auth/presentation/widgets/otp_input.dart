import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:x_ten/core/constants/app_constants.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.onCompleted,
    this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = PinTheme(
      width: 48,
      height: 56,
      textStyle: context.textTheme.titleLarge?.copyWith(color: colors.primary),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: colors.outlineVariant),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: AppConstants.otpLength,
        controller: controller,
        enabled: enabled,
        autofocus: true,
        defaultPinTheme: base,
        focusedPinTheme: base.copyDecorationWith(border: Border.all(color: colors.primary, width: 1.5)),
        errorPinTheme: base.copyDecorationWith(border: Border.all(color: colors.error)),
        forceErrorState: errorText != null,
        errorText: errorText,
        errorTextStyle: context.textTheme.bodySmall?.copyWith(color: colors.error),
        onCompleted: onCompleted,
        onChanged: onChanged,
      ),
    );
  }
}
