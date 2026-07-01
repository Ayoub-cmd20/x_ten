import 'package:flutter/material.dart';
import 'custom_sidebar.dart'; // Ensure you have this file created

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      // Connected the sidebar here
      drawer: const CustomSidebar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('INFLUENCER ELITE',
            style: TextStyle(color: Color(0xFFE2C044), fontWeight: FontWeight.bold)),
        // Wrapped in Builder so it can trigger the drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(backgroundColor: Colors.grey[800])
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مرحباً بك مجدداً', style: TextStyle(color: Colors.white, fontSize: 18)),
            const Text('لوحة التحكم الإبداعية', style: TextStyle(color: Color(0xFFE2C044), fontSize: 14)),
            const SizedBox(height: 20),

            // Grid of Status Cards
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildStatusCard(title: 'إشعارات جديدة', count: '04', label: 'بانتظار الموافقة', icon: Icons.notifications),
                _buildStatusCard(title: 'قيد التفويض', count: '08', label: 'طلبات جديدة', icon: Icons.security),
                _buildStatusCard(title: 'عقود', count: '', label: '', icon: Icons.description),
                _buildStatusCard(title: 'في انتظار التسليم', count: '06', label: 'مهام معلقة', icon: Icons.assignment),
                _buildStatusCard(title: 'في انتظار التأكيد', count: '', label: '', icon: Icons.check_circle),
                _buildStatusCard(title: 'في انتظار النشر', count: '02', label: 'نراعات نشطة', icon: Icons.cloud_upload),
              ],
            ),
            const SizedBox(height: 16),
            _buildFullWidthCard(),
          ],
        ),
      ),
    );
  }

  // Helper Methods for Cards (Maintain existing structure)
  Widget _buildStatusCard({required String title, required String count, required String label, required IconData icon}) {
    // ... same as your current implementation
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE2C044)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const Spacer(),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2C044))),
            child: const Text('عرض التفاصيل', style: TextStyle(color: Color(0xFFE2C044), fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFF2A1A1A), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تعديل مطلوب', style: TextStyle(color: Color(0xFFE24444))),
          const Text('أعمال معترض عليها', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE24444))),
            child: const Text('عرض التفاصيل', style: TextStyle(color: Color(0xFFE24444))),
          ),
        ],
      ),
    );
  }
}