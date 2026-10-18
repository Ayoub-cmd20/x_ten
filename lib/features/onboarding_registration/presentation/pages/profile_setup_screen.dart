import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/onboarding/language_registration_screen.dart'; // Adjust path if necessary

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  // 0 = شخصية طبيعية (Natural Person), 1 = شخصية معنوية (Legal Entity)
  int _selectedEntityType = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color(0xFFE5C158)), // Back arrow in RTL
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'المعلومات الشخصية\nوالبروفايل',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Picture Upload Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5C158), width: 1.5),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined, // Placeholder icon
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                        Positioned(
                          bottom: -8,
                          right: -8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE5C158),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'قم بتحميل صورة احترافية تظهر ملامحك بوضوح',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. Basic Identity Section Header
              _buildSectionHeader('الهوية الأساسية'),
              const SizedBox(height: 20),

              // Basic Identity Fields
              _buildInputField(
                label: 'الاسم واللقب',
                hint: 'أدخل اسمك بالكامل',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'اسم الشهرة',
                hint: '@handle',
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'تاريخ الميلاد',
                hint: 'mm/dd/yyyy',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'مكان الميلاد',
                hint: 'المدينة، الدولة',
              ),
              const SizedBox(height: 24),

              // Legal Entity Selection
              Text(
                'نوع الكيان القانوني',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEntitySelectionCard(
                      index: 0,
                      title: 'شخصية\nطبيعية',
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEntitySelectionCard(
                      index: 1,
                      title: 'شخصية\nمعنوية',
                      icon: Icons.domain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 3. Contact Information Section Header
              _buildSectionHeader('معلومات التواصل'),
              const SizedBox(height: 20),

              // Contact Information Fields
              _buildInputField(
                label: 'رقم الهاتف الأساسي',
                hint: '+966',
                keyboardType: TextInputType.phone,
                suffixIcon: Icons.phone_iphone,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'رقم هاتف بديل',
                hint: '+966',
                keyboardType: TextInputType.phone,
                suffixIcon: Icons.phone_in_talk_outlined,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'واتساب',
                hint: '+966',
                keyboardType: TextInputType.phone,
                suffixIcon: Icons.chat_bubble_outline,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'البريد الإلكتروني',
                hint: 'example@obsidian.com',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 40),

              // 4. Next Button (Aligned to the left in RTL)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageRegistrationScreen()),
                    );// Navigate to the next step
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5C158),
                    foregroundColor: const Color(0xFF0A0A0A),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'التالي',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_back, size: 20), // Left arrow for "Next" in RTL
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for Section Headers (Gold bar + Text)
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFE5C158),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper widget for Input Fields
  Widget _buildInputField({
    required String label,
    required String hint,
    TextInputType? keyboardType,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: const Color(0xFF151515), // Very dark grey, almost black
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            // In RTL, suffixIcon appears on the left side (matching the image)
            suffixIcon: suffixIcon != null
                ? Icon(
              suffixIcon,
              color: Colors.grey[500],
              size: 20,
            )
                : null,
          ),
        ),
      ],
    );
  }

  // Helper widget for Legal Entity Selection Cards
  Widget _buildEntitySelectionCard({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedEntityType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEntityType = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5C158) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),

    );
  }
}