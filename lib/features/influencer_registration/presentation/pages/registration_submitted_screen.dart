import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationSubmittedScreen
    extends StatelessWidget {
  final String registrationId;

  const RegistrationSubmittedScreen({
    super.key,
    required this.registrationId,
  });

  static const Color gold =
  Color(0xFFE5C158);

  static const Color background =
  Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        body: SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 45),

                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color:
                    gold.withValues(
                      alpha: 0.12,
                    ),
                    shape:
                    BoxShape.circle,
                    border: Border.all(
                      color:
                      gold.withValues(
                        alpha: 0.30,
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons
                        .check_circle_outline_rounded,
                    color: gold,
                    size: 52,
                  ),
                ),

                const SizedBox(height: 26),

                const Text(
                  'تم تسجيل طلبك بنجاح',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'شكراً لانضمامك إلى منصة X Ten.',
                  textAlign:
                  TextAlign.center,
                  style: TextStyle(
                    color: gold,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    18,
                  ),
                  decoration:
                  BoxDecoration(
                    color: const Color(
                      0xFF151515,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: const Text(
                    'سيتم مراجعة المعلومات والوثائق المقدمة من طرف فريق X Ten.\n\n'
                        'بعد المراجعة سيتم التواصل معك وبرمجة اجتماع عبر مكالمة فيديو مع إدارة المنصة للتأكد من صحة المعلومات المقدمة وإتمام عملية التوثيق.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 14,
                      height: 1.8,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    18,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    gold.withValues(
                      alpha: 0.06,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),
                    border: Border.all(
                      color:
                      gold.withValues(
                        alpha: 0.16,
                      ),
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
                                .folder_copy_outlined,
                            color: gold,
                            size: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'الوثائق المطلوبة أثناء الاجتماع',
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

                      _RequirementItem(
                        text:
                        'بطاقة التعريف الوطنية الأصلية',
                      ),

                      _RequirementItem(
                        text:
                        'Chèque CCP barré أو RIB البنكي',
                      ),

                      _RequirementItem(
                        text:
                        'أي وثيقة إضافية تطلبها إدارة المنصة',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width:
                  double.infinity,
                  padding:
                  const EdgeInsets.all(
                    15,
                  ),
                  decoration:
                  BoxDecoration(
                    color: const Color(
                      0xFF161616,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .hourglass_top_rounded,
                        color:
                        Colors.orange,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'حالة الطلب',
                              style:
                              TextStyle(
                                color: Colors
                                    .white54,
                                fontSize:
                                11,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'تم إرسال الطلب',
                              style:
                              TextStyle(
                                color: Colors
                                    .white,
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
                ),

                const SizedBox(height: 12),

                Text(
                  'رقم الطلب: $registrationId',
                  style: const TextStyle(
                    color:
                    Colors.white38,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(
                        '/influencer-verification',
                        extra: registrationId,
                      );
                    },
                    icon: const Icon(
                      Icons.track_changes_rounded,
                    ),
                    label: const Text(
                      'متابعة حالة طلبي',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFE5C158),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RequirementItem
    extends StatelessWidget {
  final String text;

  const _RequirementItem({
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
            color: Color(
              0xFFE5C158,
            ),
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