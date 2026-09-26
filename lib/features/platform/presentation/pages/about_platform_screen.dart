import 'package:flutter/material.dart';

class AboutPlatformScreen extends StatelessWidget {
  const AboutPlatformScreen({super.key});

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
            'التعرف على منصة X10',
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      gold.withValues(alpha: 0.14),
                      gold.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: gold,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'X10',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'منصة X10',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'منصة تربط المؤثرين بالمعلنين والعلامات التجارية بطريقة احترافية، سهلة وآمنة.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        height: 1.7,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              _section(
                icon: Icons.lightbulb_outline_rounded,
                title: 'فكرة المنصة',
                text:
                'تهدف X10 إلى تسهيل التعاون بين المؤثرين والمعلنين، '
                    'وتوفير بيئة منظمة لإدارة الحملات، المشاريع، الاتفاقيات '
                    'والخدمات الاحترافية في مكان واحد.',
              ),

              const SizedBox(height: 14),

              _section(
                icon: Icons.people_alt_outlined,
                title: 'لمن صممت المنصة؟',
                text:
                'للمؤثرين، صناع المحتوى، المعلنين، العلامات التجارية، '
                    'العملاء والمستقلين الذين يبحثون عن فرص تعاون وتسويق فعالة.',
              ),

              const SizedBox(height: 14),

              _section(
                icon: Icons.verified_user_outlined,
                title: 'ما الذي توفره X10؟',
                text:
                'اكتشاف المؤثرين، إنشاء الحملات، إدارة الطلبات، '
                    'التواصل، متابعة الاتفاقيات، حفظ العناصر، '
                    'الخدمات الاحترافية وتحليل فرص التعاون.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: gold.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
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