import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';

class CompanyContactStep extends StatefulWidget {
  const CompanyContactStep({super.key});

  @override
  State<CompanyContactStep> createState() => _CompanyContactStepState();
}

class _CompanyContactStepState extends State<CompanyContactStep> with ServerFieldErrors {
  static const _fields = ['phone', 'whatsapp', 'phone2', 'email'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone;
  late final TextEditingController _whatsapp;
  late final TextEditingController _phone2;
  late final String _email;

  @override
  void initState() {
    super.initState();
    final contact = context.read<CompanyCubit>().state.profile?.contact ?? const CompanyContact();
    _phone = TextEditingController(text: contact.phone);
    _whatsapp = TextEditingController(text: contact.whatsapp);
    _phone2 = TextEditingController(text: contact.phone2);
    _email = contact.email;
  }

  @override
  void dispose() {
    for (final c in [_phone, _whatsapp, _phone2]) {
      c.dispose();
    }
    super.dispose();
  }

  void _listener(BuildContext context, CompanyState state) {
    final failure = state.failure;
    if (state.didFail(CompanyAction.saveSection) && failure != null) {
      handleFailure(failure, _fields);
    }
  }

  String? _validatePhone(String? value, {required bool required}) {
    final l10n = context.l10n;
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return required ? l10n.phoneRequired : null;
    }
    return Validators.isAlgerianMobile(text) ? null : l10n.phoneInvalid;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<CompanyCubit>().saveSection(CompanyContact(
          phone: _phone.text,
          whatsapp: _whatsapp.text,
          phone2: _phone2.text,
          email: _email,
        ));
  }

  Widget _phoneField(TextEditingController controller, String field, String label, {bool required = false, String? helper}) =>
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]')), LengthLimitingTextInputFormatter(16)],
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: required ? req(label) : label, helperText: helper),
        validator: (value) => _validatePhone(value, required: required),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final state = context.watch<CompanyCubit>().state;
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
            gap,
            _phoneField(
              _phone,
              'phone',
              l10n.officialPhone,
              required: true,
              helper: state.isRegistered ? l10n.companyPhoneHint : null,
            ),
            gap,
            _phoneField(_whatsapp, 'whatsapp', l10n.companyWhatsappOptional),
            if (state.isRegistered) ...[
              gap,
              _phoneField(_phone2, 'phone2', l10n.companyPhone2, helper: l10n.companyPhoneHint),
            ],
            gap,
            TextFormField(
              initialValue: _email,
              readOnly: true,
              enabled: false,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: req(l10n.officialEmail),
                helperText: l10n.companyEmailHint,
                errorText: serverError('email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
