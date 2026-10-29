import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/scan_banner.dart';
import 'package:x_ten/features/company_profile/presentation/wilayas.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/review_step.dart' show ReviewSection;

typedef _Missing = ({String label, CompanyStep step});

List<_Missing> _missingFrom(BuildContext context, ValidationFailure failure) {
  final l10n = context.l10n;
  bool has(List<String> keys) => keys.any(failure.details.containsKey);
  final documents = [
    for (final name in failure.missingDocuments)
      enumFromApi(CompanyDocumentType.values, name, CompanyDocumentType.other),
  ];
  return [
    if (has([ApiKeys.businessType])) (label: l10n.companyStepType, step: CompanyStep.type),
    if (has([ApiKeys.firstName, ApiKeys.lastName, ApiKeys.idNumber, ApiKeys.birthDate, ApiKeys.role, ApiKeys.roleOther]))
      (label: l10n.companyStepPersonal, step: CompanyStep.personal),
    for (final type in documents)
      (
        label: l10n.missingDocumentsWarning(l10n.companyDocumentLabel(type)),
        step: switch (type) {
          _ when CompanyCatalog.identityDocuments.contains(type) => CompanyStep.personal,
          _ when CompanyCatalog.businessDocuments.contains(type) => CompanyStep.business,
          _ => CompanyStep.finish,
        },
      ),
    if (has([
      ApiKeys.accountName,
      ApiKeys.companyName,
      ApiKeys.branch,
      ApiKeys.wilaya,
      ApiKeys.address,
      ApiKeys.registrationNumber,
      ApiKeys.ns,
      ApiKeys.nif,
    ]))
      (label: l10n.companyStepBusiness, step: CompanyStep.business),
    if (has([ApiKeys.bio, ApiKeys.activityAreas, ApiKeys.activityOther, 'profileImage']))
      (label: l10n.companyStepPresence, step: CompanyStep.presence),
    if (has([ApiKeys.phone, ApiKeys.whatsapp, ApiKeys.phone2, ApiKeys.email, ApiKeys.officialEmail]))
      (label: l10n.companyStepContact, step: CompanyStep.contact),
    if (has([ApiKeys.financialAccounts])) (label: l10n.regStepFinancial, step: CompanyStep.finish),
    if (has([ApiKeys.acceptedTerms, ApiKeys.acceptedPrivacy])) (label: l10n.acceptAllConsents, step: CompanyStep.review),
  ];
}

class CompanyReviewStep extends StatefulWidget {
  const CompanyReviewStep({super.key});

  @override
  State<CompanyReviewStep> createState() => _CompanyReviewStepState();
}

class _CompanyReviewStepState extends State<CompanyReviewStep> {
  late CompanyConsents _consents;
  bool _showErrors = false;
  List<_Missing> _missing = const [];

  @override
  void initState() {
    super.initState();
    _consents = context.read<CompanyCubit>().state.profile?.consents ?? const CompanyConsents();
  }

