import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';

class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.page});

  final int count;
  final double page;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8 + 22 * _focus(i),
            height: 8,
            decoration: BoxDecoration(
              borderRadius: AppRadius.pillAll,
              color: Color.lerp(palette.borderStrong, palette.primary, _focus(i)),
            ),
          ),
      ],
    );
  }

  double _focus(int index) => (1 - (page - index).abs()).clamp(0.0, 1.0).toDouble();
}
