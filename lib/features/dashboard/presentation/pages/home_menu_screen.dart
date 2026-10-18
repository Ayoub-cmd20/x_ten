import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:x_ten/features/contracts_agreements/presentation/pages/contracts_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/conversations_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/creator_profile_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/influencer/opportunities_screen.dart';
import 'package:x_ten/features/marketplace/presentation/pages/influencers_list_screen.dart';
import 'package:x_ten/features/influencer/presentation/screens/influencer_categories_screen.dart';
import 'package:x_ten/features/settings_security/presentation/pages/financial_security_screen.dart';
import 'package:x_ten/features/work_management/presentation/pages/notifications_approval_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/on_demand_promotion_screen.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/my_promotion_requests_screen.dart';
import 'package:x_ten/features/marketplace/presentation/pages/professional_services_screen.dart';
import 'package:x_ten/features/invitations/presentation/pages/invite_user_type_screen.dart';
import 'package:x_ten/features/saved_items/presentation/pages/saved_items_screen.dart';
import 'package:x_ten/features/explore/presentation/pages/articles_news_screen.dart';
import 'package:x_ten/features/explore/presentation/pages/advertising_formats_screen.dart';
import 'package:x_ten/features/explore/presentation/pages/portfolio_gallery_screen.dart';
import 'package:x_ten/features/explore/presentation/pages/projects_browser_screen.dart';
import 'package:x_ten/features/platform/presentation/pages/about_platform_screen.dart';
import 'package:x_ten/features/platform/presentation/pages/about_us_screen.dart';
import 'package:x_ten/features/platform/presentation/pages/faq_screen.dart';
// ============================================================
// DZ-PUP MARKETPLACE — HOME MENU SCREEN
// Professional Black & Gold Theme
// Filename: home_menu_screen.dart
// ============================================================

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  void _navigateTo(Widget Function() screenBuilder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screenBuilder()),
    );
  }

  // ── Menu Data ───────────────────────────────────────────
  late final List<_MenuSection> _sections = [
    _MenuSection(
      title: 'الإدارة والتسويق',
      items: [
        _MenuItem(
          icon: Icons.handshake_outlined,
          label: 'الإتفاقيات قيد العمل',
          badge: '2',
          isPrimary: true,
          targetScreen: () => const ContractsScreen(),
        ),
        _MenuItem(
          icon: Icons.people_alt_outlined,
          label: 'قائمة المؤثرين',
          targetScreen: () => const InfluencersListScreen(),
        ),
        _MenuItem(
          icon: Icons.category_outlined,
          label: 'قائمة المؤثرين حسب المجالات',
          targetScreen: () => const InfluencerCategoriesScreen(),
        ),
        _MenuItem(
          icon: Icons.trending_up_outlined,
          label: 'ترويج حسب الطلب',
          targetScreen: () => const OnDemandPromotionScreen(),
        ),
        _MenuItem(
          icon: Icons.workspace_premium_outlined,
          label: 'خدمات المنصة الإحترافية',
          targetScreen: () =>
          const ProfessionalServicesScreen(),
        ),
        _MenuItem(
          icon: Icons.person_add_alt_outlined,
          label: 'دعوة مؤثر أو معلن',
          targetScreen: () => const InviteUserTypeScreen(),
        ),
        _MenuItem(
          icon: Icons.assignment_outlined,
          label: 'طلبات الترويج الخاصة بي',
          targetScreen: () =>
          const MyPromotionRequestsScreen(),
        ),
      ],
    ),
    _MenuSection(
      title: 'حسابي',
      items: [
        _MenuItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'معلوماتي المالية',
          targetScreen: () => const FinancialSecurityScreen(),
        ),
        _MenuItem(
          icon: Icons.bookmark_border_outlined,
          label: 'العناصر المحفوظة',
          targetScreen: () => const SavedItemsScreen(),
        ),
      ],
    ),
    _MenuSection(
      title: 'استكشاف',
      items: [
        _MenuItem(
          icon: Icons.article_outlined,
          label: 'مقالات و أخبار',
          targetScreen: () => const ArticlesNewsScreen(),
        ),

        _MenuItem(
          icon: Icons.info_outline,
          label: 'أنواع و صيغ الإشهار',
          targetScreen: () => const AdvertisingFormatsScreen(),
        ),

        _MenuItem(
          icon: Icons.business_center_outlined,
          label: 'تصفح معرض الأعمال',
          targetScreen: () => const PortfolioGalleryScreen(),
        ),

        _MenuItem(
          icon: Icons.folder_open_outlined,
          label: 'تصفح المشاريع',
          targetScreen: () => const ProjectsBrowserScreen(),
        ),
      ],
    ),
    _MenuSection(
      title: 'المنصة',
      items: [
        _MenuItem(
          icon: Icons.public_outlined,
          label: 'التعرف على المنصة : X10',
          targetScreen: () => const AboutPlatformScreen(),
        ),

        _MenuItem(
          icon: Icons.groups_outlined,
          label: 'من نحن',
          targetScreen: () => const AboutUsScreen(),
        ),

        _MenuItem(
          icon: Icons.live_help_outlined,
          label: 'أسئلة شائعة',
          targetScreen: () => const FaqScreen(),
        ),

        _MenuItem(
          icon: Icons.mail_outline,
          label: 'اتصل بنا',
          targetScreen: () => const ContractsScreen(),
        ),
      ],
    ),
  ];

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              SliverToBoxAdapter(child: _buildUserCard()),
              SliverToBoxAdapter(child: _buildQuickActions()),
              ..._buildMenuSections(),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      toolbarHeight: 64,
      leadingWidth: 96,
      titleSpacing: 4,
      centerTitle: true,
      title: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'سوق لمنتوجك بنقرة زر',
          maxLines: 1,
          style: TextStyle(
            color: Color(0xFFD4A843),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconBadge(
              icon: Icons.notifications_none_outlined,
              count: 1,
              onTap: () => _navigateTo(() => const NotificationsApprovalScreen()),
            ),
            const SizedBox(width: 6),
            _buildIconBadge(
              icon: Icons.chat_bubble_outline_rounded,
              count: 0,
              onTap: () => _navigateTo(() => const ConversationsScreen()),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: Center(
            child: GestureDetector(
              onTap: () => _navigateTo(() => const CreatorProfileScreen()),
              child: _buildCircleAvatar(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAvatar() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4A843).withValues(alpha: 0.4),
          width: 2,
        ),
        image: const DecorationImage(
          image: NetworkImage('https://i.pravatar.cc/150?img=11'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildIconBadge({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white70,
                size: 20,
              ),
              if (count > 0)
                PositionedDirectional(
                  top: 4,
                  end: 4,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                    padding: count > 9
                        ? const EdgeInsets.symmetric(horizontal: 3)
                        : EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                    child: count > 1
                        ? Center(
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // USER CARD
  // ==========================================================
  Widget _buildUserCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFD4A843).withValues(alpha: 0.15),
              const Color(0xFFD4A843).withValues(alpha: 0.05),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4A843).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A843),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'C',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CEVITAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'معلّن مسجّل',
                    style: TextStyle(
                      color: const Color(0xFFD4A843).withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _navigateTo(() => const OpportunitiesScreen()),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A843).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD4A843).withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search,
                        color: Color(0xFFD4A843),
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'بحث',
                        style: TextStyle(
                          color: Color(0xFFD4A843),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // QUICK ACTIONS (Primary Buttons Grid)
  // ==========================================================
  Widget _buildQuickActions() {
    final primaryItems = _sections.first.items;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.only(
                start: 4,
                bottom: 14,
              ),
              child: Text(
                'الإدارة والتسويق',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 88,
              ),
              itemCount: primaryItems.length,
              itemBuilder: (context, index) {
                final item = primaryItems[index];

                return DashboardMenuCard(
                  icon: item.icon,
                  label: item.label,
                  badge: item.badge,
                  onTap: () {
                    if (item.targetScreen != null) {
                      _navigateTo(item.targetScreen!);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // MENU SECTIONS
  // ==========================================================
  List<Widget> _buildMenuSections() {
    final subSections = _sections.sublist(1);

    return subSections.map((section) {
      return SliverToBoxAdapter(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A843).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: Color(0xFFD4A843),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Items
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Column(
                    children: section.items.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      final isLast = idx == section.items.length - 1;

                      return Column(
                        children: [
                          _MenuListTile(
                            icon: item.icon,
                            label: item.label,
                            onTap: () {
                              if (item.targetScreen != null) {
                                _navigateTo(item.targetScreen!);
                              }
                            },
                          ),
                          if (!isLast)
                            Divider(
                              color: Colors.white.withValues(alpha: 0.04),
                              height: 1,
                              indent: 56,
                              endIndent: 16,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

// ============================================================
// REUSABLE DASHBOARD MENU CARD WIDGET
// ============================================================

class DashboardMenuCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const DashboardMenuCard({
    super.key,
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  State<DashboardMenuCard> createState() =>
      _DashboardMenuCardState();
}

class _DashboardMenuCardState
    extends State<DashboardMenuCard>
    with SingleTickerProviderStateMixin {
  static const Color _goldColor = Color(0xFFD4A843);

  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF151515),
            ],
          ),

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: _goldColor.withValues(
              alpha: 0.22,
            ),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.28,
              ),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,

          borderRadius: BorderRadius.circular(16),

          clipBehavior: Clip.antiAlias,

          child: InkWell(
            onTap: widget.onTap,

            onTapDown: (_) {
              _pressController.forward();
            },

            onTapUp: (_) {
              _pressController.reverse();
            },

            onTapCancel: () {
              _pressController.reverse();
            },

            borderRadius: BorderRadius.circular(16),

            splashColor: _goldColor.withValues(
              alpha: 0.14,
            ),

            highlightColor: _goldColor.withValues(
              alpha: 0.06,
            ),

            child: Stack(
              children: [
                Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(
                    12,
                    10,
                    12,
                    10,
                  ),

                  child: Row(
                    // Explicit RTL
                    textDirection: TextDirection.rtl,

                    crossAxisAlignment:
                    CrossAxisAlignment.center,

                    children: [
                      // ============================
                      // ICON
                      // ============================
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color:
                          _goldColor.withValues(
                            alpha: 0.12,
                          ),

                          borderRadius:
                          BorderRadius.circular(12),

                          border: Border.all(
                            color:
                            _goldColor.withValues(
                              alpha: 0.20,
                            ),
                          ),
                        ),

                        child: Icon(
                          widget.icon,
                          color: _goldColor,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // ============================
                      // FLEXIBLE ARABIC TEXT
                      // ============================
                      Expanded(
                        child: Text(
                          widget.label,

                          textDirection:
                          TextDirection.rtl,

                          textAlign:
                          TextAlign.start,

                          maxLines: 2,

                          softWrap: true,

                          overflow:
                          TextOverflow.ellipsis,

                          style:
                          const TextStyle(
                            color: Colors.white,

                            fontSize: 12.5,

                            fontWeight:
                            FontWeight.w600,

                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ============================
                // BADGE
                // ============================
                if (widget.badge != null)
                  PositionedDirectional(
                    top: 6,
                    start: 6,

                    child: Container(
                      constraints:
                      const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),

                      alignment:
                      Alignment.center,

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(
                          0xFFFF4D4D,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color:
                            const Color(
                              0xFFFF4D4D,
                            ).withValues(
                              alpha: 0.35,
                            ),

                            blurRadius: 6,
                          ),
                        ],
                      ),

                      child: Text(
                        widget.badge!,

                        style:
                        const TextStyle(
                          color: Colors.white,

                          fontSize: 8,

                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuListTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuListTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_MenuListTile> createState() => _MenuListTileState();
}

class _MenuListTileState extends State<_MenuListTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _isPressed
            ? const Color(0xFFD4A843).withValues(alpha: 0.08)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _isPressed
                      ? const Color(0xFFD4A843).withValues(alpha: 0.15)
                      : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFFD4A843),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white.withValues(alpha: 0.2),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class _MenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final bool isPrimary;
  final Widget Function()? targetScreen;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.isPrimary = false,
    this.targetScreen,
  });
}

class _MenuSection {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });
}
