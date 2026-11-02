import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class OnboardingPill extends StatelessWidget {
  const OnboardingPill({super.key, required this.icon, required this.label, this.filled = false});

  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = filled ? palette.onGoldFill : palette.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        borderRadius: AppRadius.pillAll,
        gradient: filled ? palette.goldGradient : null,
        color: filled ? null : palette.surface,
        border: filled ? null : Border.all(color: palette.primary.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: palette.primary.withValues(alpha: filled ? 0.35 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: AppSpacing.xxs),
          Text(label, style: context.textTheme.labelMedium?.copyWith(color: foreground, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
