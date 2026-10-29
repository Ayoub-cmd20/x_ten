import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_motion.dart';
import 'package:x_ten/core/widgets/press_scale.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/illustrations/discover_illustration.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/illustrations/offers_illustration.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/illustrations/trust_illustration.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/onboarding_background.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/onboarding_slide.dart';
import 'package:x_ten/features/onboarding/presentation/widgets/page_dots.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  static const _count = 3;

  final _pages = PageController();
  late final AnimationController _loop = AnimationController(vsync: this, duration: const Duration(seconds: 8));
  int _index = 0;
  bool _finishing = false;

  bool get _isLast => _index == _count - 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _loop.stop();
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    _pages.dispose();
    super.dispose();
  }

  double get _page {
    if (_pages.hasClients && _pages.position.haveDimensions) {
      return _pages.page ?? _index.toDouble();
    }
    return _index.toDouble();
  }

  Future<void> _finish() async {
    if (_finishing) {
      return;
    }
    _finishing = true;
    final router = GoRouter.of(context);
    await context.read<OnboardingCubit>().complete();
    router.go(AuthRoutes.login);
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pages.nextPage(duration: AppMotion.page, curve: AppMotion.enter);
  }

  void _onPageChanged(int index) {
    HapticFeedback.selectionClick();
    setState(() => _index = index);
  }

  Widget _illustration(int index, double focus) => switch (index) {
        0 => DiscoverIllustration(loop: _loop, focus: focus),
        1 => OffersIllustration(loop: _loop, focus: focus),
        _ => TrustIllustration(loop: _loop, focus: focus),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = [
      (title: l10n.onboarding1Title, body: l10n.onboarding1Body),
      (title: l10n.onboarding2Title, body: l10n.onboarding2Body),
      (title: l10n.onboarding3Title, body: l10n.onboarding3Body),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pages,
              builder: (context, _) => OnboardingBackground(page: _page, loop: _loop),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: AnimatedOpacity(
                          opacity: _isLast ? 0 : 1,
                          duration: AppMotion.fast,
                          child: IgnorePointer(
                            ignoring: _isLast,
                            child: TextButton(onPressed: _finish, child: Text(l10n.onboardingSkip)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pages,
                        itemCount: _count,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) => AnimatedBuilder(
                          animation: _pages,
                          builder: (context, _) {
                            final delta = index - _page;
                            final focus = (1 - delta.abs()).clamp(0.0, 1.0).toDouble();
                            return OnboardingSlide(
                              index: index,
                              delta: delta,
                              title: slides[index].title,
                              body: slides[index].body,
                              illustration: _illustration(index, focus),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.lg),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _pages,
                            builder: (context, _) => PageDots(count: _count, page: _page),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          PressScale(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _next,
                                child: AnimatedSwitcher(
                                  duration: AppMotion.fast,
                                  transitionBuilder: (child, animation) => FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(scale: Tween(begin: 0.9, end: 1.0).animate(animation), child: child),
                                  ),
                                  child: Row(
                                    key: ValueKey(_isLast),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_isLast ? l10n.onboardingStart : l10n.next),
                                      const SizedBox(width: AppSpacing.xs),
                                      // Icon(_isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
