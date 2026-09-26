import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnDemandPromotionScreen extends StatefulWidget {
  const OnDemandPromotionScreen({super.key});

  @override
  State<OnDemandPromotionScreen> createState() =>
      _OnDemandPromotionScreenState();
}

class _OnDemandPromotionScreenState
    extends State<OnDemandPromotionScreen> {
  // =========================================================
  // COLORS
  // =========================================================
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);
  static const Color _surface2 = Color(0xFF1B1B1B);
  static const Color _error = Color(0xFFFF6B6B);

  // =========================================================
  // FORM
  // =========================================================
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _briefController;
  late final TextEditingController _budgetController;

  late final FocusNode _briefFocusNode;
  late final FocusNode _budgetFocusNode;

  bool _isSubmitting = false;
  final List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();
    _briefController = TextEditingController();
    _budgetController = TextEditingController();

    _briefFocusNode = FocusNode();
    _budgetFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _briefController.dispose();
    _budgetController.dispose();

    _briefFocusNode.dispose();
    _budgetFocusNode.dispose();

    super.dispose();
  }

  // =========================================================
  // VALIDATION
  // =========================================================
  String? _validateBrief(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى كتابة وصف لطلب الترويج';
    }

    if (text.length < 20) {
      return 'يرجى كتابة تفاصيل أكثر (20 حرفاً على الأقل)';
    }

    return null;
  }

  String? _validateBudget(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال الميزانية';
    }

    final budget = double.tryParse(text);

    if (budget == null) {
      return 'يرجى إدخال مبلغ صحيح';
    }

    if (budget <= 0) {
      return 'يجب أن تكون الميزانية أكبر من صفر';
    }

    return null;
  }

  // =========================================================
  // ATTACHMENTS
  // =========================================================
  Future<void> _pickAttachments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      setState(() {
        for (final file in result.files) {
          final exists = _attachments.any((e) => e.path == file.path);
          if (!exists) {
            _attachments.add(file);
          }
        }
      });
    } catch (e) {
      _showSnackBar('تعذر اختيار المرفقات');
    }
  }

  void _removeAttachment(PlatformFile file) {
    setState(() {
      _attachments.remove(file);
    });
  }

  // =========================================================
  // SUBMIT
  // =========================================================
  Future<void> _submitRequest() async {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final budget = double.parse(_budgetController.text.trim());

      // TODO:
      // Replace this with your API / Firebase / Supabase call.
      // Example payload:
      // {
      //   "brief": brief,
      //   "budget": budget,
      //   "attachments": _attachments.map((e) => e.path).toList(),
      // }

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: _surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _gold.withValues(alpha: 0.18),
                ),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: _gold,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'تم إرسال الطلب',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'تم إرسال طلب الترويج بنجاح.\n\n'
                    'الميزانية: ${budget.toStringAsFixed(0)} دج\n'
                    'عدد المرفقات: ${_attachments.length}\n\n'
                    'سيتم مراجعة الطلب والتواصل معك لاحقاً.',
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      color: _gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      _formKey.currentState?.reset();
      _briefController.clear();
      _budgetController.clear();

      setState(() {
        _attachments.clear();
      });
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء إرسال الطلب');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // =========================================================
  // HELPERS
  // =========================================================
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: _surface2,
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  IconData _fileIcon(String? extension) {
    final ext = (extension ?? '').toLowerCase();

    if (['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)) {
      return Icons.image_outlined;
    }
    if (['pdf'].contains(ext)) {
      return Icons.picture_as_pdf_outlined;
    }
    if (['doc', 'docx'].contains(ext)) {
      return Icons.description_outlined;
    }
    if (['xls', 'xlsx', 'csv'].contains(ext)) {
      return Icons.table_chart_outlined;
    }
    if (['mp4', 'mov', 'avi'].contains(ext)) {
      return Icons.video_file_outlined;
    }

    return Icons.attach_file_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'ترويج حسب الطلب',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =====================================================
                    // HEADER INFO
                    // =====================================================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            _gold.withValues(alpha: 0.10),
                            _gold.withValues(alpha: 0.03),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _gold.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ما هي خدمة "ترويج حسب الطلب"؟',
                            style: TextStyle(
                              color: _gold,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'يمكنك من خلال هذه الخدمة إرسال فكرتك أو احتياجك التسويقي بشكل مباشر، '
                                'وسنساعدك في اختيار المؤثرين المناسبين، اقتراح أفكار تسويقية، '
                                'وتنسيق الحملة بما يناسب أهدافك.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.5,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // BULLETS
                    // =====================================================
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HintBullet(
                            text: 'دمج مؤثرين مناسبين مع حملتك أو مشروعك',
                          ),
                          SizedBox(height: 8),
                          _HintBullet(
                            text: 'اقتراح أفكار تسويقية أو محتوى إعلاني مناسب',
                          ),
                          SizedBox(height: 8),
                          _HintBullet(
                            text: 'كتابة أي ملاحظات إضافية أو متطلبات خاصة',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // BRIEF
                    // =====================================================
                    _sectionTitle('وصف الطلب'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _briefController,
                      focusNode: _briefFocusNode,
                      minLines: 8,
                      maxLines: 12,
                      textInputAction: TextInputAction.newline,
                      validator: _validateBrief,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.6,
                      ),
                      cursorColor: _gold,
                      decoration: _inputDecoration(
                        hint:
                        'اكتب هنا تفاصيل طلبك...\n\n'
                            'مثال:\n'
                            '- أريد الترويج لمنتج جديد\n'
                            '- أحتاج إلى مؤثرين في مجال الرياضة أو التكنولوجيا\n'
                            '- أريد أفكاراً لحملة إعلانية مناسبة\n'
                            '- الميزانية محددة وأرغب في نتائج واضحة',
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =====================================================
                    // ATTACHMENTS
                    // =====================================================
                    _sectionTitle('المرفقات'),
                    const SizedBox(height: 8),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _pickAttachments,
                        borderRadius: BorderRadius.circular(16),
                        splashColor: _gold.withValues(alpha: 0.10),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _gold.withValues(alpha: 0.18),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.attach_file_rounded,
                                color: _gold,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'إضافة مرفقات',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: _gold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Column(
                        children: _attachments.map((file) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _surface2,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _fileIcon(file.extension),
                                  color: _gold,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        file.size > 0
                                            ? '${(file.size / 1024).toStringAsFixed(1)} KB'
                                            : 'حجم غير معروف',
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _removeAttachment(file),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // =====================================================
                    // BUDGET
                    // =====================================================
                    _sectionTitle('المبلغ المخصص لهذا الإشهار'),
                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _budgetController,
                      focusNode: _budgetFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      validator: _validateBudget,
                      cursorColor: _gold,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        ),
                      ],
                      onFieldSubmitted: (_) => _submitRequest(),
                      decoration: _inputDecoration(
                        hint: 'مثال: 50000',
                        suffixText: 'دج',
                        prefixIcon: Icons.payments_outlined,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // =====================================================
                    // SUBMIT BUTTON
                    // =====================================================
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor:
                          _gold.withValues(alpha: 0.45),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _isSubmitting
                              ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          )
                              : const Row(
                            key: ValueKey('text'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded),
                              SizedBox(width: 10),
                              Text(
                                'إرسال طلب الترويج',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'بالنقر على "إرسال طلب الترويج" فأنت ترسل تفاصيل الطلب لفريق المنصة لمراجعته.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.40),
                        fontSize: 12,
                        height: 1.6,
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
  // DECORATION
  // =========================================================
  InputDecoration _inputDecoration({
    required String hint,
    String? suffixText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.28),
        height: 1.6,
      ),
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: _gold,
        fontWeight: FontWeight.w700,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
        prefixIcon,
        color: _gold,
        size: 20,
      )
          : null,
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      errorStyle: const TextStyle(
        color: _error,
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _gold,
          width: 1.3,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: _error,
          width: 1.3,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HintBullet extends StatelessWidget {
  final String text;

  const _HintBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: Color(0xFFE5C158),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}