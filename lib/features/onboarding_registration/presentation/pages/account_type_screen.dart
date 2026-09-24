import 'package:flutter/material.dart';
import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/profile_setup_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/company/company_registration_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/freelancer/freelancer_registration_screen.dart';

enum AccountType { contentCreator, brand, freelancer }

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  AccountType? _selectedType;

  void _handleContinue() {
    if (_selectedType == null) return;

    switch (_selectedType!) {
      case AccountType.contentCreator:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileSetupScreen(),
          ),
        );
        break;
      case AccountType.brand:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CompanyRegistrationScreen(),
          ),
        );
        break;
      case AccountType.freelancer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FreelancerRegistrationScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // 1. Header Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(text: 'ما الذي يجلبك إلى '),
                            TextSpan(
                              text: 'X Ten',
                              style: TextStyle(color: Color(0xFFE5C158)),
                            ),
                            TextSpan(text: '؟'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 2. Subtitle
                      Text(
                        'اختر المسار المهني الذي يمثل غايتك للبدء في تخصيص تجربتك.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 3. Interactive Cards List
                      AccountTypeCard(
                        icon: Icons.auto_awesome,
                        title: 'صانع محتوى',
                        description: 'نمِّ أعمالك وتواصل مع كبرى العلامات التجارية.',
                        isSelected: _selectedType == AccountType.contentCreator,
                        onTap: () {
                          setState(() {
                            _selectedType = AccountType.contentCreator;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      AccountTypeCard(
                        icon: Icons.business_center,
                        title: 'علامة تجارية / عميل',
                        description: 'اكتشف صُنّاع المحتوى وأطلق حملاتك التسويقية.',
                        isSelected: _selectedType == AccountType.brand,
                        onTap: () {
                          setState(() {
                            _selectedType = AccountType.brand;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      AccountTypeCard(
                        icon: Icons.work_outline,
                        title: 'مستقل',
                        description: 'قدّم خدماتك الإبداعية للعلامات التجارية وصُنّاع المحتوى.',
                        isSelected: _selectedType == AccountType.freelancer,
                        onTap: () {
                          setState(() {
                            _selectedType = AccountType.freelancer;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // 4. Login Link Footer
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
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
                      const SizedBox(height: 20),

                      // 5. Bottom Policy Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildBottomLink('سياسة الخصوصية'),
                          _buildBottomLink('الشروط والأحكام'),
                          _buildBottomLink('مركز المساعدة'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 6. Sticky Interactive Primary Action Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _selectedType != null ? _handleContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5C158),
                      disabledBackgroundColor: const Color(0xFF222222),
                      foregroundColor: const Color(0xFF0A0A0A),
                      disabledForegroundColor: Colors.grey[600],
                      elevation: _selectedType != null ? 6 : 0,
                      shadowColor: const Color(0xFFE5C158).withValues(alpha:0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'متابعة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedType != null ? const Color(0xFF0A0A0A) : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_back, // Points left in RTL
                          size: 18,
                          color: _selectedType != null ? const Color(0xFF0A0A0A) : Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomLink(String text) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

// --- Interactive Card Component ---

class AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFE5C158);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1C1A14) : const Color(0xFF121212),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? goldColor : const Color(0xFF262626),
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: goldColor.withValues(alpha:0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: goldColor.withValues(alpha:0.08),
          highlightColor: goldColor.withValues(alpha:0.04),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row (Icon + Title + Animated Radio Indicator)
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? goldColor.withValues(alpha:0.15) : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? goldColor : Colors.grey[400],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? goldColor : Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    // Interactive Radio Indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? goldColor : Colors.grey[700]!,
                          width: 2,
                        ),
                        color: isSelected ? goldColor : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Color(0xFF0A0A0A),
                      )
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description Text
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.grey[300] : Colors.grey[400],
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}