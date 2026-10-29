import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

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
          Text(question, style: context.textTheme.bodyMedium?.copyWith(color: context.palette.textMuted)),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      );
}
