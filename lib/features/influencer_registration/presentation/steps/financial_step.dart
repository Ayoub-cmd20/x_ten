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
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

/// المؤسسات المالية التي تتعامل معها + أرقام حساباتك في كل واحدة.
/// حقلين برك: اسم المؤسسة ورقم الحساب. الوثيقة تتعرض في الاجتماع.
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
    if (state.didFail(RegistrationAction.deleteFinancial)) showRegistrationFailure(context, state.failure!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
        children: [
          SectionTitle(l10n.regFinancialTitle),
          if (state.financialAccounts.isEmpty) EmptyHint(icon: Icons.account_balance_outlined, text: l10n.finEmpty),
          for (final account in state.financialAccounts)
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
              onPressed: state.isLoading ? null : _openForm,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.regAddInstitution),
            ),
          ),
          if (_showErrors && state.financialAccounts.isEmpty)
            Text(l10n.finEmpty, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
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

  @override
  void dispose() {
    _institution.dispose();
    _number.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().addFinancialAccount(FinancialAccount(
          institutionName: _institution.text,
          accountNumber: _number.text,
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
            TextFormField(
              controller: _institution,
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
              decoration: InputDecoration(labelText: l10n.finAccountNumber),
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
