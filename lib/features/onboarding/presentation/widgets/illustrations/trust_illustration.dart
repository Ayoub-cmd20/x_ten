import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class TrustIllustration extends StatelessWidget {
  const TrustIllustration({super.key, required this.loop, required this.focus});

  final Animation<double> loop;
  final double focus;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = context.l10n;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return LayoutBuilder(
      builder: (context, constraints) {
        final s = math.min(constraints.maxWidth, constraints.maxHeight);
        Offset at(double x, double y) => Offset((rtl ? 1 - x : x) * s, y * s);
        final start = at(0.15, 0.62);
        final mid = at(0.5, 0.42);
        final end = at(0.85, 0.62);
        final node = s * 0.2;
        final core = s * 0.3;
        return Center(
          child: SizedBox.square(
            dimension: s,
            child: AnimatedBuilder(
              animation: loop,
              builder: (context, _) {
                final t = loop.value;
                final wave = (t * 2) % 1;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _LinkPainter(
                          start: start,
                          mid: mid,
                          end: end,
                          lift: s * 0.16,
                          progress: t,
                          reveal: focus,
                          line: palette.borderStrong,
                          glow: palette.primary,
                        ),
                      ),
                    ),
                    _place(start, node, _Node(icon: Icons.storefront_rounded, label: l10n.onboardingBrand, size: node, palette: palette)),
                    _place(end, node, _Node(icon: Icons.auto_awesome_rounded, label: l10n.onboardingCreator, size: node, palette: palette)),
                    Positioned(
                      left: mid.dx - core / 2,
                      top: mid.dy - core / 2,
                      child: SizedBox.square(
                        dimension: core,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: 1 + wave * 0.7,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: palette.primary.withValues(alpha: (1 - wave) * 0.6), width: 2),
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.7 + 0.3 * focus,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: palette.goldGradient,
                                  boxShadow: [
                                    BoxShadow(color: palette.primary.withValues(alpha: 0.45), blurRadius: s * 0.12),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(Icons.verified_user_rounded, color: palette.onGoldFill, size: core * 0.45),
                                ),
                              ),
                            ),
                          ],
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

  Widget _place(Offset center, double size, Widget child) => Positioned(
        left: center.dx - size * 0.9,
        top: center.dy - size / 2,
        width: size * 1.8,
        child: Transform.translate(
          offset: Offset(0, (1 - focus) * 30),
          child: Opacity(opacity: (0.3 + 0.7 * focus).clamp(0.0, 1.0).toDouble(), child: child),
        ),
      );
}

class _Node extends StatelessWidget {
  const _Node({required this.icon, required this.label, required this.size, required this.palette});

  final IconData icon;
  final String label;
  final double size;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.surface,
              border: Border.all(color: palette.primary.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: Icon(icon, color: palette.primary, size: size * 0.45),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(color: palette.textSecondary),
          ),
        ],
      );
}

class _LinkPainter extends CustomPainter {
  _LinkPainter({
    required this.start,
    required this.mid,
    required this.end,
    required this.lift,
    required this.progress,
    required this.reveal,
    required this.line,
    required this.glow,
  });

  final Offset start;
  final Offset mid;
  final Offset end;
  final double lift;
  final double progress;
  final double reveal;
  final Color line;
  final Color glow;

  @override
  void paint(Canvas canvas, Size size) {
    final c1 = Offset((start.dx + mid.dx) / 2, math.min(start.dy, mid.dy) - lift * 0.4);
    final c2 = Offset((mid.dx + end.dx) / 2, math.min(mid.dy, end.dy) - lift * 0.4);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(c1.dx, c1.dy, mid.dx, mid.dy)
      ..quadraticBezierTo(c2.dx, c2.dy, end.dx, end.dy);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return;
    }
    final metric = metrics.first;
    final length = metric.length;
    final visible = length * reveal.clamp(0.0, 1.0).toDouble();

    canvas.drawPath(
      metric.extractPath(0, visible),
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    for (final phase in const [0.0, 0.5]) {
      final position = ((progress * 1.5 + phase) % 1) * visible;
      canvas.drawPath(
        metric.extractPath(math.max(0.0, position - 46), position),
        Paint()
          ..color = glow
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      final tangent = metric.getTangentForOffset(position);
      if (tangent == null) {
        continue;
      }
      canvas
        ..drawCircle(
          tangent.position,
          9,
          Paint()
            ..color = glow.withValues(alpha: 0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
        )
        ..drawCircle(tangent.position, 4.5, Paint()..color = glow);
    }
  }

  @override
  bool shouldRepaint(covariant _LinkPainter old) =>
      old.progress != progress || old.reveal != reveal || old.line != line || old.glow != glow || old.start != start;
}
