import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/documents_step.dart';

/// المؤسسات المالية التي تتعامل معها + أرقام حساباتك في كل واحدة (عدة مؤسسات).
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

  void _listener(BuildContext context, RegistrationState state) {
    const actions = {
      RegistrationAction.deleteFinancial,
      RegistrationAction.uploadDocument,
      RegistrationAction.deleteDocument,
    };
    if (state.status == OperationStatus.failure && actions.contains(state.action)) {
      showRegistrationFailure(context, state.failure!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
        children: [
          SectionTitle(l10n.regFinancialTitle, subtitle: l10n.documentsSubtitle),
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
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () => showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _AccountForm())),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.regAddInstitution),
            ),
          ),
          if (_showErrors && state.financialAccounts.isEmpty) Text(l10n.finEmpty, style: errorStyle),
          if (_showErrors && state.accountsMissingDocument.isNotEmpty) Text(l10n.finMissingDoc, style: errorStyle),
        ],
      ),
    );
  }
}

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
    final number = account.kind == FinancialKind.ccp
        ? '${account.accountNumber} / ${account.accountKey}'
        : account.accountNumber;

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
              Icon(
                account.kind == FinancialKind.ccp ? Icons.local_post_office_outlined : Icons.account_balance_outlined,
                color: AppColors.gold,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.institutionName, style: context.textTheme.titleSmall),
                    Text(ltr(number), style: context.textTheme.bodySmall),
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
            type: account.documentType,
            document: document,
            busy: false,
            enabled: enabled && !busy,
            highlightMissing: highlightMissing,
            onUpload: (file, check) =>
                cubit.uploadDocument(account.documentType, file, financialAccountId: account.id, check: check),
            onDelete: cubit.deleteDocument,
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
  static const _fields = ['kind', 'institutionName', 'accountNumber', 'accountKey'];

  final _formKey = GlobalKey<FormState>();
  final _institution = TextEditingController();
  final _number = TextEditingController();
  final _key = TextEditingController();
  FinancialKind _kind = FinancialKind.ccp;

  @override
  void dispose() {
    _institution.dispose();
    _number.dispose();
    _key.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().addFinancialAccount(FinancialAccount(
          kind: _kind,
          institutionName: _institution.text,
          accountNumber: _number.text,
          accountKey: _key.text,
        ));
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      Navigator.of(context).pop();
    } else if (state.status == OperationStatus.failure) {
      final failure = state.failure!;
      if (failure is ValidationFailure) {
        final l10n = context.l10n;
        final translated = ValidationFailure(details: {
          for (final field in _fields)
            if (failure.fieldError(field) case final error?)
              field: switch (error) {
                'ccp' => l10n.finCcpNumberInvalid,
                'ccpKey' => l10n.ccpKeyInvalid,
                'rib' => l10n.ribInvalid,
                'required' => l10n.fieldRequired,
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
    final isCcp = _kind == FinancialKind.ccp;
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
            gap,
            SegmentedButton<FinancialKind>(
              showSelectedIcon: false,
              segments: [
                for (final kind in FinancialKind.values)
                  ButtonSegment(value: kind, label: Text(l10n.financialKindLabel(kind))),
              ],
              selected: {_kind},
              onSelectionChanged: (value) => setState(() {
                _kind = value.first;
                clearServerErrors();
              }),
            ),
            if (!isCcp) ...[
              gap,
              TextFormField(
                controller: _institution,
                forceErrorText: serverError('institutionName'),
                onChanged: (_) => clearServerError('institutionName'),
                decoration: InputDecoration(labelText: l10n.finInstitution),
                validator: (v) => requiredText(context, v),
              ),
            ],
            gap,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: ValueKey(_kind),
                    controller: _number,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(isCcp ? 12 : 20),
                    ],
                    forceErrorText: serverError('accountNumber'),
                    onChanged: (_) => clearServerError('accountNumber'),
                    decoration: InputDecoration(labelText: isCcp ? l10n.finCcpNumber : l10n.finRib),
                    validator: (v) {
                      final digits = v?.trim() ?? '';
                      if (digits.isEmpty) return l10n.fieldRequired;
                      if (!isCcp && digits.length != 20) return l10n.ribInvalid;
                      return null;
                    },
                  ),
                ),
                if (isCcp) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      controller: _key,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                      forceErrorText: serverError('accountKey'),
                      onChanged: (_) => clearServerError('accountKey'),
                      decoration: InputDecoration(labelText: l10n.ccpKey),
                      validator: (v) => (v?.trim().length ?? 0) == 2 ? null : l10n.ccpKeyInvalid,
                    ),
                  ),
                ],
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
