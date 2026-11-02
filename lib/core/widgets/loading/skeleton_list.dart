import 'package:flutter/material.dart';
import 'package:x_ten/core/widgets/loading/shimmer_wrapper.dart';
import 'package:x_ten/core/widgets/loading/skeleton_shapes.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 6,
    this.itemBuilder,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
  });

  final int itemCount;
  final WidgetBuilder? itemBuilder;
  final double spacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => ShimmerWrapper(
        child: ListView.separated(
          padding: padding,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (context, index) => SizedBox(height: spacing),
          itemBuilder: (context, index) =>
              itemBuilder?.call(context) ?? const SkeletonListTile(),
        ),
      );
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          SkeletonCircle(size: 48),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 160),
                SizedBox(height: 8),
                SkeletonLine(),
              ],
            ),
          ),
        ],
      );
}
