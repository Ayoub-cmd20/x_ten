import 'package:flutter/material.dart';
import 'package:x_ten/features/campaigns/presentation/pages/campaign_creation_screen.dart';
import 'package:x_ten/features/marketplace/domain/entities/influencer.dart';

class InfluencerDetailsScreen
    extends StatelessWidget {
  final Influencer influencer;

  const InfluencerDetailsScreen({
    super.key,
    required this.influencer,
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

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'تفاصيل المؤثر',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
              ),
              color:
              const Color(0xFF1A1A1A),
              onSelected: (value) {},
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'report',
                  child: Text(
                    'إبلاغ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Text(
                    'حظر',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: influencer.isAvailable
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CampaignCreationScreen(
                            influencerName:
                            influencer.name,
                          ),
                    ),
                  );
                }
                    : null,
                icon: const Icon(
                  Icons.campaign_outlined,
                ),
                label: Text(
                  influencer.isAvailable
                      ? 'ابدأ إشهارك مع ${influencer.name}'
                      : 'المؤثر غير متاح حالياً',
                  overflow:
                  TextOverflow.ellipsis,
                ),
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor:
                  Colors.black,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                  ),
                  textStyle:
                  const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),

        body: SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),
          padding:
          const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            25,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              // PROFILE

              Center(
                child: Container(
                  padding:
                  const EdgeInsets.all(3),
                  decoration:
                  BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: gold,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      influencer.imageUrl,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, _, _) =>
                          Container(
                            width: 110,
                            height: 110,
                            color:
                            const Color(
                              0xFF202020,
                            ),
                            child:
                            const Icon(
                              Icons.person,
                              size: 50,
                              color:
                              Colors.white38,
                            ),
                          ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                influencer.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                influencer.category,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: gold,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: gold,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    influencer.rating
                        .toStringAsFixed(1),
                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),

              if (influencer.isAmbassador) ...[
                const SizedBox(height: 14),

                Center(
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration:
                    BoxDecoration(
                      color: gold.withValues(
                        alpha: 0.12,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color: gold.withValues(
                          alpha: 0.25,
                        ),
                      ),
                    ),
                    child: Text(
                      'سفير المنصة لمجال '
                          '${influencer.ambassadorCategory ?? ''}'
                          ' سنة '
                          '${influencer.ambassadorYear ?? ''}',
                      style:
                      const TextStyle(
                        color: gold,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 25),

              _section(
                title: 'نبذة عن المؤثر',
                child: Text(
                  influencer.bio,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'الإحصائيات',
                child: Column(
                  children: [
                    _info(
                      'Facebook',
                      _followers(
                        influencer
                            .facebookFollowers,
                      ),
                    ),
                    _info(
                      'Instagram',
                      _followers(
                        influencer
                            .instagramFollowers,
                      ),
                    ),
                    _info(
                      'TikTok',
                      _followers(
                        influencer
                            .tiktokFollowers,
                      ),
                    ),
                    _info(
                      'YouTube',
                      _followers(
                        influencer
                            .youtubeFollowers,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'معلومات عامة',
                child: Column(
                  children: [
                    _info(
                      'المدينة',
                      influencer.city,
                    ),
                    _info(
                      'تاريخ الانضمام',
                      '${influencer.joinDate.day}/'
                          '${influencer.joinDate.month}/'
                          '${influencer.joinDate.year}',
                    ),
                    _info(
                      'مشاهدات الملف',
                      '${influencer.profileViews}',
                    ),
                    _info(
                      'المعلنون المهتمون',
                      '${influencer.interestedAdvertisers}',
                    ),
                    _info(
                      'الحالة',
                      influencer.isAvailable
                          ? 'متاح للإشهار'
                          : 'غير متاح',
                    ),
                  ],
                ),
              ),

              if (influencer
                  .featuredWorks.isNotEmpty) ...[
                const SizedBox(height: 14),

                _section(
                  title: 'أهم الأعمال',
                  child: Column(
                    children: influencer
                        .featuredWorks
                        .map(
                          (work) => Padding(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 7,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .check_circle_outline,
                              size: 17,
                              color: gold,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                work,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: gold,
              fontSize: 15,
              fontWeight:
              FontWeight.w700,
            ),
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }

  Widget _info(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style:
              const TextStyle(
                color:
                Colors.white54,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign:
              TextAlign.end,
              style:
              const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _followers(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} K';
    }

    return '$value';
  }
}
