import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  final List<Map<String, String>> _faqs = const [
    {
      'question': 'ما هي منصة X10؟',
      'answer':
      'X10 منصة تربط المؤثرين بالمعلنين والعلامات التجارية '
          'وتساعد على إدارة الحملات وفرص التعاون.',
    },
    {
      'question': 'كيف أجد مؤثراً مناسباً؟',
      'answer':
      'يمكنك استخدام قائمة المؤثرين أو البحث حسب المجالات '
          'ثم فلترة النتائج حسب التقييم، عدد المتابعين وتاريخ الانضمام.',
    },
    {
      'question': 'كيف أبدأ حملة إشهارية؟',
      'answer':
      'افتح ملف المؤثر ثم اضغط على "ابدأ الإشهار"، '
          'وحدد تفاصيل الحملة والميزانية والمدة.',
    },
    {
      'question': 'ما هي خدمة ترويج حسب الطلب؟',
      'answer':
      'هي خدمة تسمح لك بإرسال احتياجك التسويقي لفريق المنصة '
          'لمساعدتك على اختيار المؤثرين والخطة المناسبة.',
    },
    {
      'question': 'هل يمكن حفظ المؤثرين للرجوع إليهم لاحقاً؟',
      'answer':
      'نعم، يمكنك إضافة المؤثر أو المشروع أو المقال إلى العناصر المحفوظة.',
    },
    {
      'question': 'كيف أتابع طلباتي؟',
      'answer':
      'يمكن متابعة طلبات الترويج والحملات من الأقسام المخصصة لذلك داخل الحساب.',
    },
  ];

  int? _openedIndex;

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
            'أسئلة شائعة',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _faqs.length,
          separatorBuilder: (_, _) =>
          const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = _faqs[index];
            final opened = _openedIndex == index;

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: opened
                      ? gold.withValues(alpha: 0.30)
                      : Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: opened,
                onExpansionChanged: (value) {
                  setState(() {
                    _openedIndex = value ? index : null;
                  });
                },
                iconColor: gold,
                collapsedIconColor: Colors.white38,
                title: Text(
                  item['question']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      item['answer']!,
                      style: const TextStyle(
                        color: Colors.white54,
                        height: 1.65,
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