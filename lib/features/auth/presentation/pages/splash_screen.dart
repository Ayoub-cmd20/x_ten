import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Navigate to Login Screen after 3 seconds using GoRouter
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A), // Dark background
      body: Center(
        // This centers the entire logo on the screen
        child: MonolithLogo(),
      ),
    );
  }
}

// --- The Reusable Logo Component ---

class MonolithLogo extends StatelessWidget {
  const MonolithLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 1. The Glowing Rotated Container
        Stack(
          alignment: Alignment.center,
          children: [
            // Background Glow Effect
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE4BC4F).withValues(alpha: 0.08),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),

            // The Dark Diamond Background
            Transform.rotate(
              angle: 45 * math.pi / 180, // Rotate 45 degrees
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), // Smooth rounded corners
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A2A2A), // Lighter grey top edge
                      Color(0xFF141414), // Deep dark grey body
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                // 2. The Gold Diamond Icon (Counter-rotated)
                child: Transform.rotate(
                  angle: -45 * math.pi / 180, // Counter-rotate to keep icon upright
                  child: Center(
                    child: CustomPaint(
                      size: const Size(55, 45), // Specific proportions for the icon
                      painter: ExactDiamondPainter(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 50), // Spacing between icon and text

        // 3. Arabic Text
        const Text(
          'منصة المؤثرين',
          style: TextStyle(
            color: Color(0xFFE4BC4F), // Gold color
            fontSize: 36,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo', // Adjust to your Arabic font
          ),
        ),

        const SizedBox(height: 8),

        // 4. English Text
        const Text(
          'THE MONOLITH',
          style: TextStyle(
            color: Color(0xFF666666), // Muted grey
            fontSize: 13,
            letterSpacing: 8.0, // Wide spacing to match the image
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// --- The Custom Painter for the exact Diamond Shape ---

class ExactDiamondPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Draw the solid gold silhouette
    final paintFill = Paint()
      ..color = const Color(0xFFE4BC4F)
      ..style = PaintingStyle.fill;

    final path = Path();
    // Top flat edge
    path.moveTo(w * 0.25, 0);
    path.lineTo(w * 0.75, 0);
    // Right angled edge
    path.lineTo(w, h * 0.35);
    // Bottom point
    path.lineTo(w * 0.5, h);
    // Left angled edge
    path.lineTo(0, h * 0.35);
    path.close();

    canvas.drawPath(path, paintFill);

    // 2. Draw the cut-out lines (using the background dark color)
    final paintLines = Paint()
      ..color = const Color(0xFF181818) // Matches the container background closely
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5; // Thickness of the cuts

    // Horizontal cut across the middle
    canvas.drawLine(Offset(0, h * 0.35), Offset(w, h * 0.35), paintLines);

    // Top vertical cuts
    canvas.drawLine(Offset(w * 0.4, 0), Offset(w * 0.35, h * 0.35), paintLines);
    canvas.drawLine(Offset(w * 0.6, 0), Offset(w * 0.65, h * 0.35), paintLines);

    // Bottom angled cuts connecting to the bottom point
    canvas.drawLine(Offset(w * 0.25, h * 0.35), Offset(w * 0.5, h), paintLines);
    canvas.drawLine(Offset(w * 0.75, h * 0.35), Offset(w * 0.5, h), paintLines);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
