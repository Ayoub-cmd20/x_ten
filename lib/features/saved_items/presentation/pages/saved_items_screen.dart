import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/saved_items_service.dart';
import '../../domain/models/saved_item.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);

  SavedItemType? _selectedType;

  List<SavedItem> _getFilteredItems(List<SavedItem> items) {
    if (_selectedType == null) {
      return items;
    }

    return items.where((item) => item.type == _selectedType).toList();
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
            'العناصر المحفوظة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ValueListenableBuilder<List<SavedItem>>(
          valueListenable: SavedItemsService.instance,
          builder: (context, items, _) {
            final filteredItems = _getFilteredItems(items);

            return Column(
              children: [
                const SizedBox(height: 8),

                // ===============================
                // FILTERS
                // ===============================
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    children: [
                      _filterChip(
                        label: 'الكل',
                        icon: Icons.grid_view_rounded,
                        selected: _selectedType == null,
                        onTap: () {
                          setState(() {
                            _selectedType = null;
                          });
                        },
                      ),
                      _filterChip(
                        label: 'المؤثرون',
                        icon: Icons.people_alt_outlined,
                        selected: _selectedType == SavedItemType.influencer,
                        onTap: () {
                          setState(() {
                            _selectedType = SavedItemType.influencer;
                          });
                        },
                      ),
                      _filterChip(
                        label: 'الحملات',
                        icon: Icons.campaign_outlined,
                        selected: _selectedType == SavedItemType.campaign,
                        onTap: () {
                          setState(() {
                            _selectedType = SavedItemType.campaign;
                          });
                        },
                      ),
                      _filterChip(
                        label: 'المشاريع',
                        icon: Icons.folder_open_outlined,
                        selected: _selectedType == SavedItemType.project,
                        onTap: () {
                          setState(() {
                            _selectedType = SavedItemType.project;
                          });
                        },
                      ),
                      _filterChip(
                        label: 'المقالات',
                        icon: Icons.article_outlined,
                        selected: _selectedType == SavedItemType.article,
                        onTap: () {
                          setState(() {
                            _selectedType = SavedItemType.article;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ===============================
                // COUNT
                // ===============================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'المحفوظات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${filteredItems.length} عنصر',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.40),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ===============================
                // LIST
                // ===============================
                Expanded(
                  child: filteredItems.isEmpty
                      ? const _EmptySavedItems()
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            28,
                          ),
                          itemCount: filteredItems.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];

                            return _SavedItemCard(
                              item: item,
                              onTap: () {
                                _openItem(item);
                              },
                              onRemove: () {
                                _removeItem(item);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: 8,
      ),
      child: ChoiceChip(
        selected: selected,
        avatar: Icon(
          icon,
          size: 17,
          color: selected ? Colors.black : Colors.white54,
        ),
        label: Text(label),
        onSelected: (_) => onTap(),
        selectedColor: _gold,
        backgroundColor: _surface,
        side: BorderSide(
          color: selected
              ? _gold
              : Colors.white.withValues(alpha: 0.08),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _removeItem(SavedItem item) {
    SavedItemsService.instance.removeItem(item);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1B1B1B),
          behavior: SnackBarBehavior.floating,
          content: const Text(
            'تمت إزالة العنصر من المحفوظات',
            textDirection: TextDirection.rtl,
          ),
          action: SnackBarAction(
            label: 'تراجع',
            textColor: _gold,
            onPressed: () {
              SavedItemsService.instance.toggleSaveInfluencer(
                id: item.id,
                name: item.title,
                category: item.subtitle,
                rating: 5.0,
                totalFollowers: 0,
                imageUrl: item.imageUrl,
              );
            },
          ),
        ),
      );
  }

  void _openItem(SavedItem item) {
    switch (item.type) {
      case SavedItemType.influencer:
        context.push(
          '/advertiser/influencer-details',
          extra: item.id,
        );
        break;

      case SavedItemType.campaign:
        context.push('/advertiser/campaigns');
        break;

      case SavedItemType.project:
        context.push('/advertiser/promotion/requests');
        break;

      case SavedItemType.article:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('عرض التفاصيل'),
          ),
        );
        break;
    }
  }
}

// ==========================================================
// SAVED ITEM CARD
// ==========================================================

class _SavedItemCard extends StatelessWidget {
  final SavedItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SavedItemCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  static const Color gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: gold.withValues(alpha: 0.10),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF121212),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: gold.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            children: [
              _buildLeading(),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _typeBadge(),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.white30,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(item.savedAt),
                          style: const TextStyle(
                            color: Colors.white30,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'إزالة من المحفوظات',
                onPressed: onRemove,
                icon: const Icon(
                  Icons.bookmark_rounded,
                  color: gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          item.imageUrl!,
          width: 62,
          height: 62,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallbackIcon(),
        ),
      );
    }

    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        _iconForType(item.type),
        color: gold,
        size: 27,
      ),
    );
  }

  Widget _typeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _typeName(item.type),
        style: const TextStyle(
          color: gold,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  IconData _iconForType(SavedItemType type) {
    switch (type) {
      case SavedItemType.influencer:
        return Icons.person_outline_rounded;
      case SavedItemType.campaign:
        return Icons.campaign_outlined;
      case SavedItemType.project:
        return Icons.folder_open_outlined;
      case SavedItemType.article:
        return Icons.article_outlined;
    }
  }

  String _typeName(SavedItemType type) {
    switch (type) {
      case SavedItemType.influencer:
        return 'مؤثر';
      case SavedItemType.campaign:
        return 'حملة';
      case SavedItemType.project:
        return 'مشروع';
      case SavedItemType.article:
        return 'مقال';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ==========================================================
// EMPTY STATE
// ==========================================================

class _EmptySavedItems extends StatelessWidget {
  const _EmptySavedItems();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 64,
              color: Colors.white.withValues(alpha: 0.18),
            ),
            const SizedBox(height: 15),
            const Text(
              'لا توجد عناصر محفوظة',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'يمكنك حفظ المؤثرين والحملات والمشاريع للرجوع إليها لاحقاً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12.5,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
