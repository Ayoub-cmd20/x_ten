import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({
    super.key,
  });

  @override
  State<OpportunitiesScreen> createState() =>
      _OpportunitiesScreenState();
}

class _OpportunitiesScreenState
    extends State<OpportunitiesScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  String selectedFilter = 'الكل';

  final List<String> filters = const [
    'الكل',
    'إعلانات',
    'Collaboration',
    'Ambassador',
    'UGC',
  ];

  final List<_CampaignOpportunity> opportunities = const [
    _CampaignOpportunity(
      title: 'حملة إطلاق منتج جديد',
      brand: 'Nova Beauty',
      category: 'Beauty',
      budget: '40,000 - 60,000 دج',
      deadline: '3 أيام',
      platforms: [
        'Instagram',
        'TikTok',
      ],
      description:
      'نبحث عن صانع محتوى لإنشاء فيديو Reels وStories للترويج لمنتج تجميلي جديد.',
      type: 'إعلان',
    ),
    _CampaignOpportunity(
      title: 'تغطية افتتاح مطعم',
      brand: 'Food House',
      category: 'Food',
      budget: '25,000 دج',
      deadline: '5 أيام',
      platforms: [
        'Instagram',
        'Facebook',
      ],
      description:
      'تغطية الافتتاح، تصوير المحتوى ونشر Reel مع Stories.',
      type: 'Collaboration',
    ),
    _CampaignOpportunity(
      title: 'Brand Ambassador',
      brand: 'Sport DZ',
      category: 'Sport',
      budget: '80,000 دج / شهر',
      deadline: '10 أيام',
      platforms: [
        'Instagram',
        'TikTok',
        'YouTube',
      ],
      description:
      'نبحث عن سفير للعلامة التجارية للتعاون لمدة ثلاثة أشهر.',
      type: 'Ambassador',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: const Text(
            'فرص التعاون',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            100,
          ),
          children: [
            _buildHeaderCard(),

            const SizedBox(height: 20),

            TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'ابحث عن حملة أو علامة تجارية...',
                hintStyle: const TextStyle(
                  color: Colors.white38,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: gold,
                ),
                filled: true,
                fillColor: surface,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = filters[index];
                  final selected =
                      selectedFilter == item;

                  return ChoiceChip(
                    selected: selected,
                    label: Text(item),
                    selectedColor:
                    gold.withValues(alpha: 0.18),
                    backgroundColor: surface,
                    side: BorderSide(
                      color: selected
                          ? gold
                          : Colors.white12,
                    ),
                    labelStyle: TextStyle(
                      color: selected
                          ? gold
                          : Colors.white70,
                      fontWeight:
                      FontWeight.w700,
                    ),
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = item;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'فرص مناسبة لك',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 12),

            ...opportunities.map(
                  (item) => _OpportunityCard(
                opportunity: item,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF292314),
            Color(0xFF171717),
            Color(0xFF111111),
          ],
        ),
        border: Border.all(
          color: gold.withValues(alpha: 0.25),
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF242014),
            child: Icon(
              Icons.campaign_outlined,
              color: gold,
              size: 28,
            ),
          ),

          SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'اكتشف فرصاً جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'حملات وإعلانات وتعاونات مناسبة لمحتواك وجمهورك.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final _CampaignOpportunity opportunity;

  const _OpportunityCard({
    required this.opportunity,
  });

  static const gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: gold.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.business_center_outlined,
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
                      opportunity.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      opportunity.brand,
                      style: const TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: gold.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                  BorderRadius.circular(8),
                ),
                child: Text(
                  opportunity.type,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            opportunity.description,
            style: const TextStyle(
              color: Colors.white60,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
            opportunity.platforms.map(
                  (platform) {
                return Chip(
                  label: Text(platform),
                  backgroundColor:
                  const Color(0xFF202020),
                  side: BorderSide.none,
                  labelStyle:
                  const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: gold,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                opportunity.budget,
                style: const TextStyle(
                  color: gold,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.schedule_outlined,
                color: Colors.white38,
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                opportunity.deadline,
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/creator/opportunity-details',
                  extra: {
                    'title':
                    opportunity.title,
                    'brand':
                    opportunity.brand,
                    'category':
                    opportunity.category,
                    'budget':
                    opportunity.budget,
                    'deadline':
                    opportunity.deadline,
                    'description':
                    opportunity.description,
                    'type':
                    opportunity.type,
                    'platforms':
                    opportunity.platforms,
                  },
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor:
                Colors.black,
                minimumSize:
                const Size.fromHeight(48),
              ),
              child: const Text(
                'عرض تفاصيل الفرصة',
                style: TextStyle(
                  fontWeight:
                  FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignOpportunity {
  final String title;
  final String brand;
  final String category;
  final String budget;
  final String deadline;
  final List<String> platforms;
  final String description;
  final String type;

  const _CampaignOpportunity({
    required this.title,
    required this.brand,
    required this.category,
    required this.budget,
    required this.deadline,
    required this.platforms,
    required this.description,
    required this.type,
  });
}