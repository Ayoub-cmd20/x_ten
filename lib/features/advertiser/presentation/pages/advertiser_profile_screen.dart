import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Advertiser profile: brand info, financial info, saved items,
/// contracts and settings shortcuts.
class AdvertiserProfileScreen extends StatefulWidget {
  const AdvertiserProfileScreen({super.key});

  @override
  State<AdvertiserProfileScreen> createState() => _AdvertiserProfileScreenState();
}

class _AdvertiserProfileScreenState extends State<AdvertiserProfileScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);

  String _brandName = 'اسم العلامة التجارية';
  String _email = 'brand@example.com';
  String _category = 'التجارة الإلكترونية';
  String _phone = '+966 50 123 4567';
  String _bio = 'علامة تجارية متخصصة في تقديم أحدث المنتجات والتجارب المبتكرة.';
  String _website = 'https://brand.example.com';
  String _location = 'الرياض، المملكة العربية السعودية';

  Future<void> _openEditProfile() async {
    final result = await context.push<Map<String, dynamic>>(
      '/advertiser/profile/edit',
      extra: {
        'brandName': _brandName,
        'email': _email,
        'category': _category,
        'phone': _phone,
        'bio': _bio,
        'website': _website,
        'location': _location,
      },
    );

    if (result != null && mounted) {
      setState(() {
        if (result['brandName'] != null) _brandName = result['brandName'];
        if (result['email'] != null) _email = result['email'];
        if (result['category'] != null) _category = result['category'];
        if (result['phone'] != null) _phone = result['phone'];
        if (result['bio'] != null) _bio = result['bio'];
        if (result['website'] != null) _website = result['website'];
        if (result['location'] != null) _location = result['location'];
      });
    }
  }

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
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: _openEditProfile,
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
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
                              Text(
                                _brandName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _email,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.50),
                                  fontSize: 13,
                                ),
                              ),
                              if (_category.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _gold.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _category,
                                    style: const TextStyle(
                                      color: _gold,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: _gold,
                          ),
                          onPressed: _openEditProfile,
                          tooltip: 'تعديل بروفايل العلامة التجارية',
                        ),
                      ],
                    ),
                  ),
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
                  context.push('/settings/financial-security');
                },
              ),
              _menuItem(
                icon: Icons.bookmark_outline_rounded,
                title: 'العناصر المحفوظة',
                onTap: () {
                  context.push('/saved-items');
                },
              ),
              _menuItem(
                icon: Icons.description_outlined,
                title: 'العقود والاتفاقيات',
                onTap: () {
                  context.push('/contracts');
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
                  context.push('/settings');
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
