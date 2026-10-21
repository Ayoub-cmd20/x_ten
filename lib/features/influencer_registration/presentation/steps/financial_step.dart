import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
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
import 'package:x_ten/features/influencer_registration/presentation/widgets/submit_missing.dart';

const _postInstitution = 'Algérie Poste (CCP)';

class FinancialStep extends StatefulWidget {
  const FinancialStep({super.key});

  @override
  State<FinancialStep> createState() => _FinancialStepState();
}

class _FinancialStepState extends State<FinancialStep> {
  bool _showErrors = false;
  List<SubmitMissing> _missing = const [];
  int _attempts = 0;
  UploadFile? _lastCheque;

  void _submit() {
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.financialComplete) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _missing = const []);
    cubit.submit();
  }

  Future<void> _scanCheque() async {
    final file = await pickDocument(context);
    if (file == null || !mounted) return;
    _lastCheque = file;
    await context.read<RegistrationCubit>().scanCcpCheque(file);
  }

  void _openForm({_ChequeProof? proof}) {
    final cubit = context.read<RegistrationCubit>();
    showFormSheet<void>(context, BlocProvider.value(value: cubit, child: _AccountForm(proof: proof)));
  }

  void _onChequeFailed(BuildContext context, Failure failure) {
    final l10n = context.l10n;
    final file = _lastCheque;
    if (isOcrUnavailable(failure) && file != null) {
      showErrorSnackBar(context, l10n.ocrUnavailable);
      _openForm(proof: (file: file, acceptUnreadable: false));
      return;
    }
    if (!isUnrecognized(failure) || file == null) {
      showRegistrationFailure(context, failure);
      return;
    }
    _attempts++;
    const max = RegistrationCatalog.maxScanAttempts;
    if (_attempts < max) {
      showErrorSnackBar(context, l10n.docUnrecognizedRetry(_attempts, max));
      return;
    }
    _attempts = 0;
    showErrorSnackBar(context, l10n.finScanManualAfterTries);
    _openForm(proof: (file: file, acceptUnreadable: true));
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.scanCcpCheque)) {
      _attempts = 0;
      showSuccessSnackBar(context, context.l10n.ccpChequeRead);
      return;
    }
    if (state.status != OperationStatus.failure || failure == null) return;
    if (state.action == RegistrationAction.scanCcpCheque) {
      _onChequeFailed(context, failure);
      return;
    }
    if (state.action == RegistrationAction.submit && failure is ValidationFailure) {
      final missing = submitMissingFrom(context, failure);
      if (missing.isNotEmpty) {
        setState(() => _missing = missing);
        return;
      }
    }
    const actions = {
      RegistrationAction.submit,
      RegistrationAction.deleteFinancial,
      RegistrationAction.uploadDocument,
    };
    if (actions.contains(state.action)) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final cheque = state.ccpCheque;
    final postAccount = state.financialAccounts.where((a) => a.id == cheque?.financialAccountId).firstOrNull;
    final others = [for (final a in state.financialAccounts) if (a.id != postAccount?.id) a];

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(
          isLoading: state.isLoadingFor(RegistrationAction.submit),
          onBack: cubit.back,
          onNext: _submit,
          nextLabel: l10n.submitForReview,
        ),
        children: [
          if (_missing.isNotEmpty) SubmitMissingBox(items: _missing, onFix: cubit.goTo),
          SectionTitle(l10n.ccpChequeTitle, subtitle: l10n.ccpChequeHint),
          _ChequeCard(
            document: cheque,
            account: postAccount,
            busy: state.isLoadingFor(RegistrationAction.scanCcpCheque) ||
                state.isLoadingFor(RegistrationAction.uploadDocument, postAccount?.id) ||
                (postAccount != null && state.isLoadingFor(RegistrationAction.deleteFinancial, postAccount.id)),
            enabled: !state.isLoading,
            highlightMissing: _showErrors && cheque == null,
            onScan: _scanCheque,
            onDelete: postAccount == null ? null : () => cubit.deleteFinancialAccount(postAccount.id),
          ),
          SectionTitle(l10n.otherInstitutionsTitle),
          for (final account in others)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ItemCard(
                icon: Icons.account_balance_outlined,
                title: account.institutionName.isEmpty ? l10n.financialKindLabel(account.kind) : account.institutionName,
                subtitle: ltr(account.accountNumber),
                trailing: state.isLoadingFor(RegistrationAction.deleteFinancial, account.id)
                    ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
                    : IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: state.isLoading ? null : () => cubit.deleteFinancialAccount(account.id),
                      ),
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: state.isLoading ? null : () => _openForm(),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.regAddInstitution),
            ),
          ),
        ],
      ),
    );
  }
}

