import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/company_documents.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/scan_banner.dart';

class CompanyPersonalStep extends StatefulWidget {
  const CompanyPersonalStep({super.key});

  @override
  State<CompanyPersonalStep> createState() => _CompanyPersonalStepState();
}

class _CompanyPersonalStepState extends State<CompanyPersonalStep> with ServerFieldErrors {
  static const _fields = ['firstName', 'lastName', 'idNumber', 'birthDate', 'role', 'roleOther'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _roleOther;
  late final TextEditingController _idNumber;
  DateTime? _birthDate;
  String? _role;
  bool _showErrors = false;
  late IdentityKind _identity;

  @override
  void initState() {
    super.initState();
    final state = context.read<CompanyCubit>().state;
    final personal = state.profile?.personal ?? const CompanyPersonal();
    _firstName = TextEditingController(text: personal.firstName);
    _lastName = TextEditingController(text: personal.lastName);
    _idNumber = TextEditingController(text: personal.idNumber);
    _roleOther = TextEditingController(text: personal.roleOther);
    _birthDate = personal.birthDate;
    _role = personal.role.isEmpty ? null : personal.role;
    _identity = CompanyIdentityDocuments.initialKind(state);
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _roleOther, _idNumber]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillFrom(CompanyDocument document) {
    final scanned = document.scanned;
    if (!scanned.hasIdentity) {
      return;
    }
    setState(() {
      if (scanned.firstName.isNotEmpty) {
        _firstName.text = scanned.firstName;
      }
      if (scanned.lastName.isNotEmpty) {
        _lastName.text = scanned.lastName;
      }
      if (scanned.idNumber.isNotEmpty) {
        _idNumber.text = scanned.idNumber;
      }
      _birthDate = scanned.birthDate ?? _birthDate;
    });
    clearServerErrors();
    showSuccessSnackBar(context, context.l10n.scanFilled);
  }

  void _listener(BuildContext context, CompanyState state) {
    if (state.didSucceed(CompanyAction.uploadDocument)) {
      final type = state.target;
      if (type is CompanyDocumentType && CompanyCatalog.identityDocuments.contains(type)) {
        if (state.documentOf(type) case final document?) {
          _fillFrom(document);
        }
      }
      return;
    }
    final failure = state.failure;
    if (failure == null || state.status != CompanyStatus.failure) {
      return;
    }
    if (state.action == CompanyAction.saveSection) {
      handleFailure(failure, _fields);
    } else if (state.action == CompanyAction.deleteDocument) {
      showRegistrationFailure(context, failure);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 90);
    final last = DateTime(now.year - 18, now.month, now.day);
    var initial = _birthDate ?? DateTime(now.year - 30);
    if (initial.isAfter(last)) {
      initial = last;
    }
    if (initial.isBefore(first)) {
      initial = first;
    }
    final picked = await showDatePicker(context: context, initialDate: initial, firstDate: first, lastDate: last);
    if (!mounted || picked == null) {
      return;
    }
    setState(() => _birthDate = picked);
  }

  void _submit(bool registered) {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    final cubit = context.read<CompanyCubit>();
    if (!valid || !cubit.state.hasIdentity || _role == null || (registered && _birthDate == null)) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.saveSection(CompanyPersonal(
      firstName: _firstName.text,
      lastName: _lastName.text,
      idNumber: _idNumber.text,
      birthDate: registered ? _birthDate : null,
      role: _role ?? '',
      roleOther: _roleOther.text,
    ));
  }

  TextFormField _field(TextEditingController controller, String field, String label) => TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: label),
        validator: (value) => requiredText(context, value),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final type = state.businessType ?? BusinessType.individualActivity;
    final registered = type == BusinessType.registeredBusiness;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(
            isLoading: state.isLoadingFor(CompanyAction.saveSection),
            onBack: context.read<CompanyCubit>().back,
            onNext: () => _submit(registered),
          ),
          children: [
            ScanBanner(title: l10n.scanFromIdTitle, text: l10n.scanFromIdHint),
            gap,
            CompanyIdentityDocuments(
              kind: _identity,
              showErrors: _showErrors,
              onKindChanged: (kind) => setState(() => _identity = kind),
            ),
            SectionTitle(l10n.regFullName),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _field(_firstName, 'firstName', l10n.firstName)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _field(_lastName, 'lastName', l10n.lastName)),
              ],
            ),
            gap,
            TextFormField(
              controller: _idNumber,
              keyboardType: TextInputType.visiblePassword,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')), LengthLimitingTextInputFormatter(30)],
              forceErrorText: serverError('idNumber'),
              onChanged: (_) => clearServerError('idNumber'),
              decoration: InputDecoration(labelText: l10n.regIdNumber),
              validator: (value) => requiredText(context, value),
            ),
            if (registered) ...[
              gap,
              InkWell(
                borderRadius: AppRadius.lgAll,
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.dateOfBirth,
                    suffixIcon: const Icon(Icons.calendar_month_outlined),
                    errorText:
                        serverError('birthDate') ?? (_showErrors && _birthDate == null ? l10n.fieldRequired : null),
                  ),
                  child: Text(switch (_birthDate) {
                    final date? => DateFormat.yMMMd(locale).format(date),
                    null => '—',
                  }),
                ),
              ),
            ],
            SectionTitle(l10n.companyRoleTitle),
            RadioGroup<String>(
              groupValue: _role,
              onChanged: (value) => setState(() => _role = value),
              child: Column(
                children: [
                  for (final role in CompanyCatalog.roles(type))
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: role,
                      title: Text(l10n.companyRole(role), style: context.textTheme.bodyMedium),
                    ),
                ],
              ),
            ),
            if (_role == CompanyCatalog.otherRole)
              TextFormField(
                controller: _roleOther,
                forceErrorText: serverError('roleOther'),
                onChanged: (_) => clearServerError('roleOther'),
                decoration: InputDecoration(labelText: l10n.companyRoleOtherHint),
                validator: (value) => requiredText(context, value),
              ),
            if ((_showErrors && _role == null) || serverError('role') != null)
              Text(l10n.fieldRequired, style: errorStyle),
          ],
        ),
      ),
    );
  }
}
