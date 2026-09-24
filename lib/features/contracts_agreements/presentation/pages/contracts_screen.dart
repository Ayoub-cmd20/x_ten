import 'package:flutter/material.dart';

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  // قائمة العقود النشطة والمكتملة
  List<Map<String, String>> contractsList = [
    {
      'id': 'CNT-2026-001',
      'brandName': 'براند الرفاهية للنظارات',
      'campaignTitle': 'حملة الصيف الإعلانية 2026',
      'amount': '15,000 ر.س',
      'status': 'نشط وموثق',
      'date': '24 يوليو 2026',
    },
    {
      'id': 'CNT-2026-002',
      'brandName': 'شركة الأناقة للموضة',
      'campaignTitle': 'تشكيلة الخريف الجديدة',
      'amount': '8,500 ر.س',
      'status': 'نشط وموثق',
      'date': '18 يوليو 2026',
    },
    {
      'id': 'CNT-2026-003',
      'brandName': 'متجر التقنية الذكية',
      'campaignTitle': 'إطلاق السماعات اللاسلكية',
      'amount': '12,000 ر.س',
      'status': 'مكتمل ومسدد',
      'date': '01 يونيو 2026',
    },
  ];

  void _showContractDetails(BuildContext context, Map<String, String> contract) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2C044).withValues(alpha:0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.description_outlined, color: Color(0xFFE2C044), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contract['brandName']!,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'رقم العقد: ${contract['id']}',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      contract['amount']!,
                      style: const TextStyle(color: Color(0xFFE2C044), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: Color(0xFF1F1F1F), thickness: 1),
                ),
                const Text('ملخص البنود والالتزامات:', style: TextStyle(color: Color(0xFFE2C044), fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  '• يتعهد الطرف الثاني بنشر المحتوى المتفق عليه في المواعيد المحددة.\n'
                      '• تحويل المستحقات المالية يتم خلال 7 أيام عمل بعد تأكيد النشر.\n'
                      '• حقوق استخدام الفيديو مملوكة للطرف الأول لمدة 3 أشهر.',
                  style: TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('جاري تحميل العقد ${contract['id']} بصيغة PDF...'),
                          backgroundColor: const Color(0xFF1F1F1F),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 18),
                    label: const Text('تحميل العقد بصيغة PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2C044),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          'العقود الموثقة',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: contractsList.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 16),
              const Text(
                'لا توجد عقود نشطة حالياً',
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: contractsList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = contractsList[index];
            final isCompleted = item['status'] == 'مكتمل ومسدد';

            return _buildContractCard(
              context,
              contract: item,
              isCompleted: isCompleted,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContractCard(
      BuildContext context, {
        required Map<String, String> contract,
        required bool isCompleted,
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
                    child: const Icon(Icons.description_outlined, color: Color(0xFFE2C044), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract['brandName']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        contract['campaignTitle']!,
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withValues(alpha:0.12)
                      : const Color(0xFFE2C044).withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green.withValues(alpha:0.3)
                        : const Color(0xFFE2C044).withValues(alpha:0.3),
                  ),
                ),
                child: Text(
                  contract['status']!,
                  style: TextStyle(
                    color: isCompleted ? Colors.green[400] : const Color(0xFFE2C044),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
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
                  const Text('قيمة العقد:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    contract['amount']!,
                    style: const TextStyle(color: Color(0xFFE2C044), fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('تاريخ التوثيق:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(contract['date']!, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showContractDetails(context, contract),
              icon: const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.white),
              label: const Text('معاينة العقد والبنود', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2C2C2C)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}