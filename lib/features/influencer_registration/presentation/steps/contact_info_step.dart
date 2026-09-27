import 'package:flutter/material.dart';

import '../../domain/models/influencer_registration_draft.dart';

class ContactInfoStep extends StatelessWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const ContactInfoStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  static const Color gold = Color(0xFFE5C158);

  InputDecoration _decoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: gold),
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: gold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'معلومات الاتصال',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'سيستخدم فريق X Ten هذه المعلومات للتواصل معك بشأن التوثيق وطلبات الإشهار.',
          style: TextStyle(
            color: Colors.white54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 22),

        TextFormField(
          initialValue: draft.email,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            draft.email = value;
            onChanged();
          },
          decoration: _decoration(
            'البريد الإلكتروني',
            Icons.email_outlined,
          ),
        ),

        const SizedBox(height: 14),

        TextFormField(
          initialValue: draft.phone,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            draft.phone = value;
            onChanged();
          },
          decoration: _decoration(
            'رقم الهاتف',
            Icons.phone_outlined,
          ),
        ),

        const SizedBox(height: 14),

        TextFormField(
          initialValue: draft.whatsapp,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            draft.whatsapp = value;
            onChanged();
          },
          decoration: _decoration(
            'رقم WhatsApp',
            Icons.chat_outlined,
          ),
        ),
      ],
    );
  }
}