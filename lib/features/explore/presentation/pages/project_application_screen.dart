import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'portfolio_selection_screen.dart';

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

  final List<Map<String, String>> _selectedPortfolioWorks = [];

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

  // =========================================================
  // PORTFOLIO SELECTION
  // =========================================================

  Future<void> _openPortfolioSelection() async {
    final result =
    await Navigator.push<List<Map<String, String>>>(
      context,
      MaterialPageRoute(
        builder: (_) => PortfolioSelectionScreen(
          initiallySelectedIds: _selectedPortfolioWorks
              .map((item) => item['id'])
              .whereType<String>()
              .toSet(),
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _selectedPortfolioWorks
        ..clear()
        ..addAll(result);
    });
  }

  void _removePortfolioWork(
      Map<String, String> work,
      ) {
    final id = work['id'];

    setState(() {
      _selectedPortfolioWorks.removeWhere(
            (item) => item['id'] == id,
      );
    });
  }

  // =========================================================
  // SUBMIT APPLICATION
  // =========================================================

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
      final portfolioIds = _selectedPortfolioWorks
          .map((work) => work['id'])
          .whereType<String>()
          .toList();

      final payload = {
        'projectTitle': widget.projectTitle,
        'company': widget.company,
        'category': widget.category,
        'budget': widget.budget,
        'message': _messageController.text.trim(),
        'price': double.parse(
          _priceController.text.trim(),
        ),
        'deliveryDays': int.parse(
          _deliveryDaysController.text.trim(),
        ),
        'portfolioIds': portfolioIds,
      };

      debugPrint(
        'PROJECT APPLICATION: $payload',
      );

      // TODO:
      // Replace with your real API / Firebase / Supabase call.

      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
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
                    'عدد الأعمال المرفقة: '
                    '${_selectedPortfolioWorks.length}\n\n'
                    'سيتم إشعارك عند مراجعة الطلب من طرف المعلن.',
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.7,
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
    } catch (e) {
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

  // =========================================================
  // BUILD
  // =========================================================

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
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus
                  ?.unfocus();
            },
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.stretch,
                  children: [
                    // =====================================================
                    // PROJECT SUMMARY
                    // =====================================================

                    Container(
                      padding: const EdgeInsets.all(16),
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

                          const SizedBox(height: 14),

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

                    // =====================================================
                    // MESSAGE
                    // =====================================================

                    _fieldLabel(
                      'رسالة التقديم',
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

                    // =====================================================
                    // PRICE
                    // =====================================================

                    _fieldLabel(
                      'عرض السعر',
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

                    // =====================================================
                    // DELIVERY
                    // =====================================================

                    _fieldLabel(
                      'مدة التنفيذ',
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

                    // =====================================================
                    // PORTFOLIO BUTTON
                    // =====================================================

                    Container(
                      padding: const EdgeInsets.all(16),
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

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                const Text(
                                  'إضافة أعمال سابقة',
                                  style: TextStyle(
                                    color:
                                    Colors.white,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedPortfolioWorks
                                      .isEmpty
                                      ? 'اختر أعمالاً من معرضك لإرفاقها مع طلب التقديم.'
                                      : 'تم اختيار ${_selectedPortfolioWorks.length} من الأعمال.',
                                  style: const TextStyle(
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
                            tooltip:
                            'اختيار أعمال',
                            onPressed:
                            _openPortfolioSelection,
                            icon: const Icon(
                              Icons
                                  .add_circle_outline_rounded,
                              color: gold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =====================================================
                    // SELECTED PORTFOLIO WORKS
                    // =====================================================

                    if (_selectedPortfolioWorks
                        .isNotEmpty) ...[
                      const SizedBox(height: 12),

                      Container(
                        padding:
                        const EdgeInsets.all(
                          14,
                        ),
                        decoration:
                        BoxDecoration(
                          color: surface,
                          borderRadius:
                          BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color:
                            gold.withValues(
                              alpha: 0.14,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .check_circle_outline_rounded,
                                  color: gold,
                                  size: 19,
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                Expanded(
                                  child: Text(
                                    'الأعمال المرفقة (${_selectedPortfolioWorks.length})',
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight
                                          .w700,
                                    ),
                                  ),
                                ),

                                TextButton(
                                  onPressed:
                                  _openPortfolioSelection,
                                  child:
                                  const Text(
                                    'تعديل',
                                    style:
                                    TextStyle(
                                      color: gold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            ..._selectedPortfolioWorks
                                .map(
                                  (work) =>
                                  _buildSelectedWork(
                                    work,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    // =====================================================
                    // SUBMIT BUTTON
                    // =====================================================

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

  // =========================================================
  // SELECTED PORTFOLIO ITEM
  // =========================================================

  Widget _buildSelectedWork(
      Map<String, String> work,
      ) {
    final details = [
      work['category'],
      work['platform'],
    ]
        .whereType<String>()
        .where(
          (value) =>
      value.trim().isNotEmpty,
    )
        .join(' • ');

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
        const Color(0xFF1C1C1C),
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
              gold.withValues(
                alpha: 0.08,
              ),
              borderRadius:
              BorderRadius.circular(
                11,
              ),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: gold,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  work['title'] ??
                      'عمل سابق',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                if (details.isNotEmpty) ...[
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    details,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    const TextStyle(
                      color:
                      Colors.white38,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            tooltip: 'إزالة',
            visualDensity:
            VisualDensity.compact,
            onPressed: () {
              _removePortfolioWork(
                work,
              );
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white38,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LABEL
  // =========================================================

  Widget _fieldLabel(
      String title,
      ) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // =========================================================
  // SUMMARY ROW
  // =========================================================

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

  // =========================================================
  // INPUT DECORATION
  // =========================================================

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

      suffixStyle:
      const TextStyle(
        color: gold,
        fontWeight:
        FontWeight.w700,
      ),

      filled: true,
      fillColor: surface,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        BorderSide(
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