import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/enums/verification_status.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_palette.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/presentation/pages/registration_wizard_page.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

typedef _StatusView = ({IconData icon, Color color, String title, String body});

class RegistrationStatusPage extends StatefulWidget {
  const RegistrationStatusPage({super.key});

  @override
  State<RegistrationStatusPage> createState() => _RegistrationStatusPageState();
}

class _RegistrationStatusPageState extends State<RegistrationStatusPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.loaded) {
      cubit.load();
    }
  }

  static _StatusView _view(AppLocalizations l10n, AppPalette palette, VerificationStatus status) => switch (status) {
        VerificationStatus.underReview => (
            icon: Icons.manage_search_rounded,
            color: palette.info,
            title: l10n.statusUnderReviewTitle,
            body: l10n.regSubmittedMessage,
          ),
        VerificationStatus.meetingRequired => (
            icon: Icons.support_agent_rounded,
            color: palette.warning,
            title: l10n.statusMeetingRequiredTitle,
            body: l10n.statusMeetingRequiredBody,
          ),
        VerificationStatus.meetingScheduled => (
            icon: Icons.event_available_rounded,
            color: palette.primary,
            title: l10n.statusMeetingScheduledTitle,
            body: l10n.statusMeetingScheduledBody,
          ),
        VerificationStatus.needsChanges => (
            icon: Icons.edit_note_rounded,
            color: palette.warning,
            title: l10n.statusNeedsChangesTitle,
            body: l10n.statusNeedsChangesBody,
          ),
        VerificationStatus.rejected => (
            icon: Icons.block_rounded,
            color: palette.error,
            title: l10n.statusRejectedTitle,
            body: l10n.statusRejectedBody,
          ),
        _ => (
            icon: Icons.mark_email_read_outlined,
            color: palette.success,
            title: l10n.statusSubmittedTitle,
            body: l10n.regSubmittedMessage,
          ),
      };

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.load)) {
      final destination = RegistrationRoutes.destinationFor(state.registration);
      if (destination == RegistrationRoutes.form || state.registration?.status == VerificationStatus.verified) {
        context.go(destination);
      }
    } else if (state.status == OperationStatus.failure && failure != null) {
      showRegistrationFailure(context, failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final registration = state.registration;

    if (registration == null) {
      if (state.loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go(RegistrationRoutes.form);
        });
      }
      return BlocListener<RegistrationCubit, RegistrationState>(
        listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
        listener: _listener,
        child: const Scaffold(body: AppLoader()),
      );
    }

    final view = _view(l10n, context.palette, registration.status);
    final meeting = state.meeting;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final refreshing = state.isLoadingFor(RegistrationAction.load);

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
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: cubit.load,
          child: ListView(
            padding: AppSpacing.screen,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(color: view.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: Icon(view.icon, color: view.color, size: 48),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(view.title, textAlign: TextAlign.center, style: context.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                view.body,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(color: context.palette.textSecondary),
              ),
              if (registration.status == VerificationStatus.meetingScheduled && meeting != null) ...[
                const SizedBox(height: AppSpacing.xl),
                ItemCard(
                  icon: Icons.event_rounded,
                  title: DateFormat.yMMMMEEEEd(locale).format(meeting.scheduledAt),
                  subtitle: ltr(DateFormat.jm(locale).format(meeting.scheduledAt)),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              if (registration.canEditOptional) ...[
                OutlinedButton.icon(
                  onPressed: () => context.push(RegistrationRoutes.optional),
                  icon: Icon(Icons.insights_outlined, color: context.palette.accent),
                  label: Text(l10n.regCompleteOptional),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (registration.status == VerificationStatus.needsChanges) ...[
                PrimaryButton(
                  label: l10n.regEditFile,
                  icon: Icons.edit_note_rounded,
                  onPressed: () => context.go(RegistrationRoutes.form),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (registration.status != VerificationStatus.needsChanges &&
                  registration.status != VerificationStatus.rejected) ...[
                OutlinedButton.icon(
                  onPressed: () => context.go(RegistrationRoutes.creatorHome),
                  icon: const Icon(Icons.home_outlined),
                  label: Text(l10n.regGoHome),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
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
