import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/invitation_type.dart';
import 'invite_success_screen.dart';

class InviteUserFormScreen extends StatefulWidget {
  final InvitationType invitationType;

  const InviteUserFormScreen({
    super.key,
    required this.invitationType,
  });

  @override
  State<InviteUserFormScreen> createState() =>
      _InviteUserFormScreenState();
}

class _InviteUserFormScreenState
    extends State<InviteUserFormScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF161616);

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _messageController = TextEditingController(
      text:
      'أود دعوتك للانضمام إلى منصة X Ten للاستفادة من فرص التعاون والتسويق.',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }

    final regex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!regex.hasMatch(email)) {
      return 'البريد الإلكتروني غير صحيح';
    }

    return null;
  }

  Future<void> _sendInvitation() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final valid =
        _formKey.currentState?.validate() ?? false;

    if (!valid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InviteSuccessScreen(
            name: _nameController.text.trim(),
            invitationType:
            widget.invitationType,
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
    final isInfluencer =
        widget.invitationType ==
            InvitationType.influencer;

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
          title: Text(
            isInfluencer
                ? 'دعوة مؤثر'
                : 'دعوة معلن',
            style: const TextStyle(
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
                    padding:
                    const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                      gold.withValues(alpha: 0.08),
                      borderRadius:
                      BorderRadius.circular(18),
                      border: Border.all(
                        color:
                        gold.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isInfluencer
                              ? Icons.person_add_alt_1
                              : Icons
                              .business_center_outlined,
                          color: gold,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'دعوة ${widget.invitationType.arabicName} للانضمام إلى X Ten',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _label('الاسم'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى إدخال الاسم';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _decoration(
                      'الاسم الكامل',
                      Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('البريد الإلكتروني'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    keyboardType:
                    TextInputType.emailAddress,
                    validator: _validateEmail,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _decoration(
                      'email@example.com',
                      Icons.email_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('رقم الهاتف'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType:
                    TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9+]'),
                      ),
                    ],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _decoration(
                      '0550 00 00 00',
                      Icons.phone_outlined,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('رسالة الدعوة'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _messageController,
                    minLines: 5,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length < 10) {
                        return 'يرجى كتابة رسالة دعوة';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.6,
                    ),
                    decoration: _decoration(
                      'اكتب رسالة الدعوة...',
                      Icons.message_outlined,
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : _sendInvitation,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 21,
                        height: 21,
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
                        _isLoading
                            ? 'جاري إرسال الدعوة...'
                            : 'إرسال الدعوة',
                      ),
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor:
                        Colors.black,
                        disabledBackgroundColor:
                        gold.withValues(
                          alpha: 0.5,
                        ),
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                        ),
                        textStyle:
                        const TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w800,
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

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
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
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide(
          color:
          Colors.white.withValues(alpha: 0.07),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: gold,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    );
  }
}