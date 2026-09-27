import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/influencer_registration_demo_repository.dart';
import '../../data/influencer_registration_repository.dart';
import '../../domain/models/influencer_registration_draft.dart';

import '../steps/personal_info_step.dart';
import '../steps/categories_step.dart';
import '../steps/contact_info_step.dart';
import '../steps/financial_info_step.dart';
import '../steps/documents_step.dart';
import '../steps/social_accounts_step.dart';
import '../steps/audience_step.dart';
import '../steps/content_type_step.dart';
import '../steps/notification_preferences_step.dart';
import '../steps/terms_conditions_step.dart';
import '../steps/registration_review_step.dart';


class InfluencerRegistrationScreen extends StatefulWidget {
  const InfluencerRegistrationScreen({
    super.key,
  });

  @override
  State<InfluencerRegistrationScreen> createState() =>
      _InfluencerRegistrationScreenState();
}

class _InfluencerRegistrationScreenState
    extends State<InfluencerRegistrationScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  final InfluencerRegistrationDraft _draft =
  InfluencerRegistrationDraft();

  late final InfluencerRegistrationRepository _repository;

  int _currentStep = 0;

  bool _isSubmitting = false;
  bool _isSavingDraft = false;

  final List<String> _stepTitles = const [
    'المعلومات الشخصية',
    'المجالات والتخصصات',
    'معلومات الاتصال',
    'المعلومات المالية',
    'رفع الوثائق',
    'حسابات التواصل',
    'بيانات الجمهور',
    'نوع المحتوى',
    'طريقة استقبال الطلبات',
    'الشروط والموافقة',
    'مراجعة التسجيل',
  ];

  @override
  void initState() {
    super.initState();

    _repository =
        InfluencerRegistrationDemoRepository();
  }

  void _refresh() {
    if (!mounted) return;

    setState(() {});
  }

  void _goToStep(int index) {
    if (index < 0 ||
        index >= _stepTitles.length) {
      return;
    }

    setState(() {
      _currentStep = index;
    });
  }

  void _previousStep() {
    if (_currentStep <= 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _currentStep--;
    });
  }

  Future<void> _nextStep() async {
    if (!_validateCurrentStep()) {
      return;
    }

    await _saveDraftSilently();

    if (!mounted) return;

    if (_currentStep <
        _stepTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_draft.firstName.trim().isEmpty ||
            _draft.lastName.trim().isEmpty ||
            _draft.displayName.trim().isEmpty ||
            _draft.birthDate == null ||
            _draft.birthPlace.trim().isEmpty) {
          _showMessage(
            'يرجى إكمال المعلومات الشخصية الأساسية.',
          );
          return false;
        }

        return true;

      case 1:
        if (_draft.primaryCategories.isEmpty) {
          _showMessage(
            'اختر مجالاً رئيسياً واحداً على الأقل.',
          );
          return false;
        }

        return true;

      case 2:
        if (_draft.email.trim().isEmpty ||
            _draft.phone.trim().isEmpty) {
          _showMessage(
            'يرجى إدخال البريد الإلكتروني ورقم الهاتف.',
          );
          return false;
        }

        return true;

      case 3:
        return true;

      case 4:
        if (_draft.documents.isEmpty) {
          _showMessage(
            'يرجى رفع الوثائق المطلوبة.',
          );
          return false;
        }

        return true;

      case 5:
        if (_draft.socialAccounts.isEmpty) {
          _showMessage(
            'أضف حساب تواصل اجتماعي واحداً على الأقل.',
          );
          return false;
        }

        return true;

      case 6:
        return true;

      case 7:
        if (_draft.contentTypes.isEmpty) {
          _showMessage(
            'اختر نوع محتوى واحداً على الأقل.',
          );
          return false;
        }

        return true;

      case 8:
        return true;

      case 9:
        if (!_draft.confirmInformation ||
            !_draft.acceptTerms ||
            !_draft.acceptPrivacy ||
            !_draft.acceptVerification ||
            !_draft.acceptContact) {
          _showMessage(
            'يجب الموافقة على جميع الشروط المطلوبة.',
          );
          return false;
        }

        return true;

      default:
        return true;
    }
  }

  Future<void> _saveDraftSilently() async {
    try {
      final registration =
      _draft.toRegistration();

      await _repository.saveDraft(
        registration,
      );
    } catch (_) {
      // لا نوقف انتقال المستخدم بسبب فشل حفظ مسودة تجريبية.
    }
  }

  Future<void> _saveDraftManually() async {
    if (_isSavingDraft) return;

    setState(() {
      _isSavingDraft = true;
    });

    try {
      await _repository.saveDraft(
        _draft.toRegistration(),
      );

      if (!mounted) return;

      _showMessage(
        'تم حفظ المسودة.',
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'تعذر حفظ المسودة.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDraft = false;
        });
      }
    }
  }

  Future<void> _submitRegistration() async {
    final registration =
    _draft.toRegistration();

    if (!registration.canSubmit) {
      _showMessage(
        'لا يمكن إرسال الطلب قبل إكمال المعلومات المطلوبة.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final registrationId =
      await _repository.submitRegistration(
        registration,
      );

      if (!mounted) return;

      context.go(
        '/influencer-registration/submitted',
        extra: registrationId,
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حدث خطأ أثناء إرسال طلب التسجيل.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          const Color(0xFF1B1B1B),
          content: Text(
            message,
            textDirection:
            TextDirection.rtl,
          ),
        ),
      );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return PersonalInfoStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 1:
        return CategoriesStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 2:
        return ContactInfoStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 3:
        return FinancialInfoStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 4:
        return DocumentsStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 5:
        return SocialAccountsStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 6:
        return AudienceStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 7:
        return ContentTypeStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 8:
        return NotificationPreferencesStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 9:
        return TermsConditionsStep(
          draft: _draft,
          onChanged: _refresh,
        );

      case 10:
        return RegistrationReviewStep(
          draft: _draft,
          onEdit: _goToStep,
        );

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        (_currentStep + 1) /
            _stepTitles.length;

    final bool isLastStep =
        _currentStep ==
            _stepTitles.length - 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,

          iconTheme:
          const IconThemeData(
            color: Colors.white,
          ),

          title: const Text(
            'تسجيل مؤثر',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          actions: [
            TextButton.icon(
              onPressed: _isSavingDraft
                  ? null
                  : _saveDraftManually,
              icon: _isSavingDraft
                  ? const SizedBox(
                width: 15,
                height: 15,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: gold,
                ),
              )
                  : const Icon(
                Icons.save_outlined,
                color: gold,
                size: 19,
              ),
              label: const Text(
                'حفظ',
                style: TextStyle(
                  color: gold,
                ),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin:
                const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  0,
                ),
                padding:
                const EdgeInsets.all(
                  16,
                ),
                decoration:
                BoxDecoration(
                  color: surface,
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color:
                    gold.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _stepTitles[
                            _currentStep],
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize: 15,
                              fontWeight:
                              FontWeight
                                  .w800,
                            ),
                          ),
                        ),

                        Text(
                          '${_currentStep + 1}/${_stepTitles.length}',
                          style:
                          const TextStyle(
                            color: gold,
                            fontWeight:
                            FontWeight
                                .w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        50,
                      ),
                      child:
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        backgroundColor:
                        const Color(
                          0xFF242424,
                        ),
                        valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                          gold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child:
                SingleChildScrollView(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,
                  padding:
                  const EdgeInsets.all(
                    18,
                  ),
                  child:
                  _buildCurrentStep(),
                ),
              ),

              Container(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  14,
                ),
                decoration:
                BoxDecoration(
                  color: const Color(
                    0xFF101010,
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white
                          .withValues(
                        alpha: 0.05,
                      ),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child:
                      OutlinedButton(
                        onPressed:
                        _previousStep,
                        style:
                        OutlinedButton
                            .styleFrom(
                          foregroundColor:
                          Colors.white,
                          minimumSize:
                          const Size(
                            0,
                            54,
                          ),
                          side:
                          BorderSide(
                            color: Colors
                                .white
                                .withValues(
                              alpha: 0.15,
                            ),
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                        ),
                        child: Text(
                          _currentStep == 0
                              ? 'إلغاء'
                              : 'السابق',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      flex: 2,
                      child:
                      ElevatedButton(
                        onPressed:
                        _isSubmitting
                            ? null
                            : isLastStep
                            ? _submitRegistration
                            : _nextStep,
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          gold,
                          foregroundColor:
                          Colors.black,
                          minimumSize:
                          const Size(
                            0,
                            54,
                          ),
                          elevation: 0,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              15,
                            ),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                            Colors.black,
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Text(
                              isLastStep
                                  ? 'إرسال طلب التسجيل'
                                  : 'التالي',
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight
                                    .w800,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Icon(
                              isLastStep
                                  ? Icons
                                  .send_rounded
                                  : Icons
                                  .arrow_back_rounded,
                              size: 19,
                            ),
                          ],
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