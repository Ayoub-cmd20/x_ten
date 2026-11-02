import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

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
            style: text.bodyMedium?.copyWith(color: context.palette.textMuted),
          ),
        ],
      ],
    );
  }
}
