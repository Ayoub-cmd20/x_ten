import 'package:flutter/material.dart';

class AuthorizationSecuringScreen extends StatefulWidget {
  const AuthorizationSecuringScreen({super.key});

  @override
  State<AuthorizationSecuringScreen> createState() => _AuthorizationSecuringScreenState();
}

class _AuthorizationSecuringScreenState extends State<AuthorizationSecuringScreen> {
  // قائمة طلبات التفويض الأذونات المعلقة
  List<Map<String, String>> authorizationList = [
    {
      'id': 'AUTH-2026-01',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'authType': 'تفويض إعلاني (Spark Ads Code)',
      'duration': '30 يوماً من تاريخ النشر',
      'status': 'بانتظار رمز التفويض',
    },
    {
      'id': 'AUTH-2026-02',
      'brandName': 'شركة الأناقة للموضة',
      'campaignTitle': 'تشكيلة الخريف الجديدة',
      'authType': 'ربط حساب الترويج (Partnership Label)',
      'duration': '14 يوماً',
      'status': 'معلق للتأكيد',
    },
  ];

  void _openAuthDialog(BuildContext context, int index) {
    final auth = authorizationList[index];
    final codeController = TextEditingController();

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
                        color: const Color(0xFFE2C044).withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.gpp_good_outlined, color: Color(0xFFE2C044), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تفويض إعلاني: ${auth['brandName']}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            auth['authType']!,
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Auth Code Input Field
                const Text('رمز الترويج / كود التفويض (Ad Code):', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: codeController,
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'أدخل كود التفويض المولّد من المنصة (مثال: TikTok_8f93a...)',
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
                    fillColor: const Color(0xFF0A0A0A),
                    filled: true,
                    prefixIcon: const Icon(Icons.key_rounded, color: Color(0xFFE2C044)),
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
                      _grantAuthorization(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2C044),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('منح التفويض وإرسال الكود', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _grantAuthorization(int index) {
    final auth = authorizationList[index];

    setState(() {
      authorizationList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم منح التفويض لـ "${auth['brandName']}" بنجاح!',
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
          'قيد التفويض والإذونات',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: authorizationList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد طلبات تفويض معلقة حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'تمت معالجة كافة أذونات الإعلانات والحقوق بنجاح',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: authorizationList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = authorizationList[index];
            return _buildAuthCard(
              context,
              index: index,
              brandName: item['brandName']!,
              campaignTitle: item['campaignTitle']!,
              authType: item['authType']!,
              duration: item['duration']!,
              status: item['status']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAuthCard(
      BuildContext context, {
        required int index,
        required String brandName,
        required String campaignTitle,
        required String authType,
        required String duration,
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
                    child: const Icon(Icons.gpp_good_outlined, color: Color(0xFFE2C044), size: 20),
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
                  color: const Color(0xFFE2C044).withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2C044).withValues(alpha:0.3)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نوع التفويض المطلوبة:', style: TextStyle(color: Color(0xFFE2C044), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(authType, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('مدة الترويج:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(duration, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openAuthDialog(context, index),
              icon: const Icon(Icons.shield_outlined, size: 18),
              label: const Text('إدخال كود التفويض والترخيص', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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