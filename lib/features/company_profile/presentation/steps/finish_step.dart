import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/company_documents.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/scan_banner.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart' show cleanAccountNumber;
import 'package:x_ten/features/influencer_registration/presentation/steps/financial_step.dart' show FinancialAccountCard;

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
        step: CompanyCatalog.identityDocuments.contains(type) ? CompanyStep.personal : CompanyStep.finish,
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
    if (has([ApiKeys.phone, ApiKeys.whatsapp, ApiKeys.phone2, ApiKeys.email]))
      (label: l10n.companyStepContact, step: CompanyStep.contact),
    if (has([ApiKeys.financialAccounts])) (label: l10n.regStepFinancial, step: CompanyStep.finish),
    if (has([ApiKeys.acceptedTerms, ApiKeys.acceptedPrivacy])) (label: l10n.acceptAllConsents, step: CompanyStep.finish),
  ];
}

class CompanyFinishStep extends StatefulWidget {
  const CompanyFinishStep({super.key});

  @override
  State<CompanyFinishStep> createState() => _CompanyFinishStepState();
}

class _CompanyFinishStepState extends State<CompanyFinishStep> {
  late CompanyConsents _consents;
  bool _showErrors = false;
  List<_Missing> _missing = const [];

  @override
  void initState() {
    super.initState();
    _consents = context.read<CompanyCubit>().state.profile?.consents ?? const CompanyConsents();
  }

  void _submit() {
    final cubit = context.read<CompanyCubit>();
    if (!cubit.state.financialComplete || !_consents.all) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _missing = const []);
    cubit.submit(_consents);
  }

  void _openAccountForm() {
    final cubit = context.read<CompanyCubit>();
    showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _AccountForm()));
  }

  void _listener(BuildContext context, CompanyState state) {
    final failure = state.failure;
    if (state.status != CompanyStatus.failure || failure == null) {
      return;
    }
    if (state.action == CompanyAction.submit && failure is ValidationFailure) {
      final missing = _missingFrom(context, failure);
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    switch (state.action) {
      case CompanyAction.submit || CompanyAction.deleteFinancial || CompanyAction.uploadDocument:
        showRegistrationFailure(context, failure);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(
          isLoading: state.isLoadingFor(CompanyAction.submit),
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          if (_missing.isNotEmpty) _MissingBox(items: _missing, onFix: cubit.goTo),
          SectionTitle(l10n.regFinancialTitle, subtitle: l10n.finAddHint),
          for (final account in state.financialAccounts)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: FinancialAccountCard(
                account: account,
                hasProof: state.proofOf(account.id) != null,
                busy: state.isLoadingFor(CompanyAction.deleteFinancial, account.id) ||
                    state.isLoadingFor(CompanyAction.uploadDocument, account.id),
                onDelete: state.isLoading ? null : () => cubit.deleteFinancialAccount(account.id),
              ),
            ),
          if (_showErrors && !state.financialComplete) Text(l10n.finEmpty, style: errorStyle),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: state.isLoading ? null : _openAccountForm,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.regAddInstitution),
            ),
          ),
          SectionTitle(l10n.consentsTitle),
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
          ScanBanner(title: l10n.companyStepFinish, text: l10n.companyMeetingNote, icon: Icons.event_available_outlined),
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
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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

