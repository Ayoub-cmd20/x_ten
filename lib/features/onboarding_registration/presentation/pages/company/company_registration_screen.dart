import 'package:flutter/material.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/company/company_official_info_screen.dart';

class CompanyRegistrationScreen extends StatefulWidget {
  const CompanyRegistrationScreen({
    super.key,
  });

  @override
  State<CompanyRegistrationScreen> createState() =>
      _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState
    extends State<CompanyRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _hasCommercialRegister = true;
  bool _isIndividualActivity = false;

  final _ownerNameController =
  TextEditingController();

  final _orgNameController =
  TextEditingController();

  final _branchController =
  TextEditingController();

  final _addressController =
  TextEditingController();

  final _professionalTitleController =
  TextEditingController();

  final _activityController =
  TextEditingController();

  final _nationalIdController =
  TextEditingController();

  final _ninController =
  TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _orgNameController.dispose();
    _branchController.dispose();
    _addressController.dispose();

    _professionalTitleController.dispose();
    _activityController.dispose();
    _nationalIdController.dispose();
    _ninController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
        const Color(0xFF1A1A1A),

        body: SafeArea(
          child: Column(
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color:
                        Color(0xFFD4A843),
                      ),
                    ),

                    const Expanded(
                      child: Text(
                        'تسجيل الشركة',
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 48,
                    ),
                  ],
                ),
              ),

              // =====================================================
              // STEP INFO
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    const Text(
                      'المعلومات الأساسية',
                      style: TextStyle(
                        color:
                        Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const Text(
                      'الخطوة 1 من 5',
                      style: TextStyle(
                        color:
                        Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // =====================================================
              // PROGRESS BAR
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    4,
                  ),
                  child:
                  const LinearProgressIndicator(
                    value: 0.2,
                    backgroundColor:
                    Color(0xFF2A2A2A),
                    valueColor:
                    AlwaysStoppedAnimation<
                        Color>(
                      Color(0xFFD4A843),
                    ),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // =====================================================
              // PROFILE IMAGE
              // =====================================================

              Column(
                children: [
                  Stack(
                    alignment:
                    Alignment.bottomLeft,
                    children: [
                      Container(
                        width: 110,
                        height: 110,

                        decoration:
                        BoxDecoration(
                          shape:
                          BoxShape.circle,
                          color:
                          const Color(
                            0xFF2A2A2A,
                          ),
                          border:
                          Border.all(
                            color:
                            const Color(
                              0xFF3A3A3A,
                            ),
                            width: 2,
                          ),
                        ),

                        child:
                        const Icon(
                          Icons
                              .add_photo_alternate_outlined,
                          color:
                          Colors.white54,
                          size: 40,
                        ),
                      ),

                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration:
                          const BoxDecoration(
                            color:
                            Color(
                              0xFFD4A843,
                            ),
                            shape:
                            BoxShape.circle,
                          ),
                          child:
                          const Icon(
                            Icons.edit,
                            color:
                            Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    _hasCommercialRegister
                        ? 'صورة الملف الشخصي للمؤسسة'
                        : 'الصورة الشخصية أو صورة النشاط',
                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // =====================================================
              // FORM
              // =====================================================

              Expanded(
                child:
                SingleChildScrollView(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 20,
                  ),

                  child: Form(
                    key: _formKey,

                    child: Container(
                      padding:
                      const EdgeInsets
                          .all(
                        20,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFF252525,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                        border:
                        Border.all(
                          color:
                          const Color(
                            0xFFD4A843,
                          ).withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [
                          // =================================================
                          // COMMERCIAL REGISTER QUESTION
                          // =================================================

                          const Text(
                            'هل لديك سجل تجاري؟',
                            style:
                            TextStyle(
                              color:
                              Colors.white,
                              fontSize: 15,
                              fontWeight:
                              FontWeight
                                  .w500,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                _buildRadioOption(
                                  label:
                                  'نعم',
                                  value:
                                  true,
                                  groupValue:
                                  _hasCommercialRegister,
                                  onChanged:
                                      (value) {
                                    if (value ==
                                        null) {
                                      return;
                                    }

                                    setState(
                                          () {
                                        _hasCommercialRegister =
                                            value;

                                        if (value) {
                                          _isIndividualActivity =
                                          false;
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child:
                                _buildRadioOption(
                                  label:
                                  'لا',
                                  value:
                                  false,
                                  groupValue:
                                  _hasCommercialRegister,
                                  onChanged:
                                      (value) {
                                    if (value ==
                                        null) {
                                      return;
                                    }

                                    setState(
                                          () {
                                        _hasCommercialRegister =
                                            value;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =================================================
                          // COMMON OWNER NAME
                          // =================================================

                          _buildTextField(
                            label:
                            _hasCommercialRegister
                                ? 'اسم المالك'
                                : 'اسم صاحب النشاط',
                            hint:
                            _hasCommercialRegister
                                ? 'أدخل اسم المالك'
                                : 'أدخل الاسم الكامل',
                            controller:
                            _ownerNameController,
                            icon: Icons
                                .person_outline,
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          // =================================================
                          // COMMERCIAL REGISTER = YES
                          // =================================================

                          if (_hasCommercialRegister) ...[
                            _buildSectionTitle(
                              'معلومات المؤسسة',
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            _buildTextField(
                              label:
                              'اسم المؤسسة',
                              hint:
                              'أدخل اسم المؤسسة',
                              controller:
                              _orgNameController,
                              icon: Icons
                                  .apartment_outlined,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    const Text(
                                      'الفرع',
                                      style:
                                      TextStyle(
                                        color: Colors
                                            .white,
                                        fontSize:
                                        15,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                      ),
                                    ),

                                    Text(
                                      '(اختياري)',
                                      style:
                                      TextStyle(
                                        color: Colors
                                            .white
                                            .withValues(
                                          alpha:
                                          0.5,
                                        ),
                                        fontSize:
                                        13,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 8,
                                ),

                                _buildInputField(
                                  hint:
                                  'أدخل اسم الفرع إن وجد',
                                  controller:
                                  _branchController,
                                  icon: Icons
                                      .business_outlined,
                                  required:
                                  false,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'عنوان المؤسسة',
                              hint:
                              'أدخل العنوان التفصيلي',
                              controller:
                              _addressController,
                              icon: Icons
                                  .location_on_outlined,
                              maxLines:
                              2,
                            ),
                          ],

                          // =================================================
                          // COMMERCIAL REGISTER = NO
                          // =================================================

                          if (!_hasCommercialRegister) ...[
                            _buildSectionTitle(
                              'معلومات النشاط الفردي',
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            const Text(
                              'أدخل معلومات نشاطك المهني حتى تتمكن المنصة من التحقق من حسابك.',
                              style:
                              TextStyle(
                                color: Colors
                                    .white54,
                                fontSize:
                                13,
                                height:
                                1.5,
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'الصفة المهنية',
                              hint:
                              'مثال: مصمم، مطور، مصور، مسوق...',
                              controller:
                              _professionalTitleController,
                              icon: Icons
                                  .work_outline,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'النشاط / التخصص',
                              hint:
                              'مثال: تطوير تطبيقات، تصميم، تصوير...',
                              controller:
                              _activityController,
                              icon: Icons
                                  .design_services_outlined,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'رقم بطاقة التعريف الوطنية',
                              hint:
                              'أدخل رقم بطاقة التعريف',
                              controller:
                              _nationalIdController,
                              icon: Icons
                                  .credit_card_outlined,
                              keyboardType:
                              TextInputType
                                  .number,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'الرقم التعريفي الوطني NIN',
                              hint:
                              'أدخل الرقم التعريفي الوطني',
                              controller:
                              _ninController,
                              icon:
                              Icons.fingerprint,
                              keyboardType:
                              TextInputType
                                  .number,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            _buildTextField(
                              label:
                              'عنوان الإقامة / النشاط',
                              hint:
                              'أدخل العنوان التفصيلي',
                              controller:
                              _addressController,
                              icon: Icons
                                  .location_on_outlined,
                              maxLines:
                              2,
                            ),

                            const SizedBox(
                              height: 18,
                            ),

                            Container(
                              decoration:
                              BoxDecoration(
                                color:
                                const Color(
                                  0xFF1E1E1E,
                                ),
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  12,
                                ),
                                border:
                                Border.all(
                                  color:
                                  _isIndividualActivity
                                      ? const Color(
                                    0xFFD4A843,
                                  )
                                      : const Color(
                                    0xFF3A3A3A,
                                  ),
                                ),
                              ),

                              child:
                              CheckboxListTile(
                                value:
                                _isIndividualActivity,

                                activeColor:
                                const Color(
                                  0xFFD4A843,
                                ),

                                checkColor:
                                Colors.black,

                                controlAffinity:
                                ListTileControlAffinity
                                    .leading,

                                title:
                                const Text(
                                  'أصرّح أنني أمارس نشاطي بصفتي فرداً ولا أملك سجلاً تجارياً حالياً.',
                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize:
                                    14,
                                    height:
                                    1.5,
                                  ),
                                ),

                                subtitle:
                                const Padding(
                                  padding:
                                  EdgeInsets
                                      .only(
                                    top: 5,
                                  ),
                                  child:
                                  Text(
                                    'يمكن طلب وثائق إثبات الهوية أو النشاط لاحقاً أثناء عملية التحقق.',
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .white38,
                                      fontSize:
                                      11,
                                    ),
                                  ),
                                ),

                                onChanged:
                                    (value) {
                                  setState(
                                        () {
                                      _isIndividualActivity =
                                          value ??
                                              false;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // =====================================================
              // BOTTOM BUTTONS
              // =====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),

                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        style:
                        TextButton.styleFrom(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical:
                            16,
                          ),
                        ),

                        child:
                        const Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                          children: [
                            Icon(
                              Icons
                                  .arrow_back_ios,
                              color:
                              Colors.white,
                              size:
                              16,
                            ),

                            SizedBox(
                              width:
                              4,
                            ),

                            Text(
                              'الرجوع',
                              style:
                              TextStyle(
                                color:
                                Colors.white,
                                fontSize:
                                15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      flex: 3,

                      child:
                      ElevatedButton(
                        onPressed:
                        _continueRegistration,

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                            0xFFD4A843,
                          ),
                          foregroundColor:
                          Colors.black,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            vertical:
                            16,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                          elevation:
                          0,
                        ),

                        child:
                        const Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                          children: [
                            Text(
                              'الخطوة التالية',
                              textAlign:
                              TextAlign
                                  .center,
                              style:
                              TextStyle(
                                fontSize:
                                15,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),

                            SizedBox(
                              width:
                              8,
                            ),

                            Icon(
                              Icons
                                  .arrow_forward_ios,
                              size:
                              16,
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

  // =============================================================
  // CONTINUE
  // =============================================================

  void _continueRegistration() {
    FocusScope.of(context).unfocus();

    final isValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    if (!_hasCommercialRegister &&
        !_isIndividualActivity) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'يجب تأكيد التصريح الخاص بالنشاط الفردي.',
            textDirection:
            TextDirection.rtl,
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const CompanyOfficialInfoScreen(),
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle(
      String title,
      ) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color:
            const Color(
              0xFFD4A843,
            ),
            borderRadius:
            BorderRadius.circular(
              5,
            ),
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Text(
          title,
          style:
          const TextStyle(
            color:
            Color(
              0xFFD4A843,
            ),
            fontSize:
            16,
            fontWeight:
            FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // RADIO OPTION
  // =============================================================

  Widget _buildRadioOption({
    required String label,
    required bool value,
    required bool groupValue,
    required ValueChanged<bool?>
    onChanged,
  }) {
    final isSelected =
        value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(
          value,
        );
      },

      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds:
          180,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal:
          16,
          vertical:
          14,
        ),

        decoration:
        BoxDecoration(
          color:
          isSelected
              ? const Color(
            0xFFD4A843,
          ).withValues(
            alpha:
            0.10,
          )
              : const Color(
            0xFF1E1E1E,
          ),

          borderRadius:
          BorderRadius.circular(
            10,
          ),

          border:
          Border.all(
            color:
            isSelected
                ? const Color(
              0xFFD4A843,
            )
                : const Color(
              0xFF3A3A3A,
            ),
            width:
            1.5,
          ),
        ),

        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

          children: [
            Text(
              label,
              style:
              TextStyle(
                color:
                isSelected
                    ? Colors.white
                    : Colors.white70,
                fontSize:
                15,
                fontWeight:
                isSelected
                    ? FontWeight
                    .w600
                    : FontWeight
                    .w400,
              ),
            ),

            Container(
              width:
              20,
              height:
              20,

              decoration:
              BoxDecoration(
                shape:
                BoxShape.circle,

                border:
                Border.all(
                  color:
                  isSelected
                      ? const Color(
                    0xFFD4A843,
                  )
                      : Colors
                      .white54,
                  width:
                  2,
                ),
              ),

              child:
              isSelected
                  ? Center(
                child:
                Container(
                  width:
                  10,
                  height:
                  10,
                  decoration:
                  const BoxDecoration(
                    color:
                    Color(
                      0xFFD4A843,
                    ),
                    shape:
                    BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // TEXT FIELD WITH LABEL
  // =============================================================

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController
    controller,
    required IconData icon,
    int maxLines = 1,
    bool required = true,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            Text(
              label,
              style:
              const TextStyle(
                color:
                Colors.white,
                fontSize:
                15,
                fontWeight:
                FontWeight.w500,
              ),
            ),

            if (!required) ...[
              const Spacer(),

              Text(
                '(اختياري)',
                style:
                TextStyle(
                  color:
                  Colors.white
                      .withValues(
                    alpha:
                    0.5,
                  ),
                  fontSize:
                  13,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(
          height:
          8,
        ),

        _buildInputField(
          hint:
          hint,
          controller:
          controller,
          icon:
          icon,
          maxLines:
          maxLines,
          required:
          required,
          keyboardType:
          keyboardType,
        ),
      ],
    );
  }

  // =============================================================
  // INPUT FIELD
  // =============================================================

  Widget _buildInputField({
    required String hint,
    required TextEditingController
    controller,
    required IconData icon,
    int maxLines = 1,
    bool required = true,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller:
      controller,

      maxLines:
      maxLines,

      keyboardType:
      keyboardType,

      style:
      const TextStyle(
        color:
        Colors.white,
      ),

      textAlign:
      TextAlign.right,

      decoration:
      InputDecoration(
        hintText:
        hint,

        hintStyle:
        TextStyle(
          color:
          Colors.white
              .withValues(
            alpha:
            0.35,
          ),
          fontSize:
          14,
        ),

        prefixIcon:
        Icon(
          icon,
          color:
          Colors.white54,
          size:
          22,
        ),

        filled:
        true,

        fillColor:
        const Color(
          0xFF1E1E1E,
        ),

        contentPadding:
        const EdgeInsets
            .symmetric(
          horizontal:
          16,
          vertical:
          16,
        ),

        border:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            10,
          ),

          borderSide:
          const BorderSide(
            color:
            Color(
              0xFF3A3A3A,
            ),
            width:
            1,
          ),
        ),

        enabledBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            10,
          ),

          borderSide:
          const BorderSide(
            color:
            Color(
              0xFF3A3A3A,
            ),
            width:
            1,
          ),
        ),

        focusedBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            10,
          ),

          borderSide:
          const BorderSide(
            color:
            Color(
              0xFFD4A843,
            ),
            width:
            1.5,
          ),
        ),

        errorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            10,
          ),

          borderSide:
          const BorderSide(
            color:
            Colors.redAccent,
            width:
            1,
          ),
        ),

        focusedErrorBorder:
        OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(
            10,
          ),

          borderSide:
          const BorderSide(
            color:
            Colors.redAccent,
            width:
            1.5,
          ),
        ),
      ),

      validator:
          (value) {
        if (!required) {
          return null;
        }

        if (value ==
            null ||
            value
                .trim()
                .isEmpty) {
          return 'هذا الحقل مطلوب';
        }

        return null;
      },
    );
  }
}