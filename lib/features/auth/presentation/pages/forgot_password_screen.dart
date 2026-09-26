import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF161616);
  static const Color _border = Color(0xFF303030);
  static const Color _error = Color(0xFFFF6B6B);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final FocusNode _emailFocusNode;

  bool _isLoading = false;
  bool _isSent = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

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

  Future<void> _sendResetLink() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // =====================================================
      // TODO: Replace with real auth logic
      //
      // final email = _emailController.text.trim();
      //
      // Firebase example:
      //
      // await FirebaseAuth.instance
      //     .sendPasswordResetEmail(email: email);
      //
      // Supabase example:
      //
      // await Supabase.instance.client.auth.resetPasswordForEmail(
      //   email,
      // );
      //
      // REST API example:
      //
      // await authRepository.requestPasswordReset(email);
      // =====================================================

      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      setState(() {
        _isSent = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFB3261E),
            behavior: SnackBarBehavior.floating,
            content: const Text(
              'تعذر إرسال رابط إعادة تعيين كلمة المرور. حاول مرة أخرى.',
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,

        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,

          iconTheme: const IconThemeData(
            color: Colors.white,
          ),

          title: const Text(
            'استعادة كلمة المرور',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,

            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },

            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  32,
                ),

                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ),

                  child: AnimatedSwitcher(
                    duration:
                    const Duration(milliseconds: 300),

                    child: _isSent
                        ? _buildSuccessState()
                        : _buildFormState(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FORM STATE
  // =========================================================

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('forgot-form'),

        crossAxisAlignment:
        CrossAxisAlignment.stretch,

        children: [
          Center(
            child: Container(
              width: 76,
              height: 76,

              decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.10),

                borderRadius:
                BorderRadius.circular(22),

                border: Border.all(
                  color: _gold.withValues(alpha: 0.22),
                ),
              ),

              child: const Icon(
                Icons.lock_reset_rounded,
                color: _gold,
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 26),

          const Text(
            'نسيت كلمة المرور؟',
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'أدخل البريد الإلكتروني المرتبط بحسابك، '
                'وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50),
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 34),

          const Text(
            'البريد الإلكتروني',

            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 9),

          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,

            keyboardType:
            TextInputType.emailAddress,

            textInputAction:
            TextInputAction.done,

            autofillHints: const [
              AutofillHints.email,
            ],

            validator: _validateEmail,

            onFieldSubmitted: (_) {
              _sendResetLink();
            },

            cursorColor: _gold,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),

            decoration: InputDecoration(
              hintText: 'email@example.com',

              hintStyle: TextStyle(
                color:
                Colors.white.withValues(alpha: 0.25),
              ),

              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Colors.white38,
              ),

              filled: true,
              fillColor: _surface,

              errorStyle: const TextStyle(
                color: _error,
                fontSize: 12,
              ),

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color: _border,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color: _border,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color: _gold,
                  width: 1.4,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color: _error,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(16),

                borderSide:
                const BorderSide(
                  color: _error,
                  width: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 26),

          SizedBox(
            height: 56,

            child: ElevatedButton(
              onPressed:
              _isLoading ? null : _sendResetLink,

              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.black,

                disabledBackgroundColor:
                _gold.withValues(alpha: 0.45),

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(17),
                ),
              ),

              child: AnimatedSwitcher(
                duration:
                const Duration(milliseconds: 200),

                child: _isLoading
                    ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 23,
                  height: 23,

                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2.4,

                    valueColor:
                    AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                )
                    : const Row(
                  key: ValueKey('send'),

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.send_outlined,
                      size: 20,
                    ),

                    SizedBox(width: 9),

                    Text(
                      'إرسال رابط الاستعادة',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          Center(
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
              ),

              label: const Text(
                'العودة إلى تسجيل الدخول',
              ),

              style: TextButton.styleFrom(
                foregroundColor: _gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUCCESS STATE
  // =========================================================

  Widget _buildSuccessState() {
    final email = _emailController.text.trim();

    return Column(
      key: const ValueKey('success'),

      crossAxisAlignment:
      CrossAxisAlignment.stretch,

      children: [
        const SizedBox(height: 30),

        Center(
          child: Container(
            width: 96,
            height: 96,

            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.10),

              shape: BoxShape.circle,

              border: Border.all(
                color: _gold.withValues(alpha: 0.30),
                width: 2,
              ),
            ),

            child: const Icon(
              Icons.mark_email_read_outlined,
              color: _gold,
              size: 45,
            ),
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          'تحقق من بريدك الإلكتروني',

          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'إذا كان هناك حساب مرتبط بالبريد الإلكتروني التالي، '
              'فستصلك تعليمات إعادة تعيين كلمة المرور:',

          textAlign: TextAlign.center,

          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.50),
            height: 1.6,
          ),
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: _surface,

            borderRadius:
            BorderRadius.circular(14),

            border: Border.all(
              color: _gold.withValues(alpha: 0.15),
            ),
          ),

          child: Text(
            email,

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          height: 54,

          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),

            child: const Text(
              'العودة لتسجيل الدخول',

              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        TextButton(
          onPressed:
          _isLoading ? null : _sendResetLink,

          child: const Text(
            'إعادة إرسال الرابط',

            style: TextStyle(
              color: _gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}