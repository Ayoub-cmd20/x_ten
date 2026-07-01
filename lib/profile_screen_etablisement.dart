import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile UI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141414), // Dark background matching the image
        fontFamily: 'Cairo', // Recommended Arabic font (ensure it's in pubspec.yaml or it will fallback gracefully)
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Color constants based on the design
  static const Color primaryYellow = Color(0xFFF4C754);
  static const Color fieldBackground = Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    // Enforcing RTL directionality for Arabic UI
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildProfilePictureUploader(),
                const SizedBox(height: 32),

                // --- Section 1: Basic Identity ---
                _buildSectionTitle('الهوية الأساسية'),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'الإسم واللقب',
                  hint: 'ادخل اسمك بالكامل',
                ),
                _buildInputField(
                  label: 'إسم علامة تجاري',
                  hint: '@handle',
                ),
                _buildInputField(
                  label: 'تاريخ الميلاد',
                  hint: 'mm/dd/yyyy',
                ),
                _buildInputField(
                  label: 'مكان الميلاد',
                  hint: 'المدينة، الدولة',
                ),
                const SizedBox(height: 24),

                // --- Section 2: Contact Information ---
                _buildSectionTitle('معلومات التواصل'),
                const SizedBox(height: 16),
                _buildInputField(
                  label: 'رقم الهاتف الأساسي',
                  hint: '+966',
                  prefixIcon: Icons.phone_android,
                  isHintOnLeft: true,
                ),
                _buildInputField(
                  label: 'رقم هاتف بديل',
                  hint: '+966',
                  prefixIcon: Icons.phone,
                  isHintOnLeft: true,
                ),
                _buildInputField(
                  label: 'واتساب',
                  hint: '+966',
                  prefixIcon: Icons.chat_bubble_outline,
                  isHintOnLeft: true,
                ),
                _buildInputField(
                  label: 'البريد الإلكتروني',
                  hint: 'example@obsidian.com',
                  prefixIcon: Icons.email_outlined,
                  isHintOnLeft: true,
                ),
                const SizedBox(height: 32),

                // --- Next Button ---
                Align(
                  alignment: Alignment.centerLeft, // Aligned to the bottom left as per RTL convention
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryYellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Handle navigation or form submission
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: 20), // Pointing left for "Next" in RTL
                          SizedBox(width: 8),
                          Text(
                            'التالي',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the top header with title and back button
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'المعلومات الشخصية\nوالبروفايل',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: primaryYellow), // Back arrow in RTL points right
          onPressed: () {},
        ),
      ],
    );
  }

  /// Builds the profile image upload widget
  Widget _buildProfilePictureUploader() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C32),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryYellow, width: 1.5),
                ),
                child: const Center(
                  child: Icon(Icons.add_a_photo, color: primaryYellow, size: 40),
                ),
              ),
              Positioned(
                bottom: -6,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'قم بتحميل صورة احترافية تظهر ملامحك بوضوح',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Builds the section headers with the yellow vertical line
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          color: primaryYellow,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Reusable widget to build labeled input fields consistently
  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? prefixIcon,
    bool isHintOnLeft = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: fieldBackground,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              // Handles placing the icon on the right (prefix in RTL)
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.white54, size: 20)
                  : null,
              // Handles placing standard text like "+966" on the far left (suffix in RTL)
              suffixText: isHintOnLeft ? hint : null,
              suffixStyle: const TextStyle(color: Colors.white38),
              // Normal hint text placement
              hintText: !isHintOnLeft ? hint : null,
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}