typedef _ChequeProof = ({UploadFile file, bool acceptUnreadable});

class _ChequeCard extends StatelessWidget {
  const _ChequeCard({
    required this.document,
    required this.account,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
    required this.onScan,
    required this.onDelete,
  });

  final RegistrationDocument? document;
  final FinancialAccount? account;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;
  final VoidCallback onScan;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = this.document;
    final account = this.account;
    final onDelete = this.onDelete;

    return ItemCard(
      icon: document == null ? Icons.document_scanner_outlined : Icons.task_alt_rounded,
      highlight: document != null ? AppColors.success : (highlightMissing ? AppColors.error : null),
      title: document == null ? l10n.docCcpCheque : ltr(account?.accountNumber ?? document.fileName),
      subtitle: switch (document) {
        null => highlightMissing ? l10n.ccpChequeRequired : l10n.documentsSubtitle,
        RegistrationDocument(check: DocumentCheck.needsManualReview) => l10n.regNeedsReview,
        RegistrationDocument(check: DocumentCheck.passed) => '${l10n.finCcp} · ${l10n.regDocChecked}',
        _ => l10n.finCcp,
      },
      onTap: enabled && !busy ? onScan : null,
      trailing: busy
          ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
          : document != null && onDelete != null
              ? IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: enabled ? onDelete : null,
                )
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                  child: Text(l10n.upload, style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary)),
                ),
    );
  }
}

class _AccountForm extends StatefulWidget {
  const _AccountForm({this.proof});

  final _ChequeProof? proof;

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> with ServerFieldErrors {
  static const _fields = ['institutionName', 'accountNumber'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _institution;
  final _number = TextEditingController();
  int _accountsBefore = 0;

  @override
  void initState() {
    super.initState();
    _institution = TextEditingController(text: widget.proof == null ? '' : _postInstitution);
  }

  @override
  void dispose() {
    _institution.dispose();
    _number.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<RegistrationCubit>();
    _accountsBefore = cubit.state.financialAccounts.length;
    cubit.addFinancialAccount(FinancialAccount(
      institutionName: _institution.text,
      accountNumber: _number.text,
    ));
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      final cubit = context.read<RegistrationCubit>();
      final proof = widget.proof;
      final added = state.financialAccounts.length > _accountsBefore ? state.financialAccounts.last : null;
      Navigator.of(context).pop();
      if (proof != null && added != null) {
        cubit.uploadDocument(
          DocumentType.ccpCheque,
          proof.file,
          financialAccountId: added.id,
          acceptUnreadable: proof.acceptUnreadable,
        );
      }
    } else if (state.status == OperationStatus.failure) {
      final failure = state.failure!;
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.addFinancial));
    final proof = widget.proof;
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.addFinancial && previous.status != current.status,
      listener: _onChanged,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.regAddInstitution, style: context.textTheme.titleMedium),
            if (proof != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.finProofAttached(proof.file.name), style: context.textTheme.bodySmall),
            ],
            gap,
            TextFormField(
              controller: _institution,
              readOnly: proof != null,
              textInputAction: TextInputAction.next,
              forceErrorText: serverError('institutionName'),
              onChanged: (_) => clearServerError('institutionName'),
              decoration: InputDecoration(labelText: l10n.finInstitutionName),
              validator: (v) => requiredText(context, v),
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
              decoration: InputDecoration(labelText: proof != null ? l10n.ccpRipLabel : l10n.finAccountNumber),
              validator: (v) {
                final number = cleanAccountNumber(v ?? '');
                if (number.isEmpty) return l10n.fieldRequired;
                if (!RegExp(r'^[A-Z0-9]{4,40}$').hasMatch(number)) return l10n.finNumberInvalid;
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
