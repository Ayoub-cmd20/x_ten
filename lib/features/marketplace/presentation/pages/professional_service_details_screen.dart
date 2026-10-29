import 'package:flutter/material.dart';
import 'package:x_ten/features/marketplace/domain/entities/professional_service.dart';
import 'package:x_ten/features/marketplace/presentation/pages/professional_service_request_screen.dart';

class ProfessionalServiceDetailsScreen
    extends StatelessWidget {
  final ProfessionalService service;

  const ProfessionalServiceDetailsScreen({
    super.key,
    required this.service,
  });

  static const Color _gold =
  Color(0xFFE5C158);

  static const Color _background =
  Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      TextDirection.rtl,

      child: Scaffold(
        backgroundColor: _background,

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
            'تفاصيل الخدمة',

            style: TextStyle(
              color: Colors.white,

              fontWeight:
              FontWeight.w800,
            ),
          ),
        ),

        bottomNavigationBar:
        SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.all(
              16,
            ),

            child: SizedBox(
              height: 56,

              child:
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          ProfessionalServiceRequestScreen(
                            service: service,
                          ),
                    ),
                  );
                },

                icon:
                const Icon(
                  Icons
                      .send_outlined,
                ),

                label:
                const Text(
                  'طلب هذه الخدمة',
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
                    fontWeight:
                    FontWeight
                        .w800,

                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),

        body:
        SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          padding:
          const EdgeInsets.all(
            18,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,

            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,

                  decoration:
                  BoxDecoration(
                    color:
                    _gold.withValues(
                      alpha: 0.12,
                    ),

                    borderRadius:
                    BorderRadius
                        .circular(
                      24,
                    ),

                    border:
                    Border.all(
                      color:
                      _gold.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),

                  child: Icon(
                    service.icon,

                    color: _gold,

                    size: 35,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                service.title,

                textAlign:
                TextAlign.center,

                style:
                const TextStyle(
                  color: Colors.white,

                  fontSize: 23,

                  fontWeight:
                  FontWeight
                      .w800,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                service.description,

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

              if (service.priceFrom !=
                  null) ...[
                const SizedBox(
                  height: 18,
                ),

                Container(
                  padding:
                  const EdgeInsets
                      .all(
                    14,
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
                      16,
                    ),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons
                            .payments_outlined,

                        color:
                        _gold,
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      const Text(
                        'السعر:',

                        style:
                        TextStyle(
                          color:
                          Colors.white60,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        service
                            .priceFrom!,

                        style:
                        const TextStyle(
                          color: _gold,

                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(
                height: 22,
              ),

              const Text(
                'ماذا تشمل الخدمة؟',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 17,

                  fontWeight:
                  FontWeight
                      .w800,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              ...service.features.map(
                    (feature) =>
                    Container(
                      margin:
                      const EdgeInsets
                          .only(
                        bottom: 9,
                      ),

                      padding:
                      const EdgeInsets
                          .all(
                        13,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFF151515,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons
                                .check_circle_outline_rounded,

                            color:
                            _gold,

                            size: 19,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Text(
                              feature,

                              style:
                              const TextStyle(
                                color:
                                Colors.white70,

                                height:
                                1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
