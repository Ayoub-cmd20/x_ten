import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectApplicationScreen extends StatefulWidget {
  final String projectTitle;
  final String company;
  final String category;
  final String budget;

  const ProjectApplicationScreen({
    super.key,
    required this.projectTitle,
    required this.company,
    required this.category,
    required this.budget,
  });

  @override
  State<ProjectApplicationScreen> createState() =>
      _ProjectApplicationScreenState();
}

class _ProjectApplicationScreenState
    extends State<ProjectApplicationScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF161616);

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController _messageController;
  late final TextEditingController _priceController;
  late final TextEditingController _deliveryDaysController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _messageController = TextEditingController(
      text:
      'مرحباً، أنا مهتم بالمشاركة في هذا المشروع وأعتقد أن خبرتي ومحتواي يتناسبان مع متطلبات الحملة.',
    );

    _priceController = TextEditingController();
    _deliveryDaysController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _priceController.dispose();
    _deliveryDaysController.dispose();

    super.dispose();
  }

  Future<void> _submitApplication() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final valid =
        _formKey.currentState?.validate() ?? false;

    if (!valid || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO:
      // Replace this section with your backend/API call.
      //
      // Example payload:
      //
      // {
      //   "projectTitle": widget.projectTitle,
      //   "company": widget.company,
      //   "message": _messageController.text.trim(),
      //   "price": _priceController.text.trim(),
      //   "deliveryDays": _deliveryDaysController.text.trim(),
      // }

      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor:
              const Color(0xFF171717),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),

              title: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: gold,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'تم إرسال طلب التقديم',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              content: Text(
                'تم إرسال طلبك للمشروع:\n\n'
                    '${widget.projectTitle}\n\n'
                    'سيتم إشعارك عند مراجعة الطلب من طرف المعلن.',
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );

                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      color: gold,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            backgroundColor:
            Color(0xFF1B1B1B),
            behavior:
            SnackBarBehavior.floating,
            content: Text(
              'حدث خطأ أثناء إرسال الطلب',
              textDirection:
              TextDirection.rtl,
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
            'التقدم للمشروع',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus
                  ?.unfocus();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // ==============================
                    // PROJECT SUMMARY
                    // ==============================

                    Container(
                      padding:
                      const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end:
                          Alignment.bottomLeft,
                          colors: [
                            gold.withValues(
                              alpha: 0.12,
                            ),
                            gold.withValues(
                              alpha: 0.03,
                            ),
                          ],
                        ),
                        borderRadius:
                        BorderRadius.circular(18),
                        border: Border.all(
                          color: gold.withValues(
                            alpha: 0.18,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المشروع',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            widget.projectTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _summaryRow(
                            Icons.business_outlined,
                            widget.company,
                          ),

                          const SizedBox(height: 8),

                          _summaryRow(
                            Icons.category_outlined,
                            widget.category,
                          ),

                          const SizedBox(height: 8),

                          _summaryRow(
                            Icons.payments_outlined,
                            widget.budget,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ==============================
                    // MESSAGE
                    // ==============================

                    const Text(
                      'رسالة التقديم',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller:
                      _messageController,
                      minLines: 6,
                      maxLines: 10,
                      validator: (value) {
                        if (value == null ||
                            value
                                .trim()
                                .length <
                                20) {
                          return 'يرجى كتابة رسالة تقديم واضحة';
                        }

                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.6,
                      ),
                      cursorColor: gold,
                      decoration: _decoration(
                        hint:
                        'اشرح لماذا أنت مناسب لهذا المشروع...',
                        icon:
                        Icons.message_outlined,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==============================
                    // PRICE
                    // ==============================

                    const Text(
                      'عرض السعر',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller:
                      _priceController,
                      keyboardType:
                      TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                      validator: (value) {
                        final amount =
                        double.tryParse(
                          value ?? '',
                        );

                        if (amount == null ||
                            amount <= 0) {
                          return 'يرجى إدخال عرض سعر صحيح';
                        }

                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: gold,
                      decoration: _decoration(
                        hint: 'مثال: 30000',
                        icon:
                        Icons.payments_outlined,
                        suffix: 'دج',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==============================
                    // DELIVERY
                    // ==============================

                    const Text(
                      'مدة التنفيذ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller:
                      _deliveryDaysController,
                      keyboardType:
                      TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                      validator: (value) {
                        final days =
                        int.tryParse(
                          value ?? '',
                        );

                        if (days == null ||
                            days <= 0) {
                          return 'يرجى تحديد مدة التنفيذ';
                        }

                        return null;
                      },
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: gold,
                      decoration: _decoration(
                        hint: 'مثال: 5',
                        icon:
                        Icons.schedule_outlined,
                        suffix: 'يوم',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ==============================
                    // PORTFOLIO SECTION
                    // ==============================

                    Container(
                      padding:
                      const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius:
                        BorderRadius.circular(18),
                        border: Border.all(
                          color:
                          Colors.white.withValues(
                            alpha: 0.06,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration:
                            BoxDecoration(
                              color:
                              gold.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius:
                              BorderRadius.circular(
                                13,
                              ),
                            ),
                            child: const Icon(
                              Icons
                                  .business_center_outlined,
                              color: gold,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  'إضافة أعمال سابقة',
                                  style: TextStyle(
                                    color:
                                    Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'يمكنك لاحقاً اختيار أعمال من معرضك لإرفاقها مع طلب التقديم.',
                                  style: TextStyle(
                                    color:
                                    Colors.white38,
                                    fontSize: 11.5,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              // TODO:
                              // Open portfolio selection.
                            },
                            icon: const Icon(
                              Icons
                                  .add_circle_outline_rounded,
                              color: gold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ==============================
                    // SUBMIT
                    // ==============================

                    SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed:
                        _isSubmitting
                            ? null
                            : _submitApplication,

                        icon: _isSubmitting
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
                            : const Icon(
                          Icons
                              .send_rounded,
                        ),

                        label: Text(
                          _isSubmitting
                              ? 'جاري إرسال الطلب...'
                              : 'إرسال طلب التقديم',
                        ),

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor:
                          Colors.black,
                          disabledBackgroundColor:
                          gold.withValues(
                            alpha: 0.45,
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

                    const SizedBox(height: 12),

                    const Text(
                      'سيتم إرسال عرضك إلى صاحب المشروع، ويمكنه قبول الطلب أو طلب المزيد من المعلومات.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
      IconData icon,
      String value,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          color: gold,
          size: 17,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
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
      suffixText: suffix,
      suffixStyle: const TextStyle(
        color: gold,
        fontWeight: FontWeight.w700,
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
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide(
          color:
          Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: gold,
          width: 1.3,
        ),
      ),
      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: Colors.redAccent,
          width: 1.3,
        ),
      ),
    );
  }
}