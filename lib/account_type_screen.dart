import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import this if you want the login link to work
import 'profile_setup_screen.dart'; // Make sure this path is correct
class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header Text (RichText for mixed colors)
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo', // Assuming you are using an Arabic font
                      color: Colors.white,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(text: 'اختر مسارك في '),
                      TextSpan(
                        text: 'عالم\nالتأثير',
                        style: TextStyle(color: Color(0xFFE5C158)), // Gold color
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Subtitle
                Text(
                  'انضم إلى النخبة في أكبر تجمع لصناع المحتوى\nوالماركات العالمية. اختر نوع الحساب الذي\nيناسب طموحاتك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),

                // 3. Card 1: Content Creator
                // 3. Card 1: Content Creator
                AccountTypeCard(
                  icon: Icons.star,
                  title: 'صانع محتوى',
                  description:
                  'للمبدعين والمؤثرين الذين يسعون\nلتحويل شغفهم إلى علامة تجارية رائدة\nوالوصول لفرص تعاون حصرية.',
                  isHighlighted: false,
                  onSelect: () {
                    // Navigate to profile setup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 4. Card 2: Client / Brand (Highlighted)
                AccountTypeCard(
                  icon: Icons.business_center, // Briefcase icon
                  title: 'عميل / علامة تجارية',
                  description:
                  'للشركات والوكالات التي تبحث عن\nأفضل المواهب لإدارة حملات تسويقية\nاستثنائية وتحقيق نتائج ملموسة.',
                  isHighlighted: true, // This applies the gold theme and glow
                  onSelect: () {
                    // Action for selecting Client/Brand
                  },
                ),
                const SizedBox(height: 20),

                // 5. Card 3: Freelancer
                AccountTypeCard(
                  icon: Icons.handyman, // Tools icon
                  title: 'مستقل',
                  description:
                  'للمحترفين في مجالات المونتاج،\nالتصوير، وإدارة الحسابات الذين يرغبون\nفي تقديم خدماتهم للنخبة.',
                  isHighlighted: false,
                  onSelect: () {
                    // Action for selecting Freelancer
                  },
                ),
                const SizedBox(height: 40),

                // 6. Login Link Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'هل لديك حساب بالفعل؟',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Login Screen
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                        );
                      },
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Color(0xFFE5C158),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 7. Bottom Links (Privacy, Terms, Help)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBottomLink('سياسة الخصوصية'),
                    _buildBottomLink('الشروط والأحكام'),
                    _buildBottomLink('مركز المساعدة'),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for bottom text links
  Widget _buildBottomLink(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 11,
      ),
    );
  }
}

// --- Reusable Widget for the Account Type Cards ---

class AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isHighlighted;
  final VoidCallback onSelect;

  const AccountTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isHighlighted,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151515), // Very dark grey background for cards
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighlighted ? const Color(0xFFE5C158).withOpacity(0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon Container
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: isHighlighted ? const Color(0xFFE5C158) : const Color(0xFF252525),
              borderRadius: BorderRadius.circular(18),
              boxShadow: isHighlighted
                  ? [
                BoxShadow(
                  color: const Color(0xFFE5C158).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isHighlighted ? const Color(0xFF151515) : const Color(0xFFE5C158),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? const Color(0xFFE5C158) : Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          ElevatedButton(
            onPressed: onSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5C158), // Gold button
              foregroundColor: const Color(0xFF0A0A0A), // Dark text on button
              elevation: 0,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'اختيار الحساب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}