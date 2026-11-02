import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.index,
    required this.delta,
    required this.title,
    required this.body,
    required this.illustration,
  });

  final int index;
  final double delta;
  final String title;
  final String body;
  final Widget illustration;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.textTheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final distance = delta.abs().clamp(0.0, 1.0).toDouble();
    final shift = delta * (rtl ? -1 : 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          Expanded(
            child: Transform.translate(
              offset: Offset(shift * 110, 0),
              child: Opacity(
                opacity: (1 - distance * 0.85).clamp(0.0, 1.0).toDouble(),
                child: Transform.scale(
                  scale: 1 - distance * 0.18,
                  child: RepaintBoundary(child: illustration),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Transform.translate(
            offset: Offset(shift * 50, distance * 28),
            child: Opacity(
              opacity: (1 - distance * 1.6).clamp(0.0, 1.0).toDouble(),
              child: Column(
                children: [
                  Text(
                    '0${index + 1}',
                    style: text.labelLarge?.copyWith(color: palette.primary, letterSpacing: 4),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: text.headlineSmall?.copyWith(height: 1.35),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: text.bodyLarge?.copyWith(color: palette.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
