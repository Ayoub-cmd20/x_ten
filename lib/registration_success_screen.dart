import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; // Adjust the file path if necessary

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  // Theme Colors
  final Color _bgDark = const Color(0xFF101010);
  final Color _cardDark = const Color(0xFF1A1A1A);
  final Color _gold = const Color(0xFFE2C044);
  final Color _textGrey = const Color(0xFFA0A0A0);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgDark,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                // 1. Success Icon Badge
                _buildSuccessBadge(),
                const SizedBox(height: 24),

                // 2. Title & Subtitle
                const Text(
                  'لقد تم تسجيل طلبك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'لقد تم تسجيل طلبك، سيتم مراجعة ملفك من\nقبل فريقنا المختص خلال 48 ساعة القادمة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Next Steps Card (with Timeline)
                _buildNextStepsCard(),

                const Spacer(flex: 2),

                // 4. Action Button
                // 4. Action Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Dashboard and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                          (route) => false, // This clears the history
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _gold,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'الرئيسية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Footer Text
                Text(
                  'سيصلك رابط الموعد عبر البريد الإلكتروني أو الرسائل النصية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  // Top Success Badge (Square with checkmark and small badge)
  Widget _buildSuccessBadge() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[900]!, width: 1),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _gold,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.black,
                size: 24,
                weight: 700,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -6,
          right: -6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _cardDark,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: Icon(
              Icons.verified_outlined,
              color: _gold,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Next Steps Card container
  Widget _buildNextStepsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(12),
        // The gold line is explicitly on the left side of the card in the design
        border: Border(
          left: BorderSide(color: _gold, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'الخطوات القادمة: موعد\nمكالمة الفيديو',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),
              Icon(Icons.calendar_today_outlined, color: _gold, size: 24),
            ],
          ),
          const SizedBox(height: 32),

          // Timeline Steps
          _buildTimelineStep(
            title: 'الهوية الوطنية الأصلية',
            subtitle: 'يرجى تجهيز أصل الهوية للمطابقة أثناء\nالمكالمة.',
            isLast: false,
          ),
          _buildTimelineStep(
            title: 'إثبات المعلومات البنكية',
            subtitle: 'وثيقة رسمية توضح رقم الحساب والآيبان\nالخاص بك.',
            isLast: false,
          ),
          _buildTimelineStep(
            title: 'إثبات الوصول للمنصات',
            subtitle: 'القدرة على تسجيل الدخول المباشر\nلحساباتك الموثقة.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  // Individual Timeline Step Item
  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Indicator Column
        Column(
          children: [
            // Dot
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _bgDark,
                shape: BoxShape.circle,
                border: Border.all(color: _gold, width: 1.5),
              ),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Connecting Line (Don't render if it's the last item)
            if (!isLast)
              Container(
                width: 1,
                height: 50, // Fixed height to provide spacing between items
                color: Colors.grey[800],
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Text Content Column
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0), // Spacing after text block
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}