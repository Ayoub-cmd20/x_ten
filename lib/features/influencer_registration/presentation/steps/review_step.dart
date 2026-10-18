import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

typedef _Missing = ({String label, RegistrationStep step});

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  late Consents _consents;
  List<_Missing> _missing = const [];
  bool _showConsentError = false;

  @override
  void initState() {
    super.initState();
    _consents = context.read<RegistrationCubit>().state.registration?.consents ?? const Consents();
  }

  void _submit() {
    if (!_consents.all) {
      setState(() => _showConsentError = true);
      return;
    }
    setState(() => _missing = const []);
    context.read<RegistrationCubit>().submit(_consents);
  }

  List<_Missing> _missingFrom(ValidationFailure failure) {
    final l10n = context.l10n;
    final details = failure.details;
    bool has(String key) => details.containsKey(key);
    return [
      if (has(ApiKeys.firstName) || has(ApiKeys.lastName) || has(ApiKeys.displayName))
        (label: l10n.missingNames, step: RegistrationStep.basicInfo),
      if (has(ApiKeys.bio)) (label: l10n.bio, step: RegistrationStep.basicInfo),
      if (has(ApiKeys.email) || has(ApiKeys.phone)) (label: l10n.missingContact, step: RegistrationStep.basicInfo),
      if (has(ApiKeys.primaryCategories)) (label: l10n.primaryCategories, step: RegistrationStep.audience),
      if (has(ApiKeys.contentTypes)) (label: l10n.contentTypes, step: RegistrationStep.audience),
      if (has(ApiKeys.audience)) (label: l10n.audienceAge, step: RegistrationStep.audience),
      if (has(ApiKeys.socialAccounts)) (label: l10n.socialAccountsEmpty, step: RegistrationStep.accounts),
      if (has(ApiKeys.financialInformation)) (label: l10n.payoutMethod, step: RegistrationStep.financial),
      if (failure.missingDocuments.isNotEmpty)
        (
          label: l10n.missingDocumentsWarning(l10n.documentList([
            for (final type in failure.missingDocuments) enumFromApi(DocumentType.values, type, DocumentType.other),
          ])),
          step: RegistrationStep.financial,
        ),
    ];
  }

  void _onSubmitFailed(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (failure is ValidationFailure) {
      final missing = _missingFrom(failure);
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    if (failure != null) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<RegistrationCubit>();
    final notifications = context.select((RegistrationCubit c) => c.state.notifications);
    final isSubmitting = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.submit));

    final consentRows = <(String, bool, Consents Function(bool))>[
      (l10n.consentConfirm, _consents.confirmInformation, (v) => _consents.copyWith(confirmInformation: v)),
      (l10n.consentTerms, _consents.acceptedTerms, (v) => _consents.copyWith(acceptedTerms: v)),
      (l10n.consentPrivacy, _consents.acceptedPrivacy, (v) => _consents.copyWith(acceptedPrivacy: v)),
      (l10n.consentVerification, _consents.acceptedVerification, (v) => _consents.copyWith(acceptedVerification: v)),
      (l10n.consentContact, _consents.acceptedContact, (v) => _consents.copyWith(acceptedContact: v)),
    ];

    final notificationRows = <(String, bool, NotificationPreferences Function(bool))>[
      (l10n.notifyInApp, notifications.inApp, (v) => notifications.copyWith(inApp: v)),
      (l10n.notifyWhatsapp, notifications.whatsapp, (v) => notifications.copyWith(whatsapp: v)),
      (l10n.email, notifications.email, (v) => notifications.copyWith(email: v)),
      (l10n.notifySms, notifications.sms, (v) => notifications.copyWith(sms: v)),
      (l10n.notifyPhone, notifications.phoneCall, (v) => notifications.copyWith(phoneCall: v)),
    ];

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.submit && current.status == OperationStatus.failure,
      listener: _onSubmitFailed,
      child: StepBody(
        actions: StepActions(
          isLoading: isSubmitting,
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          if (_missing.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.submitMissingTitle, style: context.textTheme.titleSmall?.copyWith(color: AppColors.error)),
                  const SizedBox(height: AppSpacing.xs),
                  for (final item in _missing)
                    Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(child: Text(item.label, style: context.textTheme.bodySmall)),
                        TextButton(onPressed: () => cubit.goTo(item.step), child: Text(l10n.fix)),
                      ],
                    ),
                ],
              ),
            ),
          ],
          SectionTitle(l10n.notificationsTitle),
          for (final (label, value, update) in notificationRows)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: context.textTheme.bodyMedium),
              value: value,
              onChanged: (v) => cubit.setNotifications(update(v)),
            ),
          SectionTitle(l10n.consentsTitle),
          for (final (label, value, update) in consentRows)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(label, style: context.textTheme.bodyMedium),
              value: value,
              onChanged: (v) => setState(() {
                _consents = update(v ?? false);
                if (_consents.all) _showConsentError = false;
              }),
            ),
          TextButton(
            onPressed: () => setState(() {
              _consents = const Consents(
                confirmInformation: true,
                acceptedTerms: true,
                acceptedPrivacy: true,
                acceptedVerification: true,
                acceptedContact: true,
              );
              _showConsentError = false;
            }),
            child: Text(l10n.acceptAll),
          ),
          if (_showConsentError)
            Text(l10n.acceptAllConsents, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
