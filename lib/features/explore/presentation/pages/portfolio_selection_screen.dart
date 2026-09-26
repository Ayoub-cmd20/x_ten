import 'package:flutter/material.dart';

class PortfolioSelectionScreen extends StatefulWidget {
  final Set<String> initiallySelectedIds;

  const PortfolioSelectionScreen({
    super.key,
    this.initiallySelectedIds = const {},
  });

  @override
  State<PortfolioSelectionScreen> createState() =>
      _PortfolioSelectionScreenState();
}

class _PortfolioSelectionScreenState
    extends State<PortfolioSelectionScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  late Set<String> _selectedIds;

  final List<Map<String, String>> _works = const [
    {
      'id': 'work_1',
      'title': 'حملة أزياء',
      'category': 'الموضة',
      'platform': 'Instagram',
    },
    {
      'id': 'work_2',
      'title': 'مراجعة هاتف',
      'category': 'التكنولوجيا',
      'platform': 'YouTube',
    },
    {
      'id': 'work_3',
      'title': 'حملة رياضية',
      'category': 'الرياضة',
      'platform': 'TikTok',
    },
    {
      'id': 'work_4',
      'title': 'إعلان مطعم',
      'category': 'الطبخ',
      'platform': 'Instagram',
    },
  ];

  @override
  void initState() {
    super.initState();

    _selectedIds = {
      ...widget.initiallySelectedIds,
    };
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _confirmSelection() {
    final selectedWorks = _works
        .where(
          (work) => _selectedIds.contains(work['id']),
    )
        .toList();

    Navigator.pop(
      context,
      selectedWorks,
    );
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
          title: const Text(
            'اختيار أعمال سابقة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedIds.isEmpty
                    ? null
                    : _confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor:
                  gold.withValues(alpha: 0.30),
                  disabledForegroundColor:
                  Colors.black54,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _selectedIds.isEmpty
                      ? 'اختر عملاً واحداً على الأقل'
                      : 'إضافة ${_selectedIds.length} من الأعمال',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                14,
              ),
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                  gold.withValues(alpha: 0.07),
                  borderRadius:
                  BorderRadius.circular(16),
                  border: Border.all(
                    color:
                    gold.withValues(alpha: 0.15),
                  ),
                ),
                child: const Text(
                  'اختر من أعمالك السابقة ما يناسب هذا المشروع. '
                      'سيتم إرفاق هذه الأعمال مع طلب التقديم.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  24,
                ),
                itemCount: _works.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 215,
                ),
                itemBuilder: (context, index) {
                  final work = _works[index];
                  final id = work['id']!;
                  final isSelected =
                  _selectedIds.contains(id);

                  return _PortfolioSelectableCard(
                    work: work,
                    isSelected: isSelected,
                    onTap: () {
                      _toggleSelection(id);
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
}

class _PortfolioSelectableCard
    extends StatelessWidget {
  final Map<String, String> work;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortfolioSelectableCard({
    required this.work,
    required this.isSelected,
    required this.onTap,
  });

  static const Color gold =
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
        child: Ink(
          decoration: BoxDecoration(
            color:
            const Color(0xFF161616),
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? gold
                  : gold.withValues(
                alpha: 0.12,
              ),
              width:
              isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration:
                      BoxDecoration(
                        color:
                        gold.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius:
                        const BorderRadius
                            .vertical(
                          top:
                          Radius.circular(
                            18,
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons
                              .image_outlined,
                          color: gold,
                          size: 42,
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 10,
                      end: 10,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration:
                        BoxDecoration(
                          color: isSelected
                              ? gold
                              : const Color(
                            0xCC111111,
                          ),
                          shape:
                          BoxShape.circle,
                          border:
                          Border.all(
                            color: isSelected
                                ? gold
                                : Colors.white24,
                          ),
                        ),
                        child: Icon(
                          isSelected
                              ? Icons
                              .check_rounded
                              : Icons
                              .add_rounded,
                          color: isSelected
                              ? Colors.black
                              : Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.all(
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      work['title']!,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      work['category']!,
                      style:
                      const TextStyle(
                        color: gold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      work['platform']!,
                      style:
                      const TextStyle(
                        color:
                        Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}