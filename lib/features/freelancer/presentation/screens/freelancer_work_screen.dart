import 'package:flutter/material.dart';

class FreelancerWorkScreen extends StatelessWidget {
  const FreelancerWorkScreen({
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
          'مشاريعي',
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
        children: const [
          _ProjectCard(
            title: 'تصميم تطبيق توصيل',
            client: 'Fast Delivery',
            progress: 0.75,
            deadline: '3 أيام',
            budget: '70,000 دج',
          ),

          _ProjectCard(
            title: 'إدارة حساب Instagram',
            client: 'Beauty House',
            progress: 0.45,
            deadline: '8 أيام',
            budget: '35,000 دج',
          ),

          _ProjectCard(
            title: 'Website Redesign',
            client: 'DZ Market',
            progress: 0.90,
            deadline: 'يومان',
            budget: '90,000 دج',
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final String client;
  final double progress;
  final String deadline;
  final String budget;

  const _ProjectCard({
    required this.title,
    required this.client,
    required this.progress,
    required this.deadline,
    required this.budget,
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

          const SizedBox(height: 5),

          Text(
            client,
            style: const TextStyle(
              color: Colors.white38,
            ),
          ),

          const SizedBox(height: 14),

          LinearProgressIndicator(
            value: progress,
            minHeight: 7,
            color: gold,
            backgroundColor:
            const Color(0xFF292929),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: gold,
                ),
              ),

              const Spacer(),

              Text(
                'متبقي $deadline',
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: gold,
                size: 18,
              ),

              const SizedBox(width: 6),

              Text(
                budget,
                style: const TextStyle(
                  color: gold,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}