import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/locale_cubit.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/theme_mode_button.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:x_ten/features/onboarding/presentation/onboarding_routes.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  static const _languages = [
    (code: 'ar', flag: '🇩🇿', name: 'العربية', subtitle: 'Arabic'),
    (code: 'fr', flag: '🇫🇷', name: 'Français', subtitle: 'French'),
    (code: 'en', flag: '🇬🇧', name: 'English', subtitle: 'English'),
  ];

  Future<void> _continue(BuildContext context) async {
    final cubit = context.read<LocaleCubit>();
    await cubit.setLocale(cubit.state.languageCode);
    if (!context.mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      final seen = context.read<OnboardingCubit>().completed;
      context.go(seen ? AuthRoutes.login : OnboardingRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = context.select((LocaleCubit cubit) => cubit.state.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.selectLanguage),
        actions: const [ThemeModeButton()],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _languages.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final language = _languages[index];
          return _LanguageCard(
            flag: language.flag,
            title: language.name,
            subtitle: language.subtitle,
            selected: selected == language.code,
            onTap: () => context.read<LocaleCubit>().setLocale(language.code),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ElevatedButton(
            onPressed: () => _continue(context),
            child: Text(context.l10n.continueText),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.flag,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String flag;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.xlAll,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: AppRadius.xlAll,
            border: Border.all(
              color: selected ? colors.primary : colors.outlineVariant,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.12),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: selected ? colors.primary : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(subtitle, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  key: ValueKey(selected),
                  color: selected ? colors.primary : context.palette.textDisabled,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}