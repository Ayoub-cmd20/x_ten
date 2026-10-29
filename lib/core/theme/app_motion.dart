import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const press = Duration(milliseconds: 90);
  static const release = Duration(milliseconds: 160);
  static const fast = Duration(milliseconds: 180);
  static const page = Duration(milliseconds: 260);
  static const pageReverse = Duration(milliseconds: 220);
  static const theme = Duration(milliseconds: 250);

  static const enter = Curves.easeOutCubic;
  static const exit = Curves.easeInCubic;
  static const spring = Curves.easeOutBack;
}
