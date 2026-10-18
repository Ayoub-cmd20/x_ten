export 'package:x_ten/core/widgets/form_helpers.dart';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:x_ten/core/constants/app_constants.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/countdown_text.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.withAppBar = true, this.bottom});

  final Widget child;
  final bool withAppBar;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final bottom = this.bottom;
    return Scaffold(
      appBar: withAppBar ? AppBar() : null,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screen,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(
              child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: bottom),
            ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, this.subtitle, this.icon});

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final subtitle = this.subtitle;
    final text = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: icon == null
              ? Image.asset('assets/images/logo.png', height: 72)
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: context.colors.primary, size: 36),
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(title, textAlign: TextAlign.center, style: text.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: text.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.autofillHints = const [AutofillHints.password],
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? errorText;
  final Iterable<String> autofillHints;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        obscureText: _obscure,
        enableSuggestions: false,
        autocorrect: false,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        forceErrorText: widget.errorText,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onFieldSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            tooltip: _obscure ? context.l10n.showPassword : context.l10n.hidePassword,
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
          ),
        ),
      );
}

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

class ResendCodeButton extends StatelessWidget {
  const ResendCodeButton({
    super.key,
    required this.round,
    required this.seconds,
    required this.onResend,
    this.enabled = true,
  });

  final int round;
  final int seconds;
  final VoidCallback onResend;
  final bool enabled;

  static String _format(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => CountdownText(
        key: ValueKey(round),
        seconds: seconds,
        builder: (context, remaining) => remaining > 0
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Text(
                  context.l10n.resendCodeIn(ltr(_format(remaining))),
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              )
            : TextButton(
                onPressed: enabled ? onResend : null,
                child: Text(context.l10n.resendCode),
              ),
      );
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({super.key, required this.question, required this.action, required this.onTap});

  final String question;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xxs,
        children: [
          Text(question, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted)),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      );
}
