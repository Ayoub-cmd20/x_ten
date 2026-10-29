import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/fast_switcher.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/accounts_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/contact_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/financial_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/optional_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/personal_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/profile_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/review_step.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/submitted_dialog.dart';

const _snackbarActions = {
  RegistrationAction.deletePortfolio,
  RegistrationAction.uploadPhoto,
  RegistrationAction.deletePhoto,
};

Future<void> logoutFromRegistration(BuildContext context) async {
  final router = GoRouter.of(context);
  await context.read<AuthCubit>().logout();
  router.go(AuthRoutes.login);
}

class RegistrationWizardPage extends StatelessWidget {
  const RegistrationWizardPage({super.key});

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.submit)) {
      final router = GoRouter.of(context);
      router.go(RegistrationRoutes.destinationFor(state.registration));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final root = router.routerDelegate.navigatorKey.currentContext;
        if (root != null && root.mounted) {
          showRegistrationSubmittedDialog(root);
        }
      });
    } else if (state.status == OperationStatus.failure && failure != null && _snackbarActions.contains(state.action)) {
      showRegistrationFailure(context, failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loaded = context.select((RegistrationCubit c) => c.state.loaded);
    final step = context.select((RegistrationCubit c) => c.state.step);

    if (!loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(RegistrationRoutes.gate);
      });
      return const Scaffold(body: AppLoader());
    }

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.registrationTitle),
          actions: [
            IconButton(
              tooltip: l10n.logout,
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => logoutFromRegistration(context),
            ),
          ],
          bottom: const PreferredSize(preferredSize: Size.fromHeight(76), child: _StepHeader()),
        ),
        body: FastSwitcher(
          child: KeyedSubtree(
            key: ValueKey(step),
            child: switch (step) {
              RegistrationStep.personal => const PersonalStep(),
              RegistrationStep.profile => const ProfileStep(),
              RegistrationStep.contact => const ContactStep(),
              RegistrationStep.accounts => const AccountsStep(),
              RegistrationStep.optional => const OptionalStep(),
              RegistrationStep.financial => const FinancialStep(),
              RegistrationStep.review => const ReviewStep(),
            },
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    const steps = RegistrationStep.values;
    final current = state.step.index;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.stepCounter(current + 1, steps.length),
                style: context.textTheme.labelMedium?.copyWith(color: context.palette.primary),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.stepTitle(state.step),
                  style: context.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final step in steps) ...[
                if (step.index > 0) const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: l10n.stepTitle(step),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => cubit.goTo(step),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.pillAll,
                          color: step.index <= current
                              ? (step == RegistrationStep.optional ? context.palette.accent : context.palette.primary)
                              : step.index <= state.furthestAllowed.index
                                  ? context.palette.primary.withValues(alpha: 0.3)
                                  : context.colors.surfaceContainerHighest,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
