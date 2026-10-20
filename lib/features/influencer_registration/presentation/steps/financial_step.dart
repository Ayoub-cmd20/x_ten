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
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/documents_step.dart';

/// المؤسسات المالية التي تتعامل معها + أرقام حساباتك في كل واحدة (أي مؤسسة، عدة مؤسسات).
/// الطريقة الأساسية: صورة الصك/الشيك تعمّر الحساب وحدها. الإدخال اليدوي متوفر دائماً.
class FinancialStep extends StatefulWidget {
  const FinancialStep({super.key});

  @override
  State<FinancialStep> createState() => _FinancialStepState();
}

class _FinancialStepState extends State<FinancialStep> {
  bool _showErrors = false;
  int _scanAttempts = 0;
  UploadFile? _lastScan;

  void _next() {
    final cubit = context.read<RegistrationCubit>();
    if (!cubit.state.financialComplete) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.next();
  }

  Future<void> _scan() async {
    final file = await pickDocument(context);
    if (file == null || !mounted) return;
    _lastScan = file;
    await context.read<RegistrationCubit>().scanFinancialDocument(file);
  }

  void _openForm({FinancialAccount? initial, UploadFile? proof, bool acceptUnreadable = false}) {
    final cubit = context.read<RegistrationCubit>();
    showFormSheet<void>(
      context,
      BlocProvider.value(
        value: cubit,
        child: _AccountForm(initial: initial, proof: proof, acceptUnreadable: acceptUnreadable),
      ),
    );
  }

  void _onScanFailed(BuildContext context, Failure failure) {
    final l10n = context.l10n;
    final file = _lastScan;

    // قرينا جزء: نعمّرو الاستمارة والمؤثر يكمّل، والصورة تترفع مع الحساب
    final fields = partialFields(failure);
    if (fields.isNotEmpty || failure.code == ScanErrors.accountIncomplete) {
      _scanAttempts = 0;
      showErrorSnackBar(context, l10n.finCompleteScanned);
      _openForm(
        proof: file,
        initial: FinancialAccount(
          institutionName: '${fields[ApiKeys.institutionName] ?? ''}',
          accountNumber: '${fields[ApiKeys.accountNumber] ?? ''}',
          accountKey: '${fields[ApiKeys.accountKey] ?? ''}',
        ),
      );
      return;
    }
    if (isOcrUnavailable(failure)) {
      showErrorSnackBar(context, l10n.ocrUnavailable);
      _openForm(proof: file);
      return;
    }
    if (isUnrecognized(failure)) {
      _scanAttempts++;
      const max = RegistrationCatalog.maxScanAttempts;
      if (_scanAttempts < max) {
        showErrorSnackBar(context, l10n.docUnrecognizedRetry(_scanAttempts, max));
        return;
      }
      // بعد 3 محاولات: يدخل المعلومات يدوياً والصورة تتقبل وتتراجع في الاجتماع
      _scanAttempts = 0;
      showErrorSnackBar(context, l10n.finScanManualAfterTries);
      _openForm(proof: file, acceptUnreadable: true);
      return;
    }
    showRegistrationFailure(context, failure);
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.scanFinancial)) {
      _scanAttempts = 0;
      final added = state.financialAccounts.lastOrNull;
      showSuccessSnackBar(context, context.l10n.finAdded(added?.institutionName ?? ''));
      return;
    }
    if (state.status != OperationStatus.failure || failure == null) return;
    if (state.action == RegistrationAction.scanFinancial) {
      _onScanFailed(context, failure);
      return;
    }
    // الوثيقة اللي ما تقراتش: الخانة تتكفّل بيها (المحاولات)
    if (state.action == RegistrationAction.uploadDocument && isUnrecognized(failure)) return;
    const actions = {
      RegistrationAction.deleteFinancial,
      RegistrationAction.uploadDocument,
      RegistrationAction.deleteDocument,
    };
    if (actions.contains(state.action)) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    final scanning = state.isLoadingFor(RegistrationAction.scanFinancial);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
        children: [
          SectionTitle(l10n.regFinancialTitle, subtitle: l10n.finScanHint),
          PrimaryButton(
            label: l10n.finScanCheque,
            icon: Icons.document_scanner_outlined,
            isLoading: scanning,
            onPressed: state.isLoading ? null : _scan,
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: state.isLoading ? null : () => _openForm(),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.finManualEntry),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.financialAccounts.isEmpty) EmptyHint(icon: Icons.account_balance_outlined, text: l10n.finEmpty),
          for (final account in state.financialAccounts)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _AccountCard(
                account: account,
                document: state.documentForAccount(account),
                busy: state.isLoadingFor(RegistrationAction.deleteFinancial, account.id) ||
                    state.isLoadingFor(RegistrationAction.uploadDocument, account.id) ||
                    state.isLoadingFor(RegistrationAction.deleteDocument, account.id),
                enabled: !state.isLoading,
                highlightMissing: _showErrors && state.documentForAccount(account) == null,
              ),
            ),
          if (_showErrors && state.financialAccounts.isEmpty) Text(l10n.finEmpty, style: errorStyle),
          if (_showErrors && state.accountsMissingDocument.isNotEmpty) Text(l10n.finMissingDoc, style: errorStyle),
        ],
      ),
    );
  }
}

