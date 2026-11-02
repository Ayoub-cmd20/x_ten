import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key, required this.page, required this.loop});

  final double page;
  final Animation<double> loop;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dark = palette.brightness == Brightness.dark;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: loop,
        builder: (context, _) {
          final wave = math.sin(loop.value * 2 * math.pi);
          return Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: palette.background),
              Align(
                alignment: Alignment(-0.9 + page * 0.7, -0.75 + wave * 0.06),
                child: _Glow(color: palette.primary.withValues(alpha: dark ? 0.24 : 0.18), size: 460),
              ),
              Align(
                alignment: Alignment(0.95 - page * 0.6, 0.7 - wave * 0.06),
                child: _Glow(color: palette.accent.withValues(alpha: dark ? 0.12 : 0.08), size: 380),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
          ),
        ),
      );
}
