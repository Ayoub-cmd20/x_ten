import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_ten/core/theme/app_motion.dart';

class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.enabled = true, this.scale = 0.96, this.haptic = true});

  final Widget child;
  final bool enabled;
  final double scale;
  final bool haptic;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (!widget.enabled || _pressed == value) {
      return;
    }
    if (value && widget.haptic) {
      HapticFeedback.lightImpact();
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) => Listener(
        onPointerDown: (_) => _set(true),
        onPointerUp: (_) => _set(false),
        onPointerCancel: (_) => _set(false),
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1,
          duration: _pressed ? AppMotion.press : AppMotion.release,
          curve: _pressed ? Curves.easeOut : AppMotion.spring,
          child: widget.child,
        ),
      );
}
