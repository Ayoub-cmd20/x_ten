import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Advertiser profile: brand info, financial info, saved items,
/// contracts and settings shortcuts.
class AdvertiserProfileScreen extends StatelessWidget {
  const AdvertiserProfileScreen({super.key});

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'حسابي',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --------------------------------------------------
              // BRAND CARD
              // --------------------------------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      _gold.withValues(alpha: 0.12),
                      _gold.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.18),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: _gold.withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.storefront_outlined,
                        color: _gold,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'اسم العلامة التجارية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'brand@example.com',
                            style: TextStyle(
                              color:
                                  Colors.white.withValues(alpha: 0.50),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: _gold,
                      ),
                      onPressed: () {
                        // TODO: edit brand profile
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // MENU
              // --------------------------------------------------
              _menuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'معلوماتي المالية',
                onTap: () {
                  // TODO: financial info screen
                },
              ),
              _menuItem(
                icon: Icons.bookmark_outline_rounded,
                title: 'العناصر المحفوظة',
                onTap: () {
                  // TODO: saved items screen
                },
              ),
              _menuItem(
                icon: Icons.description_outlined,
                title: 'العقود والاتفاقيات',
                onTap: () {
                  // TODO: contracts screen
                },
              ),
              _menuItem(
                icon: Icons.assignment_outlined,
                title: 'طلبات الترويج الخاصة بي',
                onTap: () {
                  context.push('/advertiser/promotion/requests');
                },
              ),
              _menuItem(
                icon: Icons.language_rounded,
                title: 'اللغة',
                onTap: () {
                  context.push('/settings/language');
                },
              ),
              _menuItem(
                icon: Icons.security_rounded,
                title: 'الإعدادات والأمان',
                onTap: () {
                  // TODO: settings & security screen
                },
              ),

              const SizedBox(height: 24),

              // --------------------------------------------------
              // LOGOUT
              // --------------------------------------------------
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: real logout once auth is integrated
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF6B6B),
                    side: const BorderSide(
                      color: Color(0xFFFF6B6B),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: _gold, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.25),
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
