import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart'; // To navigate back to login
import 'otp_verification_screen.dart'; // Added the import for the OTP Screen

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A), // App dark background
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Title
                  const Text(
                    'انضم إلى مجتمع المؤثرين',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE5C158), // App gold color
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 2. Header Subtitle
                  Text(
                    'ابدأ رحلتك نحو التميز الرقمي مع أقوى منصة للمؤثرين في المنطقة.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 3. Full Name Field
                  _buildInputField(
                    label: 'الاسم الكامل',
                    hint: 'ادخل اسمك الكامل',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 20),

                  // 4. Email Field
                  _buildInputField(
                    label: 'البريد الإلكتروني',
                    hint: 'email@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // 5. Phone Field
                  _buildInputField(
                    label: 'رقم الهاتف',
                    hint: '05XXXXXXXX',
                    keyboardType: TextInputType.phone,
                    suffixIcon: Icon(Icons.phone_outlined, color: Colors.grey[600], size: 22),
                  ),
                  const SizedBox(height: 20),

                  // 6. Password Field
                  _buildInputField(
                    label: 'كلمة المرور',
                    hint: '........',
                    isPassword: true,
                    obscureText: _isPasswordObscured,
                    onToggleVisibility: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  const SizedBox(height: 30),

                  // 7. Signup Button
                  ElevatedButton(
                    onPressed: () {
                      // NAVIGATE TO OTP SCREEN
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OtpVerificationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5C158),
                      foregroundColor: const Color(0xFF0A0A0A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'إنشاء حساب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 8. Divider with text
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'أو الاشتراك عبر',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 9. Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        iconWidget: const FaIcon(FontAwesomeIcons.apple, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        iconWidget: const FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 20),
                      _buildSocialButton(
                        iconWidget: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 10. Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Navigate back to login screen
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            color: Color(0xFFE5C158),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper Method for Input Fields
  Widget _buildInputField({
    required String label,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[700]),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey[600],
              ),
              onPressed: onToggleVisibility,
            )
                : suffixIcon,
          ),
        ),
      ],
    );
  }

  // Helper method for circular social buttons
  Widget _buildSocialButton({required Widget iconWidget}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: iconWidget,
        ),
      ),
    );
  }
}