import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/account_type_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late Timer _timer;
  int _start = 54; // Starting time as seen in your image
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 54;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _canResend = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Always cancel timers to prevent memory leaks
    super.dispose();
  }

  // Format the seconds into MM:SS
  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Define the style for the OTP input boxes
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color(0xFFE5C158), // Gold text for entered numbers
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark grey background for boxes
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center everything horizontally
                children: [
                  // 1. Lock Icon Container
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_person_outlined, // Matches the keyhole/person lock icon
                      color: Color(0xFFE5C158),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 2. Title
                  const Text(
                    'تحقق من رقمك',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE5C158),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 3. Subtitle
                  Text(
                    'لقد أرسلنا رمز التحقق المكون من 6 أرقام\nإلى رقم هاتفك المسجل.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 4. OTP Input Fields (Using pinput)
                  Directionality(
                    textDirection: TextDirection.ltr, // Keep numbers LTR even in RTL layout
                    child: Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: const Color(0xFFE5C158), width: 1.5),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme,
                      showCursor: true,
                      onCompleted: (pin) {
                        // Automatically triggered when 6 digits are entered
                        debugPrint("Entered OTP: $pin");
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 5. Timer Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[500], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'إعادة الإرسال خلال $timerText',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 6. Resend Button
                  TextButton(
                    onPressed: _canResend ? startTimer : null,
                    style: TextButton.styleFrom(
                      foregroundColor: _canResend ? const Color(0xFFE5C158) : Colors.grey[700],
                    ),
                    child: const Text(
                      'إعادة إرسال الرمز',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 7. Verify Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement OTP verification with your backend
                     // ScaffoldMessenger.of(context).showSnackBar(
                       // const SnackBar(content: Text('جاري التحقق...')),
                      //);
                        // Navigate to Account Type Selection after successful OTP
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AccountTypeScreen()),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5C158),
                      foregroundColor: const Color(0xFF0A0A0A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 55), // Full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تحقق الآن',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.verified_outlined, size: 22),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 8. Support Footer
                  Text(
                    'تواجه مشكلة؟ يرجى التواصل مع الدعم الفني\nالخاص بمنصة المؤثرين.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}