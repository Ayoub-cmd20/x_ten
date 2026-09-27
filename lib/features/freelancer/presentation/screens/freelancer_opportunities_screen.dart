import 'package:flutter/material.dart';

class FreelancerOpportunitiesScreen extends StatefulWidget {
  const FreelancerOpportunitiesScreen({
    super.key,
  });

  @override
  State<FreelancerOpportunitiesScreen> createState() =>
      _FreelancerOpportunitiesScreenState();
}

class _FreelancerOpportunitiesScreenState
    extends State<FreelancerOpportunitiesScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  final List<_Opportunity> opportunities = const [
    _Opportunity(
      title: 'تصميم هوية بصرية لمتجر',
      company: 'Nova Digital',
      category: 'Graphic Design',
      budget: '45,000 دج',
      duration: '5 أيام',
    ),
    _Opportunity(
      title: 'تطوير Landing Page',
      company: 'Tech DZ',
      category: 'Web Development',
      budget: '60,000 دج',
      duration: '7 أيام',
    ),
    _Opportunity(
      title: 'مونتاج فيديو إعلاني',
      company: 'Vision Media',
      category: 'Video Editing',
      budget: '30,000 دج',
      duration: '3 أيام',
    ),
    _Opportunity(
      title: 'تصميم واجهة تطبيق',
      company: 'Smart Solutions',
      category: 'UI / UX',
      budget: '70,000 دج',
      duration: '10 أيام',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'فرص العمل',
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
          TextField(
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'ابحث عن فرصة عمل...',
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

          const SizedBox(height: 20),

          const Text(
            'فرص مقترحة لك',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 14),

          ...opportunities.map(
                (item) => _OpportunityCard(
              opportunity: item,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final _Opportunity opportunity;

  const _OpportunityCard({
    required this.opportunity,
  });

  static const gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius:
        BorderRadius.circular(18),
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
              Expanded(
                child: Text(
                  opportunity.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w800,
                  ),
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
                  opportunity.category,
                  style: const TextStyle(
                    color: gold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            opportunity.company,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 18,
                color: gold,
              ),

              const SizedBox(width: 6),

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
                opportunity.duration,
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
              onPressed: () {},
              style:
              ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor:
                Colors.black,
              ),
              child: const Text(
                'عرض تفاصيل المشروع',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Opportunity {
  final String title;
  final String company;
  final String category;
  final String budget;
  final String duration;

  const _Opportunity({
    required this.title,
    required this.company,
    required this.category,
    required this.budget,
    required this.duration,
  });
}