  void _submit() {
    if (!_consents.all) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _missing = const []);
    context.read<CompanyCubit>().submit(_consents);
  }

  void _listener(BuildContext context, CompanyState state) {
    final failure = state.failure;
    if (!state.didFail(CompanyAction.submit) || failure == null) {
      return;
    }
    if (failure is ValidationFailure) {
      final missing = _missingFrom(context, failure);
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
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final profile = state.profile;
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    final locale = Localizations.localeOf(context);

    if (profile == null) {
      return const SizedBox.shrink();
    }

    final registered = state.isRegistered;
    final personal = profile.personal;
    final business = profile.business;
    final presence = profile.presence;
    final contact = profile.contact;
    String docs(Iterable<CompanyDocumentType> types) =>
        l10n.companyDocumentList([for (final type in types) if (state.documentOf(type) != null) type]);
    String code(String value) => value.isEmpty ? '' : ltr(value);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        requiredNote: true,
        actions: StepActions(
          isLoading: state.isLoadingFor(CompanyAction.submit),
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.fact_check_outlined, color: AppColors.gold),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(l10n.regReviewHint, style: context.textTheme.titleSmall)),
              ],
            ),
          ),
          if (_missing.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _MissingBox(items: _missing, onFix: cubit.editFrom),
          ],
          ReviewSection(
            title: l10n.companyStepType,
            onEdit: () => cubit.editFrom(CompanyStep.type),
            rows: [
              (
                l10n.businessTypeQuestion,
                switch (profile.businessType) {
                  final type? => l10n.businessTypeTitle(type),
                  null => '',
                },
              ),
            ],
          ),
          ReviewSection(
            title: l10n.companyStepPersonal,
            onEdit: () => cubit.editFrom(CompanyStep.personal),
            rows: [
              (l10n.firstName, personal.firstName),
              (l10n.lastName, personal.lastName),
              (l10n.regIdNumber, code(personal.idNumber)),
              (
                l10n.dateOfBirth,
                switch (personal.birthDate) {
                  final date? => DateFormat.yMMMd(locale.toLanguageTag()).format(date),
                  null => '',
                },
              ),
              (
                l10n.companyRoleTitle,
                switch (personal.role) {
                  '' => '',
                  CompanyCatalog.otherRole => personal.roleOther,
                  final role => l10n.companyRole(role),
                },
              ),
              (l10n.regIdentityDocument, docs(CompanyCatalog.identityDocuments)),
            ],
          ),
          ReviewSection(
            title: l10n.companyStepBusiness,
            onEdit: () => cubit.editFrom(CompanyStep.business),
            rows: [
              if (registered) ...[
                (l10n.companyInstitutionName, business.companyName),
                (l10n.companyBranch, business.branch),
              ] else
                (l10n.companyAccountName, business.accountName),
              (
                registered ? l10n.companyHqWilaya : l10n.wilaya,
                business.wilaya.isEmpty ? '' : wilayaLabel(context, business.wilaya),
              ),
              (registered ? l10n.companyHqAddress : l10n.address, business.address),
              if (registered) ...[
                (l10n.commercialRegister, code(business.registrationNumber)),
                (l10n.nationalId, code(business.ns)),
                (l10n.taxId, code(business.nif)),
                (l10n.documentsTitle, docs(CompanyCatalog.businessDocuments)),
              ],
              (
                l10n.companyCapital,
                switch (business.capital) {
                  final capital? => '${ltr('$capital')} ${l10n.companyCurrency}',
                  null => '',
                },
              ),
            ],
          ),
          ReviewSection(
            title: l10n.companyStepPresence,
            onEdit: () => cubit.editFrom(CompanyStep.presence),
            rows: [
              (
                l10n.companyActivitiesTitle,
                [
                  for (final area in presence.activityAreas)
                    area == CompanyCatalog.otherActivity && presence.activityOther.isNotEmpty
                        ? presence.activityOther
                        : l10n.activityArea(area),
                ].join(l10n.listSeparator),
              ),
              for (final page in presence.marketingPages)
                (
                  l10n.platform(page.platform),
                  [
                    if (page.accountName.isNotEmpty) page.accountName else ltr(page.url),
                    if ((page.followers ?? 0) > 0) l10n.followersCount(ltr('${page.followers}')),
                  ].join(' · '),
                ),
              (l10n.companyBio, presence.bio),
            ],
          ),
          ReviewSection(
            title: l10n.companyStepContact,
            onEdit: () => cubit.editFrom(CompanyStep.contact),
            rows: [
              (l10n.officialPhone, code(contact.phone)),
              (l10n.companyWhatsappOptional, code(contact.whatsapp)),
              if (registered) (l10n.companyPhone2, code(contact.phone2)),
              (l10n.email, code(contact.email)),
              (l10n.companyOfficialEmail, code(contact.officialEmail)),
            ],
          ),
          ReviewSection(
            title: l10n.companyStepFinish,
            onEdit: () => cubit.editFrom(CompanyStep.finish),
            rows: [
              for (final account in state.financialAccounts)
                (l10n.institutionLabel(account.institutionName), ltr(account.accountNumber)),
              if (registered)
                (
                  l10n.companyLicensesTitle,
                  [
                    for (final license in state.documentsOf(CompanyDocumentType.license))
                      license.description.isNotEmpty ? license.description : license.fileName,
                  ].join(l10n.listSeparator),
                ),
            ],
          ),
          SectionTitle(req(l10n.consentsTitle)),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _consents.acceptedPrivacy,
            title: Text(l10n.regConsentPrivacy, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(
              () => _consents = CompanyConsents(acceptedTerms: _consents.acceptedTerms, acceptedPrivacy: value ?? false),
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _consents.acceptedTerms,
            title: Text(l10n.regConsentTerms, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(
              () => _consents = CompanyConsents(acceptedTerms: value ?? false, acceptedPrivacy: _consents.acceptedPrivacy),
            ),
          ),
          if (_showErrors && !_consents.all) Text(l10n.acceptAllConsents, style: errorStyle),
          const SizedBox(height: AppSpacing.md),
          ScanBanner(title: l10n.regStepReview, text: l10n.companyMeetingNote, icon: Icons.event_available_outlined),
        ],
      ),
    );
  }
}

class _MissingBox extends StatelessWidget {
  const _MissingBox({required this.items, required this.onFix});

  final List<_Missing> items;
  final ValueChanged<CompanyStep> onFix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
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
          for (final item in items)
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(item.label, style: context.textTheme.bodySmall)),
                TextButton(onPressed: () => onFix(item.step), child: Text(l10n.fix)),
              ],
            ),
        ],
      ),
    );
  }
}
