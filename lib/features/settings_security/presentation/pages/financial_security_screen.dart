import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:x_ten/features/onboarding_registration/presentation/pages/registration_success_screen.dart';

class FinancialSecurityScreen extends StatefulWidget {
  const FinancialSecurityScreen({super.key});

  @override
  State<FinancialSecurityScreen> createState() =>
      _FinancialSecurityScreenState();
}

class _FinancialSecurityScreenState
    extends State<FinancialSecurityScreen> {
  // ============================================================
  // X TEN THEME COLORS
  // ============================================================

  static const Color _bgDark = Color(0xFF101010);
  static const Color _cardDark = Color(0xFF1A1A1A);
  static const Color _inputDark = Color(0xFF0A0A0A);
  static const Color _gold = Color(0xFFE2C044);
  static const Color _textGrey = Color(0xFFA0A0A0);

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _financialInstitutionController =
  TextEditingController();

  final TextEditingController _accountHolderController =
  TextEditingController();

  final TextEditingController _accountNumberController =
  TextEditingController();

  // ============================================================
  // DOCUMENTS
  // ============================================================

  PlatformFile? _identityDocument;
  PlatformFile? _bankDocument;

  // ============================================================
  // CHECKBOXES
  // ============================================================

  bool _agreeToDataPolicy = false;
  bool _agreeToTerms = false;

  // ============================================================
  // SUBMISSION
  // ============================================================

  bool _isSubmitting = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _financialInstitutionController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  // ============================================================
  // PICK IDENTITY DOCUMENT
  // ============================================================

  Future<void> _pickIdentityDocument() async {
    try {
      final FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _identityDocument = result.files.single;
        });
      }
    } catch (e) {
      if (!mounted) return;

      _showError(
        'حدث خطأ أثناء اختيار بطاقة التعريف.',
      );
    }
  }

  // ============================================================
  // PICK BANK DOCUMENT
  // ============================================================

  Future<void> _pickBankDocument() async {
    try {
      final FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _bankDocument = result.files.single;
        });
      }
    } catch (e) {
      if (!mounted) return;

      _showError(
        'حدث خطأ أثناء اختيار الوثيقة المالية.',
      );
    }
  }

  // ============================================================
  // REMOVE DOCUMENTS
  // ============================================================

  void _removeIdentityDocument() {
    setState(() {
      _identityDocument = null;
    });
  }

  void _removeBankDocument() {
    setState(() {
      _bankDocument = null;
    });
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submitApplication() async {
    FocusScope.of(context).unfocus();

    final bool formIsValid =
        _formKey.currentState?.validate() ?? false;

    if (!formIsValid) {
      _showError(
        'يرجى إكمال جميع البيانات المالية المطلوبة.',
      );
      return;
    }

    if (_identityDocument == null) {
      _showError(
        'يرجى رفع بطاقة التعريف.',
      );
      return;
    }

    if (_bankDocument == null) {
      _showError(
        'يرجى رفع وثيقة بنكية أو بريدية.',
      );
      return;
    }

    if (!_agreeToDataPolicy) {
      _showError(
        'يجب الموافقة على سياسة حماية البيانات.',
      );
      return;
    }

    if (!_agreeToTerms) {
      _showError(
        'يجب الموافقة على الشروط والأحكام.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ========================================================
      // TODO:
      // SEND DATA TO YOUR API HERE
      //
      // Example:
      //
      // await registrationRepository.submitFinancialData(
      //   institution:
      //       _financialInstitutionController.text.trim(),
      //
      //   accountHolder:
      //       _accountHolderController.text.trim(),
      //
      //   accountNumber:
      //       _accountNumberController.text.trim(),
      //
      //   identityDocument:
      //       _identityDocument!,
      //
      //   bankDocument:
      //       _bankDocument!,
      // );
      // ========================================================

      // Temporary delay for local UI testing.
      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const RegistrationSuccessScreen(),
        ),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      _showError(
        'تعذر إرسال الطلب. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF252525),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bgDark,

        // ======================================================
        // APP BAR
        // ======================================================

        appBar: AppBar(
          backgroundColor: _bgDark,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: _gold,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: const Text(
            'البيانات المالية والتحقق',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          centerTitle: false,

          actions: const [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'X TEN',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================

        body: SafeArea(
          child: Column(
            children: [
              // ==================================================
              // PROGRESS BAR
              // ==================================================

              Container(
                height: 3,
                width: double.infinity,
                color: _gold,
              ),

              // ==================================================
              // CONTENT
              // ==================================================

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // ========================================
                        // INTRODUCTION
                        // ========================================

                        _buildIntroCard(),

                        const SizedBox(height: 30),

                        // ========================================
                        // FINANCIAL INFORMATION
                        // ========================================

                        _buildSectionHeader(
                          'المعلومات المالية',
                          Icons.account_balance_outlined,
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'تستخدم هذه البيانات فقط لإدارة المدفوعات والتحقق من الحساب.',
                          style: TextStyle(
                            color: _textGrey,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildCustomInputField(
                          controller:
                          _financialInstitutionController,
                          label:
                          'البنك أو المؤسسة المالية',
                          hint:
                          'مثال: BNA / BADR / CPA / CCP',
                          icon:
                          Icons.account_balance_outlined,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'يرجى إدخال اسم المؤسسة المالية';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        _buildCustomInputField(
                          controller:
                          _accountHolderController,
                          label:
                          'اسم صاحب الحساب',
                          hint:
                          'الاسم واللقب كما يظهران في الحساب',
                          icon:
                          Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'يرجى إدخال اسم صاحب الحساب';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        _buildCustomInputField(
                          controller:
                          _accountNumberController,
                          label:
                          'رقم الحساب / RIB / RIP / IBAN',
                          hint:
                          'أدخل رقم الحساب البنكي أو البريدي',
                          icon:
                          Icons.credit_card_rounded,
                          keyboardType:
                          TextInputType.text,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'يرجى إدخال رقم الحساب';
                            }

                            if (value.trim().length < 5) {
                              return 'رقم الحساب غير صالح';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 34),

                        // ========================================
                        // DOCUMENTS
                        // ========================================

                        _buildSectionHeader(
                          'وثائق التحقق',
                          Icons.verified_user_outlined,
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'ارفع ملفات واضحة بصيغة JPG أو PNG أو PDF.',
                          style: TextStyle(
                            color: _textGrey,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildUploadCard(
                          title: 'بطاقة التعريف',
                          subtitle:
                          'صورة واضحة للوجهين أو ملف PDF',
                          icon:
                          Icons.badge_outlined,
                          selectedFile:
                          _identityDocument,
                          onTap:
                          _pickIdentityDocument,
                          onRemove:
                          _removeIdentityDocument,
                        ),

                        const SizedBox(height: 14),

                        _buildUploadCard(
                          title:
                          'وثيقة بنكية أو بريدية',
                          subtitle:
                          'شيك مشطوب، RIB، RIP أو كشف حساب',
                          icon:
                          Icons.request_quote_outlined,
                          selectedFile:
                          _bankDocument,
                          onTap:
                          _pickBankDocument,
                          onRemove:
                          _removeBankDocument,
                        ),

                        const SizedBox(height: 34),

                        // ========================================
                        // SECURITY NOTICE
                        // ========================================

                        _buildSecurityNotice(),

                        const SizedBox(height: 28),

                        // ========================================
                        // AGREEMENTS
                        // ========================================

                        _buildSectionHeader(
                          'الموافقة',
                          Icons.gavel_outlined,
                        ),

                        const SizedBox(height: 16),

                        _buildCustomCheckbox(
                          value:
                          _agreeToDataPolicy,
                          onChanged: (value) {
                            setState(() {
                              _agreeToDataPolicy =
                                  value ?? false;
                            });
                          },
                          textSpans: const [
                            TextSpan(
                              text:
                              'أوافق على سياسة ',
                            ),
                            TextSpan(
                              text:
                              'حماية البيانات',
                              style: TextStyle(
                                color: _gold,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                              ' ومعالجة المعلومات الشخصية والمالية بطريقة آمنة.',
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _buildCustomCheckbox(
                          value:
                          _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms =
                                  value ?? false;
                            });
                          },
                          textSpans: const [
                            TextSpan(
                              text:
                              'أؤكد اطلاعي وموافقتي على ',
                            ),
                            TextSpan(
                              text:
                              'الشروط والأحكام',
                              style: TextStyle(
                                color: _gold,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                              ' الخاصة باستخدام منصة X TEN.',
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // ========================================
                        // SUBMIT BUTTON
                        // ========================================

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                            _isSubmitting
                                ? null
                                : _submitApplication,

                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor:
                              _gold,
                              disabledBackgroundColor:
                              _gold.withValues(alpha:0.45),
                              foregroundColor:
                              Colors.black,
                              elevation: 0,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),

                            child: _isSubmitting
                                ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2.3,
                                color:
                                Colors.black,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Text(
                                  'إرسال طلب التحقق',
                                  style:
                                  TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight
                                        .w800,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons
                                      .arrow_back_rounded,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        const Center(
                          child: Text(
                            'سيتم مراجعة طلبك قبل تفعيل الحساب بالكامل.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _textGrey,
                              fontSize: 10.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INTRO CARD
  // ============================================================

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _gold.withValues(alpha:0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _gold.withValues(alpha:0.12),
              borderRadius:
              BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _gold,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'الخطوة الأخيرة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'أدخل بيانات الدفع وارفع وثائق التحقق لإتمام تسجيلك في منصة X TEN.',
                  style: TextStyle(
                    color: _textGrey,
                    fontSize: 11,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader(
      String title,
      IconData icon,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          color: _gold,
          size: 21,
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.only(
            right: 3,
            bottom: 8,
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),

          cursorColor: _gold,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: TextStyle(
              color:
              Colors.grey.shade700,
              fontSize: 12,
            ),

            prefixIcon: Icon(
              icon,
              color:
              Colors.grey.shade600,
              size: 20,
            ),

            filled: true,
            fillColor: _inputDark,

            contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),

            enabledBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              borderSide: BorderSide(
                color:
                Colors.grey.shade900,
              ),
            ),

            focusedBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              borderSide:
              const BorderSide(
                color: _gold,
                width: 1.2,
              ),
            ),

            errorBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              borderSide:
              const BorderSide(
                color:
                Colors.redAccent,
              ),
            ),

            focusedErrorBorder:
            OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(
                12,
              ),
              borderSide:
              const BorderSide(
                color:
                Colors.redAccent,
              ),
            ),

            errorStyle:
            const TextStyle(
              color: Colors.redAccent,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DOCUMENT UPLOAD CARD
  // ============================================================

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required PlatformFile? selectedFile,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final bool hasFile =
        selectedFile != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,

        borderRadius:
        BorderRadius.circular(14),

        splashColor:
        _gold.withValues(alpha:0.08),

        highlightColor:
        _gold.withValues(alpha:0.04),

        child: AnimatedContainer(
          duration:
          const Duration(
            milliseconds: 220,
          ),

          width: double.infinity,

          padding:
          const EdgeInsets.all(16),

          decoration:
          BoxDecoration(
            color: _cardDark,

            borderRadius:
            BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color: hasFile
                  ? _gold
                  .withValues(alpha:0.55)
                  : Colors
                  .grey.shade900,
            ),
          ),

          child: Row(
            children: [
              // ================================================
              // DOCUMENT ICON
              // ================================================

              Container(
                width: 52,
                height: 52,

                decoration:
                BoxDecoration(
                  color: hasFile
                      ? _gold
                      .withValues(alpha:
                    0.15,
                  )
                      : const Color(
                    0xFF121212,
                  ),

                  borderRadius:
                  BorderRadius
                      .circular(
                    13,
                  ),
                ),

                child: Icon(
                  hasFile
                      ? Icons
                      .check_circle_outline_rounded
                      : icon,
                  color: _gold,
                  size: 27,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              // ================================================
              // TEXT
              // ================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      title,
                      style:
                      const TextStyle(
                        color:
                        Colors.white,
                        fontSize: 13.5,
                        fontWeight:
                        FontWeight
                            .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      hasFile
                          ? selectedFile
                          .name
                          : subtitle,

                      maxLines: 2,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style:
                      TextStyle(
                        color: hasFile
                            ? _gold
                            .withValues(alpha:
                          0.85,
                        )
                            : _textGrey,

                        fontSize: 10.5,

                        height: 1.45,
                      ),
                    ),

                    if (hasFile) ...[
                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        _formatFileSize(
                          selectedFile
                              .size,
                        ),
                        style:
                        const TextStyle(
                          color:
                          Colors.white38,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              // ================================================
              // ACTION
              // ================================================

              if (hasFile)
                IconButton(
                  tooltip:
                  'حذف الملف',

                  onPressed: onRemove,

                  icon:
                  const Icon(
                    Icons
                        .close_rounded,
                    color:
                    Colors.white54,
                  ),
                )
              else
                Container(
                  width: 42,
                  height: 42,

                  decoration:
                  BoxDecoration(
                    color: _gold,

                    borderRadius:
                    BorderRadius
                        .circular(
                      11,
                    ),
                  ),

                  child:
                  const Icon(
                    Icons
                        .upload_file_rounded,
                    color:
                    Colors.black,
                    size: 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECURITY NOTICE
  // ============================================================

  Widget _buildSecurityNotice() {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: _gold.withValues(alpha:0.06),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color:
          _gold.withValues(alpha:0.15),
        ),
      ),

      child: const Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            color: _gold,
            size: 22,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              'يتم التعامل مع المعلومات المالية ووثائق التحقق باعتبارها بيانات حساسة ولا تستخدم إلا لأغراض التحقق والدفع وفق سياسة المنصة.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10.5,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHECKBOX
  // ============================================================

  Widget _buildCustomCheckbox({
    required bool value,
    required ValueChanged<bool?>
    onChanged,
    required List<TextSpan>
    textSpans,
  }) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },

      borderRadius:
      BorderRadius.circular(10),

      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          vertical: 4,
        ),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration:
              const Duration(
                milliseconds: 180,
              ),

              width: 22,
              height: 22,

              margin:
              const EdgeInsets.only(
                top: 2,
              ),

              decoration:
              BoxDecoration(
                color: value
                    ? _gold
                    : Colors
                    .transparent,

                border:
                Border.all(
                  color: value
                      ? _gold
                      : Colors
                      .grey.shade700,

                  width: 1.5,
                ),

                borderRadius:
                BorderRadius
                    .circular(
                  5,
                ),
              ),

              child: value
                  ? const Icon(
                Icons.check_rounded,
                size: 16,
                color:
                Colors.black,
              )
                  : null,
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: RichText(
                text: TextSpan(
                  style:
                  const TextStyle(
                    color: _textGrey,
                    fontSize: 11.5,
                    height: 1.6,
                    fontFamily:
                    'Cairo',
                  ),
                  children:
                  textSpans,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILE SIZE FORMATTER
  // ============================================================

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes <
        1024 * 1024) {
      final double kb =
          bytes / 1024;

      return '${kb.toStringAsFixed(1)} KB';
    }

    final double mb =
        bytes /
            (1024 * 1024);

    return '${mb.toStringAsFixed(1)} MB';
  }
}
