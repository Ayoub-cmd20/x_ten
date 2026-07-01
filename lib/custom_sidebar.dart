import 'package:flutter/material.dart';

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
              _buildMenuSection(title: 'أدوات المحتوى والإعلانات', items: [
                ('مقالات وأخبار', Icons.newspaper),
                ('أنواع وصيغ الإشهار', Icons.category),
                ('تصفح معرض الأعمال', Icons.video_library),
                ('تصفح مشاريع العناصر المحفوظة', Icons.folder),
                ('إنجازاتي مكتملة', Icons.check_circle),
                ('إنجازاتي المرفوضة والملغاة', Icons.warning),
              ]),

              const Divider(color: Colors.grey),

              _buildMenuSection(title: 'التعرف على المنصة', items: [
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
                leading: const Icon(Icons.logout, color: Colors.grey),
                title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.grey)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<(String, IconData)> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        ...items.map((item) => ListTile(
          leading: Icon(item.$2, color: const Color(0xFFE2C044), size: 20),
          title: Text(item.$1, style: const TextStyle(color: Colors.white, fontSize: 14)),
          onTap: () {},
        )),
      ],
    );
  }
}