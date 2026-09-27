import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration_draft.dart';

class ContactInfoStep extends StatelessWidget {
  final FreelancerRegistrationDraft draft;
  final VoidCallback onChanged;

  const ContactInfoStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  InputDecoration _decoration(
      String label,
      ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFF161616),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: draft.email,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            draft.email = value;
          },
          decoration: _decoration(
            'البريد الإلكتروني',
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue: draft.phone,
          keyboardType: TextInputType.phone,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            draft.phone = value;
          },
          decoration: _decoration(
            'رقم الهاتف',
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        TextFormField(
          initialValue: draft.whatsapp,
          keyboardType: TextInputType.phone,
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (value) {
            draft.whatsapp = value;
          },
          decoration: _decoration(
            'WhatsApp',
          ),
        ),
      ],
    );
  }
}