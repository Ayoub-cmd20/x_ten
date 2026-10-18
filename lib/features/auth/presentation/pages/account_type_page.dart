import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/feedback/empty_view.dart';
import 'package:x_ten/features/auth/domain/auth_usecases.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  Role? _selected;

  void _continue() {
    final role = _selected;
    if (role != null) context.read<AuthCubit>().selectRole(role);
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final role = state.role;
    final failure = state.failure;
    if (state.status == AuthStatus.success && role != null) {
      context.go(AuthRoutes.onboardingFor(role));
    } else if (state.status == AuthStatus.failure && failure != null) {
      if (failure is ValidationFailure && failure.fieldError('registrationToken') != null) {
        showErrorSnackBar(context, context.l10n.registrationExpired);
        context.go(AuthRoutes.signup);
      } else {
        showFailure(context, failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<AuthCubit>().state;
    final isLoading = state.isLoadingFor(AuthAction.selectRole);

    if (state.registrationToken == null && !state.didSucceed(AuthAction.selectRole)) {
      return Scaffold(
        body: EmptyView(
          icon: Icons.timer_off_outlined,
          title: l10n.registrationExpired,
          action: FilledButton(
            onPressed: () => context.go(AuthRoutes.signup),
            child: Text(l10n.startOver),
          ),
        ),
      );
    }

    final options = [
      for (final role in SelectRoleUseCase.selectableRoles) _RoleOption.of(role, l10n),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.action == AuthAction.selectRole && previous.status != current.status,
      listener: _onAuthChanged,
      child: AuthScaffold(
        withAppBar: false,
        bottom: PrimaryButton(
          label: l10n.continueText,
          isLoading: isLoading,
          onPressed: _selected == null ? null : _continue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(title: l10n.accountTypeTitle, subtitle: l10n.accountTypeSubtitle),
            const SizedBox(height: AppSpacing.xxl),
            for (final option in options) ...[
              _RoleCard(
                option: option,
                selected: _selected == option.role,
                onTap: isLoading ? null : () => setState(() => _selected = option.role),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            _RoleCard(
              option: _RoleOption(
                role: null,
                title: l10n.freelancer,
                description: l10n.freelancerDesc,
                icon: Icons.laptop_mac_rounded,
                color: AppColors.info,
              ),
              badge: l10n.comingSoon,
              selected: false,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleOption {
  const _RoleOption({
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  factory _RoleOption.of(Role role, AppLocalizations l10n) => switch (role) {
        Role.brand => _RoleOption(
            role: role,
            title: l10n.brandOrCompany,
            description: l10n.brandOrCompanyDesc,
            icon: Icons.business_center_rounded,
            color: AppColors.accentPurple,
          ),
        _ => _RoleOption(
            role: role,
            title: l10n.contentCreator,
            description: l10n.contentCreatorDesc,
            icon: Icons.auto_awesome_rounded,
            color: AppColors.gold,
          ),
      };

  final Role? role;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.option, required this.selected, required this.onTap, this.badge});

  final _RoleOption option;
  final bool selected;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;
    final badge = this.badge;
    final enabled = onTap != null || selected;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.xxlAll,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: selected ? option.color.withValues(alpha: 0.08) : colors.surfaceContainer,
              borderRadius: AppRadius.xxlAll,
              border: Border.all(
                color: selected ? option.color : colors.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: option.color.withValues(alpha: 0.12),
                    borderRadius: AppRadius.lgAll,
                  ),
                  child: Icon(option.icon, color: option.color),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text(option.title, style: text.titleSmall)),
                          if (badge != null) ...[
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: AppRadius.pillAll,
                              ),
                              child: Text(badge, style: text.labelSmall),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(option.description, style: text.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  color: selected ? option.color : AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
