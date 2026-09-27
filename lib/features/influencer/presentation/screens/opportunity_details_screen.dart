import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OpportunityDetailsScreen extends StatelessWidget {
  final String title;
  final String brand;
  final String category;
  final String budget;
  final String deadline;
  final String description;
  final String type;
  final List<String> platforms;

  const OpportunityDetailsScreen({
    super.key,
    required this.title,
    required this.brand,
    required this.category,
    required this.budget,
    required this.deadline,
    required this.description,
    required this.type,
    required this.platforms,
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
          title: const Text(
            'تفاصيل الفرصة',
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
            120,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gold.withValues(
                    alpha: 0.15,
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: gold.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.campaign_outlined,
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
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight:
                                FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              brand,
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(text: type),
                      _Tag(text: category),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'وصف الحملة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white60,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _InfoCard(
              icon: Icons.payments_outlined,
              title: 'الميزانية',
              value: budget,
            ),

            _InfoCard(
              icon: Icons.schedule_outlined,
              title: 'آخر أجل',
              value: deadline,
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المنصات المطلوبة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: platforms.map(
                          (platform) {
                        return Chip(
                          label: Text(
                            platform,
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        backgroundColor:
                        const Color(0xFF171717),

                        title: const Text(
                          'إرسال طلب المشاركة',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        content: Text(
                          'هل تريد التقدم للمشاركة في حملة "$title"؟',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },
                            child: const Text(
                              'إلغاء',
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                              );

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'تم إرسال طلب المشاركة بنجاح',
                                    textDirection:
                                    TextDirection.rtl,
                                  ),
                                ),
                              );
                            },
                            style:
                            ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor:
                              Colors.black,
                            ),
                            child: const Text(
                              'إرسال',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.send_rounded,
              ),
              label: const Text(
                'التقدم لهذه الفرصة',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                minimumSize:
                const Size.fromHeight(54),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(
                'رجوع',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF151515),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE5C158),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE5C158)
            .withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE5C158),
          fontSize: 11,
        ),
      ),
    );
  }
}