import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/theme/app_motion.dart';

bool get usesCupertinoNavigation =>
    defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;

Page<void> appPage(GoRouterState state, Widget child) {
  if (usesCupertinoNavigation) {
    return CupertinoPage<void>(key: state.pageKey, name: state.name, child: child);
  }
  return CustomTransitionPage<void>(
    key: state.pageKey,
    name: state.name,
    child: child,
    transitionDuration: AppMotion.page,
    reverseTransitionDuration: AppMotion.pageReverse,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final rtl = Directionality.of(context) == TextDirection.rtl;
      final enter = CurvedAnimation(parent: animation, curve: AppMotion.enter, reverseCurve: AppMotion.exit);
      final leave = CurvedAnimation(parent: secondaryAnimation, curve: AppMotion.enter);
      return SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: Offset(rtl ? 0.08 : -0.08, 0)).animate(leave),
        child: FadeTransition(
          opacity: enter,
          child: SlideTransition(
            position: Tween<Offset>(begin: Offset(rtl ? -0.12 : 0.12, 0), end: Offset.zero).animate(enter),
            child: child,
          ),
        ),
      );
    },
  );
}
