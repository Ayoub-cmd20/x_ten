import 'package:flutter/material.dart';

import 'package:x_ten/features/auth/presentation/pages/login_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/profile_setup_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/company/company_registration_screen.dart';
import 'package:x_ten/features/onboarding_registration/presentation/pages/freelancer/freelancer_registration_screen.dart';

enum AccountType {
  contentCreator,
  brand,
  freelancer,
}

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  AccountType? _selectedType;

  static const Color _goldColor = Color(0xFFE5C158);
  static const Color _darkBg = Color(0xFF090A0F);

  void _selectType(AccountType type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
    });
  }

  void _handleContinue() {
    final selectedType = _selectedType;

    if (selectedType == null) {
      return;
    }

    Widget destination;

    switch (selectedType) {
      case AccountType.contentCreator:
        destination = const ProfileSetupScreen();
        break;

      case AccountType.brand:
        destination = const CompanyRegistrationScreen();
        break;

      case AccountType.freelancer:
        destination = const FreelancerRegistrationScreen();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => destination,
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _darkBg,
        body: Stack(
          children: [
            // ============================================================
            // BACKGROUND GLOW - TOP RIGHT
            // ============================================================

            Positioned(
              top: -100,
              right: -100,
              child: IgnorePointer(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _goldColor.withValues(alpha: 0.07),
                        blurRadius: 120,
                        spreadRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ============================================================
            // BACKGROUND GLOW - BOTTOM LEFT
            // ============================================================

            Positioned(
              left: -120,
              bottom: 80,
              child: IgnorePointer(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF745A16)
                            .withValues(alpha: 0.06),
                        blurRadius: 130,
                        spreadRadius: 45,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // ======================================================
                  // TOP BAR
                  // ======================================================

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      4,
                    ),
                    child: Row(
                      children: [
                        _BackButton(
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),

                        const Spacer(),

                        const _StepBadge(),

                        const Spacer(),

                        // Keeps top bar perfectly balanced.
                        const SizedBox(
                          width: 42,
                          height: 42,
                        ),
                      ],
                    ),
                  ),

                  // ======================================================
                  // SCROLLABLE CONTENT
                  // ======================================================

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ==================================================
                          // HEADER
                          // ==================================================

                          RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                              ),
                              children: [
                                TextSpan(
                                  text: 'ما الذي يجلبك إلى ',
                                ),
                                TextSpan(
                                  text: 'X Ten',
                                  style: TextStyle(
                                    color: _goldColor,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: Color(0x55E5C158),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                TextSpan(
                                  text: '؟',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'اختر المسار الأنسب لك، وسنخصص تجربتك لتبدأ رحلتك مع X Ten.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13.5,
                              height: 1.8,
                              color: Colors.grey.shade400,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ==================================================
                          // CONTENT CREATOR
                          // ==================================================

                          _RoleSelectionCard(
                            title: 'صانع محتوى',
                            subtitle: 'مؤثر وإبداع',
                            description:
                            'نمِّ حضورك، اعرض أعمالك، وتواصل مع العلامات التجارية المناسبة لك.',
                            icon: Icons.auto_awesome_rounded,
                            accentColor: const Color(0xFFE5C158),
                            isSelected:
                            _selectedType == AccountType.contentCreator,
                            onTap: () {
                              _selectType(AccountType.contentCreator);
                            },
                          ),

                          const SizedBox(height: 16),

                          // ==================================================
                          // BRAND
                          // ==================================================

                          _RoleSelectionCard(
                            title: 'علامة تجارية / عميل',
                            subtitle: 'نمو واستثمار',
                            description:
                            'اكتشف صُنّاع المحتوى، تعاون معهم، وأطلق حملاتك التسويقية بسهولة.',
                            icon: Icons.business_center_rounded,
                            accentColor: const Color(0xFFB477FF),
                            isSelected: _selectedType == AccountType.brand,
                            onTap: () {
                              _selectType(AccountType.brand);
                            },
                          ),

                          const SizedBox(height: 16),

                          // ==================================================
                          // FREELANCER
                          // ==================================================

                          _RoleSelectionCard(
                            title: 'مستقل',
                            subtitle: 'خدمات إبداعية',
                            description:
                            'قدّم خدماتك الإبداعية للعلامات التجارية وصُنّاع المحتوى.',
                            icon: Icons.laptop_mac_rounded,
                            accentColor: const Color(0xFF5C8DFF),
                            isSelected:
                            _selectedType == AccountType.freelancer,
                            onTap: () {
                              _selectType(AccountType.freelancer);
                            },
                          ),

                          const SizedBox(height: 32),

                          // ==================================================
                          // LOGIN
                          // ==================================================

                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Text(
                                'هل لديك حساب بالفعل؟',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12.5,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _goToLogin,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'تسجيل الدخول',
                                    style: TextStyle(
                                      color: _goldColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.5,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // ==================================================
                          // SECONDARY LINKS
                          // ==================================================

                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            runSpacing: 8,
                            children: [
                              _BottomLink(
                                text: 'سياسة الخصوصية',
                                onTap: () {},
                              ),
                              const _FooterDot(),
                              _BottomLink(
                                text: 'الشروط والأحكام',
                                onTap: () {},
                              ),
                              const _FooterDot(),
                              _BottomLink(
                                text: 'مركز المساعدة',
                                onTap: () {},
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // ======================================================
                  // STICKY CONTINUE BUTTON
                  // ======================================================

                  Container(
                    decoration: BoxDecoration(
                      color: _darkBg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      18,
                    ),
                    child: _AnimatedCTAButton(
                      isEnabled: _selectedType != null,
                      onPressed: _handleContinue,
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

// ============================================================================
// BACK BUTTON
// ============================================================================

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF13151D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF252734),
            ),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STEP BADGE
// ============================================================================

class _StepBadge extends StatelessWidget {
  const _StepBadge();

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE5C158);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: gold.withValues(alpha: 0.25),
        ),
      ),
      );
  }
}

// ============================================================================
// ROLE CARD
// ============================================================================

class _RoleSelectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleSelectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_RoleSelectionCard> createState() => _RoleSelectionCardState();
}

class _RoleSelectionCardState extends State<_RoleSelectionCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.accentColor;

    final double scale = _pressed
        ? 0.985
        : widget.isSelected
        ? 1.01
        : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 160),

      // IMPORTANT:
      // Do not use elastic/back curves here.
      curve: Curves.easeOutCubic,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),

          // IMPORTANT:
          // Safe non-overshooting curve.
          curve: Curves.easeInOutCubic,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: widget.isSelected
                  ? [
                accent.withValues(alpha: 0.12),
                const Color(0xFF15151C),
                const Color(0xFF0F1016),
              ]
                  : const [
                Color(0xFF15161D),
                Color(0xFF101117),
                Color(0xFF0D0E13),
              ],
            ),

            border: Border.all(
              color: widget.isSelected
                  ? accent.withValues(alpha: 0.9)
                  : const Color(0xFF292B36),
              width: widget.isSelected ? 1.5 : 1.0,
            ),

            // IMPORTANT:
            // Keep exactly one shadow in BOTH states.
            // Only animate opacity/blur/spread values.
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? accent.withValues(alpha: 0.20)
                    : Colors.black.withValues(alpha: 0.18),
                blurRadius: widget.isSelected ? 20 : 8,
                spreadRadius: widget.isSelected ? 1 : 0,
                offset: widget.isSelected
                    ? const Offset(0, 7)
                    : const Offset(0, 3),
              ),
            ],
          ),

          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ========================================================
                  // ICON
                  // ========================================================

                  _RoleIcon(
                    icon: widget.icon,
                    accentColor: accent,
                    isSelected: widget.isSelected,
                  ),

                  const SizedBox(width: 14),

                  // ========================================================
                  // TEXT
                  // ========================================================

                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: widget.isSelected
                                  ? Colors.white
                                  : Colors.grey.shade200,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.35,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                constraints.maxWidth.clamp(80.0, 220.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? accent.withValues(alpha: 0.12)
                                    : const Color(0xFF1A1B23),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                widget.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 9.5,
                                  color: widget.isSelected
                                      ? accent
                                      : Colors.grey.shade500,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            widget.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.5,
                              height: 1.6,
                              color: widget.isSelected
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ========================================================
                  // SELECTION INDICATOR
                  // ========================================================

                  _SelectionIndicator(
                    selected: widget.isSelected,
                    color: accent,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ROLE ICON
// ============================================================================

class _RoleIcon extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final bool isSelected;

  const _RoleIcon({
    required this.icon,
    required this.accentColor,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSelected
              ? [
            accentColor.withValues(alpha: 0.30),
            accentColor.withValues(alpha: 0.08),
          ]
              : const [
            Color(0xFF22232D),
            Color(0xFF171820),
          ],
        ),
        border: Border.all(
          color: isSelected
              ? accentColor.withValues(alpha: 0.40)
              : const Color(0xFF2A2C38),
        ),

        // Keep a constant shadow list.
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(
              alpha: isSelected ? 0.18 : 0,
            ),
            blurRadius: isSelected ? 14 : 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: isSelected ? accentColor : Colors.grey.shade400,
        size: 25,
      ),
    );
  }
}

