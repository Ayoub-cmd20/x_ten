import 'package:flutter/material.dart';

class VerificationMeetingScreen
    extends StatefulWidget {
  final String registrationId;

  const VerificationMeetingScreen({
    super.key,
    required this.registrationId,
  });

  @override
  State<VerificationMeetingScreen>
  createState() =>
      _VerificationMeetingScreenState();
}

class _VerificationMeetingScreenState
    extends State<VerificationMeetingScreen> {
  static const Color gold =
  Color(0xFFE5C158);

  static const Color background =
  Color(0xFF0A0A0A);

  // Demo data.
  final DateTime meetingDate =
  DateTime(
    2026,
    10,
    28,
    14,
    30,
  );

  String get formattedDate {
    return '${meetingDate.day.toString().padLeft(2, '0')}/'
        '${meetingDate.month.toString().padLeft(2, '0')}/'
        '${meetingDate.year}';
  }

  String get formattedTime {
    return '${meetingDate.hour.toString().padLeft(2, '0')}:'
        '${meetingDate.minute.toString().padLeft(2, '0')}';
  }

  Future<void>
  _requestReschedule() async {
    final reasonController =
    TextEditingController();

    final result =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection:
          TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
            const Color(
              0xFF171717,
            ),

            title: const Text(
              'طلب تغيير الموعد',
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            content: TextField(
              controller:
              reasonController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration:
              InputDecoration(
                hintText:
                'اذكر سبب طلب تغيير الموعد...',
                hintStyle:
                const TextStyle(
                  color:
                  Colors.white30,
                ),
                filled: true,
                fillColor:
                const Color(
                  0xFF202020,
                ),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    14,
                  ),
                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                    false,
                  );
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color:
                    Colors.white54,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if (reasonController
                      .text
                      .trim()
                      .isEmpty) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    true,
                  );
                },
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  gold,
                  foregroundColor:
                  Colors.black,
                ),
                child: const Text(
                  'إرسال الطلب',
                ),
              ),
            ],
          ),
        );
      },
    );

    reasonController.dispose();

    if (!mounted ||
        result != true) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          Color(0xFF1B1B1B),
          content: Text(
            'تم إرسال طلب تغيير الموعد إلى إدارة X Ten.',
            textDirection:
            TextDirection.rtl,
          ),
        ),
      );
  }

  void _joinMeeting() {
   ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          behavior:
          SnackBarBehavior.floating,
          backgroundColor:
          Color(0xFF1B1B1B),
          content: Text(
            'سيتم تفعيل رابط الاجتماع من طرف إدارة X Ten.',
            textDirection:
            TextDirection.rtl,
          ),
        ),
      );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
        const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white
              .withValues(
            alpha: 0.05,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
            BoxDecoration(
              color:
              gold.withValues(
                alpha: 0.09,
              ),
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                  const TextStyle(
                    color:
                    Colors.white38,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontWeight:
                    FontWeight
                        .w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor:
          background,
          elevation: 0,

          iconTheme:
          const IconThemeData(
            color: Colors.white,
          ),

          title: const Text(
            'اجتماع التوثيق',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),

        body:
        SingleChildScrollView(
          padding:
          const EdgeInsets.all(
            18,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Container(
                padding:
                const EdgeInsets.all(
                  22,
                ),
                decoration:
                BoxDecoration(
                  gradient:
                  LinearGradient(
                    begin:
                    Alignment.topRight,
                    end: Alignment
                        .bottomLeft,
                    colors: [
                      gold.withValues(
                        alpha: 0.15,
                      ),
                      const Color(
                        0xFF151515,
                      ),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    22,
                  ),
                  border: Border.all(
                    color:
                    gold.withValues(
                      alpha: 0.18,
                    ),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons
                          .video_call_rounded,
                      color: gold,
                      size: 60,
                    ),

                    SizedBox(height: 12),

                    Text(
                      'مكالمة فيديو لتوثيق الحساب',
                      textAlign:
                      TextAlign.center,
                      style:
                      TextStyle(
                        color:
                        Colors.white,
                        fontSize: 19,
                        fontWeight:
                        FontWeight
                            .w800,
                      ),
                    ),

                    SizedBox(height: 7),

                    Text(
                      'سيقوم فريق X Ten بالتأكد من الهوية والوثائق والمعلومات المقدمة.',
                      textAlign:
                      TextAlign.center,
                      style:
                      TextStyle(
                        color: Colors
                            .white54,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _infoCard(
                icon:
                Icons.person_outline,
                label:
                'الاجتماع مع',
                value:
                'مدير منصة X Ten',
              ),

              _infoCard(
                icon: Icons
                    .calendar_month_outlined,
                label: 'التاريخ',
                value:
                formattedDate,
              ),

              _infoCard(
                icon: Icons
                    .access_time_rounded,
                label: 'الساعة',
                value:
                formattedTime,
              ),

              _infoCard(
                icon:
                Icons.videocam_outlined,
                label:
                'نوع الاجتماع',
                value:
                'مكالمة فيديو',
              ),

              const SizedBox(height: 10),

              Container(
                padding:
                const EdgeInsets.all(
                  17,
                ),
                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xFF151515,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    17,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons
                              .assignment_outlined,
                          color: gold,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'ما يجب تحضيره',
                          style:
                          TextStyle(
                            color:
                            Colors.white,
                            fontWeight:
                            FontWeight
                                .w800,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14),

                    _MeetingRequirement(
                      text:
                      'بطاقة التعريف الوطنية الأصلية',
                    ),

                    _MeetingRequirement(
                      text:
                      'Chèque CCP barré أو RIB البنكي الأصلي',
                    ),

                    _MeetingRequirement(
                      text:
                      'الهاتف أو الحاسوب مع كاميرا وميكروفون',
                    ),

                    _MeetingRequirement(
                      text:
                      'اتصال إنترنت مستقر',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 55,
                child:
                ElevatedButton.icon(
                  onPressed:
                  _joinMeeting,
                  icon: const Icon(
                    Icons
                        .video_call_rounded,
                  ),
                  label: const Text(
                    'دخول الاجتماع',
                  ),
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    gold,
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
                      fontWeight:
                      FontWeight
                          .w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 52,
                child:
                OutlinedButton.icon(
                  onPressed:
                  _requestReschedule,
                  icon: const Icon(
                    Icons
                        .calendar_month_outlined,
                  ),
                  label: const Text(
                    'طلب تغيير الموعد',
                  ),
                  style:
                  OutlinedButton
                      .styleFrom(
                    foregroundColor:
                    gold,
                    side:
                    BorderSide(
                      color:
                      gold.withValues(
                        alpha: 0.30,
                      ),
                    ),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'رقم الطلب: ${widget.registrationId}',
                textAlign:
                TextAlign.center,
                style: const TextStyle(
                  color:
                  Colors.white24,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetingRequirement
    extends StatelessWidget {
  final String text;

  const _MeetingRequirement({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_rounded,
            color:
            Color(0xFFE5C158),
            size: 18,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color:
                Colors.white60,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}