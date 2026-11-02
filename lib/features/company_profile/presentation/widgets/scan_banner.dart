import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class ScanBanner extends StatelessWidget {
  const ScanBanner({super.key, required this.title, required this.text, this.icon = Icons.document_scanner_outlined});

  final String title;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.palette.primary.withValues(alpha: 0.1),
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: context.palette.primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.palette.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(text, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      );
}
