import 'package:flutter/material.dart';

class JoinEliteScreen extends StatelessWidget {
  const JoinEliteScreen({super.key});

  // Define Theme Colors based on the UI design
  static const Color primaryGold = Color(0xFFDCAE4F);
  static const Color scaffoldBackground = Color(0xFF101010);
  static const Color cardColor = Color(0xFF1A1A1A);
  static const Color iconBackgroundColor = Color(0xFF242424);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Enforce RTL for Arabic UI
      child: Scaffold(
        backgroundColor: scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Top Shield Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryGold.withOpacity(0.3), width: 1),
                  ),
                  child: const Icon(
                    Icons.local_police_outlined, // Shield icon
                    color: primaryGold,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),

                // Main Header Texts
                const Text(
                  'انضم إلى النخبة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'اختر نوع الحساب لبدء رحلتك في عالم الفخامة\nوالتميز الرقمي.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // Option Card 1: Company / Establishment
                _buildOptionCard(
                  icon: Icons.domain,
                  title: 'تسجيل شركة / مؤسسة',
                  description: 'للمنشآت الكبرى والعلامات التجارية الراسخة التي\nتسعى للريادة.',
                  buttonText: 'بدء التسجيل للمؤسسات',
                  isPrimary: true, // Uses the filled gold button
                  onTap: () {
                    // TODO: Navigate to Establishment Registration
                  },
                ),
                const SizedBox(height: 20),

                // Option Card 2: Store / Project
                _buildOptionCard(
                  icon: Icons.storefront,
                  title: 'تسجيل متجر / مشروع',
                  description: 'للمشاريع الطموحة والمتاجر المتخصصة التي تبحث\nعن منصة استثنائية.',
                  buttonText: 'بدء التسجيل للمتاجر',
                  isPrimary: false, // Uses the outlined button
                  onTap: () {
                    // TODO: Navigate to Store Registration
                  },
                ),
                const SizedBox(height: 48),

                // Footer Section (Prestige & Back Button)
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget to build the selectable cards
  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 1),
      ),
      child: Column(
        children: [
          // Icon Box inside the card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGold, size: 32),
          ),
          const SizedBox(height: 20),

          // Card Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Card Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white54,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic Button (Filled or Outlined)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: isPrimary
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGold,
                foregroundColor: Colors.black, // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              onPressed: onTap,
              child: Text(
                buttonText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            )
                : OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryGold,
                side: const BorderSide(color: primaryGold, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: onTap,
              child: Text(
                buttonText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for the footer UI elements
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        // Faint gradient divider line
        Container(
          width: 200,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                primaryGold.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // English Text Footer
        const Text(
          'PRESTIGE & EXCELLENCE',
          style: TextStyle(
            color: primaryGold,
            letterSpacing: 2.5,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 32),

        // Return Back Button
        GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back, color: Colors.white54, size: 18),
              SizedBox(width: 8),
              Text(
                'العودة الرئيسية',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}