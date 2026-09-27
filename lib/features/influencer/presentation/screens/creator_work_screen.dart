import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreatorWorkScreen extends StatefulWidget {
  const CreatorWorkScreen({
    super.key,
  });

  @override
  State<CreatorWorkScreen> createState() =>
      _CreatorWorkScreenState();
}

class _CreatorWorkScreenState
    extends State<CreatorWorkScreen> {
  static const gold = Color(0xFFE5C158);
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF151515);

  int selectedTab = 0;

  final tabs = const [
    'النشطة',
    'بانتظار الموافقة',
    'مكتملة',
  ];

  final projects = const [
    _CreatorProject(
      title: 'حملة Nova Beauty',
      brand: 'Nova Beauty',
      status: 'قيد التنفيذ',
      progress: 0.70,
      deadline: '3 أيام',
      amount: '45,000 دج',
      deliverables: '1 Reel + 3 Stories',
    ),
    _CreatorProject(
      title: 'إعلان Sport DZ',
      brand: 'Sport DZ',
      status: 'بانتظار المحتوى',
      progress: 0.45,
      deadline: '6 أيام',
      amount: '35,000 دج',
      deliverables: '2 TikTok Videos',
    ),
    _CreatorProject(
      title: 'تغطية Food House',
      brand: 'Food House',
      status: 'المراجعة النهائية',
      progress: 0.90,
      deadline: 'يومان',
      amount: '25,000 دج',
      deliverables: '1 Reel + Photos',
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
            'إدارة أعمالي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
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
            _buildSummary(),

            const SizedBox(height: 20),

            Container(
              height: 48,
              padding:
              const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: surface,
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Row(
                children:
                List.generate(
                  tabs.length,
                      (index) {
                    final selected =
                        selectedTab == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                        child:
                        AnimatedContainer(
                          duration:
                          const Duration(
                            milliseconds: 200,
                          ),
                          decoration:
                          BoxDecoration(
                            color: selected
                                ? gold
                                .withValues(
                              alpha: .15,
                            )
                                : Colors
                                .transparent,
                            borderRadius:
                            BorderRadius
                                .circular(
                              11,
                            ),
                          ),
                          alignment:
                          Alignment.center,
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: selected
                                  ? gold
                                  : Colors
                                  .white54,
                              fontSize: 11,
                              fontWeight:
                              FontWeight
                                  .w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            ...projects.map(
              _buildProjectCard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Row(
      children: const [
        Expanded(
          child: _SummaryCard(
            value: '3',
            label: 'حملات نشطة',
            icon: Icons.work_outline,
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: _SummaryCard(
            value: '105K',
            label: 'قيمة العقود',
            icon:
            Icons.payments_outlined,
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: _SummaryCard(
            value: '96%',
            label: 'التسليم',
            icon:
            Icons.task_alt_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(
      _CreatorProject project,
      ) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),
      padding:
      const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius:
        BorderRadius.circular(
          20,
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
                  project.title,
                  style:
                  const TextStyle(
                    color:
                    Colors.white,
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
                decoration:
                BoxDecoration(
                  color:
                  gold.withValues(
                    alpha: .12,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  project.status,
                  style:
                  const TextStyle(
                    color: gold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            project.brand,
            style: const TextStyle(
              color: Colors.white38,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            project.deliverables,
            style: const TextStyle(
              color: Colors.white60,
            ),
          ),

          const SizedBox(height: 14),

          LinearProgressIndicator(
            value: project.progress,
            minHeight: 7,
            color: gold,
            backgroundColor:
            const Color(
              0xFF292929,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                '${(project.progress * 100).round()}%',
                style:
                const TextStyle(
                  color: gold,
                ),
              ),

              const Spacer(),

              Text(
                'متبقي ${project.deadline}',
                style:
                const TextStyle(
                  color:
                  Colors.white38,
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
              const SizedBox(width: 5),
              Text(
                project.amount,
                style:
                const TextStyle(
                  color: gold,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.push(
                    '/creator/project-details',
                    extra: {
                      'title':
                      project.title,
                      'brand':
                      project.brand,
                      'status':
                      project.status,
                      'progress':
                      project.progress,
                      'deadline':
                      project.deadline,
                      'amount':
                      project.amount,
                      'deliverables':
                      project.deliverables,
                    },
                  );
                },
                child: const Text(
                  'إدارة المشروع',
                  style: TextStyle(
                    color: gold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(
        12,
      ),
      decoration: BoxDecoration(
        color:
        const Color(
          0xFF151515,
        ),
        borderRadius:
        BorderRadius.circular(
          16,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
            const Color(
              0xFFE5C158,
            ),
            size: 21,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style:
            const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight:
              FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              color:
              Colors.white38,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorProject {
  final String title;
  final String brand;
  final String status;
  final double progress;
  final String deadline;
  final String amount;
  final String deliverables;

  const _CreatorProject({
    required this.title,
    required this.brand,
    required this.status,
    required this.progress,
    required this.deadline,
    required this.amount,
    required this.deliverables,
  });
}