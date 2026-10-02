import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'package:x_ten/core/localization/locale_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(
      'assets/videos/splash.mp4',
    );

    try {
      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isVideoInitialized = true;
      });

      _controller.play();

      _controller.addListener(_videoListener);
    } catch (e) {
      _scheduleFallbackNavigation();
    }
  }

  void _videoListener() {
    if (_hasNavigated || !_controller.value.isInitialized) return;

    if (_controller.value.position >= _controller.value.duration) {
      _navigateNext();
    }
  }

  void _scheduleFallbackNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    if (localeController.hasSelectedLanguage) {
      context.go('/choose-language');
    }
  }

  @override
  void dispose() {
    if (_isVideoInitialized) {
      _controller.removeListener(_videoListener);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isVideoInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
