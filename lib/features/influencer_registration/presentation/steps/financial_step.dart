import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/document_tiles.dart';

class FinancialStep extends StatefulWidget {
  const FinancialStep({super.key});

  @override
  State<FinancialStep> createState() => _FinancialStepState();
}

class _FinancialStepState extends State<FinancialStep> {
  bool _showErrors = false;

  void _next() {
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.financialComplete) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.next();
  }

  void _openForm() {
    final cubit = context.read<RegistrationCubit>();
    showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _AccountForm()));
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.status != OperationStatus.failure || failure == null) {
      return;
    }
    const actions = {
      RegistrationAction.deleteFinancial,
      RegistrationAction.uploadDocument,
    };
    if (actions.contains(state.action)) {
      showRegistrationFailure(context, failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: context.palette.error);

    return BlocListener<RegistrationCubit, RegistrationState>(
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
                busy: state.isLoadingFor(RegistrationAction.deleteFinancial, account.id) ||
                    state.isLoadingFor(RegistrationAction.uploadDocument, account.id),
                onDelete: state.isLoading ? null : () => cubit.deleteFinancialAccount(account.id),
              ),
            ),
          if (_showErrors && !state.financialComplete) Text(l10n.finEmpty, style: errorStyle),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: state.isLoading ? null : _openForm,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.regAddInstitution),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class FinancialAccountCard extends StatelessWidget {
  const FinancialAccountCard({
    super.key,
    required this.account,
    required this.hasProof,
    required this.busy,
    required this.onDelete,
  });

  final FinancialAccount account;
  final bool hasProof;
  final bool busy;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ItemCard(
      icon: hasProof ? Icons.task_alt_rounded : Icons.account_balance_outlined,
      highlight: hasProof ? context.palette.success : null,
      title: l10n.institutionLabel(account.institutionName),
      subtitle: hasProof ? '${ltr(account.accountNumber)} · ${l10n.finProofAdded}' : ltr(account.accountNumber),
      trailing: busy
          ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
          : IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: onDelete,
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
  String? _institution;
  final _number = TextEditingController();
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
    final cubit = context.read<RegistrationCubit>();
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

  void _onRead(BuildContext context, RegistrationState state) {
    final l10n = context.l10n;
    if (state.status == OperationStatus.success) {
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
      const max = RegistrationCatalog.maxScanAttempts;
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
    final cubit = context.read<RegistrationCubit>();
    _accountsBefore = cubit.state.financialAccounts.length;
    cubit.addFinancialAccount(FinancialAccount(institutionName: _institution ?? '', accountNumber: _number.text));
  }

  void _onSaved(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      final cubit = context.read<RegistrationCubit>();
      final proof = _proof;
      final added = state.financialAccounts.length > _accountsBefore ? state.financialAccounts.last : null;
      Navigator.of(context).pop();
      if (proof != null && added != null) {
        cubit.uploadDocument(
          DocumentType.financialProof,
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
    final state = context.watch<RegistrationCubit>().state;
    final saving = state.isLoadingFor(RegistrationAction.addFinancial);
    final reading = state.isLoadingFor(RegistrationAction.readFinancial);
    final proof = _proof;
    const gap = SizedBox(height: AppSpacing.md);

    return MultiBlocListener(
      listeners: [
        BlocListener<RegistrationCubit, RegistrationState>(
          listenWhen: (previous, current) =>
              current.action == RegistrationAction.readFinancial &&
              previous.status != current.status &&
              current.status != OperationStatus.loading,
          listener: _onRead,
        ),
        BlocListener<RegistrationCubit, RegistrationState>(
          listenWhen: (previous, current) =>
              current.action == RegistrationAction.addFinancial &&
              previous.status != current.status &&
              current.status != OperationStatus.loading,
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
