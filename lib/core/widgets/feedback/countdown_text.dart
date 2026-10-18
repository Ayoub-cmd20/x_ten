import 'dart:async';

import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  const CountdownText({
    super.key,
    required this.seconds,
    required this.builder,
    this.onFinished,
  });

  final int seconds;
  final Widget Function(BuildContext context, int remaining) builder;
  final VoidCallback? onFinished;

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(CountdownText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) _start();
  }

  void _start() {
    _timer?.cancel();
    _remaining = widget.seconds;
    if (_remaining <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
        widget.onFinished?.call();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _remaining);
}
