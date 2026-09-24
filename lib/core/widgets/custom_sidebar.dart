import 'package:flutter/material.dart';
import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Profile Header
              const CircleAvatar(radius: 35, backgroundColor: Color(0xFFE2C044)),
              const SizedBox(height: 10),
              const Text('نخبة المؤثرين', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('عضوية ذهبية', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 30),
              const Divider(color: Colors.grey),

              // Menu Items
              _buildMenuSection(context, title: 'أدوات المحتوى والإعلانات', items: [
                ('مقالات وأخبار', Icons.newspaper),
                ('أنواع وصيغ الإشهار', Icons.category),
                ('تصفح معرض الأعمال', Icons.video_library),
                ('تصفح مشاريع العناصر المحفوظة', Icons.folder),
                ('إنجازاتي مكتملة', Icons.check_circle),
                ('إنجازاتي المرفوضة والملغاة', Icons.warning),
              ]),

              const Divider(color: Colors.grey),

              _buildMenuSection(context, title: 'التعرف على المنصة', items: [
                ('من نحن', Icons.groups),
                ('لماذا نحن', Icons.verified_user),
                ('أسئلة شائعة', Icons.question_answer),
                ('فوائد المنصة', Icons.star),
                ('الإعدادات والخصوصية', Icons.security),
                ('الدعم والمساعدة', Icons.support),
                ('اتصل بنا', Icons.email),
              ]),

              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () {
                  // Close the drawer first
                  Navigator.pop(context);
                  // Navigate to Login Screen and clear navigation stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, {required String title, required List<(String, IconData)> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        ...items.map((item) => ListTile(
          leading: Icon(item.$2, color: const Color(0xFFE2C044), size: 20),
          title: Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 14)),
          onTap: () {
            // Close the drawer
            Navigator.pop(context);
            
            // Show a polished SnackBar for placeholder screens
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF1A1A1A),
                content: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'جاري الانتقال إلى الصفحة...',
                    style: TextStyle(color: Color(0xFFE2C044), fontFamily: 'Cairo'),
                  ),
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        )),
      ],
    );
  }
}