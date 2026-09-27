import 'package:flutter/material.dart';

class FreelancerProfileScreen extends StatelessWidget {
  const FreelancerProfileScreen({
    super.key,
  });

  static const gold = Color(0xFFE5C158);
  static const background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          18,
          10,
          18,
          100,
        ),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 52,
              backgroundColor:
              Color(0xFF191919),
              child: Icon(
                Icons.person_rounded,
                size: 50,
                color: gold,
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Freelancer',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          const Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: Colors.greenAccent,
              ),
              SizedBox(width: 5),
              Text(
                'حساب موثق',
                style: TextStyle(
                  color:
                  Colors.greenAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          const _ProfileStatRow(),

          const SizedBox(height: 24),

          _section(
            title: 'نبذة',
            child: const Text(
              'مصمم ومطور مستقل متخصص في تقديم حلول رقمية احترافية.',
              style: TextStyle(
                color: Colors.white60,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 14),

          _section(
            title: 'المهارات',
            child: const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text('Flutter'),
                ),
                Chip(
                  label: Text('UI/UX'),
                ),
                Chip(
                  label: Text('Figma'),
                ),
                Chip(
                  label: Text('Photoshop'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          _section(
            title: 'الخدمات',
            child: const Column(
              children: [
                _ProfileListItem(
                  icon:
                  Icons.phone_android,
                  title:
                  'تطوير تطبيقات',
                ),
                _ProfileListItem(
                  icon:
                  Icons.design_services,
                  title:
                  'UI / UX Design',
                ),
                _ProfileListItem(
                  icon:
                  Icons.language,
                  title:
                  'Web Development',
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          _section(
            title: 'إعدادات الحساب',
            child: const Column(
              children: [
                _ProfileListItem(
                  icon:
                  Icons.edit_outlined,
                  title:
                  'تعديل الملف الشخصي',
                ),
                _ProfileListItem(
                  icon:
                  Icons.account_balance_outlined,
                  title:
                  'المعلومات المالية',
                ),
                _ProfileListItem(
                  icon:
                  Icons.folder_outlined,
                  title:
                  'وثائقي',
                ),
                _ProfileListItem(
                  icon:
                  Icons.notifications_outlined,
                  title:
                  'الإشعارات',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }
}

class _ProfileStatRow
    extends StatelessWidget {
  const _ProfileStatRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _Stat(
            value: '4.9',
            title: 'التقييم',
          ),
        ),

        Expanded(
          child: _Stat(
            value: '35',
            title: 'مشروع',
          ),
        ),

        Expanded(
          child: _Stat(
            value: '96%',
            title: 'نجاح',
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String title;

  const _Stat({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE5C158),
            fontSize: 20,
            fontWeight:
            FontWeight.w900,
          ),
        ),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
}

class _ProfileListItem
    extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileListItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Icon(
        icon,
        color: const Color(
          0xFFE5C158,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white24,
        size: 15,
      ),
    );
  }
}