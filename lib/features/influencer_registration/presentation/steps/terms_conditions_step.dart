import 'package:flutter/material.dart';

import '../../domain/models/influencer_registration_draft.dart';

class TermsConditionsStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const TermsConditionsStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<TermsConditionsStep> createState() =>
      _TermsConditionsStepState();
}

class _TermsConditionsStepState extends State<TermsConditionsStep> {
  static const Color gold = Color(0xFFE5C158);

  Widget _checkbox({
    required bool value,
    required String title,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(15),
      ),
      child: CheckboxListTile(
        value: value,
        activeColor: gold,
        checkColor: Colors.black,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (newValue) {
          onChanged(newValue ?? false);
          widget.onChanged();
          setState(() {});
        },
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'الشروط والموافقة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'اقرأ البنود التالية جيداً قبل إرسال طلب التسجيل.',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),

        const SizedBox(height: 18),

        _checkbox(
          value: widget.draft.confirmInformation,
          title:
          'أؤكد أن جميع المعلومات والبيانات المقدمة صحيحة.',
          onChanged: (value) {
            widget.draft.confirmInformation = value;
          },
        ),

        _checkbox(
          value: widget.draft.acceptTerms,
          title: 'أوافق على شروط استخدام منصة X Ten.',
          onChanged: (value) {
            widget.draft.acceptTerms = value;
          },
        ),

        _checkbox(
          value: widget.draft.acceptPrivacy,
          title: 'أوافق على سياسة الخصوصية ومعالجة البيانات.',
          onChanged: (value) {
            widget.draft.acceptPrivacy = value;
          },
        ),

        _checkbox(
          value: widget.draft.acceptVerification,
          title:
          'أوافق على التحقق من حساباتي الاجتماعية والوثائق المقدمة.',
          onChanged: (value) {
            widget.draft.acceptVerification = value;
          },
        ),

        _checkbox(
          value: widget.draft.acceptContact,
          title:
          'أوافق على تواصل فريق X Ten معي هاتفياً أو برسالة أو عبر مكالمة فيديو لإتمام التوثيق.',
          onChanged: (value) {
            widget.draft.acceptContact = value;
          },
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: gold.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'بعد إرسال الطلب سيتم مراجعته، ثم يمكن برمجة مكالمة فيديو مع إدارة المنصة للتحقق من الهوية والوثائق.',
            style: TextStyle(
              color: Colors.white54,
              height: 1.6,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}