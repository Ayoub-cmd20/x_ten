import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/freelancer_registration_demo_repository.dart';
import '../../data/freelancer_registration_repository.dart';
import '../../domain/models/freelancer_registration_draft.dart';
import '../steps/contact_info_step.dart';
import '../steps/documents_step.dart';
import '../steps/financial_info_step.dart';
import '../steps/opportunity_preferences_step.dart';
import '../steps/personal_info_step.dart';
import '../steps/portfolio_step.dart';
import '../steps/professional_info_step.dart';
import '../steps/registration_review_step.dart';
import '../steps/services_step.dart';
import '../steps/skills_step.dart';
import '../steps/terms_conditions_step.dart';

class FreelancerRegistrationScreen extends StatefulWidget {
  const FreelancerRegistrationScreen({super.key});

  @override
  State<FreelancerRegistrationScreen> createState() =>
      _FreelancerRegistrationScreenState();
}

class _FreelancerRegistrationScreenState
    extends State<FreelancerRegistrationScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color bg = Color(0xFF0A0A0A);

  final draft = FreelancerRegistrationDraft();
  late final FreelancerRegistrationRepository repo;

  int step = 0;
  bool submitting = false;

  final List<String> titles = const [
    'المعلومات الشخصية',
    'المعلومات المهنية',
    'الخدمات التي يقدمها',
    'المهارات والخبرة',
    'معرض الأعمال Portfolio',
    'معلومات الاتصال',
    'المعلومات المالية',
    'رفع الوثائق',
    'طريقة استقبال فرص العمل',
    'الشروط والموافقة',
    'مراجعة البيانات',
  ];

  @override
  void initState() {
    super.initState();
    repo = FreelancerRegistrationDemoRepository();
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  void msg(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  bool valid() {
    switch (step) {
      case 0:
        return draft.firstName.trim().isNotEmpty &&
            draft.lastName.trim().isNotEmpty &&
            draft.displayName.trim().isNotEmpty;
      case 1:
        return draft.jobTitle.trim().isNotEmpty;
      case 2:
        return draft.services.isNotEmpty;
      case 3:
        return draft.skills.isNotEmpty;
      case 5:
        return draft.email.trim().isNotEmpty &&
            draft.phone.trim().isNotEmpty;
      case 9:
        return draft.confirmInformation &&
            draft.acceptTerms &&
            draft.acceptPrivacy &&
            draft.acceptVerification &&
            draft.acceptContact;
      default:
        return true;
    }
  }

  Future<void> next() async {
    if (!valid()) {
      msg('يرجى إكمال المعلومات المطلوبة.');
      return;
    }
    await repo.saveDraft(draft.toRegistration());
    if (mounted && step < titles.length - 1) {
      setState(() => step++);
    }
  }

  void prev() {
    if (step == 0) {
      context.pop();
    } else {
      setState(() => step--);
    }
  }

  Future<void> submit() async {
    final registration = draft.toRegistration();
    if (!registration.canSubmit) {
      msg('لا يمكن إرسال الطلب قبل إكمال المعلومات.');
      return;
    }
    setState(() => submitting = true);
    try {
      final id = await repo.submitRegistration(registration);
      if (mounted) {
        context.go('/freelancer-registration/submitted', extra: id);
      }
    } finally {
      if (mounted) {
        setState(() => submitting = false);
      }
    }
  }

  Widget body() {
    switch (step) {
      case 0:
        return PersonalInfoStep(draft: draft, onChanged: refresh);
      case 1:
        return ProfessionalInfoStep(draft: draft, onChanged: refresh);
      case 2:
        return ServicesStep(draft: draft, onChanged: refresh);
      case 3:
        return SkillsStep(draft: draft, onChanged: refresh);
      case 4:
        return PortfolioStep(draft: draft, onChanged: refresh);
      case 5:
        return ContactInfoStep(draft: draft, onChanged: refresh);
      case 6:
        return FinancialInfoStep(draft: draft, onChanged: refresh);
      case 7:
        return DocumentsStep(draft: draft, onChanged: refresh);
      case 8:
        return OpportunityPreferencesStep(draft: draft, onChanged: refresh);
      case 9:
        return TermsConditionsStep(draft: draft, onChanged: refresh);
      case 10:
        return RegistrationReviewStep(
          draft: draft,
          onEdit: (index) => setState(() => step = index),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == titles.length - 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          title: const Text('تسجيل مستقل'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            titles[step],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '${step + 1}/${titles.length}',
                          style: const TextStyle(color: gold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (step + 1) / titles.length,
                      color: gold,
                      backgroundColor: const Color(0xFF222222),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: body(),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                color: const Color(0xFF111111),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: prev,
                        child: Text(step == 0 ? 'إلغاء' : 'السابق'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: submitting
                            ? null
                            : (isLastStep ? submit : next),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          isLastStep ? 'إرسال طلب التسجيل' : 'التالي',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
