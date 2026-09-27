import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FreelancerRegistrationSubmittedScreen extends StatelessWidget {
  final String registrationId;

  const FreelancerRegistrationSubmittedScreen({
    super.key,
    required this.registrationId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFFE5C158),
                  size: 80,
                ),
                const SizedBox(height: 18),
                const Text(
                  'تم استلام طلب تسجيلك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'رقم الطلب: $registrationId',
                  style: const TextStyle(
                    color: Color(0xFFE5C158),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(
                    '/freelancer-verification',
                    extra: registrationId,
                  ),
                  child: const Text('متابعة حالة طلبي'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
