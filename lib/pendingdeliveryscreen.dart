import 'package:flutter/material.dart';

class PendingDeliveryScreen extends StatefulWidget {
  const PendingDeliveryScreen({super.key});

  @override
  State<PendingDeliveryScreen> createState() => _PendingDeliveryScreenState();
}

class _PendingDeliveryScreenState extends State<PendingDeliveryScreen> {
  // Demo dataset for campaigns awaiting deliverable submission
  List<Map<String, String>> pendingDeliveries = [
    {
      'id': '201',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'deliverableType': 'فيديو Reel على Instagram',
      'deadline': 'باقي يومان (28 يوليو 2026)',
      'status': 'في انتظار التسليم',
    },
    {
      'id': '202',
      'brandName': 'متجر التقنية الذكية',
      'campaignTitle': 'إطلاق السماعات اللاسلكية',
      'deliverableType': 'فيديو مراجعة على TikTok',
      'deadline': 'باقي 4 أيام (30 يوليو 2026)',
      'status': 'في انتظار التسليم',
    },
  ];

  void _openUploadBottomSheet(BuildContext context, int index) {
    final campaign = pendingDeliveries[index];
    final linkController = TextEditingController();

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
                        color: const Color(0xFFE2C044).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFFE2C044), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تسليم العمل: ${campaign['brandName']}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            campaign['campaignTitle']!,
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Link / File field
                const Text('رابط المحتوى / مسودة العمل:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: linkController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ضع رابط Google Drive / Dropbox / Video Link...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    fillColor: const Color(0xFF0A0A0A),
                    filled: true,
                    prefixIcon: const Icon(Icons.link_rounded, color: Color(0xFFE2C044)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF1F1F1F)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE2C044)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _submitDelivery(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2C044),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('إرسال للمراجعة والنشر', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitDelivery(int index) {
    final campaign = pendingDeliveries[index];

    setState(() {
      pendingDeliveries.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تسليم عمل "${campaign['campaignTitle']}" بنجاح! تحولت إلى "في انتظار النشر".',
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
          'في انتظار التسليم',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: pendingDeliveries.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد مهام معلقة للتسليم حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'تم تسليم جميع أعمال الحملات بنجاح',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: pendingDeliveries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = pendingDeliveries[index];
            return _buildDeliveryCard(
              context,
              index: index,
              brandName: item['brandName']!,
              campaignTitle: item['campaignTitle']!,
              deliverableType: item['deliverableType']!,
              deadline: item['deadline']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(
      BuildContext context, {
        required int index,
        required String brandName,
        required String campaignTitle,
        required String deliverableType,
        required String deadline,
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
                    child: const Icon(Icons.assignment_outlined, color: Color(0xFFE2C044), size: 20),
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
                child: const Text(
                  'مهام معلقة',
                  style: TextStyle(color: Color(0xFFE2C044), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(color: Color(0xFF1F1F1F), thickness: 1),
          ),

          // Required Task & Deadline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المحتوى المطلوب:', style: TextStyle(color: Color(0xFFE2C044), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(deliverableType, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('الموعد النهائي:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(deadline, style: const TextStyle(color: Color(0xFFE24444), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Button to submit delivery
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openUploadBottomSheet(context, index),
              icon: const Icon(Icons.file_upload_outlined, size: 18),
              label: const Text('رفع وتكليف العمل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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