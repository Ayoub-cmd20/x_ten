import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'home_menu_screen.dart';

// ============================================================
// COMPANY REGISTRATION — STEP 5: REVIEW & CONFIRM
// Filename: company_review_confirm_screen.dart
// ============================================================

class CompanyReviewConfirmScreen extends StatefulWidget {
  const CompanyReviewConfirmScreen({super.key});

  @override
  State<CompanyReviewConfirmScreen> createState() =>
      _CompanyReviewConfirmScreenState();
}

class _CompanyReviewConfirmScreenState extends State<CompanyReviewConfirmScreen>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────
  bool _agreeToTerms = false;
  bool _confirmAccuracy = false;

  late final AnimationController _buttonAnimController;
  late final Animation<double> _buttonScale;

  // ── Mock Data (replace with your real state management) ───
  final Map<String, String> _companyInfo = {
    'الاسم القانوني': 'شركة التقنية الحديثة ش.م.م',
    'نوع الكيان': 'شركة ذات مسؤولية محدودة',
    'تاريخ التأسيس المقترح': '01/01/2024',
  };

  final Map<String, String> _contactInfo = {
    'البريد الإلكتروني': 'contact@moderntech.com',
    'رقم الهاتف': '+971 50 123 4567',
    'العنوان الرئيسي': 'برج الابتكار، الطابق 15، دبي',
  };

  final List<Map<String, String>> _stakeholders = [
    {
      'name': 'أحمد محمد',
      'role': 'المدير التنفيذي',
      'share': '50%',
      'initials': 'أم',
    },
    {
      'name': 'سارة عبدالله',
      'role': 'شريك إداري',
      'share': '50%',
      'initials': 'س.ع',
    },
  ];

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _buttonAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _buttonAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonAnimController.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────
  bool get _canSubmit => _agreeToTerms && _confirmAccuracy;

  void _submit() {
    if (!_canSubmit) return;
    debugPrint('✅ Registration submitted');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeMenuScreen(),
      ),
      (route) => false,
    );
  }

  // ── Build ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildProgressSection(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildSectionTitle(),
                      const SizedBox(height: 24),
                      _buildCompanyInfoCard(),
                      const SizedBox(height: 16),
                      _buildContactCard(),
                      const SizedBox(height: 16),
                      _buildStakeholdersCard(),
                      const SizedBox(height: 16),
                      _buildDeclarationsCard(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Company Registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 48),
          // Back/close arrow on the left side (RTL end)
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFD4A843),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PROGRESS
  // ==========================================================
  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الخطوة 5 من 5: المراجعة والتأكيد',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A843).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '100%',
                  style: TextStyle(
                    color: Color(0xFFD4A843),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: const Color(0xFF2A2A2A),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD4A843),
                  ),
                  minHeight: 5,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================
  Widget _buildSectionTitle() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Text(
        'المراجعة والتأكيد',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ==========================================================
  // COMPANY INFO CARD
  // ==========================================================
  Widget _buildCompanyInfoCard() {
    return _SummaryCard(
      icon: Icons.apartment_outlined,
      title: 'معلومات الشركة',
      children: _companyInfo.entries.map((e) {
        return _InfoRow(label: e.key, value: e.value);
      }).toList(),
    );
  }

  // ==========================================================
  // CONTACT CARD
  // ==========================================================
  Widget _buildContactCard() {
    return _SummaryCard(
      icon: Icons.location_on_outlined,
      title: 'العنوان والاتصال',
      children: _contactInfo.entries.map((e) {
        return _InfoRow(label: e.key, value: e.value);
      }).toList(),
    );
  }

  // ==========================================================
  // STAKEHOLDERS CARD
  // ==========================================================
  Widget _buildStakeholdersCard() {
    return _SummaryCard(
      icon: Icons.groups_outlined,
      title: 'المدراء والمساهمين',
      children: _stakeholders.map((person) {
        return _PersonRow(
          initials: person['initials']!,
          name: person['name']!,
          role: person['role']!,
          share: person['share']!,
        );
      }).toList(),
    );
  }

  // ==========================================================
  // DECLARATIONS CARD
  // ==========================================================
  Widget _buildDeclarationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A843).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإقرارات والموافقات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckboxTile(
            value: _agreeToTerms,
            onChanged: (v) => setState(() => _agreeToTerms = v!),
            label: 'أوافق على سياسة الخصوصية و الشروط والأحكام الخاصة بالخدمة.',
          ),
          const SizedBox(height: 12),
          _buildCheckboxTile(
            value: _confirmAccuracy,
            onChanged: (v) => setState(() => _confirmAccuracy = v!),
            label:
            'أقر بأن جميع المعلومات المقدمة أعلاه صحيحة وكاملة ومحتدثة.',
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: value
                    ? const Color(0xFFD4A843)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? const Color(0xFFD4A843)
                      : Colors.white38,
                  width: 1.8,
                ),
              ),
              child: value
                  ? const Icon(
                Icons.check,
                size: 14,
                color: Colors.black,
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: value ? Colors.white : Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: value ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BOTTOM BAR
  // ==========================================================
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'السابق',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Submit button
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTapDown: (_) => _buttonAnimController.forward(),
              onTapUp: (_) {
                _buttonAnimController.reverse();
                _submit();
              },
              onTapCancel: () => _buttonAnimController.reverse(),
              child: AnimatedBuilder(
                animation: _buttonScale,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _buttonScale.value,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: _canSubmit
                            ? const Color(0xFFD4A843)
                            : const Color(0xFFD4A843).withOpacity(0.35),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _canSubmit
                            ? [
                          BoxShadow(
                            color: const Color(0xFFD4A843)
                                .withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : null,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تأكيد وإرسال',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS
// ============================================================

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A843).withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A843).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFD4A843),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            color: Color(0xFF2A2A2A),
            height: 1,
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final String share;

  const _PersonRow({
    required this.initials,
    required this.name,
    required this.role,
    required this.share,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFD4A843),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$role ($share)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 13,
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
}