// ============================================================================
// SAFE ANIMATED SELECTION INDICATOR
// ============================================================================

class _SelectionIndicator extends StatelessWidget {
  final bool selected;
  final Color color;

  const _SelectionIndicator({
    required this.selected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ---------------------------------------------------------------
          // Outer circle
          //
          // IMPORTANT:
          // Curves.easeInOut is intentional.
          // We do NOT use easeOutBack here because it can overshoot during
          // BoxDecoration interpolation and produce a negative blur radius.
          // ---------------------------------------------------------------

          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? color : Colors.transparent,
              border: Border.all(
                color: selected
                    ? color
                    : const Color(0xFF4A4D5A),
                width: selected ? 2.0 : 1.6,
              ),

              // Keep ONE shadow for both states.
              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                    alpha: selected ? 0.28 : 0.0,
                  ),
                  blurRadius: selected ? 9.0 : 0.0,
                  spreadRadius: selected ? 1.0 : 0.0,
                  offset: Offset.zero,
                ),
              ],
            ),
          ),

          AnimatedScale(
            scale: selected ? 1 : 0,
            duration: const Duration(milliseconds: 200),

            // Back curve is safe here because it only changes SCALE.
            curve: Curves.easeOutBack,

            child: const Icon(
              Icons.check_rounded,
              size: 17,
              color: Color(0xFF090A0F),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTINUE BUTTON
// ============================================================================

class _AnimatedCTAButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _AnimatedCTAButton({
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;

    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE5C158);

    return AnimatedScale(
      scale: _pressed && widget.isEnabled ? 0.985 : 1,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: widget.isEnabled
            ? (_) {
          _setPressed(true);
        }
            : null,

        onTapUp: widget.isEnabled
            ? (_) {
          _setPressed(false);
        }
            : null,

        onTapCancel: () {
          _setPressed(false);
        },

        onTap: widget.isEnabled
            ? widget.onPressed
            : null,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            gradient: widget.isEnabled
                ? const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFFF8DB7B),
                Color(0xFFE5C158),
                Color(0xFFCAA034),
              ],
            )
                : null,

            color: widget.isEnabled
                ? null
                : const Color(0xFF1A1B21),

            border: Border.all(
              color: widget.isEnabled
                  ? const Color(0xFFFFE59C)
                  .withValues(alpha: 0.60)
                  : const Color(0xFF292B35),
            ),

            // Same shadow-list length for both enabled/disabled states.
            boxShadow: [
              BoxShadow(
                color: gold.withValues(
                  alpha: widget.isEnabled ? 0.30 : 0.0,
                ),
                blurRadius: widget.isEnabled ? 20 : 0,
                spreadRadius: widget.isEnabled ? 1 : 0,
                offset: widget.isEnabled
                    ? const Offset(0, 7)
                    : Offset.zero,
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: widget.isEnabled
                      ? const Color(0xFF090A0F)
                      : const Color(0xFF626572),
                ),
                child: const Text('متابعة'),
              ),

              const SizedBox(width: 10),

              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                offset: widget.isEnabled
                    ? const Offset(-0.15, 0)
                    : Offset.zero,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 21,
                  color: widget.isEnabled
                      ? const Color(0xFF090A0F)
                      : const Color(0xFF626572),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FOOTER
// ============================================================================

class _BottomLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _BottomLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Colors.grey.shade600,
            fontSize: 10.5,
          ),
        ),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  const _FooterDot();

  @override
  Widget build(BuildContext context) {
    return Text(
      '•',
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 11,
      ),
    );
  }
}