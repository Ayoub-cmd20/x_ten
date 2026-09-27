import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FreelancerDashboardScreen extends StatefulWidget {
  const FreelancerDashboardScreen({
    super.key,
  });

  @override
  State<FreelancerDashboardScreen> createState() =>
      _FreelancerDashboardScreenState();
}

class _FreelancerDashboardScreenState
    extends State<FreelancerDashboardScreen> {
  static const Color _gold =
  Color(0xFFE5C158);

  static const Color _background =
  Color(0xFF0A0A0A);

  static const Color _surface =
  Color(0xFF151515);

  static const Color _surface2 =
  Color(0xFF1B1B1B);

  int _selectedIndex = 0;

  final List<_DashboardStat> _stats = const [
    _DashboardStat(
      title: 'المشاريع النشطة',
      value: '3',
      icon: Icons.work_outline_rounded,
    ),
    _DashboardStat(
      title: 'العروض الجديدة',
      value: '12',
      icon: Icons.local_offer_outlined,
    ),
    _DashboardStat(
      title: 'التقييم',
      value: '4.9',
      icon: Icons.star_outline_rounded,
    ),
    _DashboardStat(
      title: 'الأرباح',
      value: '84K دج',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  final List<_OpportunityItem> _opportunities =
  const [
    _OpportunityItem(
      title: 'تصميم هوية بصرية',
      company: 'Nova Digital',
      budget: '45,000 دج',
      time: 'منذ 15 دقيقة',
      type: 'تصميم',
    ),
    _OpportunityItem(
      title: 'تطوير Landing Page',
      company: 'Tech DZ',
      budget: '60,000 دج',
      time: 'منذ ساعة',
      type: 'Web',
    ),
    _OpportunityItem(
      title: 'مونتاج فيديو إعلاني',
      company: 'Vision Media',
      budget: '30,000 دج',
      time: 'منذ ساعتين',
      type: 'Video',
    ),
  ];

  final List<_ProjectItem> _projects = const [
    _ProjectItem(
      title: 'تصميم تطبيق توصيل',
      client: 'Fast Delivery',
      progress: 0.75,
      deadline: '3 أيام',
    ),
    _ProjectItem(
      title: 'إدارة صفحة Instagram',
      client: 'Beauty House',
      progress: 0.45,
      deadline: '8 أيام',
    ),
  ];

  void _changeTab(
      int index,
      ) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        context.push(
          '/freelancer/opportunities',
        );
        break;

      case 2:
        context.push(
          '/freelancer/projects',
        );
        break;

      case 3:
        context.push(
          '/messages',
        );
        break;

      case 4:
        context.push(
          '/freelancer/profile',
        );
        break;
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,

        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,

          title: const Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'لوحة التحكم',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w900,
                ),
              ),
              Text(
                'Freelancer Dashboard',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          actions: [
            IconButton(
              onPressed: () {
                context.push(
                  '/messages',
                );
              },
              icon: const Icon(
                Icons.chat_bubble_outline_rounded,
              ),
            ),

            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                  ),
                ),

                PositionedDirectional(
                  top: 10,
                  start: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration:
                    const BoxDecoration(
                      color:
                      Colors.redAccent,
                      shape:
                      BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              width: 4,
            ),
          ],
        ),

        body: SafeArea(
          child: RefreshIndicator(
            color: _gold,
            onRefresh: () async {
              await Future<void>.delayed(
                const Duration(
                  milliseconds: 800,
                ),
              );
            },

            child: ListView(
              padding:
              const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                110,
              ),
              children: [
                _buildWelcomeCard(),

                const SizedBox(
                  height: 20,
                ),

                _buildSectionTitle(
                  'نظرة عامة',
                ),

                const SizedBox(
                  height: 12,
                ),

                GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount:
                  _stats.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder:
                      (context, index) {
                    return _buildStatCard(
                      _stats[index],
                    );
                  },
                ),

                const SizedBox(
                  height: 24,
                ),

                _buildQuickActions(),

                const SizedBox(
                  height: 24,
                ),

                _buildSectionHeader(
                  title:
                  'فرص مناسبة لك',
                  actionTitle:
                  'عرض الكل',
                  onTap: () {
                    context.push(
                      '/freelancer/opportunities',
                    );
                  },
                ),

                const SizedBox(
                  height: 12,
                ),

                ..._opportunities.map(
                  _buildOpportunityCard,
                ),

                const SizedBox(
                  height: 24,
                ),

                _buildSectionHeader(
                  title:
                  'مشاريعي الحالية',
                  actionTitle:
                  'كل المشاريع',
                  onTap: () {
                    context.push(
                      '/freelancer/projects',
                    );
                  },
                ),

                const SizedBox(
                  height: 12,
                ),

                ..._projects.map(
                  _buildProjectCard,
                ),

                const SizedBox(
                  height: 24,
                ),

                _buildPerformanceCard(),
              ],
            ),
          ),
        ),

        bottomNavigationBar:
        _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(22),

        gradient:
        const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF252015),
            Color(0xFF171717),
            Color(0xFF111111),
          ],
        ),

        border: Border.all(
          color: _gold.withValues(
            alpha: 0.25,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: _gold.withValues(
              alpha: 0.08,
            ),
            blurRadius: 24,
            offset:
            const Offset(
              0,
              10,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration:
            BoxDecoration(
              shape: BoxShape.circle,
              color:
              _surface2,
              border: Border.all(
                color: _gold,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: _gold,
              size: 32,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          const Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك 👋',
                  style: TextStyle(
                    color:
                    Colors.white54,
                    fontSize: 12,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'Freelancer',
                  style: TextStyle(
                    color:
                    Colors.white,
                    fontSize: 19,
                    fontWeight:
                    FontWeight.w900,
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Text(
                  'حسابك موثق وجاهز لاستقبال المشاريع',
                  style: TextStyle(
                    color: _gold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration:
            BoxDecoration(
              color:
              Colors.green
                  .withValues(
                alpha: 0.12,
              ),
              borderRadius:
              BorderRadius.circular(
                50,
              ),
            ),
            child: const Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color:
                  Colors.greenAccent,
                  size: 16,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'موثق',
                  style: TextStyle(
                    color:
                    Colors.greenAccent,
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      _DashboardStat stat,
      ) {
    return Container(
      padding: const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
          Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            stat.icon,
            color: _gold,
            size: 24,
          ),

          const Spacer(),

          Text(
            stat.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight:
              FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            stat.title,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions =
    <_QuickAction>[
      _QuickAction(
        title: 'الخدمات',
        icon:
        Icons.design_services_outlined,
        onTap: () {
          context.push(
            '/freelancer/services',
          );
        },
      ),

      _QuickAction(
        title: 'Portfolio',
        icon:
        Icons.collections_outlined,
        onTap: () {
          context.push(
            '/freelancer/portfolio',
          );
        },
      ),

      _QuickAction(
        title: 'المشاريع',
        icon:
        Icons.work_outline_rounded,
        onTap: () {
          context.push(
            '/freelancer/projects',
          );
        },
      ),

      _QuickAction(
        title: 'الرسائل',
        icon:
        Icons.chat_outlined,
        onTap: () {
          context.push(
            '/messages',
          );
        },
      ),
    ];

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(
          'وصول سريع',
        ),

        const SizedBox(
          height: 12,
        ),

        Row(
          children: actions.map(
                (action) {
              return Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: InkWell(
                    onTap:
                    action.onTap,
                    borderRadius:
                    BorderRadius.circular(
                      16,
                    ),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        _surface,
                        borderRadius:
                        BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            action.icon,
                            color:
                            _gold,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            action.title,
                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                              fontSize:
                              10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildOpportunityCard(
      _OpportunityItem item,
      ) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius:
        BorderRadius.circular(
          18,
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
                  item.title,
                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration:
                BoxDecoration(
                  color:
                  _gold.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  item.type,
                  style:
                  const TextStyle(
                    color: _gold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          Text(
            item.company,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 16,
                color: _gold,
              ),

              const SizedBox(
                width: 5,
              ),

              Text(
                item.budget,
                style:
                const TextStyle(
                  color: _gold,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const Spacer(),

              Text(
                item.time,
                style:
                const TextStyle(
                  color:
                  Colors.white24,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
      _ProjectItem project,
      ) {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius:
        BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          Text(
            project.client,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          LinearProgressIndicator(
            value: project.progress,
            minHeight: 7,
            backgroundColor:
            const Color(
              0xFF292929,
            ),
            color: _gold,
          ),

          const SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Text(
                '${(project.progress * 100).round()}%',
                style:
                const TextStyle(
                  color: _gold,
                  fontSize: 11,
                ),
              ),

              const Spacer(),

              Text(
                'متبقي ${project.deadline}',
                style:
                const TextStyle(
                  color:
                  Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: const Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'أداء حسابك',
            style: TextStyle(
              color: Colors.white,
              fontWeight:
              FontWeight.w900,
              fontSize: 16,
            ),
          ),

          SizedBox(
            height: 16,
          ),

          _PerformanceRow(
            title: 'إكمال المشاريع',
            value: '96%',
          ),

          _PerformanceRow(
            title: 'التسليم في الموعد',
            value: '94%',
          ),

          _PerformanceRow(
            title: 'إعادة التوظيف',
            value: '82%',
          ),

          _PerformanceRow(
            title: 'معدل الاستجابة',
            value: '98%',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex:
      _selectedIndex,
      backgroundColor:
      const Color(
        0xFF111111,
      ),
      indicatorColor:
      _gold.withValues(
        alpha: 0.15,
      ),
      onDestinationSelected:
      _changeTab,
      destinations:
      const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: _gold,
          ),
          label: 'الرئيسية',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.explore_outlined,
          ),
          selectedIcon: Icon(
            Icons.explore_rounded,
            color: _gold,
          ),
          label: 'الفرص',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.work_outline,
          ),
          selectedIcon: Icon(
            Icons.work_rounded,
            color: _gold,
          ),
          label: 'مشاريعي',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
          ),
          selectedIcon: Icon(
            Icons.chat_bubble_rounded,
            color: _gold,
          ),
          label: 'الرسائل',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
          ),
          selectedIcon: Icon(
            Icons.person_rounded,
            color: _gold,
          ),
          label: 'حسابي',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
      String title,
      ) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight:
        FontWeight.w900,
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionTitle,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child:
          _buildSectionTitle(
            title,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionTitle,
            style: const TextStyle(
              color: _gold,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardStat {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class _OpportunityItem {
  final String title;
  final String company;
  final String budget;
  final String time;
  final String type;

  const _OpportunityItem({
    required this.title,
    required this.company,
    required this.budget,
    required this.time,
    required this.type,
  });
}

class _ProjectItem {
  final String title;
  final String client;
  final double progress;
  final String deadline;

  const _ProjectItem({
    required this.title,
    required this.client,
    required this.progress,
    required this.deadline,
  });
}

class _QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class _PerformanceRow
    extends StatelessWidget {
  final String title;
  final String value;

  const _PerformanceRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style:
              const TextStyle(
                color:
                Colors.white54,
              ),
            ),
          ),
          Text(
            value,
            style:
            const TextStyle(
              color:
              Color(
                0xFFE5C158,
              ),
              fontWeight:
              FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}