import 'package:flutter/material.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final String description;

  const ArticleDetailsScreen({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.description,
  });

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

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
            'تفاصيل المقال',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      gold.withValues(alpha: 0.18),
                      const Color(0xFF161616),
                    ],
                  ),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.18),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.article_outlined,
                    color: gold,
                    size: 70,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white38,
                    size: 15,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.9,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: const Text(
                  'يمكن هنا إضافة المحتوى الكامل للمقال، الصور، '
                      'الفقرات، الإحصائيات، النصائح والروابط ذات الصلة.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}