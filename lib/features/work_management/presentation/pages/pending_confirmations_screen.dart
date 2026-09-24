import 'package:flutter/material.dart';

class PendingConfirmationScreen extends StatefulWidget {
  final Map<String, String>? acceptedCampaign;

  const PendingConfirmationScreen({super.key, this.acceptedCampaign});

  @override
  State<PendingConfirmationScreen> createState() => _PendingConfirmationScreenState();
}

class _PendingConfirmationScreenState extends State<PendingConfirmationScreen> {
  late List<Map<String, String>> pendingConfirmations;

  @override
  void initState() {
    super.initState();
    pendingConfirmations = [
      if (widget.acceptedCampaign != null) widget.acceptedCampaign!,
      {
        'id': '101',
        'brandName': 'شركة الأناقة للموضة',
        'campaignTitle': 'تشكيلة الخريف الجديدة 2026',
        'details': 'بانتظار توقيع الاتفاقية النهائية وتأكيد جدول المواعيد.',
        'date': 'منذ 3 ساعات',
        'status': 'قيد التأكيد',
      },
    ];
  }

  void _confirmCampaign(int index) {
    final campaign = pendingConfirmations[index];

    setState(() {
      pendingConfirmations.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم تأكيد "${campaign['campaignTitle']}" بنجاح! تحولت إلى "في انتظار التسليم".',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE2C044),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _cancelCampaign(int index) {
    setState(() {
      pendingConfirmations.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم إلغاء الطلب بنجاح', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE24444),
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
          'في انتظار التأكيد',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: pendingConfirmations.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد طلبات بانتظار التأكيد حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'تم تأكيد جميع العقود بنجاح',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: pendingConfirmations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = pendingConfirmations[index];
            return _buildConfirmationCard(
              context,
              index: index,
              brandName: item['brandName'] ?? 'براند تجاري',
              campaignTitle: item['campaignTitle'] ?? 'حملة إعلانية',
              details: item['details'] ?? 'في انتظار مراجعة البنود والتأكيد النهائي من الطرفين.',
              date: item['date'] ?? 'الآن',
            );
          },
        ),
      ),
    );
  }

  Widget _buildConfirmationCard(
      BuildContext context, {
        required int index,
        required String brandName,
        required String campaignTitle,
        required String details,
        required String date,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2C044).withValues(alpha:0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.hourglass_top_rounded, color: Color(0xFFE2C044), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brandName,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        campaignTitle,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2C044).withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2C044).withValues(alpha:0.3)),
                ),
                child: const Text(
                  'قيد التأكيد',
                  style: TextStyle(color: Color(0xFFE2C044), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14.0),
            child: Divider(color: Color(0xFF1F1F1F), thickness: 1),
          ),
          const Text(
            'حالة الشروط والتأكيد:',
            style: TextStyle(color: Color(0xFFE2C044), fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            details,
            style: TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _confirmCampaign(index),
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('تأكيد نهائي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2C044),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => _cancelCampaign(index),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3D1C1C)),
                    backgroundColor: const Color(0xFF221414),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(color: Color(0xFFE24444), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}