import 'package:flutter/material.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
class AdvertiserProfileScreen extends StatelessWidget {
  final String companyName;
  final String category;

  const AdvertiserProfileScreen({
    super.key,
    required this.companyName,
    required this.category,
  });

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'ملف المعلن',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.stretch,
            children: [
              // =====================================================
              // HEADER
              // =====================================================

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      gold.withValues(alpha: 0.14),
                      gold.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: gold.withValues(alpha: 0.28),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.business_rounded,
                        color: gold,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      companyName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      category,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withValues(
                            alpha: 0.20,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'معلن موثّق',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =====================================================
              // ABOUT
              // =====================================================

              _section(
                title: 'عن المعلن',
                child: Text(
                  '$companyName معلن يستخدم منصة X Ten '
                      'لإنشاء الحملات الإشهارية والتعاون مع المؤثرين '
                      'وصناع المحتوى في مجال $category.',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // =====================================================
              // INFORMATION
              // =====================================================

              _section(
                title: 'معلومات المعلن',
                child: const Column(
                  children: [
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'الموقع',
                      value: 'الجزائر',
                    ),
                    SizedBox(height: 13),

                    _InfoRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'عضو منذ',
                      value: '2026',
                    ),
                    SizedBox(height: 13),

                    _InfoRow(
                      icon: Icons.star_outline_rounded,
                      label: 'التقييم',
                      value: '4.8 / 5',
                    ),
                    SizedBox(height: 13),

                    _InfoRow(
                      icon: Icons.work_outline_rounded,
                      label: 'المشاريع المنشورة',
                      value: '12',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // =====================================================
              // STATS
              // =====================================================

              _section(
                title: 'إحصائيات التعاون',
                child: Row(
                  children: const [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.task_alt_rounded,
                        value: '8',
                        label: 'حملات مكتملة',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.groups_outlined,
                        value: '15',
                        label: 'مؤثر متعاون',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.thumb_up_alt_outlined,
                        value: '96%',
                        label: 'رضا',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // =====================================================
              // ACTIVE PROJECTS
              // =====================================================

              _section(
                title: 'مشاريع حالية',
                child: Column(
                  children: [
                    _projectItem(
                      title: 'حملة ترويجية جديدة',
                      subtitle: category,
                    ),
                    const SizedBox(height: 10),
                    _projectItem(
                      title: 'إطلاق منتج جديد',
                      subtitle: 'تسويق بالمؤثرين',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =====================================================
              // CONTACT
              // =====================================================

              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationsScreen(
                          advertiserId: companyName,
                          advertiserName: companyName,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                  ),
                  label: const Text(
                    'التواصل مع المعلن',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: gold,
                    side: BorderSide(
                      color: gold.withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }

  Widget _projectItem({
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              color: gold,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white24,
            size: 13,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: gold,
          size: 19,
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  static const Color gold =
  Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: gold,
            size: 20,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}