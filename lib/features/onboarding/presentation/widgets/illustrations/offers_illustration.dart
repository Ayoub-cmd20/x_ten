import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/onboarding_pill.dart';

class OffersIllustration extends StatelessWidget {
  const OffersIllustration({super.key, required this.loop, required this.focus});

  final Animation<double> loop;
  final double focus;

  static const _icons = [Icons.campaign_rounded, Icons.storefront_rounded, Icons.shopping_bag_rounded];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = context.l10n.onboardingNewRequest;
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = math.min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: SizedBox.square(
            dimension: s,
            child: AnimatedBuilder(
              animation: loop,
              builder: (context, _) {
                final t = loop.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var depth = 2; depth >= 0; depth--) _card(depth, t, s, palette),
                    Align(
                      alignment: const Alignment(0, -0.88),
                      child: Transform.translate(
                        offset: Offset(0, (1 - focus) * -40),
                        child: Transform.scale(
                          scale: 1 + 0.05 * math.sin(t * 4 * math.pi),
                          child: Opacity(
                            opacity: focus,
                            child: OnboardingPill(icon: Icons.notifications_active_rounded, label: label, filled: true),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _card(int depth, double t, double s, AppPalette palette) {
    final bob = math.sin((t + depth * 0.18) * 2 * math.pi) * 5;
    final enter = (1 - focus) * (70 + depth * 40);
    return Align(
      alignment: const Alignment(0, 0.25),
      child: Transform.translate(
        offset: Offset(0, -depth * s * 0.085 + bob + enter),
        child: Transform.scale(
          scale: 1 - depth * 0.07,
          child: Opacity(
            opacity: (1 - depth * 0.28) * (0.4 + 0.6 * focus),
            child: _RequestCard(width: s * 0.82, icon: _icons[depth], highlighted: depth == 0, palette: palette),
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.width, required this.icon, required this.highlighted, required this.palette});

  final double width;
  final IconData icon;
  final bool highlighted;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: AppRadius.xlAll,
          border: Border.all(color: highlighted ? palette.primary.withValues(alpha: 0.5) : palette.border),
          boxShadow: [
            BoxShadow(
              color: highlighted ? palette.primary.withValues(alpha: 0.18) : Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: palette.primaryContainer),
              child: Icon(icon, color: palette.primary, size: 22),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Bar(widthFactor: 0.75, height: 10, color: palette.textPrimary.withValues(alpha: 0.8)),
                  const SizedBox(height: AppSpacing.xs),
                  _Bar(widthFactor: 0.5, height: 8, color: palette.textMuted.withValues(alpha: 0.5)),
                ],
              ),
            ),
            if (highlighted) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: palette.goldGradient),
                child: Icon(Icons.check_rounded, size: 18, color: palette.onGoldFill),
              ),
            ],
          ],
        ),
      );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor, required this.height, required this.color});

  final double widthFactor;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor,
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: AppRadius.pillAll),
        ),
      );
}