class _AccountForm extends StatefulWidget {
  const _AccountForm();

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> with ServerFieldErrors {
  static const _fields = ['institutionName', 'accountNumber'];

  final _formKey = GlobalKey<FormState>();
  final _institution = TextEditingController();
  final _number = TextEditingController();
  UploadFile? _proof;
  bool _proofRead = false;
  int _attempts = 0;
  int _accountsBefore = 0;

  @override
  void dispose() {
    _institution.dispose();
    _number.dispose();
    super.dispose();
  }

  Future<void> _attach() async {
    final cubit = context.read<CompanyCubit>();
    final file = await pickDocument(context);
    if (file == null || !mounted) {
      return;
    }
    setState(() {
      _proof = file;
      _proofRead = false;
    });
    await cubit.readFinancialDocument(file);
  }

  void _onRead(BuildContext context, CompanyState state) {
    final l10n = context.l10n;
    if (state.status == CompanyStatus.success) {
      final read = state.readAccount;
      if (read == null) {
        return;
      }
      setState(() {
        _proofRead = true;
        _attempts = 0;
        if (read.accountNumber.isNotEmpty) {
          _number.text = read.accountNumber;
        }
        if (_institution.text.trim().isEmpty && read.institutionName.isNotEmpty) {
          _institution.text = read.institutionName;
        }
      });
      showSuccessSnackBar(context, l10n.finReadDone);
      return;
    }
    final failure = state.failure;
    if (failure == null) {
      return;
    }
    if (isOcrUnavailable(failure)) {
      showErrorSnackBar(context, l10n.ocrUnavailable);
    } else if (isUnrecognized(failure)) {
      _attempts++;
      const max = CompanyCatalog.maxScanAttempts;
      if (_attempts < max) {
        setState(() => _proof = null);
        showErrorSnackBar(context, l10n.docUnrecognizedRetry(_attempts, max));
      } else {
        showErrorSnackBar(context, l10n.finScanManualAfterTries);
      }
    } else {
      setState(() => _proof = null);
      showRegistrationFailure(context, failure);
    }
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final cubit = context.read<CompanyCubit>();
    _accountsBefore = cubit.state.financialAccounts.length;
    cubit.addFinancialAccount(FinancialAccount(institutionName: _institution.text, accountNumber: _number.text));
  }

  void _onSaved(BuildContext context, CompanyState state) {
    if (state.status == CompanyStatus.success) {
      final cubit = context.read<CompanyCubit>();
      final proof = _proof;
      final added = state.financialAccounts.length > _accountsBefore ? state.financialAccounts.last : null;
      Navigator.of(context).pop();
      if (proof != null && added != null) {
        cubit.uploadDocument(
          CompanyDocumentType.financialProof,
          proof,
          financialAccountId: added.id,
          acceptUnreadable: !_proofRead,
        );
      }
      return;
    }
    final failure = state.failure;
    if (failure == null) {
      return;
    }
    if (failure is ValidationFailure) {
      final l10n = context.l10n;
      final translated = ValidationFailure(details: {
        for (final field in _fields)
          if (failure.fieldError(field) case final error?)
            field: switch (error) {
              'required' => l10n.fieldRequired,
              'invalid' => l10n.finNumberInvalid,
              _ => error,
            },
      });
      handleFailure(translated.details.isEmpty ? failure : translated, _fields);
      return;
    }
    handleFailure(failure, _fields);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final saving = state.isLoadingFor(CompanyAction.addFinancial);
    final reading = state.isLoadingFor(CompanyAction.readFinancial);
    final proof = _proof;
    const gap = SizedBox(height: AppSpacing.md);

    return MultiBlocListener(
      listeners: [
        BlocListener<CompanyCubit, CompanyState>(
          listenWhen: (previous, current) =>
              current.action == CompanyAction.readFinancial &&
              previous.status != current.status &&
              current.status != CompanyStatus.loading,
          listener: _onRead,
        ),
        BlocListener<CompanyCubit, CompanyState>(
          listenWhen: (previous, current) =>
              current.action == CompanyAction.addFinancial &&
              previous.status != current.status &&
              current.status != CompanyStatus.loading,
          listener: _onSaved,
        ),
      ],
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.regAddInstitution, style: context.textTheme.titleMedium),
            gap,
            TextFormField(
              controller: _institution,
              textInputAction: TextInputAction.next,
              forceErrorText: serverError('institutionName'),
              onChanged: (_) => clearServerError('institutionName'),
              decoration: InputDecoration(labelText: l10n.finInstitutionName, helperText: l10n.finInstitutionHint),
              validator: (v) => requiredText(context, v),
            ),
            gap,
            OutlinedButton.icon(
              onPressed: reading || saving ? null : _attach,
              icon: reading
                  ? const AppLoader.small()
                  : Icon(proof == null ? Icons.document_scanner_outlined : Icons.task_alt_rounded),
              label: Text(proof?.name ?? l10n.finAttachDocument, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Text(l10n.finAttachDocumentHint, style: context.textTheme.bodySmall),
            ),
            gap,
            TextFormField(
              controller: _number,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 \-.]')),
                LengthLimitingTextInputFormatter(60),
              ],
              forceErrorText: serverError('accountNumber'),
              onChanged: (_) => clearServerError('accountNumber'),
              decoration: InputDecoration(labelText: l10n.finAccountNumber, helperText: l10n.finAccountNumberHint),
              validator: (v) {
                final number = cleanAccountNumber(v ?? '');
                if (number.isEmpty) {
                  return l10n.fieldRequired;
                }
                if (!RegExp(r'^[A-Z0-9]{4,40}$').hasMatch(number)) {
                  return l10n.finNumberInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: saving, onPressed: reading ? null : _save),
          ],
        ),
      ),
    );
  }
}
