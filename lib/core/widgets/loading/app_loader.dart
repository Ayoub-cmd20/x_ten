import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 28, this.strokeWidth = 3, this.color})
      : centered = true;

  const AppLoader.small({super.key, this.color})
      : size = 18,
        strokeWidth = 2,
        centered = false;

  final double size;
  final double strokeWidth;
  final Color? color;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );
    return centered ? Center(child: indicator) : indicator;
  }
}
