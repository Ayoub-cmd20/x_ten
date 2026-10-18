import 'package:flutter/material.dart';

import 'package:x_ten/features/marketplace/data/influencers_demo_data.dart';
import 'package:x_ten/features/marketplace/domain/models/influencer.dart';
import 'package:x_ten/features/marketplace/domain/models/influencer_category.dart';
import 'package:x_ten/features/influencer/presentation/screens/influencer_details_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/campaign_creation_screen.dart';

enum InfluencerSort {
  newest,
  highestRated,
  mostFollowers,
}

class CategoryInfluencersScreen extends StatefulWidget {
  final InfluencerCategory category;

  const CategoryInfluencersScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryInfluencersScreen> createState() =>
      _CategoryInfluencersScreenState();
}

class _CategoryInfluencersScreenState
    extends State<CategoryInfluencersScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  final TextEditingController _searchController =
  TextEditingController();

  String _search = '';
  InfluencerSort _sort = InfluencerSort.newest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Influencer> get influencers {
    final result = demoInfluencers.where((item) {
      final belongs =
          item.categoryId == widget.category.id;

      final matchesSearch =
          _search.isEmpty ||
              item.name.toLowerCase().contains(
                _search.toLowerCase(),
              ) ||
              item.city.toLowerCase().contains(
                _search.toLowerCase(),
              );

      return belongs && matchesSearch;
    }).toList();

    switch (_sort) {
      case InfluencerSort.newest:
        result.sort(
              (a, b) => b.joinDate.compareTo(a.joinDate),
        );
        break;

      case InfluencerSort.highestRated:
        result.sort(
              (a, b) => b.rating.compareTo(a.rating),
        );
        break;

      case InfluencerSort.mostFollowers:
        result.sort(
              (a, b) =>
              b.totalFollowers.compareTo(a.totalFollowers),
        );
        break;
    }

    return result;
  }

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
          title: Text(
            'مجال ${widget.category.name}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                12,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: gold,
                decoration: InputDecoration(
                  hintText: 'ابحث داخل هذا المجال...',
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: gold,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF161616),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: gold.withValues(alpha: 0.15),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: gold,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  const Text(
                    'ترتيب حسب:',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: DropdownButtonFormField<InfluencerSort>(
                      initialValue: _sort,
                      dropdownColor:
                      const Color(0xFF191919),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                        const Color(0xFF161616),
                        contentPadding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: gold.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: InfluencerSort.newest,
                          child: Text(
                            'الأحدث انضماماً',
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                          InfluencerSort.highestRated,
                          child: Text(
                            'الأعلى تقييماً',
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                          InfluencerSort.mostFollowers,
                          child: Text(
                            'الأكثر متابعين',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _sort = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: influencers.isEmpty
                  ? const Center(
                child: Text(
                  'لا يوجد مؤثرون في هذا المجال',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  24,
                ),
                itemCount: influencers.length,
                separatorBuilder:
                    (_, _) =>
                const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final influencer =
                  influencers[index];

                  return _InfluencerCard(
                    influencer: influencer,
                    onDetailsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InfluencerDetailsScreen(
                                influencer: influencer,
                              ),
                        ),
                      );
                    },
                    onAdvertiseTap: () {
                      _showAdvertisingSheet(
                        influencer,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvertisingSheet(
      Influencer influencer,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ابدأ الإشهار مع ${influencer.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'أنشئ طلباً إعلانياً وحدد نوع المحتوى والميزانية والمدة.',
                    style: TextStyle(
                      color: Colors.white54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Close BottomSheet
                        Navigator.pop(sheetContext);

                        // Open Campaign Creation Screen
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
                      },
                      icon: const Icon(
                        Icons.campaign_outlined,
                      ),
                      label: const Text(
                        'إنشاء حملة إشهارية',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfluencerCard extends StatelessWidget {
  final Influencer influencer;
  final VoidCallback onDetailsTap;
  final VoidCallback onAdvertiseTap;

  const _InfluencerCard({
    required this.influencer,
    required this.onDetailsTap,
    required this.onAdvertiseTap,
  });

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1C1C1C),
            Color(0xFF121212),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: gold.withValues(alpha: 0.17),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(16),
                  child: Image.network(
                    influencer.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, _, _) =>
                        Container(
                          width: 72,
                          height: 72,
                          color:
                          const Color(0xFF252525),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white38,
                          ),
                        ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        influencer.name,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        influencer.category,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: gold,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 17,
                            color: gold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            influencer.rating
                                .toStringAsFixed(1),
                            style:
                            const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Icon(
                            Icons
                                .location_on_outlined,
                            size: 15,
                            color: Colors.white38,
                          ),
                          const SizedBox(width: 3),

                          Flexible(
                            child: Text(
                              influencer.city,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              const TextStyle(
                                color:
                                Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _stat(
                    'Instagram',
                    influencer.instagramFollowers,
                  ),
                ),
                Expanded(
                  child: _stat(
                    'TikTok',
                    influencer.tiktokFollowers,
                  ),
                ),
                Expanded(
                  child: _stat(
                    'Facebook',
                    influencer.facebookFollowers,
                  ),
                ),
                Expanded(
                  child: _stat(
                    'YouTube',
                    influencer.youtubeFollowers,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetailsTap,
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      Colors.white,
                      side: BorderSide(
                        color: Colors.white
                            .withValues(
                          alpha: 0.12,
                        ),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),
                    child: const Text(
                      'المزيد من التفاصيل',
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed:
                    influencer.isAvailable
                        ? onAdvertiseTap
                        : null,
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
                          14,
                        ),
                      ),
                    ),
                    child: Text(
                      influencer.isAvailable
                          ? 'ابدأ الإشهار'
                          : 'غير متاح',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(
      String title,
      int value,
      ) {
    return Column(
      children: [
        Text(
          _formatFollowers(value),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  String _formatFollowers(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }

    return '$value';
  }
}