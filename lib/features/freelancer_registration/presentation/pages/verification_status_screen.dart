import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/freelancer_verification_status.dart';

class FreelancerVerificationStatusScreen extends StatefulWidget {
  final String registrationId;

  const FreelancerVerificationStatusScreen({
    super.key,
    required this.registrationId,
  });

  @override
  State<FreelancerVerificationStatusScreen> createState() =>
      _FreelancerVerificationStatusScreenState();
}

class _FreelancerVerificationStatusScreenState
    extends State<FreelancerVerificationStatusScreen> {
  FreelancerVerificationStatus status =
      FreelancerVerificationStatus.submitted;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),

        appBar: AppBar(
          title: const Text(
            'حالة الحساب',
          ),
        ),

        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(
              'رقم الطلب: ${widget.registrationId}',
              style: const TextStyle(
                color: Color(0xFFE5C158),
              ),
            ),

            const ListTile(
              title: Text(
                'تم إرسال الطلب',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const ListTile(
              title: Text(
                'قيد المراجعة',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const ListTile(
              title: Text(
                'توثيق الهوية / اتصال عند الحاجة',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const ListTile(
              title: Text(
                'قبول الحساب',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            if (status ==
                FreelancerVerificationStatus.meetingRequired ||
                status ==
                    FreelancerVerificationStatus.meetingScheduled)
              ElevatedButton(
                onPressed: () {
                  context.push(
                    '/freelancer-verification/meeting',
                    extra: widget.registrationId,
                  );
                },
                child: const Text(
                  'عرض التوثيق',
                ),
              ),

            const SizedBox(
              height: 20,
            ),

            // =====================================================
            // FINAL LOGIC TO USE LATER
            // =====================================================
            //
            // if (status ==
            //     FreelancerVerificationStatus.verified)
            //   ElevatedButton(
            //     onPressed: () {
            //       context.go(
            //         '/freelancer/home',
            //       );
            //     },
            //     child: const Text(
            //       'الدخول إلى Freelancer Dashboard',
            //     ),
            //   ),
            //
            // =====================================================

            // =====================================================
            // TEMPORARY BUTTON FOR DEVELOPMENT / TESTING
            // =====================================================

            ElevatedButton(
              onPressed: () {
                context.go(
                  '/freelancer/home',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFFE5C158),
                foregroundColor:
                Colors.black,
                minimumSize:
                const Size.fromHeight(54),
              ),
              child: const Text(
                'الدخول إلى Freelancer Dashboard',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}