import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/business_documents.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/company_documents.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart' show RegistrationCatalog;
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart' show cleanAccountNumber;
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/financial_step.dart' show FinancialAccountCard;

class CompanyFinishStep extends StatefulWidget {
  const CompanyFinishStep({super.key});

  @override
  State<CompanyFinishStep> createState() => _CompanyFinishStepState();
}

class _CompanyFinishStepState extends State<CompanyFinishStep> {
  bool _showErrors = false;

  void _next() {
    final cubit = context.read<CompanyCubit>();
    if (!cubit.state.financialComplete) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.next();
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
    switch (state.action) {
      case CompanyAction.uploadDocument when state.target is int:
        showRegistrationFailure(context, failure);
      case CompanyAction.deleteFinancial || CompanyAction.deleteDocument:
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
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: context.palette.error);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        requiredNote: true,
        actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
        children: [
          SectionTitle(req(l10n.regFinancialTitle), subtitle: l10n.finAddHint),
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
          if (state.isRegistered) ...[
            SectionTitle(l10n.companyLicensesTitle, subtitle: l10n.companyLicensesHint),
            const CompanyLicenses(),
          ],
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
  final _number = TextEditingController();
  String? _institution;
  UploadFile? _proof;
  bool _proofRead = false;
  int _attempts = 0;
  int _accountsBefore = 0;

  @override
  void dispose() {
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
        if (_institution == null && RegistrationCatalog.financialInstitutions.contains(read.institutionName)) {
          _institution = read.institutionName;
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
    cubit.addFinancialAccount(FinancialAccount(institutionName: _institution ?? '', accountNumber: _number.text));
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
            DropdownButtonFormField<String>(
              initialValue: _institution,
              key: ValueKey(_institution),
              isExpanded: true,
              forceErrorText: serverError('institutionName'),
              decoration: InputDecoration(labelText: req(l10n.finInstitutionName)),
              items: [
                for (final id in RegistrationCatalog.financialInstitutions)
                  DropdownMenuItem(value: id, child: Text(l10n.institutionLabel(id), overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (value) {
                clearServerError('institutionName');
                setState(() => _institution = value);
              },
              validator: (value) => value == null ? l10n.fieldRequired : null,
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
              decoration: InputDecoration(labelText: req(l10n.finAccountNumber), helperText: l10n.finAccountNumberHint),
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
