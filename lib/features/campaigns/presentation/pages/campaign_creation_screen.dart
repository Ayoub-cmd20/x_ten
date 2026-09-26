import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampaignCreationScreen extends StatefulWidget {
  final String? influencerName;

  const CampaignCreationScreen({
    super.key,
    this.influencerName,
  });

  @override
  State<CampaignCreationScreen> createState() =>
      _CampaignCreationScreenState();
}

class _CampaignCreationScreenState
    extends State<CampaignCreationScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF161616);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _budgetController;

  DateTime? _startDate;
  DateTime? _endDate;

  String _contentType = 'منشور';
  String _platform = 'Instagram';

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController();

    _descriptionController =
        TextEditingController();

    _budgetController =
        TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
      DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null) return;

    setState(() {
      _startDate = date;

      if (_endDate != null &&
          _endDate!.isBefore(date)) {
        _endDate = null;
      }
    });
  }

  Future<void> _selectEndDate() async {
    final firstDate =
        _startDate ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: firstDate.add(
        const Duration(days: 1),
      ),
      firstDate: firstDate,
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null) return;

    setState(() {
      _endDate = date;
    });
  }

  Future<void> _submitCampaign() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final valid =
        _formKey.currentState?.validate() ?? false;

    if (!valid) return;

    if (_startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى تحديد تاريخ بداية ونهاية الحملة',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection:
            TextDirection.rtl,
            child: AlertDialog(
              backgroundColor:
              const Color(0xFF171717),
              title: const Text(
                'تم إنشاء الحملة',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: const Text(
                'تم إنشاء الحملة الإشهارية بنجاح وسيتم إرسالها للمراجعة.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'حسناً',
                    style: TextStyle(
                      color: _gold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        backgroundColor: _background,

        appBar: AppBar(
          backgroundColor: _background,
          centerTitle: true,
          elevation: 0,
          iconTheme:
          const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'إنشاء حملة إشهارية',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  if (widget.influencerName != null)
                    Container(
                      padding:
                      const EdgeInsets.all(14),
                      margin:
                      const EdgeInsets.only(
                        bottom: 18,
                      ),
                      decoration:
                      BoxDecoration(
                        color: _gold.withValues(
                          alpha: 0.09,
                        ),
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color: _gold.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            color: _gold,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'الحملة مع ${widget.influencerName}',
                              style:
                              const TextStyle(
                                color:
                                Colors.white,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _label('عنوان الحملة'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                    _titleController,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'يرجى إدخال عنوان الحملة';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _decoration(
                      'مثال: حملة إطلاق منتج جديد',
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('وصف الحملة'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                    _descriptionController,
                    minLines: 5,
                    maxLines: 8,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length < 20) {
                        return 'يرجى كتابة وصف واضح للحملة';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: _decoration(
                      'اكتب الهدف، المنتج، الجمهور المستهدف والمتطلبات...',
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('المنصة'),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    initialValue: _platform,
                    dropdownColor:
                    const Color(0xFF1A1A1A),
                    decoration:
                    _decoration(''),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Instagram',
                        child: Text('Instagram'),
                      ),
                      DropdownMenuItem(
                        value: 'TikTok',
                        child: Text('TikTok'),
                      ),
                      DropdownMenuItem(
                        value: 'Facebook',
                        child: Text('Facebook'),
                      ),
                      DropdownMenuItem(
                        value: 'YouTube',
                        child: Text('YouTube'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _platform = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  _label('نوع المحتوى'),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    initialValue:
                    _contentType,
                    dropdownColor:
                    const Color(0xFF1A1A1A),
                    decoration:
                    _decoration(''),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'منشور',
                        child: Text('منشور'),
                      ),
                      DropdownMenuItem(
                        value: 'Story',
                        child: Text('Story'),
                      ),
                      DropdownMenuItem(
                        value: 'Reel',
                        child: Text('Reel'),
                      ),
                      DropdownMenuItem(
                        value: 'فيديو',
                        child: Text('فيديو'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _contentType = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 18),

                  _label('الميزانية'),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller:
                    _budgetController,
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
                        return 'يرجى إدخال ميزانية صحيحة';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration:
                    _decoration(
                      '50000',
                      suffix: 'دج',
                    ),
                  ),

                  const SizedBox(height: 18),

                  _label('مدة الحملة'),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _dateButton(
                          label:
                          _startDate == null
                              ? 'تاريخ البداية'
                              : _formatDate(
                            _startDate!,
                          ),
                          onTap:
                          _selectStartDate,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _dateButton(
                          label:
                          _endDate == null
                              ? 'تاريخ النهاية'
                              : _formatDate(
                            _endDate!,
                          ),
                          onTap:
                          _selectEndDate,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child:
                    ElevatedButton.icon(
                      onPressed:
                      _isSubmitting
                          ? null
                          : _submitCampaign,
                      icon: _isSubmitting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                          : const Icon(
                        Icons
                            .campaign_outlined,
                      ),
                      label: Text(
                        _isSubmitting
                            ? 'جاري الإنشاء...'
                            : 'إنشاء الحملة',
                      ),
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        _gold,
                        foregroundColor:
                        Colors.black,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(16),
                        ),
                        textStyle:
                        const TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight
                              .w800,
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
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }

  InputDecoration _decoration(
      String hint, {
        String? suffix,
      }) {
    return InputDecoration(
      hintText: hint,
      suffixText: suffix,
      suffixStyle: const TextStyle(
        color: _gold,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: const TextStyle(
        color: Colors.white30,
      ),
      filled: true,
      fillColor: _surface,
      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        BorderSide.none,
      ),
      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white
              .withValues(
            alpha: 0.06,
          ),
        ),
      ),
      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(16),
        borderSide:
        const BorderSide(
          color: _gold,
          width: 1.3,
        ),
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _surface,
      borderRadius:
      BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),
        child: Container(
          height: 54,
          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white
                  .withValues(
                alpha: 0.06,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons
                    .calendar_month_outlined,
                color: _gold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(
      DateTime date,
      ) {
    return '${date.day}/${date.month}/${date.year}';
  }
}