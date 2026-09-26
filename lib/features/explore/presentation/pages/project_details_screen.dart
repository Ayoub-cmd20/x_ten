import 'package:flutter/material.dart';
import 'project_application_screen.dart';
import 'advertiser_profile_screen.dart';
class ProjectDetailsScreen extends StatelessWidget {
  final String title;
  final String company;
  final String category;
  final String budget;

  const ProjectDetailsScreen({
    super.key,
    required this.title,
    required this.company,
    required this.category,
    required this.budget,
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
            'تفاصيل المشروع',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectApplicationScreen(
                        projectTitle: title,
                        company: company,
                        category: category,
                        budget: budget,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.send_outlined,
                ),
                label: const Text(
                  'التقدم للمشروع',
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
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      gold.withValues(alpha: 0.14),
                      const Color(0xFF161616),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: gold.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.work_outline_rounded,
                            color: gold,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w900,
                                  height: 1.35,
                                ),
                              ),

                              const SizedBox(height: 7),

                              Text(
                                company,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            // TODO:
                            // Save project
                          },
                          icon: const Icon(
                            Icons.bookmark_border_rounded,
                            color: gold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _badge(
                          icon: Icons.category_outlined,
                          text: category,
                        ),
                        _badge(
                          icon: Icons.payments_outlined,
                          text: budget,
                        ),
                        _badge(
                          icon: Icons.schedule_outlined,
                          text: 'مفتوح للتقديم',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _section(
                title: 'وصف المشروع',
                child: const Text(
                  'تبحث العلامة التجارية عن مؤثرين أو صناع محتوى '
                      'للمشاركة في حملة إعلانية مخصصة للترويج لمنتج أو خدمة. '
                      'يتم اختيار المشاركين حسب المجال، جودة المحتوى، '
                      'معدل التفاعل ومدى توافق الجمهور مع أهداف الحملة.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'متطلبات المشروع',
                child: const Column(
                  children: [
                    _RequirementRow(
                      text:
                      'إنشاء محتوى أصلي واحترافي خاص بالحملة.',
                    ),
                    SizedBox(height: 10),
                    _RequirementRow(
                      text:
                      'احترام التعليمات والهوية البصرية للعلامة التجارية.',
                    ),
                    SizedBox(height: 10),
                    _RequirementRow(
                      text:
                      'نشر المحتوى في التاريخ المتفق عليه.',
                    ),
                    SizedBox(height: 10),
                    _RequirementRow(
                      text:
                      'تقديم إحصائيات الأداء بعد نشر المحتوى.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'تفاصيل المشروع',
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.apartment_outlined,
                      label: 'المعلن',
                      value: company,
                    ),
                    const SizedBox(height: 13),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'المجال',
                      value: category,
                    ),
                    const SizedBox(height: 13),
                    _InfoRow(
                      icon: Icons.payments_outlined,
                      label: 'الميزانية',
                      value: budget,
                    ),
                    const SizedBox(height: 13),
                    const _InfoRow(
                      icon: Icons.groups_outlined,
                      label: 'عدد المؤثرين المطلوب',
                      value: '3 - 5',
                    ),
                    const SizedBox(height: 13),
                    const _InfoRow(
                      icon: Icons.public_outlined,
                      label: 'المنصة',
                      value: 'Instagram / TikTok',
                    ),
                    const SizedBox(height: 13),
                    const _InfoRow(
                      icon: Icons.video_camera_back_outlined,
                      label: 'نوع المحتوى',
                      value: 'Reel + Story',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'الفئة المستهدفة',
                child: const Text(
                  'شباب مهتمون بالمحتوى الرقمي والمنتجات الحديثة، '
                      'مع تركيز على المستخدمين النشطين على شبكات التواصل الاجتماعي.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _section(
                title: 'عن المعلن',
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: gold.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.business_outlined,
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
                            company,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'معلن على منصة X Ten',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdvertiserProfileScreen(
                              companyName: company,
                              category: category,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: gold,
                        side: BorderSide(
                          color: gold.withValues(alpha: 0.30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'عرض الملف',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.18),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.orange,
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'قبل التقدم، تأكد من أن ملفك الشخصي ومعلومات '
                            'حسابات التواصل الاجتماعي وأعمالك السابقة محدثة.',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12.5,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: gold,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;

  const _RequirementRow({
    required this.text,
  });

  static const Color gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: gold,
            size: 19,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}