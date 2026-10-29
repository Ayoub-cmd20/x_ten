import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/onboarding_pill.dart';

class DiscoverIllustration extends StatelessWidget {
  const DiscoverIllustration({super.key, required this.loop, required this.focus});

  final Animation<double> loop;
  final double focus;

  static const _niches = [
    Icons.photo_camera_rounded,
    Icons.mic_rounded,
    Icons.videocam_rounded,
    Icons.brush_rounded,
    Icons.music_note_rounded,
    Icons.sports_esports_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final label = context.l10n.onboardingVerified;
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
                final pulse = 1 + 0.04 * math.sin(t * 4 * math.pi);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (final ring in const [0.62, 0.92])
                      Center(
                        child: Container(
                          width: s * ring * (0.7 + 0.3 * focus),
                          height: s * ring * (0.7 + 0.3 * focus),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: palette.border),
                          ),
                        ),
                      ),
                    Center(
                      child: Transform.scale(
                        scale: pulse * (0.7 + 0.3 * focus),
                        child: Container(
                          width: s * 0.3,
                          height: s * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: palette.goldGradient,
                            boxShadow: [
                              BoxShadow(color: palette.primary.withValues(alpha: 0.45), blurRadius: s * 0.14),
                            ],
                          ),
                          child: Icon(Icons.person_search_rounded, color: palette.onGoldFill, size: s * 0.13),
                        ),
                      ),
                    ),
                    for (var i = 0; i < _niches.length; i++) _orbiting(i, t, s, palette),
                    Align(
                      alignment: const AlignmentDirectional(0.85, -0.95),
                      child: Transform.translate(
                        offset: Offset(0, math.sin(t * 2 * math.pi) * 6),
                        child: Opacity(
                          opacity: focus,
                          child: OnboardingPill(icon: Icons.verified_rounded, label: label),
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

  Widget _orbiting(int i, double t, double s, AppPalette palette) {
    final outer = i.isEven;
    final direction = outer ? 1.0 : -1.0;
    final angle = (i / _niches.length) * 2 * math.pi + t * 2 * math.pi * direction * 0.5;
    final radius = s * (outer ? 0.46 : 0.31) * (0.7 + 0.3 * focus);
    return Center(
      child: Transform.translate(
        offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
        child: _NicheAvatar(icon: _niches[i], size: s * 0.15, verified: i % 3 == 0, palette: palette),
      ),
    );
  }
}

class _NicheAvatar extends StatelessWidget {
  const _NicheAvatar({required this.icon, required this.size, required this.verified, required this.palette});

  final IconData icon;
  final double size;
  final bool verified;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.surface,
              border: Border.all(color: palette.primary.withValues(alpha: 0.35)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 14, offset: const Offset(0, 6)),
              ],
            ),
            child: Icon(icon, color: palette.primary, size: size * 0.45),
          ),
          if (verified)
            PositionedDirectional(
              end: -2,
              bottom: -2,
              child: Container(
                width: size * 0.38,
                height: size * 0.38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.goldFill,
                  border: Border.all(color: palette.background, width: 2),
                ),
                child: Icon(Icons.check_rounded, size: size * 0.24, color: palette.onGoldFill),
              ),
            ),
        ],
      );
}
