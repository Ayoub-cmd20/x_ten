import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

class FinancialStep extends StatefulWidget {
  const FinancialStep({super.key});

  @override
  State<FinancialStep> createState() => _FinancialStepState();
}

class _FinancialStepState extends State<FinancialStep> with ServerFieldErrors {
  static const _fields = ['ccpAccount', 'ccpKey', 'bankName', 'bankAccount', 'rib', 'accountType'];

  final _formKey = GlobalKey<FormState>();
  late FinancialAccountType _type;
  late final TextEditingController _ccpAccount;
  late final TextEditingController _ccpKey;
  late final TextEditingController _bankName;
  late final TextEditingController _bankAccount;
  late final TextEditingController _rib;
  bool _showMissing = false;

  @override
  void initState() {
    super.initState();
    final financial = context.read<RegistrationCubit>().state.registration?.financial;
    _type = financial?.accountType ?? FinancialAccountType.ccp;
    _ccpAccount = TextEditingController(text: financial?.ccpAccount);
    _ccpKey = TextEditingController(text: financial?.ccpKey);
    _bankName = TextEditingController(text: financial?.bankName);
    _bankAccount = TextEditingController(text: financial?.bankAccount);
    _rib = TextEditingController(text: financial?.rib);
  }

  @override
  void dispose() {
    for (final c in [_ccpAccount, _ccpKey, _bankName, _bankAccount, _rib]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _usesCcp => _type != FinancialAccountType.bank;

  bool get _usesBank => _type != FinancialAccountType.ccp;

  void _submit() {
    FocusScope.of(context).unfocus();
    final cubit = context.read<RegistrationCubit>();
    final valid = _formKey.currentState?.validate() ?? false;
    final missing = cubit.state.missingDocuments(_type);
    if (!valid || missing.isNotEmpty) {
      setState(() => _showMissing = missing.isNotEmpty);
      return;
    }
    cubit.saveFinancial(FinancialInfo(
      accountType: _type,
      ccpAccount: _ccpAccount.text,
      ccpKey: _ccpKey.text,
      bankName: _bankName.text,
      bankAccount: _bankAccount.text,
      rib: _rib.text,
    ));
  }

  Future<void> _upload(DocumentType type) async {
    final cubit = context.read<RegistrationCubit>();
    final file = await pickDocumentFile();
    if (file != null) await cubit.uploadDocument(type, file);
  }

  Widget _numberField(
    TextEditingController controller,
    String field,
    String label, {
    required int maxLength,
    required String? Function(String digits) check,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        inputFormatters: [digitsOnly, LengthLimitingTextInputFormatter(maxLength)],
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          final digits = value?.trim() ?? '';
          if (digits.isEmpty) return context.l10n.fieldRequired;
          return check(digits);
        },
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final missing = state.missingDocuments(_type);
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.saveFinancial && current.status == OperationStatus.failure,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(
            isLoading: state.isLoadingFor(RegistrationAction.saveFinancial),
            onBack: cubit.back,
            onNext: _submit,
          ),
          children: [
            SectionTitle(l10n.payoutMethod),
            SegmentedButton<FinancialAccountType>(
              segments: [
                for (final type in FinancialAccountType.values)
                  ButtonSegment(value: type, label: Text(l10n.accountTypeLabel(type))),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() => _type = value.first),
            ),
            if (_usesCcp) ...[
              gap,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _numberField(
                      _ccpAccount,
                      'ccpAccount',
                      l10n.ccpAccount,
                      maxLength: 12,
                      check: (_) => null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _numberField(
                      _ccpKey,
                      'ccpKey',
                      l10n.ccpKey,
                      maxLength: 2,
                      check: (digits) => digits.length == 2 ? null : l10n.ccpKeyInvalid,
                    ),
                  ),
                ],
              ),
            ],
            if (_usesBank) ...[
              gap,
              TextFormField(
                controller: _bankName,
                forceErrorText: serverError('bankName'),
                onChanged: (_) => clearServerError('bankName'),
                decoration: InputDecoration(labelText: l10n.bankName),
                validator: (v) => requiredText(context, v),
              ),
              gap,
              TextFormField(
                controller: _bankAccount,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                forceErrorText: serverError('bankAccount'),
                onChanged: (_) => clearServerError('bankAccount'),
                decoration: InputDecoration(labelText: l10n.bankAccount),
                validator: (v) => requiredText(context, v),
              ),
              gap,
              _numberField(
                _rib,
                'rib',
                l10n.bankRib,
                maxLength: 20,
                check: (digits) => digits.length == 20 ? null : l10n.ribInvalid,
              ),
            ],
            SectionTitle(l10n.documentsTitle, subtitle: l10n.documentsSubtitle),
            for (final type in RegistrationCatalog.requiredDocuments(_type))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _DocumentTile(
                  type: type,
                  document: state.documentOf(type),
                  busy: state.isLoadingFor(RegistrationAction.uploadDocument, type) ||
                      state.isLoadingFor(RegistrationAction.deleteDocument, type),
                  enabled: !state.isLoading,
                  highlightMissing: _showMissing,
                  onUpload: () => _upload(type),
                  onDelete: cubit.deleteDocument,
                ),
              ),
            if (_showMissing && missing.isNotEmpty)
              Text(
                l10n.missingDocumentsWarning(l10n.documentList(missing)),
                style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
              ),
          ],
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.type,
    required this.document,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
    required this.onUpload,
    required this.onDelete,
  });

  final DocumentType type;
  final RegistrationDocument? document;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;
  final VoidCallback onUpload;
  final ValueChanged<RegistrationDocument> onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final document = this.document;
    final uploaded = document != null;

    return ItemCard(
      icon: uploaded ? Icons.task_alt_rounded : Icons.upload_file_rounded,
      highlight: uploaded ? AppColors.success : (highlightMissing ? AppColors.error : null),
      title: l10n.documentLabel(type),
      subtitle: switch (document) {
        RegistrationDocument(verified: true) => l10n.documentVerified,
        final RegistrationDocument d => d.fileName.isEmpty ? l10n.documentUploaded : d.fileName,
        null => l10n.documentsSubtitle,
      },
      onTap: enabled && !busy ? onUpload : null,
      trailing: busy
          ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
          : document != null
              ? IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: enabled ? () => onDelete(document) : null,
                )
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                  child: Text(l10n.upload, style: context.textTheme.labelMedium?.copyWith(color: context.colors.primary)),
                ),
    );
  }
}
