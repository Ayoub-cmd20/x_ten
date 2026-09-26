import 'package:flutter/material.dart';
import 'article_details_screen.dart';

class ArticlesNewsScreen extends StatelessWidget {
  const ArticlesNewsScreen({super.key});

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  final List<Map<String, String>> articles = const [
    {
      'title': 'كيف تختار المؤثر المناسب لحملتك؟',
      'category': 'التسويق بالمؤثرين',
      'date': '26/09/2026',
      'description':
      'تعرف على أهم المعايير التي تساعدك في اختيار المؤثر المناسب لجمهورك وحملتك.',
    },
    {
      'title': 'أهم اتجاهات التسويق الرقمي',
      'category': 'التسويق',
      'date': '24/09/2026',
      'description':
      'نظرة على أحدث الاتجاهات في المحتوى، الحملات الرقمية والتسويق عبر المنصات.',
    },
    {
      'title': 'كيف تبني حملة إعلانية ناجحة؟',
      'category': 'الإعلانات',
      'date': '20/09/2026',
      'description':
      'خطوات عملية لبناء حملة احترافية من تحديد الهدف إلى تحليل النتائج.',
    },
  ];

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
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'مقالات و أخبار',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          separatorBuilder: (_, _) =>
          const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final article = articles[index];

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailsScreen(
                        title: article['title']!,
                        category: article['category']!,
                        date: article['date']!,
                        description: article['description']!,
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
                      color: gold.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: gold.withValues(alpha: 0.10),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              article['category']!,
                              style: const TextStyle(
                                color: gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            article['date']!,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        article['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article['description']!,
                        style: const TextStyle(
                          color: Colors.white54,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Text(
                            'قراءة المزيد',
                            style: TextStyle(
                              color: gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_back_rounded,
                            color: gold,
                            size: 18,
                          ),
                        ],
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