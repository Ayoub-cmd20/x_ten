import 'package:flutter/material.dart';

import '../../domain/models/verification_status.dart';
import 'package:go_router/go_router.dart';

class VerificationStatusScreen
    extends StatefulWidget {
  final String registrationId;

  const VerificationStatusScreen({
    super.key,
    required this.registrationId,
  });

  @override
  State<VerificationStatusScreen>
  createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState
    extends State<VerificationStatusScreen> {
  static const Color gold =
  Color(0xFFE5C158);

  static const Color background =
  Color(0xFF0A0A0A);

  InfluencerVerificationStatus _status =
      InfluencerVerificationStatus
          .submitted;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    // في النسخة الحقيقية سيأتي Repository
    // من Provider / Riverpod / GetIt أو DI.
  }

  Future<void> _refreshStatus() async {
    setState(() {
      _loading = true;
    });

    await Future.delayed(
      const Duration(
        milliseconds: 700,
      ),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  bool _isCompleted(
      InfluencerVerificationStatus target,
      ) {
    final order = [
      InfluencerVerificationStatus
          .submitted,
      InfluencerVerificationStatus
          .underReview,
      InfluencerVerificationStatus
          .meetingRequired,
      InfluencerVerificationStatus
          .meetingScheduled,
      InfluencerVerificationStatus
          .verified,
    ];

    final currentIndex =
    order.indexOf(_status);

    final targetIndex =
    order.indexOf(target);

    if (currentIndex == -1 ||
        targetIndex == -1) {
      return false;
    }

    return currentIndex >
        targetIndex;
  }

  bool _isCurrent(
      InfluencerVerificationStatus status,
      ) {
    return _status == status;
  }

  Widget _statusItem({
    required String title,
    required String subtitle,
    required InfluencerVerificationStatus
    status,
  }) {
    final completed =
    _isCompleted(status);

    final current =
    _isCurrent(status);

    Color color;

    IconData icon;

    if (completed) {
      color = Colors.green;
      icon =
          Icons.check_circle_rounded;
    } else if (current) {
      color = gold;
      icon =
          Icons.radio_button_checked;
    } else {
      color = Colors.white24;
      icon =
          Icons.radio_button_unchecked;
    }

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
        BorderRadius.circular(16),
        border: Border.all(
          color: current
              ? gold.withValues(
            alpha: 0.25,
          )
              : Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: current
                        ? gold
                        : Colors.white,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style:
                  const TextStyle(
                    color:
                    Colors.white38,
                    fontSize: 11,
                    height: 1.4,
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
    final meetingReady =
        _status ==
            InfluencerVerificationStatus
                .meetingScheduled ||
            _status ==
                InfluencerVerificationStatus
                    .meetingRequired;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,

          title: const Text(
            'حالة التوثيق',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          iconTheme:
          const IconThemeData(
            color: Colors.white,
          ),

          actions: [
            IconButton(
              tooltip:
              'تحديث الحالة',
              onPressed:
              _loading
                  ? null
                  : _refreshStatus,
              icon: _loading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: gold,
                ),
              )
                  : const Icon(
                Icons.refresh_rounded,
                color: gold,
              ),
            ),
          ],
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
                  16,
                ),
                decoration:
                BoxDecoration(
                  color:
                  gold.withValues(
                    alpha: 0.06,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    17,
                  ),
                  border: Border.all(
                    color:
                    gold.withValues(
                      alpha: 0.13,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    const Text(
                      'طلب تسجيل المؤثر',
                      style:
                      TextStyle(
                        color:
                        Colors.white54,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      widget.registrationId,
                      style:
                      const TextStyle(
                        color: gold,
                        fontSize: 16,
                        fontWeight:
                        FontWeight
                            .w800,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      _status.arabicName,
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

              const SizedBox(height: 22),

              _statusItem(
                title:
                'إرسال طلب التسجيل',
                subtitle:
                'تم إرسال بياناتك والوثائق إلى إدارة X Ten.',
                status:
                InfluencerVerificationStatus
                    .submitted,
              ),

              _statusItem(
                title:
                'مراجعة المعلومات',
                subtitle:
                'يقوم فريق المنصة بمراجعة المعلومات والحسابات والوثائق.',
                status:
                InfluencerVerificationStatus
                    .underReview,
              ),

              _statusItem(
                title:
                'التحضير لاجتماع التوثيق',
                subtitle:
                'سيتم التواصل معك لتأكيد موعد مكالمة الفيديو.',
                status:
                InfluencerVerificationStatus
                    .meetingRequired,
              ),

              _statusItem(
                title:
                'تم تحديد موعد الاجتماع',
                subtitle:
                'يمكنك الاطلاع على التاريخ والساعة وتعليمات الاجتماع.',
                status:
                InfluencerVerificationStatus
                    .meetingScheduled,
              ),

              _statusItem(
                title:
                'الحساب موثق',
                subtitle:
                'بعد نجاح عملية التحقق يتم تفعيل حساب المؤثر بالكامل.',
                status:
                InfluencerVerificationStatus
                    .verified,
              ),

              const SizedBox(height: 20),

              if (meetingReady)
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '/influencer-verification/meeting',
                        extra: widget.registrationId,
                      );
                    },
                    icon: const Icon(
                      Icons.video_call_outlined,
                    ),
                    label: const Text(
                      'عرض موعد اجتماع التوثيق',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFE5C158),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

              if (_status ==
                  InfluencerVerificationStatus
                      .needsChanges)
                _messageCard(
                  icon:
                  Icons.edit_note_rounded,
                  title:
                  'مطلوب تعديل المعلومات',
                  text:
                  'يرجى مراجعة المعلومات المطلوبة وإعادة إرسالها.',
                  color: Colors.orange,
                ),

              if (_status ==
                  InfluencerVerificationStatus
                      .rejected)
                _messageCard(
                  icon:
                  Icons.cancel_outlined,
                  title:
                  'تعذر قبول الطلب',
                  text:
                  'راجع رسالة الإدارة لمعرفة التفاصيل والخطوات الممكنة.',
                  color:
                  Colors.redAccent,
                ),
     /*         if (_status ==
                  InfluencerVerificationStatus.verified)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 18,
                  ),
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.go(
                          '/creator/home',
                        );
                      },
                      icon: const Icon(
                        Icons.dashboard_outlined,
                      ),
                      label: const Text(
                        'الدخول إلى حساب المؤثر',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFFE5C158),
                        foregroundColor:
                        Colors.black,
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
              const SizedBox(height: 20),

              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.goNamed('creatorHome');
                  },
                  icon: const Icon(
                    Icons.dashboard_rounded,
                    size: 22,
                  ),
                  label: const Text(
                    'الدخول إلى لوحة التحكم',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5C158),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

  Widget _messageCard({
    required IconData icon,
    required String title,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color:
        color.withValues(
          alpha: 0.08,
        ),
        borderRadius:
        BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style:
                  const TextStyle(
                    color:
                    Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}