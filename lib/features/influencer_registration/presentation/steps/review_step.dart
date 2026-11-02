import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/catalog/countries.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/submit_missing.dart';

class ReviewStep extends StatefulWidget {
  const ReviewStep({super.key});

  @override
  State<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends State<ReviewStep> {
  late ConsentInfo _consents;
  bool _showErrors = false;
  List<SubmitMissing> _missing = const [];

  @override
  void initState() {
    super.initState();
    _consents = context.read<RegistrationCubit>().state.registration?.consents ?? const ConsentInfo();
  }

  void _submit() {
    if (!_consents.all) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _missing = const []);
    context.read<RegistrationCubit>().submit(_consents);
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (!state.didFail(RegistrationAction.submit) || failure == null) {
      return;
    }
    if (failure is ValidationFailure) {
      final missing = submitMissingFrom(context, failure);
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final registration = state.registration;
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: context.palette.error);
    final locale = Localizations.localeOf(context);
    final language = locale.languageCode;

    if (registration == null) {
      return const SizedBox.shrink();
    }

    final personal = registration.personal;
    final profile = registration.profile;
    final contact = registration.contact;
    final optional = registration.optional;
    final identity = [
      for (final type in RegistrationCatalog.identityDocuments)
        if (state.documentOf(type) != null) l10n.documentLabel(type),
    ];
    String names(List<String> ids, String Function(String) label) => ids.map(label).join(l10n.listSeparator);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        requiredNote: true,
        actions: StepActions(
          isLoading: state.isLoadingFor(RegistrationAction.submit),
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submit,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.palette.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: context.palette.primary.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.fact_check_outlined, color: context.palette.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(l10n.regReviewHint, style: context.textTheme.titleSmall)),
              ],
            ),
          ),
          if (_missing.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            SubmitMissingBox(items: _missing, onFix: cubit.editFrom),
          ],
          ReviewSection(
            title: l10n.regStepPersonal,
            onEdit: () => cubit.editFrom(RegistrationStep.personal),
            rows: [
              (l10n.firstName, personal.firstName),
              (l10n.lastName, personal.lastName),
              (l10n.regNationalId, ltr(personal.nationalId)),
              (
                l10n.dateOfBirth,
                switch (personal.birthDate) {
                  final date? => DateFormat.yMMMd(locale.toLanguageTag()).format(date),
                  null => '',
                },
              ),
              (l10n.birthPlace, personal.birthPlace),
              (l10n.regEntityShort, switch (personal.entityType) {
                final type? => l10n.entityTypeLabel(type),
                null => '',
              }),
              (l10n.regIdentityDocument, identity.join(l10n.listSeparator)),
            ],
          ),
          ReviewSection(
            title: l10n.regStepProfile,
            onEdit: () => cubit.editFrom(RegistrationStep.profile),
            rows: [
              (l10n.regDisplayName, profile.displayName),
              (l10n.regPrimaryCategories, names(profile.primaryCategories, l10n.category)),
              (l10n.regSecondaryCategories, names(profile.secondaryCategories, l10n.category)),
              (
                l10n.regContentLanguages,
                [
                  for (final item in profile.contentLanguages)
                    '${item.name.isNotEmpty ? item.name : l10n.languageLabel(item.code)} '
                        '(${l10n.levelLabel(item.level)} ${ltr('${item.percent}%')})',
                ].join(l10n.listSeparator),
              ),
              (l10n.regAddressLanguages, names(profile.addressLanguages, l10n.languageLabel)),
            ],
          ),
          ReviewSection(
            title: l10n.regStepContact,
            onEdit: () => cubit.editFrom(RegistrationStep.contact),
            rows: [
              (l10n.phone, ltr(contact.phone)),
              (l10n.whatsapp, ltr(contact.whatsapp)),
              (l10n.email, ltr(contact.email)),
              (l10n.regBackupPhone, contact.backupPhone.isEmpty ? '' : ltr(contact.backupPhone)),
              (l10n.regDeliveryAddress, contact.deliveryAddress),
            ],
          ),
          ReviewSection(
            title: l10n.regStepSocial,
            onEdit: () => cubit.editFrom(RegistrationStep.accounts),
            rows: [
              for (final account in state.socialAccounts)
                (
                  l10n.platform(account.platform),
                  [
                    if (account.accountName.isNotEmpty) account.accountName,
                    if (account.followers > 0) l10n.followersCount('${account.followers}'),
                  ].join(' · '),
                ),
            ],
          ),
          ReviewSection(
            title: l10n.regStepOptional,
            onEdit: () => cubit.editFrom(RegistrationStep.optional),
            rows: [
              (l10n.regBio, optional.bio),
              (
                l10n.audCountries,
                [
                  for (final c in optional.audience.countries)
                    '${Countries.name(c.country, language)} ${ltr('${percentText(c.percent)}%')}',
                ].join(l10n.listSeparator),
              ),
              (l10n.regContentTypesTitle, names(optional.contentTypes, l10n.adContentTypeLabel)),
              (l10n.regPortfolioTitle, state.portfolio.isEmpty ? '' : '${state.portfolio.length}'),
            ],
          ),
          ReviewSection(
            title: l10n.regStepFinancial,
            onEdit: () => cubit.editFrom(RegistrationStep.financial),
            rows: [
              for (final account in state.financialAccounts)
                (l10n.institutionLabel(account.institutionName), ltr(account.accountNumber)),
            ],
          ),
          SectionTitle(req(l10n.consentsTitle)),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _consents.acceptedPrivacy,
            title: Text(l10n.regConsentPrivacy, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(
              () => _consents = ConsentInfo(acceptedTerms: _consents.acceptedTerms, acceptedPrivacy: value ?? false),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _consents.acceptedTerms,
            title: Text(l10n.regConsentTerms, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(
              () => _consents = ConsentInfo(acceptedTerms: value ?? false, acceptedPrivacy: _consents.acceptedPrivacy),
            ),
          ),
          if (_showErrors && !_consents.all) Text(l10n.acceptAllConsents, style: errorStyle),
        ],
      ),
    );
  }
}

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key, required this.title, required this.rows, required this.onEdit});

  final String title;
  final List<(String, String)> rows;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xs, AppSpacing.md, AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: context.textTheme.titleSmall?.copyWith(color: context.palette.primary))),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.edit),
              ),
            ],
          ),
          if (rows.isEmpty) Text('—', style: context.textTheme.bodyMedium),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(label, style: context.textTheme.bodySmall?.copyWith(color: context.palette.textSecondary)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 3,
                    child: Text(value.trim().isEmpty ? '—' : value, style: context.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
