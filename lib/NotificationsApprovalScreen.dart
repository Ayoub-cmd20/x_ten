import 'package:flutter/material.dart';
import 'pendingconfirmationscreen.dart';

class NotificationsApprovalScreen extends StatefulWidget {
  const NotificationsApprovalScreen({super.key});

  @override
  State<NotificationsApprovalScreen> createState() => _NotificationsApprovalScreenState();
}

class _NotificationsApprovalScreenState extends State<NotificationsApprovalScreen> {
  // Demo dataset for pending notifications
  List<Map<String, String>> notifications = [
    {
      'id': '1',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'details': 'مطلوب نشر فيديو ريلز على إنستغرام بمدة لا تقل عن 30 ثانية لاستعراض المنتج الجديد.',
      'date': 'منذ ساعتين',
    },
    {
      'id': '2',
      'brandName': 'شركة الأناقة للموضة',
      'campaignTitle': 'تشكيلة الخريف الجديدة',
      'details': 'إعلان ستوري مكثف مع رابط مباشر لخصم الشراء.',
      'date': 'منذ 5 ساعات',
    },
  ];

  void _acceptNotification(int index) {
    // 1. Save item data
    final acceptedItem = notifications[index];

    // 2. Remove item from local list
    setState(() {
      notifications.removeAt(index);
    });

    // 3. Show feedback notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم قبول "${acceptedItem['campaignTitle']}" وتم نقلها إلى "في انتظار التأكيد"',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE2C044),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 4. Navigate to "في انتظار التأكيد" screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendingConfirmationScreen(acceptedCampaign: acceptedItem),
      ),
    );
  }

  void _refuseNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });

    _showActionFeedback(context, 'تم رفض الطلب', isDanger: true);
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
          'الإشعارات والطلبات',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: notifications.isEmpty
            ? const Center(
          child: Text('لا توجد إشعارات معلقة حالياً', style: TextStyle(color: Colors.white54, fontSize: 16)),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return _buildNotificationApprovalCard(
              context,
              index: index,
              brandName: item['brandName']!,
              campaignTitle: item['campaignTitle']!,
              details: item['details']!,
              date: item['date']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationApprovalCard(
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
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE2C044).withOpacity(0.1),
                    child: const Icon(Icons.business_center_outlined, color: Color(0xFFE2C044), size: 20),
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
              Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Color(0xFF1F1F1F), thickness: 1),
          ),
          const Text('تفاصيل الطلب:', style: TextStyle(color: Color(0xFFE2C044), fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(details, style: TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),

          // Action Row
          Row(
            children: [
              // 1. Accept Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptNotification(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2C044),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('قبول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),

              // 2. Accept with Modification Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openModificationBottomSheet(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2C044)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('قبول مع تعديل', style: TextStyle(color: Color(0xFFE2C044), fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),

              // 3. Refuse Button
              IconButton(
                onPressed: () => _refuseNotification(index),
                icon: const Icon(Icons.cancel_outlined, color: Color(0xFFE24444)),
                tooltip: 'رفض الطلب',
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF221414),
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFF3D1C1C)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActionFeedback(BuildContext context, String message, {bool isDanger = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: isDanger ? const Color(0xFFE24444) : const Color(0xFF1F1F1F),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _openModificationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اقتراح تعديل على الطلب', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('اكتب ملاحظاتك أو الشروط البديلة ليتم إرسالها للمراجعة للبراند.', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'مثال: أود تعديل موعد النشر ليكون يوم الخميس بدلاً من الثلاثاء...',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    fillColor: const Color(0xFF0A0A0A),
                    filled: true,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1F1F1F))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2C044))),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showActionFeedback(context, 'تم إرسال مقترح التعديل بنجاح');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2C044),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('إرسال المقترح', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}