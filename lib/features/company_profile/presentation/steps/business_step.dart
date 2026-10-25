import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/business_documents.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/scan_banner.dart';
import 'package:x_ten/features/company_profile/presentation/wilayas.dart';

final _accountNameChars = RegExp(r"^[\p{L}\p{N} .'&\-_]+$", unicode: true);
final _identifierChars = FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9/ \-.]'));

class CompanyBusinessStep extends StatefulWidget {
  const CompanyBusinessStep({super.key});

  @override
  State<CompanyBusinessStep> createState() => _CompanyBusinessStepState();
}

class _CompanyBusinessStepState extends State<CompanyBusinessStep> with ServerFieldErrors {
  static const _fields = [
    'accountName',
    'companyName',
    'branch',
    'accountNameSource',
    'wilaya',
    'address',
    'registrationNumber',
    'ns',
    'nif',
    'capital',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _accountName;
  late final TextEditingController _companyName;
  late final TextEditingController _branch;
  late final TextEditingController _address;
  late final TextEditingController _registrationNumber;
  late final TextEditingController _ns;
  late final TextEditingController _nif;
  late final TextEditingController _capital;
  late AccountNameSource _source;
  String? _wilaya;

  @override
  void initState() {
    super.initState();
    final business = context.read<CompanyCubit>().state.profile?.business ?? const CompanyBusiness();
    _accountName = TextEditingController(text: business.accountName);
    _companyName = TextEditingController(text: business.companyName);
    _branch = TextEditingController(text: business.branch);
    _address = TextEditingController(text: business.address);
    _registrationNumber = TextEditingController(text: business.registrationNumber);
    _ns = TextEditingController(text: business.ns);
    _nif = TextEditingController(text: business.nif);
    _capital = TextEditingController(text: business.capital?.toString() ?? '');
    _source = business.accountNameSource;
    _wilaya = business.wilaya.isEmpty ? null : business.wilaya;
  }

  @override
  void dispose() {
    for (final c in [_accountName, _companyName, _branch, _address, _registrationNumber, _ns, _nif, _capital]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillFrom(CompanyDocument document) {
    final scanned = document.business;
    if (!scanned.hasFields) {
      return;
    }
    void put(TextEditingController controller, String value) {
      if (value.isNotEmpty) {
        controller.text = value;
      }
    }

    setState(() {
      put(_registrationNumber, scanned.registrationNumber);
      put(_companyName, scanned.companyName);
      put(_address, scanned.address);
      put(_ns, scanned.ns);
      put(_nif, scanned.nif);
      if (scanned.capital case final capital?) {
        _capital.text = '$capital';
      }
      if (wilayas.any((w) => w.code == scanned.wilaya)) {
        _wilaya = scanned.wilaya;
      }
    });
    clearServerErrors();
    showSuccessSnackBar(context, context.l10n.scanFilled);
  }

  void _listener(BuildContext context, CompanyState state) {
    if (state.didSucceed(CompanyAction.uploadDocument)) {
      final type = state.target;
      if (type is CompanyDocumentType && CompanyCatalog.businessDocuments.contains(type)) {
        if (state.documentOf(type) case final document?) {
          _fillFrom(document);
        }
      }
      return;
    }
    if (state.didFail(CompanyAction.deleteDocument) && state.failure != null) {
      showRegistrationFailure(context, state.failure!);
      return;
    }
    final failure = state.failure;
    if (!state.didFail(CompanyAction.saveSection) || failure == null) {
      return;
    }
    final l10n = context.l10n;
    final nameError = failure is ValidationFailure ? failure.fieldError('accountName') : null;
    if (failure is ValidationFailure && nameError != null) {
      final text = switch (nameError.toLowerCase()) {
        final e when e.contains('already') => l10n.companyAccountNameTaken,
        final e when e.contains('reserved') => l10n.companyAccountNameReserved,
        _ => l10n.companyAccountNameInvalid(CompanyCatalog.accountNameMin, CompanyCatalog.accountNameMax),
      };
      handleFailure(ValidationFailure(details: {...failure.details, 'accountName': text}), _fields);
      return;
    }
    handleFailure(failure, _fields);
  }

  String? _validateAccountName(String? value) {
    final l10n = context.l10n;
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return l10n.fieldRequired;
    }
    final ok = text.length >= CompanyCatalog.accountNameMin &&
        text.length <= CompanyCatalog.accountNameMax &&
        _accountNameChars.hasMatch(text);
    return ok ? null : l10n.companyAccountNameInvalid(CompanyCatalog.accountNameMin, CompanyCatalog.accountNameMax);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<CompanyCubit>().saveSection(CompanyBusiness(
          accountName: _accountName.text,
          companyName: _companyName.text,
          branch: _branch.text,
          accountNameSource: _source,
          wilaya: _wilaya ?? '',
          address: _address.text,
          registrationNumber: _registrationNumber.text,
          ns: _ns.text,
          nif: _nif.text,
          capital: int.tryParse(_capital.text),
        ));
  }

  TextFormField _field(
    TextEditingController controller,
    String field,
    String label, {
    bool required = true,
    String? helper,
    List<TextInputFormatter>? formatters,
    TextDirection? direction,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) =>
      TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        textDirection: direction,
        inputFormatters: formatters,
        forceErrorText: serverError(field),
        onChanged: (value) {
          clearServerError(field);
          onChanged?.call(value);
        },
        decoration: InputDecoration(labelText: required ? req(label) : label, helperText: helper, helperMaxLines: 3),
        validator: validator ?? (required ? (value) => requiredText(context, value) : null),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final state = context.watch<CompanyCubit>().state;
    final registered = state.isRegistered;
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: Form(
        key: _formKey,
        child: StepBody(
          requiredNote: true,
          actions: StepActions(
            isLoading: state.isLoadingFor(CompanyAction.saveSection),
            onBack: cubit.back,
            onNext: _submit,
          ),
          children: [
            const SizedBox(height: AppSpacing.md),
            if (registered) ...[
              ScanBanner(title: l10n.companyScanDocsTitle, text: l10n.companyScanDocsHint),
              gap,
              const CompanyLegalDocuments(),
              gap,
              _field(_companyName, 'companyName', l10n.companyInstitutionName),
              gap,
              _field(
                _branch,
                'branch',
                l10n.companyBranch,
                required: _source == AccountNameSource.branch,
                onChanged: (_) => setState(() {}),
              ),
              if (_branch.text.trim().isNotEmpty) ...[
                SectionTitle(l10n.companyAccountNameQuestion),
                SegmentedButton<AccountNameSource>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: AccountNameSource.company, label: Text(l10n.companyNameOption)),
                    ButtonSegment(value: AccountNameSource.branch, label: Text(l10n.companyBranchOption)),
                  ],
                  selected: {_source},
                  onSelectionChanged: (value) => setState(() => _source = value.first),
                ),
              ],
            ] else
              _field(
                _accountName,
                'accountName',
                l10n.companyAccountName,
                helper: l10n.companyAccountNameRules(CompanyCatalog.accountNameMin, CompanyCatalog.accountNameMax),
                validator: _validateAccountName,
              ),
            gap,
            DropdownButtonFormField<String>(
              key: ValueKey(_wilaya),
              initialValue: _wilaya,
              isExpanded: true,
              menuMaxHeight: 420,
              decoration: InputDecoration(
                labelText: req(registered ? l10n.companyHqWilaya : l10n.wilaya),
                errorText: serverError('wilaya'),
              ),
              items: [
                for (final wilaya in wilayas)
                  DropdownMenuItem(value: wilaya.code, child: Text(wilayaLabel(context, wilaya.code))),
              ],
              onChanged: (value) {
                clearServerError('wilaya');
                setState(() => _wilaya = value);
              },
              validator: (value) => value == null ? l10n.fieldRequired : null,
            ),
            gap,
            _field(_address, 'address', registered ? l10n.companyHqAddress : l10n.address),
            if (registered) ...[
              SectionTitle(l10n.legalInfo),
              _field(
                _registrationNumber,
                'registrationNumber',
                l10n.commercialRegister,
                formatters: [_identifierChars],
                direction: TextDirection.ltr,
              ),
              gap,
              _field(_ns, 'ns', l10n.nationalId, formatters: [_identifierChars], direction: TextDirection.ltr),
              gap,
              _field(_nif, 'nif', l10n.taxId, formatters: [_identifierChars], direction: TextDirection.ltr),
            ],
            gap,
            TextFormField(
              controller: _capital,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: [digitsOnly, LengthLimitingTextInputFormatter(15)],
              forceErrorText: serverError('capital'),
              onChanged: (_) => clearServerError('capital'),
              decoration: InputDecoration(labelText: l10n.companyCapital, suffixText: l10n.companyCurrency),
            ),
            if (registered) ...[
              SectionTitle(l10n.companyLicensesTitle, subtitle: l10n.companyLicensesHint),
              const CompanyLicenses(),
            ],
          ],
        ),
      ),
    );
  }
}
