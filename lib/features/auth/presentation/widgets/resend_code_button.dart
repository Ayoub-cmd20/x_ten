import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/countdown_text.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';

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
