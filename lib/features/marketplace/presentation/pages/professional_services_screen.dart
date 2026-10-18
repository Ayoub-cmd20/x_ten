import 'package:flutter/material.dart';

import 'package:x_ten/features/marketplace/data/professional_services_data.dart';
import 'package:x_ten/features/marketplace/domain/models/professional_service.dart';
import 'package:x_ten/features/marketplace/presentation/pages/professional_service_details_screen.dart';

class ProfessionalServicesScreen extends StatelessWidget {
  const ProfessionalServicesScreen({
    super.key,
  });

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

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
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'خدمات المنصة الاحترافية',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  30,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 180,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final service =
                      professionalServices[index];

                      return _ServiceCard(
                        service: service,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProfessionalServiceDetailsScreen(
                                    service: service,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                    childCount:
                    professionalServices.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        20,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _gold.withValues(alpha: 0.14),
            _gold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: _gold.withValues(
            alpha: 0.20,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                color: _gold,
                size: 28,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  'حلول احترافية لتنمية أعمالك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'اختر الخدمة التي تناسب احتياجاتك، '
                'وسيتولى فريق X Ten مساعدتك في التخطيط والتنفيذ والمتابعة.',
            style: TextStyle(
              color: Colors.white
                  .withValues(alpha: 0.60),
              fontSize: 13.5,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard
    extends StatelessWidget {
  final ProfessionalService service;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.onTap,
  });

  static const Color _gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius:
      BorderRadius.circular(18),

      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(18),
        splashColor:
        _gold.withValues(alpha: 0.12),

        child: Ink(
          padding:
          const EdgeInsets.all(14),

          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topRight,
              end:
              Alignment.bottomLeft,
              colors: [
                Color(0xFF1C1C1C),
                Color(0xFF121212),
              ],
            ),

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color:
              _gold.withValues(
                alpha: 0.16,
              ),
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Container(
                width: 44,
                height: 44,

                decoration:
                BoxDecoration(
                  color:
                  _gold.withValues(
                    alpha: 0.12,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),

                child: Icon(
                  service.icon,
                  color: _gold,
                  size: 22,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                service.title,

                maxLines: 2,

                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w700,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 7),

              Expanded(
                child: Text(
                  service
                      .shortDescription,

                  maxLines: 3,

                  overflow:
                  TextOverflow
                      .ellipsis,

                  style:
                  const TextStyle(
                    color:
                    Colors.white54,

                    fontSize: 11.5,

                    height: 1.45,
                  ),
                ),
              ),

              Row(
                children: [
                  if (service
                      .priceFrom !=
                      null)
                    Expanded(
                      child: Text(
                        'ابتداءً من ${service.priceFrom}',
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
                        style:
                        const TextStyle(
                          color: _gold,
                          fontSize: 10,
                          fontWeight:
                          FontWeight
                              .w700,
                        ),
                      ),
                    ),

                  const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    color:
                    Colors.white30,
                    size: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}