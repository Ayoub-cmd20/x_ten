import 'package:flutter/material.dart';

class FreelancerVerificationMeetingScreen extends StatelessWidget {
  final String registrationId;

  const FreelancerVerificationMeetingScreen({
    super.key,
    required this.registrationId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          title: const Text('توثيق حساب المستقل'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFFE5C158),
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'قد تتواصل معك إدارة X Ten هاتفياً أو عبر مكالمة فيديو للتحقق من الهوية والوثائق.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.7,
                ),
              ),
              const Spacer(),
              Text(
                'رقم الطلب: $registrationId',
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
