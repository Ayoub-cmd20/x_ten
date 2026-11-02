import 'package:flutter/material.dart';
import 'package:x_ten/core/theme/app_motion.dart';

class FastSwitcher extends StatelessWidget {
  const FastSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return AnimatedSwitcher(
      duration: AppMotion.fast,
      reverseDuration: AppMotion.press,
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset(rtl ? -0.05 : 0.05, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
