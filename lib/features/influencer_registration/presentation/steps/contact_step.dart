import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

/// معلومات الإتصال: رقم الهاتف، رقم واتساب، البريد الالكتروني.
class ContactStep extends StatefulWidget {
  const ContactStep({super.key});

  @override
  State<ContactStep> createState() => _ContactStepState();
}

class _ContactStepState extends State<ContactStep> with ServerFieldErrors {
  static const _fields = ['phone', 'whatsapp', 'email', 'backupPhone', 'deliveryAddress'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone;
  late final TextEditingController _whatsapp;
  late final TextEditingController _email;
  late final TextEditingController _backupPhone;
  late final TextEditingController _deliveryAddress;

  @override
  void initState() {
    super.initState();
    final state = context.read<RegistrationCubit>().state;
    final contact = state.registration?.contact;
    String pick(String? saved, String? fallback) => (saved ?? '').isNotEmpty ? saved! : fallback ?? '';
    _phone = TextEditingController(text: pick(contact?.phone, state.account?.phone));
    _whatsapp = TextEditingController(text: pick(contact?.whatsapp, state.account?.phone));
    _email = TextEditingController(text: pick(contact?.email, state.account?.email));
    _backupPhone = TextEditingController(text: contact?.backupPhone);
    _deliveryAddress = TextEditingController(text: contact?.deliveryAddress);
  }

  @override
  void dispose() {
    for (final c in [_phone, _whatsapp, _email, _backupPhone, _deliveryAddress]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().saveSection(
          ContactInfo(
            phone: _phone.text,
            whatsapp: _whatsapp.text,
            email: _email.text,
            backupPhone: _backupPhone.text,
            deliveryAddress: _deliveryAddress.text,
          ),
        );
  }

  String? _phoneCheck(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return context.l10n.fieldRequired;
    if (Validators.isAlgerianMobile(phone) || phone.startsWith('+')) return null;
    return context.l10n.phoneInvalid;
  }

  TextFormField _field(
    TextEditingController controller,
    String field,
    String label,
    TextInputType keyboard,
    FormFieldValidator<String> validator,
  ) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        textDirection: TextDirection.ltr,
        textInputAction: TextInputAction.next,
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: label),
        validator: validator,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveSection));
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => current.didFail(RegistrationAction.saveSection) && previous != current,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          requiredNote: true,
          actions: StepActions(isLoading: isSaving, onBack: context.read<RegistrationCubit>().back, onNext: _submit),
          children: [
            SectionTitle(l10n.regContactTitle),
            _field(_phone, 'phone', req(l10n.phone), TextInputType.phone, _phoneCheck),
            gap,
            _field(_whatsapp, 'whatsapp', req(l10n.whatsapp), TextInputType.phone, _phoneCheck),
            gap,
            _field(
              _email,
              'email',
              req(l10n.email),
              TextInputType.emailAddress,
              (value) => Validators.isEmail(value ?? '') ? null : l10n.emailInvalid,
            ),
            SectionTitle(l10n.regOptionalContactTitle),
            _field(
              _backupPhone,
              'backupPhone',
              l10n.regBackupPhone,
              TextInputType.phone,
              (value) => (value ?? '').trim().isEmpty ? null : _phoneCheck(value),
            ),
            gap,
            TextFormField(
              controller: _deliveryAddress,
              minLines: 2,
              maxLines: 3,
              maxLength: 255,
              keyboardType: TextInputType.streetAddress,
              forceErrorText: serverError('deliveryAddress'),
              onChanged: (_) => clearServerError('deliveryAddress'),
              decoration: InputDecoration(
                labelText: l10n.regDeliveryAddress,
                hintText: l10n.regDeliveryAddressHint,
                hintMaxLines: 3,
                hintStyle: context.textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
