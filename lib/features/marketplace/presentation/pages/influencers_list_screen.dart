import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer/presentation/screens/influencer_details_screen.dart';
import 'package:x_ten/features/marketplace/data/demo/influencers_demo_data.dart';
import 'package:x_ten/features/marketplace/domain/entities/influencer.dart';

class InfluencersListScreen extends StatefulWidget {
  const InfluencersListScreen({super.key});

  @override
  State<InfluencersListScreen> createState() =>
      _InfluencersListScreenState();
}

class _InfluencersListScreenState
    extends State<InfluencersListScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  String _selectedCategory = 'الكل';

  final List<String> _categories = const [
    'الكل',
    'الجمال',
    'الرياضة',
    'التكنولوجيا',
    'الموضة',
    'السفر',
    'الطبخ',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Influencer> get _filteredInfluencers {
    return demoInfluencers.where((influencer) {
      final query = _searchQuery.trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
              influencer.name.toLowerCase().contains(query) ||
              influencer.category.toLowerCase().contains(query) ||
              influencer.city.toLowerCase().contains(query);

      final matchesCategory =
          _selectedCategory == 'الكل' ||
              influencer.category.contains(_selectedCategory);

      return matchesSearch && matchesCategory;
    }).toList();
  }

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
            'قائمة المؤثرين',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ================================================
              // SEARCH
              // ================================================

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
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  cursorColor: _gold,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مؤثر...',
                    hintStyle: TextStyle(
                      color:
                      Colors.white.withValues(alpha: 0.30),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: _gold,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white38,
                      ),
                    )
                        : null,
                    filled: true,
                    fillColor: _surface,
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: _gold.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: _gold,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              // ================================================
              // CATEGORY FILTER
              // ================================================

              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) =>
                  const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category =
                    _categories[index];

                    final selected =
                        category ==
                            _selectedCategory;

                    return ChoiceChip(
                      selected: selected,
                      label: Text(category),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory =
                              category;
                        });
                      },
                      backgroundColor:
                      const Color(
                        0xFF161616,
                      ),
                      selectedColor:
                      _gold,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.black
                            : Colors.white70,
                        fontWeight:
                        FontWeight.w600,
                      ),
                      side: BorderSide(
                        color: selected
                            ? _gold
                            : Colors.white
                            .withValues(
                          alpha: 0.08,
                        ),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ================================================
              // RESULTS HEADER
              // ================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'المؤثرون',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${_filteredInfluencers.length} نتيجة',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(
                          alpha: 0.45,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ================================================
              // LIST
              // ================================================

              Expanded(
                child:
                _filteredInfluencers.isEmpty
                    ? const _EmptyState()
                    : ListView.separated(
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,
                  physics:
                  const BouncingScrollPhysics(),
                  padding:
                  const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    28,
                  ),
                  itemCount:
                  _filteredInfluencers
                      .length,
                  separatorBuilder:
                      (_, _) =>
                  const SizedBox(
                    height: 14,
                  ),
                  itemBuilder:
                      (context, index) {
                    final influencer =
                    _filteredInfluencers[
                    index];

                    return InfluencerCard(
                      influencer:
                      influencer,
                      onDetailsTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                InfluencerDetailsScreen(
                                  influencer:
                                  influencer,
                                ),
                          ),
                        );
                      },
                      onAdvertiseTap: () {
                        _startAdvertising(
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
      ),
    );
  }

  void _startAdvertising(
      Influencer influencer,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Directionality(
          textDirection:
          TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.all(20),
              child: Column(
                mainAxisSize:
                MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 45,
                    height: 4,
                    margin:
                    const EdgeInsets.only(
                      bottom: 20,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white24,
                      borderRadius:
                      BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  Text(
                    'بدء حملة مع ${influencer.name}',
                    style:
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'يمكنك الآن إنشاء طلب إشهاري وتحديد الميزانية والمدة ونوع المحتوى.',
                    style: TextStyle(
                      color: Colors.white
                          .withValues(
                        alpha: 0.55,
                      ),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 52,
                    child:
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .campaign_outlined,
                      ),
                      label:
                      const Text(
                        'إنشاء حملة إشهارية',
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
                            15,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================================================================
// CARD
// ================================================================

class InfluencerCard
    extends StatelessWidget {
  final Influencer influencer;
  final VoidCallback onDetailsTap;
  final VoidCallback onAdvertiseTap;

  const InfluencerCard({
    super.key,
    required this.influencer,
    required this.onDetailsTap,
    required this.onAdvertiseTap,
  });

  static const Color _gold =
  Color(0xFFE5C158);

  String _formatNumber(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
        const LinearGradient(
          begin: Alignment.topRight,
          end:
          Alignment.bottomLeft,
          colors: [
            Color(0xFF1B1B1B),
            Color(0xFF121212),
          ],
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          _gold.withValues(
            alpha: 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withValues(
              alpha: 0.25,
            ),
            blurRadius: 14,
            offset:
            const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
        BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // IMAGE
                  ClipRRect(
                    borderRadius:
                    BorderRadius
                        .circular(16),
                    child: Image.network(
                      influencer.imageUrl,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, _, _) =>
                          Container(
                            width: 74,
                            height: 74,
                            color:
                            const Color(
                              0xFF252525,
                            ),
                            alignment:
                            Alignment.center,
                            child:
                            const Icon(
                              Icons
                                  .person_rounded,
                              color:
                              Colors.white38,
                              size: 38,
                            ),
                          ),
                    ),
                  ),

                  const SizedBox(
                    width: 14,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                influencer
                                    .name,
                                maxLines: 1,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 17,
                                  fontWeight:
                                  FontWeight
                                      .w800,
                                ),
                              ),
                            ),

                            if (influencer
                                .isAvailable)
                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                    0xFF23C875,
                                  ).withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    20,
                                  ),
                                ),
                                child:
                                const Text(
                                  'متاح',
                                  style:
                                  TextStyle(
                                    color:
                                    Color(
                                      0xFF23C875,
                                    ),
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          influencer.category,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            color: _gold,
                            fontSize: 13,
                            fontWeight:
                            FontWeight
                                .w600,
                          ),
                        ),

                        const SizedBox(
                          height: 9,
                        ),

                        Row(
                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined,
                              size: 15,
                              color:
                              Colors.white38,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Flexible(
                              child: Text(
                                influencer
                                    .city,
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

                            const SizedBox(
                              width: 12,
                            ),

                            const Icon(
                              Icons
                                  .star_rounded,
                              color: _gold,
                              size: 16,
                            ),

                            const SizedBox(
                              width: 3,
                            ),

                            Text(
                              influencer
                                  .rating
                                  .toStringAsFixed(
                                1,
                              ),
                              style:
                              const TextStyle(
                                color:
                                Colors.white70,
                                fontSize: 12,
                                fontWeight:
                                FontWeight
                                    .w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 17,
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.025,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    13,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        platform: 'FB',
                        value: _formatNumber(
                          influencer.facebookFollowers,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        platform: 'IG',
                        value: _formatNumber(
                          influencer.instagramFollowers,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        platform: 'TikTok',
                        value: _formatNumber(
                          influencer.tiktokFollowers,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        platform: 'YT',
                        value: _formatNumber(
                          influencer.youtubeFollowers,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                    OutlinedButton(
                      onPressed:
                      onDetailsTap,
                      style:
                      OutlinedButton
                          .styleFrom(
                        foregroundColor:
                        Colors.white,
                        side: BorderSide(
                          color:
                          Colors.white
                              .withValues(
                            alpha: 0.10,
                          ),
                        ),
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 13,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                        ),
                      ),
                      child:
                      const Text(
                        'التفاصيل',
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight
                              .w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child:
                    ElevatedButton(
                      onPressed:
                      influencer
                          .isAvailable
                          ? onAdvertiseTap
                          : null,
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        _gold,
                        foregroundColor:
                        Colors.black,
                        disabledBackgroundColor:
                        const Color(
                          0xFF292929,
                        ),
                        disabledForegroundColor:
                        Colors.white38,
                        elevation: 0,
                        padding:
                        const EdgeInsets
                            .symmetric(
                          vertical: 13,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                        ),
                      ),
                      child: Text(
                        influencer
                            .isAvailable
                            ? 'ابدأ الإشهار'
                            : 'غير متاح',
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                    ),
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

// ================================================================
// STAT
// ================================================================

class _StatItem
    extends StatelessWidget {
  final String platform;
  final String value;

  const _StatItem({
    required this.platform,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow:
          TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight:
            FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          platform,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// EMPTY
// ================================================================

class _EmptyState
    extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .person_search_outlined,
              color: Colors.white
                  .withValues(
                alpha: 0.20,
              ),
              size: 58,
            ),
            const SizedBox(
              height: 14,
            ),
            const Text(
              'لم يتم العثور على مؤثرين',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight:
                FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              'جرّب تغيير كلمة البحث أو التصنيف.',
              textAlign:
              TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
