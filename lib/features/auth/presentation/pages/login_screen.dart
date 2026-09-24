import 'package:flutter/material.dart';
import 'package:x_ten/features/auth/presentation/pages/signup_screen.dart'; // Import your login screen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A), // Matched to your splash screen background
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Welcome Header
                  const Text(
                    'مرحبا بك مجددا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE5C158), // Matched to your splash screen gold
                    ),
                  ),
                  const SizedBox(height: 50),

                  // 2. Email Field
                  _buildInputField(
                    label: 'البريد الإلكتروني',
                    hint: 'email@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // 3. Password Field
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

                  // 4. Login Button
                  ElevatedButton(
                    onPressed: () {
                      // Add login logic here
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
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 5. Divider with text
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

                  // 6. Social Login Button
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
                  const SizedBox(height: 50),

                  // 7. Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لدي حساب',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          'إنشاء حساب',
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

  // Helper method for input fields
  Widget _buildInputField({
    required String label,
    required String hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
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
            fillColor: const Color(0xFF1E1E1E), // Slightly lighter than background for contrast
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
                : null,
          ),
        ),
      ],
    );
  }

  // Helper method for circular social buttons
  // Helper method for circular social buttons
  Widget _buildSocialButton({required Widget iconWidget}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // Match input field color
          shape: BoxShape.circle,
        ),
        child: Center(
          child: iconWidget,
        ),
      ),
    );
  }
}