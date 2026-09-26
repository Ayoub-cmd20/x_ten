import 'package:flutter/material.dart';
import 'project_details_screen.dart';

class ProjectsBrowserScreen extends StatelessWidget {
  const ProjectsBrowserScreen({super.key});

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'حملة إطلاق منتج تقني',
        'company': 'Tech DZ',
        'budget': '80,000 دج',
        'category': 'التكنولوجيا',
      },
      {
        'title': 'ترويج لمطعم جديد',
        'company': 'Food Company',
        'budget': '40,000 دج',
        'category': 'الطبخ',
      },
      {
        'title': 'حملة أزياء موسمية',
        'company': 'Fashion Brand',
        'budget': '100,000 دج',
        'category': 'الموضة',
      },
    ];

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
            'تصفح المشاريع',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          separatorBuilder: (_, _) =>
          const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final project = projects[index];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailsScreen(
                        title: project['title']!,
                        company: project['company']!,
                        category: project['category']!,
                        budget: project['budget']!,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Ink(
                  padding: const EdgeInsets.all(16),
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
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color:
                              gold.withValues(alpha: 0.10),
                              borderRadius:
                              BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.work_outline_rounded,
                              color: gold,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  project['company']!,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            color: Colors.white38,
                            size: 17,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            project['category']!,
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.payments_outlined,
                            color: gold,
                            size: 17,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            project['budget']!,
                            style: const TextStyle(
                              color: gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProjectDetailsScreen(
                                  title: project['title']!,
                                  company: project['company']!,
                                  category: project['category']!,
                                  budget: project['budget']!,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: gold,
                            side: BorderSide(
                              color:
                              gold.withValues(alpha: 0.35),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(13),
                            ),
                          ),
                          child: const Text(
                            'عرض تفاصيل المشروع',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
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
        ),
      ),
    );
  }
}