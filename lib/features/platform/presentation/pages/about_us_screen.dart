import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'من نحن',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: gold.withValues(alpha: 0.28),
                  ),
                ),
                child: const Icon(
                  Icons.groups_2_outlined,
                  color: gold,
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'فريق X10',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'نحن فريق يعمل على تطوير منصة رقمية حديثة '
                    'تسهل التعاون بين المؤثرين والمعلنين والعلامات التجارية.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 26),

              _infoCard(
                icon: Icons.flag_outlined,
                title: 'رؤيتنا',
                text:
                'أن تصبح X10 منصة موثوقة لتنظيم سوق التسويق بالمؤثرين '
                    'وتسهيل الوصول إلى فرص التعاون.',
              ),

              const SizedBox(height: 12),

              _infoCard(
                icon: Icons.track_changes_outlined,
                title: 'مهمتنا',
                text:
                'توفير أدوات احترافية تساعد المؤثر والمعلن على البحث، '
                    'التواصل، إدارة الحملات ومتابعة النتائج.',
              ),

              const SizedBox(height: 12),

              _infoCard(
                icon: Icons.favorite_border_rounded,
                title: 'قيمنا',
                text:
                'الشفافية، الاحترافية، سهولة الاستخدام، الثقة، '
                    'الابتكار وحماية حقوق جميع الأطراف.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(alpha: 0.13),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: gold,
            size: 25,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white54,
                    height: 1.65,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}