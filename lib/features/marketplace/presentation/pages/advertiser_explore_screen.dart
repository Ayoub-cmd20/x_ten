import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/features/advertiser/data/advertiser_demo_data.dart';
import 'package:x_ten/features/advertiser/domain/models/advertiser_models.dart';
import 'package:x_ten/features/marketplace/presentation/widgets/influencer_card.dart';

/// Discover influencers: search by name / category / city,
/// filter by availability, sort by newest / rating / followers.
class AdvertiserExploreScreen extends StatefulWidget {
  final String? categoryId;

  const AdvertiserExploreScreen({
    super.key,
    this.categoryId,
  });

  @override
  State<AdvertiserExploreScreen> createState() =>
      _AdvertiserExploreScreenState();
}

class _AdvertiserExploreScreenState
    extends State<AdvertiserExploreScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);

  late final TextEditingController _searchController;

  String _query = '';
  String? _selectedCategoryId;
  bool _availableOnly = false;
  _SortOption _sortOption = _SortOption.newest;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedCategoryId = widget.categoryId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Influencer> get _results {
    final query = _query.trim();

    Iterable<Influencer> list = demoInfluencers;

    if (_selectedCategoryId != null) {
      list = list.where(
        (i) => i.categoryId == _selectedCategoryId,
      );
    }

    if (_availableOnly) {
      list = list.where((i) => i.isAvailable);
    }

    if (query.isNotEmpty) {
      list = list.where(
        (i) =>
            i.name.contains(query) ||
            i.category.contains(query) ||
            i.city.contains(query),
      );
    }

    final sorted = list.toList();

    switch (_sortOption) {
      case _SortOption.newest:
        sorted.sort((a, b) => b.joinDate.compareTo(a.joinDate));
        break;
      case _SortOption.highestRated:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case _SortOption.mostFollowed:
        sorted.sort(
          (a, b) => b.totalFollowers.compareTo(a.totalFollowers),
        );
        break;
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            _selectedCategoryId == null
                ? 'اكتشاف المؤثرين'
                : demoInfluencerCategories
                    .firstWhere(
                      (c) => c.id == _selectedCategoryId,
                      orElse: () => demoInfluencerCategories.first,
                    )
                    .name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            // --------------------------------------------------
            // SEARCH
            // --------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => _query = value);
                },
                cursorColor: _gold,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'ابحث بالاسم، المجال أو المدينة...',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.28),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _gold,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white38,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                  filled: true,
                  fillColor: _surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: _gold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // CATEGORY + FILTERS
            // --------------------------------------------------
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _chip(
                    label: 'الكل',
                    selected: _selectedCategoryId == null,
                    onTap: () {
                      setState(() => _selectedCategoryId = null);
                    },
                  ),
                  ...demoInfluencerCategories.map(
                    (category) => _chip(
                      label: category.name,
                      selected: _selectedCategoryId == category.id,
                      onTap: () {
                        setState(() {
                          _selectedCategoryId = category.id;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    selected: _availableOnly,
                    label: const Text('المتاحون فقط'),
                    avatar: Icon(
                      Icons.circle,
                      size: 9,
                      color: _availableOnly
                          ? Colors.black
                          : Colors.greenAccent,
                    ),
                    onSelected: (value) {
                      setState(() => _availableOnly = value);
                    },
                    selectedColor: _gold,
                    backgroundColor: _surface,
                    side: BorderSide(
                      color: _availableOnly
                          ? _gold
                          : Colors.white.withValues(alpha: 0.08),
                    ),
                    labelStyle: TextStyle(
                      color:
                          _availableOnly ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<_SortOption>(
                    initialValue: _sortOption,
                    onSelected: (option) {
                      setState(() => _sortOption = option);
                    },
                    color: const Color(0xFF1B1B1B),
                    icon: const Icon(
                      Icons.sort_rounded,
                      color: _gold,
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _SortOption.newest,
                        child: Text(
                          'الأحدث انضماماً',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: _SortOption.highestRated,
                        child: Text(
                          'الأعلى تقييماً',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem(
                        value: _SortOption.mostFollowed,
                        child: Text(
                          'الأكثر متابعة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // --------------------------------------------------
            // LIST
            // --------------------------------------------------
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد نتائج مطابقة',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: results.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final influencer = results[index];

                        return InfluencerCard(
                          influencer: influencer,
                          onTap: () {
                            context.push(
                              '/advertiser/influencer-details',
                              extra: influencer.id,
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

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
        selectedColor: _gold,
        backgroundColor: _surface,
        side: BorderSide(
          color:
              selected ? _gold : Colors.white.withValues(alpha: 0.08),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum _SortOption { newest, highestRated, mostFollowed }
