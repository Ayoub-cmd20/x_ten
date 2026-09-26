import 'package:flutter/material.dart';

class WorkDetailsScreen extends StatelessWidget {
  final String title;
  final String creator;
  final String category;

  const WorkDetailsScreen({
    super.key,
    required this.title,
    required this.creator,
    required this.category,
  });

  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

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
            'تفاصيل العمل',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview
              Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      gold.withValues(alpha: 0.16),
                      const Color(0xFF161616),
                    ],
                  ),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.18),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: gold,
                    size: 70,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      // TODO: Save work
                    },
                    icon: const Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    color: gold,
                    size: 19,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    creator,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _section(
                title: 'وصف العمل',
                child: const Text(
                  'هذا العمل يمثل نموذجاً من أعمال صانع المحتوى السابقة. '
                      'يمكن عرض هنا تفاصيل الحملة، الفكرة الإعلانية، نوع المحتوى، '
                      'المنصة المستخدمة والنتائج المحققة.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'تفاصيل الحملة',
                child: const Column(
                  children: [
                    _InfoRow(
                      icon: Icons.campaign_outlined,
                      label: 'نوع العمل',
                      value: 'حملة إعلانية',
                    ),
                    SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.public_outlined,
                      label: 'المنصة',
                      value: 'Instagram',
                    ),
                    SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.visibility_outlined,
                      label: 'المشاهدات',
                      value: '125K',
                    ),
                    SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.favorite_border_rounded,
                      label: 'التفاعل',
                      value: '18.4K',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'عن صانع المحتوى',
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: gold,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            creator,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    OutlinedButton(
                      onPressed: () {
                        // TODO:
                        // Open influencer/creator profile
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: gold,
                        side: BorderSide(
                          color: gold.withValues(alpha: 0.30),
                        ),
                      ),
                      child: const Text(
                        'عرض الملف',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO:
                    // Start advertising/collaboration with creator
                  },
                  icon: const Icon(
                    Icons.campaign_outlined,
                  ),
                  label: Text(
                    'ابدأ تعاوناً مع $creator',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
        color: const Color(0xFF151515),
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

  static const Color gold = Color(0xFFE5C158);

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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}