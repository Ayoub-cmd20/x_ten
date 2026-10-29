import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/company_profile/presentation/company_routes.dart';
import 'package:x_ten/features/company_profile/presentation/steps/business_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/contact_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/finish_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/personal_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/presence_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/review_step.dart';
import 'package:x_ten/features/company_profile/presentation/steps/type_step.dart';

Future<void> _logout(BuildContext context) async {
  final router = GoRouter.of(context);
  await context.read<AuthCubit>().logout();
  router.go(AuthRoutes.login);
}

Widget _logoutButton(BuildContext context) => IconButton(
      tooltip: context.l10n.logout,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () => _logout(context),
    );

class CompanyGatePage extends StatefulWidget {
  const CompanyGatePage({super.key});

  @override
  State<CompanyGatePage> createState() => _CompanyGatePageState();
}

class _CompanyGatePageState extends State<CompanyGatePage> {
  @override
  void initState() {
    super.initState();
    context.read<CompanyCubit>().load();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<CompanyCubit, CompanyState>(
        listenWhen: (previous, current) => current.didSucceed(CompanyAction.load) && previous != current,
        listener: (context, state) => context.go(CompanyRoutes.destinationFor(state.profile)),
        builder: (context, state) {
          final failure = state.failure;
          return Scaffold(
            body: SafeArea(
              child: state.didFail(CompanyAction.load) && failure != null
                  ? ErrorView(
                      message: failure.localized(context),
                      retryLabel: context.l10n.retry,
                      onRetry: context.read<CompanyCubit>().load,
                    )
                  : const AppLoader(),
            ),
          );
        },
      );
}

class CompanyWizardPage extends StatelessWidget {
  const CompanyWizardPage({super.key});

  void _listener(BuildContext context, CompanyState state) {
    if (state.didSucceed(CompanyAction.submit)) {
      showSuccessSnackBar(context, context.l10n.companySubmittedSuccess);
      context.go(CompanyRoutes.advertiserHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final loaded = context.select((CompanyCubit c) => c.state.loaded);
    final step = context.select((CompanyCubit c) => c.state.step);
    final needsChanges =
        context.select((CompanyCubit c) => c.state.profile?.status == VerificationStatus.needsChanges);

    if (!loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(CompanyRoutes.gate);
        }
      });
      return const Scaffold(body: AppLoader());
    }

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.companyTitle),
          actions: [_logoutButton(context)],
          bottom: const PreferredSize(preferredSize: Size.fromHeight(76), child: _CompanyStepHeader()),
        ),
        body: Column(
          children: [
            if (needsChanges)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: AppRadius.lgAll,
                ),
                child: Text(l10n.companyNeedsChangesBanner, style: context.textTheme.bodySmall),
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(
                  key: ValueKey(step),
                  child: switch (step) {
                    CompanyStep.type => const BusinessTypeStep(),
                    CompanyStep.personal => const CompanyPersonalStep(),
                    CompanyStep.business => const CompanyBusinessStep(),
                    CompanyStep.presence => const CompanyPresenceStep(),
                    CompanyStep.contact => const CompanyContactStep(),
                    CompanyStep.finish => const CompanyFinishStep(),
                    CompanyStep.review => const CompanyReviewStep(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyStepHeader extends StatelessWidget {
  const _CompanyStepHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final steps = state.steps;
    final current = steps.indexOf(state.step);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.stepCounter(current + 1, steps.length),
                style: context.textTheme.labelMedium?.copyWith(color: AppColors.gold),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.companyStepTitle(state.step),
                  style: context.textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (final (index, step) in steps.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: l10n.companyStepTitle(step),
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
                            color: index <= current
                                ? AppColors.gold
                                : state.canOpen(step)
                                    ? AppColors.gold.withValues(alpha: 0.3)
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

class CompanyStatusPage extends StatelessWidget {
  const CompanyStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final refreshing = state.isLoadingFor(CompanyAction.load);

    if (!state.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(CompanyRoutes.gate);
        }
      });
      return const Scaffold(body: AppLoader());
    }

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => current.didSucceed(CompanyAction.load) && previous.status != current.status,
      listener: (context, state) {
        final destination = CompanyRoutes.destinationFor(state.profile);
        if (destination != CompanyRoutes.status) {
          context.go(destination);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.companyTitle), actions: [_logoutButton(context)]),
        body: RefreshIndicator(
          onRefresh: cubit.load,
          child: ListView(
            padding: AppSpacing.screen,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: const Icon(Icons.block_rounded, color: AppColors.error, size: 48),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.companyRejectedTitle, textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.companyRejectedBody,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              OutlinedButton.icon(
                onPressed: refreshing ? null : cubit.load,
                icon: refreshing ? const AppLoader.small() : const Icon(Icons.refresh_rounded),
                label: Text(l10n.refreshStatus),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
