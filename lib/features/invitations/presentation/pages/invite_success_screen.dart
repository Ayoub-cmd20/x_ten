import 'package:flutter/material.dart';

import '../../domain/models/invitation_type.dart';

class InviteSuccessScreen extends StatelessWidget {
  final String name;
  final InvitationType invitationType;

  const InviteSuccessScreen({
    super.key,
    required this.name,
    required this.invitationType,
  });

  static const Color gold =
  Color(0xFFE5C158);

  static const Color background =
  Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        background,
        body: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.all(
              24,
            ),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration:
                  BoxDecoration(
                    color:
                    gold.withValues(
                      alpha: 0.12,
                    ),
                    shape:
                    BoxShape.circle,
                    border:
                    Border.all(
                      color: gold,
                      width: 2,
                    ),
                  ),
                  child:
                  const Icon(
                    Icons
                        .check_rounded,
                    color: gold,
                    size: 48,
                  ),
                ),

                const SizedBox(
                  height: 26,
                ),

                const Text(
                  'تم إرسال الدعوة',
                  textAlign:
                  TextAlign.center,
                  style:
                  TextStyle(
                    color:
                    Colors.white,
                    fontSize: 24,
                    fontWeight:
                    FontWeight
                        .w800,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'تم إرسال دعوة إلى $name للانضمام إلى المنصة كـ ${invitationType.arabicName}.',
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color:
                    Colors.white60,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'يمكنك متابعة حالة الدعوة لاحقاً من قسم "دعواتي".',
                  textAlign:
                  TextAlign.center,
                  style:
                  TextStyle(
                    color:
                    gold.withValues(
                      alpha: 0.80,
                    ),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 36,
                ),

                SizedBox(
                  width:
                  double.infinity,
                  height: 54,
                  child:
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).popUntil(
                            (route) =>
                        route.isFirst,
                      );
                    },
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
                    ),
                    child:
                    const Text(
                      'العودة للرئيسية',
                      style:
                      TextStyle(
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
    );
  }
}
