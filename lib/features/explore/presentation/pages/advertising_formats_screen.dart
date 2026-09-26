import 'package:flutter/material.dart';

class AdvertisingFormatsScreen extends StatelessWidget {
  const AdvertisingFormatsScreen({super.key});

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    final formats = [
      {
        'title': 'منشور إعلاني',
        'description':
        'منشور دائم على حساب المؤثر للتعريف بالمنتج أو الخدمة.',
        'icon': Icons.post_add_outlined,
      },
      {
        'title': 'Story',
        'description':
        'محتوى قصير سريع الانتشار مناسب للعروض والإعلانات المؤقتة.',
        'icon': Icons.auto_stories_outlined,
      },
      {
        'title': 'Reel / فيديو قصير',
        'description':
        'فيديو جذاب لعرض المنتج أو الخدمة بطريقة تفاعلية.',
        'icon': Icons.video_camera_back_outlined,
      },
      {
        'title': 'مراجعة منتج',
        'description':
        'يقوم المؤثر بتجربة المنتج وتقديم رأيه ومميزاته للجمهور.',
        'icon': Icons.rate_review_outlined,
      },
      {
        'title': 'مسابقة وجوائز',
        'description':
        'حملة لزيادة التفاعل والمتابعين عبر مسابقات وجوائز.',
        'icon': Icons.emoji_events_outlined,
      },
      {
        'title': 'سفير علامة تجارية',
        'description':
        'تعاون طويل الأمد بين المؤثر والعلامة التجارية.',
        'icon': Icons.workspace_premium_outlined,
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
            'أنواع و صيغ الإشهار',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: formats.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 190,
          ),
          itemBuilder: (context, index) {
            final item = formats[index];

            return Container(
              padding: const EdgeInsets.all(15),
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
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      item['description'] as String,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}