IconData financialIcon(FinancialKind kind) => switch (kind) {
      FinancialKind.ccp => Icons.local_post_office_outlined,
      FinancialKind.bank => Icons.account_balance_outlined,
      FinancialKind.other => Icons.account_balance_wallet_outlined,
    };

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.document,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
  });

  final FinancialAccount account;
  final RegistrationDocument? document;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<RegistrationCubit>();
    final colors = context.colors;
    final number = account.accountKey.isEmpty ? account.accountNumber : '${account.accountNumber} / ${account.accountKey}';
    final institution = account.institutionName.isEmpty ? l10n.financialKindLabel(account.kind) : account.institutionName;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: highlightMissing ? AppColors.error : colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(financialIcon(account.kind), color: AppColors.gold),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(institution, style: context.textTheme.titleSmall),
                    Text(ltr(number), style: context.textTheme.bodySmall),
                    if (account.keyValid == false)
                      Text(l10n.finKeyMismatch, style: context.textTheme.bodySmall?.copyWith(color: AppColors.warning)),
                  ],
                ),
              ),
              if (busy)
                const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
              else
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: enabled ? () => cubit.deleteFinancialAccount(account.id) : null,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          DocumentTile(
            type: document?.type ?? DocumentType.financialProof,
            slot: account.id,
            document: document,
            busy: false,
            enabled: enabled && !busy,
            highlightMissing: highlightMissing,
            onUpload: (file, acceptUnreadable) => cubit.uploadDocument(
              DocumentType.financialProof,
              file,
              financialAccountId: account.id,
              acceptUnreadable: acceptUnreadable,
            ),
            onDelete: cubit.deleteDocument,
          ),
        ],
      ),
    );
  }
}

/// الإدخال اليدوي: أي مؤسسة (اقتراحات + كتابة حرة) وأي رقم حساب.
/// [proof]: صورة الصك/الشيك اللي صوّرها (تترفع مع الحساب بعد الحفظ).
class _AccountForm extends StatefulWidget {
  const _AccountForm({this.initial, this.proof, this.acceptUnreadable = false});

  final FinancialAccount? initial;
  final UploadFile? proof;
  final bool acceptUnreadable;

  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> with ServerFieldErrors {
  static const _fields = ['institutionName', 'accountNumber', 'accountKey'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _number;
  late final TextEditingController _key;
  String _institution = '';
  int _accountsBefore = 0;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _institution = initial?.institutionName ?? '';
    _number = TextEditingController(text: initial?.accountNumber ?? '');
    _key = TextEditingController(text: initial?.accountKey ?? '');
  }

  @override
  void dispose() {
    _number.dispose();
    _key.dispose();
    super.dispose();
  }

  static bool _isRib(String number) => RegExp(r'^\d{20}$').hasMatch(cleanAccountNumber(number));

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<RegistrationCubit>();
    _accountsBefore = cubit.state.financialAccounts.length;
    cubit.addFinancialAccount(FinancialAccount(
      institutionName: _institution,
      accountNumber: _number.text,
      accountKey: _key.text,
    ));
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      final proof = widget.proof;
      final added = state.financialAccounts.length > _accountsBefore ? state.financialAccounts.last : null;
      final cubit = context.read<RegistrationCubit>();
      Navigator.of(context).pop();
      if (proof != null && added != null) {
        cubit.uploadDocument(
              DocumentType.financialProof,
              proof,
              financialAccountId: added.id,
              acceptUnreadable: widget.acceptUnreadable,
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
                'invalid' => field == 'accountKey' ? l10n.finKeyInvalid : l10n.finNumberInvalid,
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
              Row(
                children: [
                  const Icon(Icons.attach_file_rounded, size: 18),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      l10n.finProofAttached(proof.name),
                      style: context.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            gap,
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _institution),
              optionsBuilder: (value) {
                final query = value.text.trim().toLowerCase();
                if (query.isEmpty) return RegistrationCatalog.financialInstitutions;
                return RegistrationCatalog.financialInstitutions.where((name) => name.toLowerCase().contains(query));
              },
              onSelected: (value) => setState(() => _institution = value),
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                forceErrorText: serverError('institutionName'),
                onChanged: (value) {
                  _institution = value;
                  clearServerError('institutionName');
                },
                decoration: InputDecoration(
                  labelText: l10n.finInstitutionName,
                  helperText: l10n.finInstitutionHint,
                  suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                ),
                // RIB: السيرفر يعرف البنك من الرمز
                validator: (v) => (v ?? '').trim().isEmpty && !_isRib(_number.text) ? l10n.fieldRequired : null,
              ),
            ),
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
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
                      if (number.isEmpty) return l10n.fieldRequired;
                      if (!RegExp(r'^[A-Z0-9]{4,40}$').hasMatch(number)) return l10n.finNumberInvalid;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextFormField(
                    controller: _key,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                    forceErrorText: serverError('accountKey'),
                    onChanged: (_) => clearServerError('accountKey'),
                    decoration: InputDecoration(labelText: l10n.finAccountKey),
                    validator: (v) {
                      final key = v?.trim() ?? '';
                      return key.isEmpty || key.length == 2 ? null : l10n.finKeyInvalid;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
