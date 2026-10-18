import 'package:flutter/material.dart';

class CreatorPortfolioScreen extends StatefulWidget {
  const CreatorPortfolioScreen({
    super.key,
  });

  @override
  State<CreatorPortfolioScreen> createState() =>
      _CreatorPortfolioScreenState();
}

class _CreatorPortfolioScreenState
    extends State<CreatorPortfolioScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  final List<_PortfolioItem> items = [
    const _PortfolioItem(
      title: 'Nova Beauty Campaign',
      type: 'Instagram Reel',
      views: '125K',
    ),
    const _PortfolioItem(
      title: 'Tech Review',
      type: 'YouTube',
      views: '85K',
    ),
    const _PortfolioItem(
      title: 'Sport DZ Campaign',
      type: 'TikTok',
      views: '210K',
    ),
    const _PortfolioItem(
      title: 'Food House',
      type: 'Instagram',
      views: '96K',
    ),
  ];

  Future<void> _addWork() async {
    final titleController =
    TextEditingController();

    final typeController =
    TextEditingController();

    final result =
    await showDialog<_PortfolioItem>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor:
            const Color(0xFF171717),

            title: const Text(
              'إضافة عمل جديد',
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                  const InputDecoration(
                    labelText: 'عنوان العمل',
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller: typeController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration:
                  const InputDecoration(
                    labelText: 'نوع المحتوى',
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child: const Text(
                  'إلغاء',
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  final title =
                  titleController.text.trim();

                  if (title.isEmpty) {
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    _PortfolioItem(
                      title: title,
                      type:
                      typeController.text
                          .trim()
                          .isEmpty
                          ? 'Content'
                          : typeController
                          .text
                          .trim(),
                      views: '0',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor:
                  Colors.black,
                ),
                child: const Text(
                  'إضافة',
                ),
              ),
            ],
          ),
        );
      },
    );

    titleController.dispose();
    typeController.dispose();

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      items.add(result);
    });
  }

  void _deleteWork(
      _PortfolioItem item,
      ) {
    setState(() {
      items.remove(item);
    });
  }

  void _showWorkDetails(
      _PortfolioItem item,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
      const Color(0xFF151515),
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding:
            const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  item.type,
                  style: const TextStyle(
                    color: gold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .visibility_outlined,
                      color:
                      Colors.white54,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Text(
                      '${item.views} مشاهدة',
                      style:
                      const TextStyle(
                        color:
                        Colors.white54,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,
                  child:
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(
                        bottomSheetContext,
                      );

                      _deleteWork(
                        item,
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    label: const Text(
                      'حذف العمل',
                    ),
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,

          title: const Text(
            'معرض الأعمال',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          actions: [
            IconButton(
              onPressed: _addWork,
              icon: const Icon(
                Icons.add_circle_outline,
                color: gold,
              ),
            ),
          ],
        ),

        body: items.isEmpty
            ? const Center(
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .collections_outlined,
                color:
                Colors.white24,
                size: 70,
              ),

              SizedBox(
                height: 14,
              ),

              Text(
                'لا توجد أعمال بعد',
                style: TextStyle(
                  color:
                  Colors.white54,
                ),
              ),
            ],
          ),
        )
            : GridView.builder(
          padding:
          const EdgeInsets.all(
            18,
          ),

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),

          itemCount:
          items.length,

          itemBuilder: (
              context,
              index,
              ) {
            final item =
            items[index];

            return InkWell(
              onTap: () {
                _showWorkDetails(
                  item,
                );
              },
              borderRadius:
              BorderRadius.circular(
                18,
              ),
              child: Container(
                decoration:
                BoxDecoration(
                  color: surface,
                  borderRadius:
                  BorderRadius
                      .circular(
                    18,
                  ),
                  border:
                  Border.all(
                    color: Colors
                        .white
                        .withValues(
                      alpha: 0.05,
                    ),
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration:
                        const BoxDecoration(
                          color:
                          Color(
                            0xFF202020,
                          ),
                          borderRadius:
                          BorderRadius
                              .vertical(
                            top: Radius
                                .circular(
                              18,
                            ),
                          ),
                        ),

                        child:
                        const Center(
                          child: Icon(
                            Icons
                                .image_outlined,
                            color: Colors
                                .white24,
                            size: 45,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets
                          .all(
                        12,
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            item.title,
                            maxLines:
                            1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style:
                            const TextStyle(
                              color:
                              Colors
                                  .white,
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),

                          const SizedBox(
                            height:
                            4,
                          ),

                          Text(
                            item.type,
                            style:
                            const TextStyle(
                              color:
                              gold,
                              fontSize:
                              11,
                            ),
                          ),

                          const SizedBox(
                            height:
                            6,
                          ),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .visibility_outlined,
                                size:
                                14,
                                color:
                                Colors
                                    .white38,
                              ),

                              const SizedBox(
                                width:
                                4,
                              ),

                              Text(
                                item.views,
                                style:
                                const TextStyle(
                                  color:
                                  Colors
                                      .white38,
                                  fontSize:
                                  10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        floatingActionButton:
        FloatingActionButton(
          onPressed: _addWork,
          backgroundColor: gold,
          foregroundColor:
          Colors.black,
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class _PortfolioItem {
  final String title;
  final String type;
  final String views;

  const _PortfolioItem({
    required this.title,
    required this.type,
    required this.views,
  });
}