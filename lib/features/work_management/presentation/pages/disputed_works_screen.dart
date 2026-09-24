import 'package:flutter/material.dart';

class DisputedWorksScreen extends StatefulWidget {
  const DisputedWorksScreen({super.key});

  @override
  State<DisputedWorksScreen> createState() => _DisputedWorksScreenState();
}

class _DisputedWorksScreenState extends State<DisputedWorksScreen> {
  // قائمة الأعمال المعترض عليها والمطلوب تعديلها
  List<Map<String, String>> disputedList = [
    {
      'id': 'DSP-2026-01',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'reason': 'الموسيقى الخلفية عالية وتغطي على صدى الصوت، ونحتاج إظهار شعار البراند بوضوح في أول 3 ثوانٍ.',
      'requestedDate': 'منذ ساعتين',
      'status': 'مطلوب تعديل عاجل',
    },
    {
      'id': 'DSP-2026-02',
      'brandName': 'شركة الأناقة للموضة',
      'campaignTitle': 'تشكيلة الخريف الجديدة',
      'reason': 'الرابط المرفق في الكابشن يحتوي على كود خصم قديم، يرجى تحديث الرابط بـ (FALL2026).',
      'requestedDate': 'منذ يومين',
      'status': 'مراجعة الكابشن',
    },
  ];

  void _openRevisionBottomSheet(BuildContext context, int index) {
    final item = disputedList[index];
    final revisionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE24444).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE24444), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إعادة تسليم التعديل: ${item['brandName']}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            item['campaignTitle']!,
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Link / Text Input Field
                const Text('رابط المحتوى المعدّل / الملاحظات:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: revisionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ضع رابط العمل بعد التعديل أو اكتب تفاصيل التحديث...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    fillColor: const Color(0xFF0A0A0A),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF1F1F1F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE24444)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resolveDispute(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE24444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('إرسال التعديل للمراجعة', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resolveDispute(int index) {
    final item = disputedList[index];

    setState(() {
      disputedList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال التعديل لـ "${item['brandName']}" بنجاح وتم إغلاق الاعتراض.',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1F1F1F),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'أعمال معترض عليها',
          style: TextStyle(color: Color(0xFFE24444), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: disputedList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد أعمال معترض عليها حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'جميع الأعمال والمحتويات تم اعتمادها بنجاح',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: disputedList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = disputedList[index];
            return _buildDisputedCard(
              context,
              index: index,
              brandName: item['brandName']!,
              campaignTitle: item['campaignTitle']!,
              reason: item['reason']!,
              requestedDate: item['requestedDate']!,
              status: item['status']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisputedCard(
      BuildContext context, {
        required int index,
        required String brandName,
        required String campaignTitle,
        required String reason,
        required String requestedDate,
        required String status,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF221414), // Red-accented dark card background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3D1C1C), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24444).withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE24444), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(brandName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(campaignTitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE24444).withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE24444).withValues(alpha:0.4)),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Color(0xFFE24444), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(color: Color(0xFF3D1C1C), thickness: 1),
          ),

          // Feedback Reason
          const Text('سبب الاعتراض / التعديل المطلوب:', style: TextStyle(color: Color(0xFFE24444), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            reason,
            style: TextStyle(color: Colors.grey[200], fontSize: 13, height: 1.4),
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('تاريخ الطلب: $requestedDate', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ),

          const SizedBox(height: 16),

          // Review & Fix Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openRevisionBottomSheet(context, index),
              icon: const Icon(Icons.build_circle_outlined, size: 18),
              label: const Text('مراجعة وإرفاق التعديل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE24444),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}