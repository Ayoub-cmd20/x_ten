import 'package:flutter/material.dart';

import '../../domain/models/freelancer_registration_draft.dart';

class TermsConditionsStep extends StatefulWidget {
  final FreelancerRegistrationDraft draft;
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

class _TermsConditionsStepState
    extends State<TermsConditionsStep> {
  Widget _buildCheckbox(
      bool value,
      String title,
      ValueChanged<bool> onValueChanged,
      ) {
    return CheckboxListTile(
      value: value,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onChanged: (newValue) {
        onValueChanged(
          newValue ?? false,
        );

        setState(() {});

        widget.onChanged();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCheckbox(
          widget.draft.confirmInformation,
          'أؤكد أن جميع المعلومات صحيحة.',
              (value) {
            widget.draft.confirmInformation =
                value;
          },
        ),

        _buildCheckbox(
          widget.draft.acceptTerms,
          'أوافق على شروط استخدام X Ten.',
              (value) {
            widget.draft.acceptTerms =
                value;
          },
        ),

        _buildCheckbox(
          widget.draft.acceptPrivacy,
          'أوافق على سياسة الخصوصية.',
              (value) {
            widget.draft.acceptPrivacy =
                value;
          },
        ),

        _buildCheckbox(
          widget.draft.acceptVerification,
          'أوافق على التحقق من هويتي ووثائقي.',
              (value) {
            widget.draft.acceptVerification =
                value;
          },
        ),

        _buildCheckbox(
          widget.draft.acceptContact,
          'أوافق على التواصل معي عند الحاجة.',
              (value) {
            widget.draft.acceptContact =
                value;
          },
        ),
      ],
    );
  }
}