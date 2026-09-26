import 'package:flutter/material.dart';
import 'work_details_screen.dart';

class PortfolioGalleryScreen extends StatelessWidget {
  const PortfolioGalleryScreen({super.key});

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    final works = [
      {
        'title': 'حملة أزياء',
        'creator': 'Sara Fashion',
        'category': 'الموضة',
      },
      {
        'title': 'مراجعة هاتف',
        'creator': 'Amine Tech',
        'category': 'التكنولوجيا',
      },
      {
        'title': 'حملة رياضية',
        'creator': 'Blayli',
        'category': 'الرياضة',
      },
      {
        'title': 'إعلان مطعم',
        'creator': 'Chef Karim',
        'category': 'الطبخ',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'معرض الأعمال',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: works.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 220,
          ),
          itemBuilder: (context, index) {
            final work = works[index];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkDetailsScreen(
                        title: work['title']!,
                        creator: work['creator']!,
                        category: work['category']!,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: gold.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: gold.withValues(alpha: 0.08),
                            borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 45,
                              color: gold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              work['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              work['creator']!,
                              style: const TextStyle(
                                color: gold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              work['category']!,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
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
          },
        ),
      ),
    );
  }
}