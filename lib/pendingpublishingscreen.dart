import 'package:flutter/material.dart';

class PendingPublishingScreen extends StatefulWidget {
  const PendingPublishingScreen({super.key});

  @override
  State<PendingPublishingScreen> createState() => _PendingPublishingScreenState();
}

class _PendingPublishingScreenState extends State<PendingPublishingScreen> {
  // Demo dataset for campaigns awaiting public post launch
  List<Map<String, String>> pendingPublishingList = [
    {
      'id': '301',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'platform': 'Instagram Reel',
      'scheduledTime': 'اليوم، 08:00 مساءً',
      'status': 'تم اعتماد المسودة',
    },
    {
      'id': '302',
      'brandName': 'شركة الأناقة للموضة',
      'campaignTitle': 'تشكيلة الخريف الجديدة',
      'platform': 'TikTok Video',
      'scheduledTime': 'غداً، 04:00 عصراً',
      'status': 'قيد معالجة المنصة',
    },
  ];

  void _confirmPostPublished(int index) {
    final campaign = pendingPublishingList[index];

    setState(() {
      pendingPublishingList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تأكيد نشر "${campaign['campaignTitle']}" بنجاح! تحولت إلى العقود التوثيقية.',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE2C044),
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
          'في انتظار النشر',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: pendingPublishingList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_done_outlined, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد منشورات قيد الإطلاق حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'تم نشر جميع الحملات وتوثيق رابط الوصول بنجاح',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: pendingPublishingList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = pendingPublishingList[index];
            return _buildPublishingCard(
              context,
              index: index,
              brandName: item['brandName']!,
              campaignTitle: item['campaignTitle']!,
              platform: item['platform']!,
              scheduledTime: item['scheduledTime']!,
              status: item['status']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPublishingCard(
      BuildContext context, {
        required int index,
        required String brandName,
        required String campaignTitle,
        required String platform,
        required String scheduledTime,
        required String status,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
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
                      color: const Color(0xFFE2C044).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFFE2C044), size: 20),
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
                  color: const Color(0xFFE2C044).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2C044).withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Color(0xFFE2C044), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(color: Color(0xFF1F1F1F), thickness: 1),
          ),

          // Platform & Publishing Schedule
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المنصة المستهدفة:', style: TextStyle(color: Color(0xFFE2C044), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(platform, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('موعد النشر المقترح:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(scheduledTime, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Confirm Live Launch Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _confirmPostPublished(index),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('تأكيد تم النشر مجدولاً / حياً', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2C044),
                foregroundColor: Colors.black,
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