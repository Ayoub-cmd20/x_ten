import 'package:flutter/material.dart';
import 'package:x_ten/core/widgets/custom_sidebar.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/review_banner.dart';
import 'package:x_ten/features/work_management/presentation/pages/notifications_approval_screen.dart';
import 'package:x_ten/features/work_management/presentation/pages/pending_confirmations_screen.dart';
import 'package:x_ten/features/work_management/presentation/pages/pending_delivery_screen.dart';
import 'package:x_ten/features/work_management/presentation/pages/pending_publishing_screen.dart';
import 'package:x_ten/features/contracts_agreements/presentation/pages/contracts_screen.dart';
import 'package:x_ten/features/contracts_agreements/presentation/pages/authorization_securing_screen.dart';
import 'package:x_ten/features/work_management/presentation/pages/disputed_works_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: const CustomSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'INFLUENCER ELITE',
          style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF1A1A1A),
              child: Icon(Icons.person, color: Color(0xFFE2C044), size: 20),
            ),
          )
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مرحباً بك مجدداً', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('لوحة التحكم الإبداعية', style: TextStyle(color: Color(0xFFE2C044), fontSize: 14)),
              const SizedBox(height: 24),
              const RegistrationReviewBanner(),

              // Stacked Full-Width Professional Cards in requested order
              Column(
                children: [
                  // 1. إشعارات جديدة
                  _buildStatusCard(
                    title: 'إشعارات جديدة',
                    count: '04',
                    label: 'بانتظار الموافقة',
                    icon: Icons.notifications_none_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsApprovalScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. في انتظار التأكيد
                  _buildStatusCard(
                    title: 'في انتظار التأكيد',
                    count: '',
                    label: 'تم تأكيد جميع الطلبات',
                    icon: Icons.check_circle_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendingConfirmationScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. في انتظار التسليم
                  _buildStatusCard(
                    title: 'في انتظار التسليم',
                    count: '06',
                    label: 'مهام معلقة',
                    icon: Icons.assignment_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendingDeliveryScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. في انتظار النشر
                  _buildStatusCard(
                    title: 'في انتظار النشر',
                    count: '02',
                    label: 'نزاعات نشطة',
                    icon: Icons.cloud_upload_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendingPublishingScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 5. عقود
                  _buildStatusCard(
                    title: 'عقود',
                    count: '',
                    label: 'لا توجد عقود نشطة حالياً',
                    icon: Icons.description_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContractsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 6. قيد التفويض
                  _buildStatusCard(
                    title: 'قيد التفويض',
                    count: '08',
                    label: 'طلبات جديدة',
                    icon: Icons.gpp_good_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthorizationSecuringScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // 7. تعديل مطلوب (أعمال معترض عليها) - Context Passed Here!
                  _buildFullWidthCard(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String count,
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F1F1F), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2C044).withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFFE2C044), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label.isNotEmpty ? label : 'محدّث بالكامل',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (count.isNotEmpty) ...[
                Text(
                  count,
                  style: const TextStyle(color: Color(0xFFE2C044), fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 8),
              ],
              TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF2C2C2C)),
                  ),
                ),
                child: const Text(
                  'عرض',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Accepts BuildContext context as parameter
  Widget _buildFullWidthCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DisputedWorksScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF221414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3D1C1C), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE24444).withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE24444), size: 24),
                ),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تعديل مطلوب', style: TextStyle(color: Color(0xFFE24444), fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('أعمال معترض عليها', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DisputedWorksScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE24444)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: const Text('مراجعة', style: TextStyle(color: Color(0xFFE24444), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}