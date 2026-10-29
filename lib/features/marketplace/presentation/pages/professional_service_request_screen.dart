import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_ten/features/marketplace/domain/entities/professional_service.dart';

class ProfessionalServiceRequestScreen
    extends StatefulWidget {
  final ProfessionalService service;

  const ProfessionalServiceRequestScreen({
    super.key,
    required this.service,
  });

  @override
  State<ProfessionalServiceRequestScreen>
  createState() =>
      _ProfessionalServiceRequestScreenState();
}

class _ProfessionalServiceRequestScreenState
    extends State<ProfessionalServiceRequestScreen> {
  static const Color _gold =
  Color(0xFFE5C158);

  static const Color _background =
  Color(0xFF0A0A0A);

  static const Color _surface =
  Color(0xFF161616);

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController
  _descriptionController =
  TextEditingController();

  final TextEditingController
  _budgetController =
  TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _budgetController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus
        ?.unfocus();

    if (!(_formKey.currentState
        ?.validate() ??
        false)) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // TODO:
      // Send request to API.

      await Future.delayed(
        const Duration(seconds: 2),
      );

      if (!mounted) return;

      await showDialog(
        context: context,

        builder: (_) =>
            Directionality(
              textDirection:
              TextDirection.rtl,

              child: AlertDialog(
                backgroundColor:
                const Color(
                  0xFF171717,
                ),

                title:
                const Text(
                  'تم إرسال الطلب',

                  style: TextStyle(
                    color:
                    Colors.white,
                  ),
                ),

                content:
                Text(
                  'تم إرسال طلب خدمة '
                      '"${widget.service.title}" '
                      'بنجاح وسيتم التواصل معك بعد مراجعة التفاصيل.',

                  style:
                  const TextStyle(
                    color:
                    Colors.white70,

                    height: 1.6,
                  ),
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );

                      Navigator.pop(
                        context,
                      );
                    },

                    child:
                    const Text(
                      'حسناً',

                      style:
                      TextStyle(
                        color:
                        _gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Directionality(
      textDirection:
      TextDirection.rtl,

      child: Scaffold(
        backgroundColor:
        _background,

        appBar: AppBar(
          backgroundColor:
          _background,

          elevation: 0,

          centerTitle: true,

          iconTheme:
          const IconThemeData(
            color: Colors.white,
          ),

          title: const Text(
            'طلب خدمة احترافية',

            style: TextStyle(
              color: Colors.white,

              fontWeight:
              FontWeight
                  .w800,
            ),
          ),
        ),

        body:
        SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets.all(
              16,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .stretch,

                children: [
                  Container(
                    padding:
                    const EdgeInsets
                        .all(
                      16,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      _gold.withValues(
                        alpha: 0.08,
                      ),

                      borderRadius:
                      BorderRadius
                          .circular(
                        18,
                      ),

                      border:
                      Border.all(
                        color:
                        _gold.withValues(
                          alpha: 0.18,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          widget
                              .service
                              .icon,

                          color:
                          _gold,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            widget
                                .service
                                .title,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  const Text(
                    'تفاصيل الطلب',

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight
                          .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _descriptionController,

                    minLines: 7,

                    maxLines: 12,

                    validator:
                        (value) {
                      if (value ==
                          null ||
                          value
                              .trim()
                              .length <
                              20) {
                        return 'يرجى كتابة تفاصيل الطلب بشكل أوضح';
                      }

                      return null;
                    },

                    style:
                    const TextStyle(
                      color:
                      Colors.white,

                      height: 1.6,
                    ),

                    cursorColor:
                    _gold,

                    decoration:
                    _decoration(
                      'اشرح احتياجاتك وأهدافك...',
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    'الميزانية المتوقعة',

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight
                          .w700,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    controller:
                    _budgetController,

                    keyboardType:
                    TextInputType
                        .number,

                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly,
                    ],

                    validator:
                        (value) {
                      final amount =
                      double
                          .tryParse(
                        value ?? '',
                      );

                      if (amount ==
                          null ||
                          amount <= 0) {
                        return 'يرجى إدخال ميزانية صحيحة';
                      }

                      return null;
                    },

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    _decoration(
                      '50000',

                      suffix: 'دج',
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    height: 56,

                    child:
                    ElevatedButton.icon(
                      onPressed:
                      _loading
                          ? null
                          : _submit,

                      icon: _loading
                          ? const SizedBox(
                        width:
                        20,
                        height:
                        20,

                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          2,

                          color:
                          Colors.black,
                        ),
                      )
                          : const Icon(
                        Icons
                            .send_outlined,
                      ),

                      label: Text(
                        _loading
                            ? 'جاري الإرسال...'
                            : 'إرسال الطلب',
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
                              .circular(
                            16,
                          ),
                        ),

                        textStyle:
                        const TextStyle(
                          fontSize: 15,

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

  InputDecoration _decoration(
      String hint, {
        String? suffix,
      }) {
    return InputDecoration(
      hintText: hint,

      suffixText: suffix,

      suffixStyle:
      const TextStyle(
        color: _gold,

        fontWeight:
        FontWeight.w700,
      ),

      hintStyle:
      const TextStyle(
        color:
        Colors.white30,
      ),

      filled: true,

      fillColor:
      _surface,

      contentPadding:
      const EdgeInsets.all(
        16,
      ),

      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          16,
        ),

        borderSide:
        BorderSide.none,
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          16,
        ),

        borderSide:
        BorderSide(
          color: Colors.white
              .withValues(
            alpha: 0.07,
          ),
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          16,
        ),

        borderSide:
        const BorderSide(
          color: _gold,

          width: 1.3,
        ),
      ),

      errorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          16,
        ),

        borderSide:
        const BorderSide(
          color:
          Colors.redAccent,
        ),
      ),
    );
  }
}
