import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHighest,
      highlightColor: scheme.surface,
      child: child,
    );
  }
}
