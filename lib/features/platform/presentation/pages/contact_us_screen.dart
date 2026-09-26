import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() =>
      _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF161616);

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _subjectController =
  TextEditingController();

  final TextEditingController _messageController =
  TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // TODO: Send to backend/support API.
      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF1B1B1B),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'تم إرسال رسالتك بنجاح',
              textDirection: TextDirection.rtl,
            ),
          ),
        );

      _subjectController.clear();
      _messageController.clear();
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'اتصل بنا',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.08),
                      borderRadius:
                      BorderRadius.circular(18),
                      border: Border.all(
                        color:
                        gold.withValues(alpha: 0.18),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'كيف يمكننا مساعدتك؟',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'أرسل لنا استفسارك أو ملاحظتك وسيقوم فريق X10 بالرد عليك.',
                          style: TextStyle(
                            color: Colors.white54,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'الموضوع',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _subjectController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى كتابة موضوع الرسالة';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: gold,
                    decoration: _decoration(
                      'موضوع الرسالة',
                      Icons.subject_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'الرسالة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _messageController,
                    minLines: 7,
                    maxLines: 12,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length < 10) {
                        return 'يرجى كتابة رسالة واضحة';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.6,
                    ),
                    cursorColor: gold,
                    decoration: _decoration(
                      'اكتب رسالتك هنا...',
                      Icons.message_outlined,
                    ),
                  ),

                  const SizedBox(height: 26),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed:
                      _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Icon(
                        Icons.send_rounded,
                      ),
                      label: Text(
                        _isSending
                            ? 'جاري الإرسال...'
                            : 'إرسال الرسالة',
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor:
                        gold.withValues(alpha: 0.45),
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        textStyle:
                        const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(
      String hint,
      IconData icon,
      ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white30,
      ),
      prefixIcon: Icon(
        icon,
        color: gold,
        size: 20,
      ),
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: gold,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }
}