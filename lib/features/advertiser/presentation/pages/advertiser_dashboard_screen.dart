import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/advertiser_demo_data.dart';
import '../../domain/models/advertiser_models.dart';

/// Home dashboard for the advertiser / brand role.
class AdvertiserDashboardScreen extends StatelessWidget {
  const AdvertiserDashboardScreen({super.key});

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  @override
  Widget build(BuildContext context) {
    final activeCampaigns = demoCampaigns
        .where((c) => c.status == CampaignStatus.active)
        .length;
    final availableInfluencers = demoInfluencers
        .where((i) => i.isAvailable)
        .length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'X TEN BUSINESS',
            style: TextStyle(
              color: _gold,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFF1A1A1A),
                child: Icon(
                  Icons.storefront_outlined,
                  color: _gold,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مرحباً بك مجدداً',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'لوحة تحكم المعلن',
                style: TextStyle(color: _gold, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // --------------------------------------------------
              // STATS ROW
              // --------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      title: 'حملات نشطة',
                      value: '$activeCampaigns',
                      icon: Icons.campaign_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'مؤثرون متاحون',
                      value: '$availableInfluencers',
                      icon: Icons.people_alt_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      title: 'مجالات',
                      value: '${demoInfluencerCategories.length}',
                      icon: Icons.category_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // MAIN SERVICES
              // --------------------------------------------------
              _serviceCard(
                title: 'قائمة المؤثرين',
                subtitle: 'تصفح وابحث عن المؤثر المناسب لحملتك',
                icon: Icons.people_alt_outlined,
                onTap: () => context.push('/advertiser/influencers'),
              ),
              const SizedBox(height: 14),

              _serviceCard(
                title: 'قائمة المؤثرين حسب المجالات',
                subtitle: 'فن، طبخ، رياضة، تكنولوجيا وأكثر',
                icon: Icons.grid_view_rounded,
                onTap: () => context.push('/advertiser/categories'),
              ),
              const SizedBox(height: 14),

              _serviceCard(
                title: 'إنشاء حملة إشهارية',
                subtitle: 'أنشئ حملة واربطها بمؤثر من اختيارك',
                icon: Icons.add_circle_outline_rounded,
                onTap: () => context.push('/advertiser/campaign/new'),
              ),
              const SizedBox(height: 14),

              _serviceCard(
                title: 'ترويج حسب الطلب',
                subtitle: 'أرسل احتياجك التسويقي وسنتكفل بالباقي',
                icon: Icons.rocket_launch_outlined,
                onTap: () => context.push('/advertiser/promotion/on-demand'),
              ),
              const SizedBox(height: 14),

              _serviceCard(
                title: 'طلبات الترويج الخاصة بي',
                subtitle: 'تتبع حالة طلباتك المرسلة',
                icon: Icons.assignment_outlined,
                onTap: () => context.push('/advertiser/promotion/requests'),
              ),
              const SizedBox(height: 14),

              _serviceCard(
                title: 'حملاتي',
                subtitle: 'إدارة ومتابعة حملاتك الإشهارية',
                icon: Icons.campaign_outlined,
                onTap: () => context.push('/advertiser/campaigns'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F1F1F)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: _gold, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: _gold,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1F1F1F)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: _gold, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.25),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
