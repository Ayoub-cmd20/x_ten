import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:x_ten/features/advertiser/data/advertiser_demo_data.dart';

/// Create a new advertising campaign, optionally pre-linked
/// to a specific influencer (passed via [preselectedInfluencer]).
class CampaignCreationScreen extends StatefulWidget {
  final String? preselectedInfluencer;

  const CampaignCreationScreen({
    super.key,
    this.preselectedInfluencer,
  });

  @override
  State<CampaignCreationScreen> createState() =>
      _CampaignCreationScreenState();
}

class _CampaignCreationScreenState
    extends State<CampaignCreationScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);
  static const Color _error = Color(0xFFFF6B6B);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _budgetController;

  String? _selectedInfluencer;
  String? _selectedPlatform;
  String? _selectedContentType;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _isSubmitting = false;

  static const List<String> _platforms = [
    'Instagram',
    'TikTok',
    'YouTube',
    'Facebook',
  ];

  static const List<String> _contentTypes = [
    'فيديو قصير',
    'ريلز + ستوري',
    'صور + فيديو',
    'فيديو طويل',
    'منشور إعلاني',
    'بث مباشر',
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _budgetController = TextEditingController();

    _selectedInfluencer = widget.preselectedInfluencer;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();

    super.dispose();
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateTitle(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال عنوان الحملة';
    }

    if (text.length < 4) {
      return 'العنوان قصير جداً';
    }

    return null;
  }

  String? _validateDescription(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى كتابة وصف الحملة';
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

  // ============================================================
  // DATE PICKERS
  // ============================================================

  Future<void> _pickStartDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked;

      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = null;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final base = _startDate ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? base.add(const Duration(days: 7)),
      firstDate: base,
      lastDate: base.add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() => _endDate = picked);
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final valid = _formKey.currentState?.validate() ?? false;

    if (_selectedInfluencer == null ||
        _selectedPlatform == null ||
        _selectedContentType == null ||
        _startDate == null ||
        _endDate == null) {
      _showSnackBar(
        'يرجى اختيار المؤثر، المنصة، نوع المحتوى وتاريخ الحملة',
      );
      return;
    }

    if (!valid || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      // TODO:
      // Replace this with your API / Firebase / Supabase call.
      // Example payload:
      // {
      //   'title': _titleController.text.trim(),
      //   'description': _descriptionController.text.trim(),
      //   'influencer': _selectedInfluencer,
      //   'platform': _selectedPlatform,
      //   'contentType': _selectedContentType,
      //   'budget': double.parse(_budgetController.text.trim()),
      //   'startDate': _startDate!.toIso8601String(),
      //   'endDate': _endDate!.toIso8601String(),
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
                      'تم إنشاء الحملة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                'تم إرسال حملة "${_titleController.text.trim()}" '
                'إلى $_selectedInfluencer للمراجعة.',
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

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showSnackBar('حدث خطأ أثناء إنشاء الحملة');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1B1B1B),
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final influencerNames =
        demoInfluencers.map((i) => i.name).toList();

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
            'إنشاء حملة إشهارية',
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
                    _sectionTitle('عنوان الحملة'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      validator: _validateTitle,
                      cursorColor: _gold,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hint: 'مثال: إطلاق منتج جديد',
                        prefixIcon: Icons.title_rounded,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _sectionTitle('وصف الحملة'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      validator: _validateDescription,
                      minLines: 4,
                      maxLines: 8,
                      cursorColor: _gold,
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.6,
                      ),
                      decoration: _inputDecoration(
                        hint:
                            'اشرح أهداف الحملة، الجمهور المستهدف، '
                            'وما تتوقعه من المؤثر...',
                      ),
                    ),

                    const SizedBox(height: 18),

                    _sectionTitle('اختيار المؤثر'),
                    const SizedBox(height: 8),
                    _dropdown<String>(
                      value: _selectedInfluencer,
                      hint: 'اختر المؤثر',
                      icon: Icons.person_outline_rounded,
                      items: influencerNames,
                      onChanged: (value) {
                        setState(() => _selectedInfluencer = value);
                      },
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _sectionTitle('المنصة'),
                              const SizedBox(height: 8),
                              _dropdown<String>(
                                value: _selectedPlatform,
                                hint: 'المنصة',
                                icon: Icons.public_rounded,
                                items: _platforms,
                                onChanged: (value) {
                                  setState(
                                    () => _selectedPlatform = value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                            children: [
                              _sectionTitle('نوع المحتوى'),
                              const SizedBox(height: 8),
                              _dropdown<String>(
                                value: _selectedContentType,
                                hint: 'النوع',
                                icon: Icons.video_library_outlined,
                                items: _contentTypes,
                                onChanged: (value) {
                                  setState(
                                    () =>
                                        _selectedContentType = value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _sectionTitle('الميزانية'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _budgetController,
                      validator: _validateBudget,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      cursorColor: _gold,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]'),
                        ),
                      ],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDecoration(
                        hint: 'مثال: 100000',
                        suffixText: 'دج',
                        prefixIcon: Icons.payments_outlined,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: _dateTile(
                            label: 'تاريخ البدء',
                            date: _startDate,
                            onTap: _pickStartDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _dateTile(
                            label: 'تاريخ الانتهاء',
                            date: _endDate,
                            onTap: _pickEndDate,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submit,
                        icon: const Icon(Icons.send_rounded),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: _isSubmitting
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'إرسال الحملة',
                                  key: ValueKey('text'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                        ),
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

  // ============================================================
  // WIDGETS
  // ============================================================

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

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: _gold, size: 19),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  hint,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _gold,
          ),
          dropdownColor: const Color(0xFF1B1B1B),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    '$item',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(label),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: _gold,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      date == null
                          ? 'اختر التاريخ'
                          : '${date.day}/${date.month}/${date.year}',
                      style: TextStyle(
                        color: date == null
                            ? Colors.white.withValues(alpha: 0.35)
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

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
          ? Icon(prefixIcon, color: _gold, size: 20)
          : null,
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      errorStyle: const TextStyle(color: _error, fontSize: 12),
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
        borderSide: const BorderSide(color: _gold, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _error, width: 1.3),
      ),
    );
  }
}
