import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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

  // ── Menu Data ───────────────────────────────────────────
  final List<_MenuSection> _sections = [
    _MenuSection(
      title: 'الإدارة والتسويق',
      items: [
        _MenuItem(
          icon: Icons.handshake_outlined,
          label: 'الإتفاقيات قيد العمل',
          badge: '2',
          isPrimary: true,
        ),
        _MenuItem(
          icon: Icons.people_alt_outlined,
          label: 'قائمة المؤثرين',
        ),
        _MenuItem(
          icon: Icons.category_outlined,
          label: 'قائمة المؤثرين حسب المجالات',
        ),
        _MenuItem(
          icon: Icons.trending_up_outlined,
          label: 'ترويج حسب الطلب',
        ),
        _MenuItem(
          icon: Icons.workspace_premium_outlined,
          label: 'خدمات المنصة الإحترافية',
        ),
        _MenuItem(
          icon: Icons.person_add_alt_outlined,
          label: 'دعوة مؤثر أو معلن',
        ),
        _MenuItem(
          icon: Icons.campaign_outlined,
          label: 'إشهاراتي',
        ),
      ],
    ),
    _MenuSection(
      title: 'حسابي',
      items: [
        _MenuItem(
          icon: Icons.account_balance_wallet_outlined,
          label: 'معلوماتي المالية',
        ),
        _MenuItem(
          icon: Icons.bookmark_border_outlined,
          label: 'العناصر المحفوظة',
        ),
      ],
    ),
    _MenuSection(
      title: 'استكشاف',
      items: [
        _MenuItem(
          icon: Icons.article_outlined,
          label: 'مقالات و أخبار',
        ),
        _MenuItem(
          icon: Icons.info_outline,
          label: 'أنواع و صيغ الإشهار',
        ),
        _MenuItem(
          icon: Icons.business_center_outlined,
          label: 'تصفح معرض الأعمال',
        ),
        _MenuItem(
          icon: Icons.folder_open_outlined,
          label: 'تصفح المشاريع',
        ),
      ],
    ),
    _MenuSection(
      title: 'المنصة',
      items: [
        _MenuItem(
          icon: Icons.public_outlined,
          label: 'التعرف على المنصة : DZ_PUP',
        ),
        _MenuItem(
          icon: Icons.groups_outlined,
          label: 'من نحن',
        ),
        _MenuItem(
          icon: Icons.live_help_outlined,
          label: 'أسئلة شائعة',
        ),
        _MenuItem(
          icon: Icons.mail_outline,
          label: 'اتصل بنا',
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
      title: const Text(
        'سوق لمنتوجك بنقرة زر',
        style: TextStyle(
          color: Color(0xFFD4A843),
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          _buildIconBadge(
            icon: Icons.notifications_none_outlined,
            count: 1,
            onTap: () {},
          ),
          const SizedBox(width: 4),
          _buildIconBadge(
            icon: Icons.chat_bubble_outline,
            count: 0,
            onTap: () {},
          ),
        ],
      ),
      actions: [
        _buildCircleAvatar(),
        const SizedBox(width: 12),
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
          color: const Color(0xFFD4A843).withOpacity(0.4),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 20,
            ),
            if (count > 0)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
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
              const Color(0xFFD4A843).withOpacity(0.15),
              const Color(0xFFD4A843).withOpacity(0.05),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4A843).withOpacity(0.2),
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
                      color: const Color(0xFFD4A843).withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4A843).withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD4A843).withOpacity(0.25),
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
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // QUICK ACTIONS (Primary Buttons)
  // ==========================================================
  Widget _buildQuickActions() {
    final primaryItems = _sections.first.items;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Text(
                'الإتفاقيات قيد العمل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.4,
              ),
              itemCount: primaryItems.length,
              itemBuilder: (context, index) {
                final item = primaryItems[index];
                return _PrimaryActionButton(
                  icon: item.icon,
                  label: item.label,
                  badge: item.badge,
                  onTap: () {},
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
                    color: const Color(0xFFD4A843).withOpacity(0.1),
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
                      color: Colors.white.withOpacity(0.04),
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
                            onTap: () {},
                          ),
                          if (!isLast)
                            Divider(
                              color: Colors.white.withOpacity(0.04),
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
// REUSABLE WIDGETS
// ============================================================

class _PrimaryActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });

  @override
  State<_PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<_PrimaryActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E1E1E),
                    const Color(0xFF1A1A1A),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFD4A843).withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A843).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.icon,
                            color: const Color(0xFFD4A843),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
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
            ? const Color(0xFFD4A843).withOpacity(0.08)
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
                      ? const Color(0xFFD4A843).withOpacity(0.15)
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
                color: Colors.white.withOpacity(0.2),
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

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.isPrimary = false,
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