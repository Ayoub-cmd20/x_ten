import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:x_ten/features/auth/presentation/pages/signup_screen.dart';
import 'package:x_ten/features/auth/presentation/pages/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF161616);
  static const Color _fieldColor = Color(0xFF1B1B1B);
  static const Color _borderColor = Color(0xFF303030);

  // ============================================================
  // FORM / CONTROLLERS / FOCUS
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }

    if (value.length < 6) {
      return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
    }

    return null;
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _login() async {
    // Close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();

      // ========================================================
      // TODO:
      // Replace this section with Firebase / API / Repository.
      //
      // Example:
      //
      // await authRepository.login(
      //   email: email,
      //   password: password,
      // );
      // ========================================================

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Temporary demonstration
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1B1B1B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: _gold.withValues(alpha: 0.30),
              ),
            ),
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: _gold,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تم التحقق من البيانات: $email',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      // After real authentication:
      //
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => const HomeScreen(),
      //   ),
      // );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFB3261E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: const Text(
              'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة مرة أخرى.',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsetsDirectional.fromSTEB(
                  24,
                  24,
                  24,
                  32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ========================================
                        // LOGO / BRAND
                        // ========================================

                        Center(
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  _gold,
                                  _gold.withValues(alpha: 0.70),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: _gold.withValues(alpha: 0.18),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'X',
                              style: TextStyle(
                                color: _background,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ========================================
                        // HEADER
                        // ========================================

                        const Text(
                          'مرحباً بك مجدداً',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'سجّل الدخول إلى حسابك للمتابعة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.white.withValues(alpha: 0.50),
                          ),
                        ),

                        const SizedBox(height: 38),

                        // ========================================
                        // EMAIL
                        // ========================================

                        _buildInputField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          label: 'البريد الإلكتروني',
                          hint: 'email@example.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: _validateEmail,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                          onSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                        ),

                        const SizedBox(height: 20),

                        // ========================================
                        // PASSWORD
                        // ========================================

                        _buildInputField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          label: 'كلمة المرور',
                          hint: 'أدخل كلمة المرور',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _isPasswordObscured,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                          suffixIcon: IconButton(
                            tooltip: _isPasswordObscured
                                ? 'إظهار كلمة المرور'
                                : 'إخفاء كلمة المرور',
                            splashRadius: 22,
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured =
                                !_isPasswordObscured;
                              });
                            },
                            icon: AnimatedSwitcher(
                              duration:
                              const Duration(milliseconds: 180),
                              child: Icon(
                                _isPasswordObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                key: ValueKey(_isPasswordObscured),
                                color: _isPasswordObscured
                                    ? Colors.white38
                                    : _gold,
                                size: 21,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            _login();
                          },
                        ),

                        const SizedBox(height: 12),

                        // ========================================
                        // FORGOT PASSWORD
                        // ========================================

                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: _gold,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                            ),
                            child: const Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========================================
                        // LOGIN BUTTON
                        // ========================================

                        _buildLoginButton(),

                        const SizedBox(height: 34),

                        // ========================================
                        // DIVIDER
                        // ========================================

                        _buildDivider(),

                        const SizedBox(height: 26),

                        // ========================================
                        // SOCIAL BUTTONS
                        // ========================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              tooltip: 'Apple',
                              iconWidget: const FaIcon(
                                FontAwesomeIcons.apple,
                                color: Colors.white,
                                size: 21,
                              ),
                              onTap: () {
                                // TODO: Apple login
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              tooltip: 'Google',
                              iconWidget: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                                size: 20,
                              ),
                              onTap: () {
                                // TODO: Google login
                              },
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              tooltip: 'Facebook',
                              iconWidget: const FaIcon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: 19,
                              ),
                              onTap: () {
                                // TODO: Facebook login
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 42),

                        // ========================================
                        // SIGN UP
                        // ========================================

                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              'ليس لديك حساب؟',
                              style: TextStyle(
                                color:
                                Colors.white.withValues(alpha: 0.45),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                    const SignupScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: _gold,
                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 4,
                                ),
                              ),
                              child: const Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  color: _gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
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
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required TextInputAction textInputAction,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<String>? autofillHints,
    Widget? suffixIcon,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 9),

        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          cursorColor: _gold,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.25),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),

            filled: true,
            fillColor: _fieldColor,

            prefixIcon: Icon(
              prefixIcon,
              color: Colors.white38,
              size: 21,
            ),

            suffixIcon: suffixIcon,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),

            errorStyle: const TextStyle(
              color: Color(0xFFFF6B6B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),

            errorMaxLines: 2,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: _borderColor,
                width: 1,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: _borderColor,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: _gold,
                width: 1.4,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFFF5F57),
                width: 1,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFFF6B6B),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGIN BUTTON
  // ============================================================

  Widget _buildLoginButton() {
    return SizedBox(
      height: 56,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: _isLoading
                  ? [
                _gold.withValues(alpha: 0.65),
                _gold.withValues(alpha: 0.52),
              ]
                  : [
                const Color(0xFFF0D16F),
                _gold,
              ],
            ),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: InkWell(
            onTap: _isLoading ? null : _login,
            borderRadius: BorderRadius.circular(17),
            splashColor: Colors.black.withValues(alpha: 0.12),
            highlightColor: Colors.black.withValues(alpha: 0.06),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isLoading
                  ? const Center(
                key: ValueKey('loading'),
                child: SizedBox(
                  width: 23,
                  height: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      _background,
                    ),
                  ),
                ),
              )
                  : const Center(
                key: ValueKey('text'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        color: _background,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 9),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: _background,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.08),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'أو المتابعة عبر',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withValues(alpha: 0.08),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SOCIAL BUTTON
  // ============================================================

  Widget _buildSocialButton({
    required String tooltip,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _isLoading
              ? null
              : () {
            HapticFeedback.selectionClick();
            onTap();
          },
          customBorder: const CircleBorder(),
          splashColor: _gold.withValues(alpha: 0.16),
          highlightColor: _gold.withValues(alpha: 0.06),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _surface,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.24),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: iconWidget,
            ),
          ),
        ),
      ),
    );
  }
}