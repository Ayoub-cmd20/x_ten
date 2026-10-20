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

/// الإمتثال للتشريعات + الموافقة على الشروط، ثم معلومات الأمان وطريقة إسترداد الحساب.
class SecurityStep extends StatefulWidget {
  const SecurityStep({super.key});

  @override
  State<SecurityStep> createState() => _SecurityStepState();
}

class _SecurityStepState extends State<SecurityStep> with ServerFieldErrors {
  static const _fields = ['acceptedPrivacy', 'acceptedTerms', 'recoveryMethod', 'recoveryPhone'];

  late bool _privacy;
  late bool _terms;
  RecoveryMethod? _method;
  late final TextEditingController _otherPhone;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final security = context.read<RegistrationCubit>().state.registration?.security ?? const SecurityInfo();
    _privacy = security.acceptedPrivacy;
    _terms = security.acceptedTerms;
    _method = security.recoveryMethod;
    _otherPhone = TextEditingController(text: security.recoveryPhone);
  }

  @override
  void dispose() {
    _otherPhone.dispose();
    super.dispose();
  }

  bool get _otherPhoneValid => Validators.isAlgerianMobile(_otherPhone.text);

  void _submit() {
    FocusScope.of(context).unfocus();
    final otherInvalid = _method == RecoveryMethod.otherPhone && !_otherPhoneValid;
    if (!_privacy || !_terms || _method == null || otherInvalid) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveSection(SecurityInfo(
          acceptedPrivacy: _privacy,
          acceptedTerms: _terms,
          recoveryMethod: _method,
          recoveryPhone: _otherPhone.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final contact = state.registration?.contact;
    final isSaving = state.isLoadingFor(RegistrationAction.saveSection);
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    final email = contact?.email ?? state.account?.email ?? '';

    String methodLabel(RecoveryMethod method) => switch (method) {
          RecoveryMethod.phone => l10n.recPhone(ltr(contact?.phone ?? '')),
          RecoveryMethod.whatsapp => l10n.recWhatsapp(ltr(contact?.whatsapp ?? '')),
          RecoveryMethod.email => l10n.recEmail(ltr(email)),
          RecoveryMethod.otherPhone => l10n.recOther,
        };

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => current.didFail(RegistrationAction.saveSection) && previous != current,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: StepBody(
        actions: StepActions(isLoading: isSaving, onBack: context.read<RegistrationCubit>().back, onNext: _submit),
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _privacy,
            title: Text(l10n.regConsentPrivacy, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(() => _privacy = value ?? false),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _terms,
            title: Text(l10n.regConsentTerms, style: context.textTheme.bodyMedium),
            onChanged: (value) => setState(() => _terms = value ?? false),
          ),
          if (_showErrors && (!_privacy || !_terms)) Text(l10n.acceptAllConsents, style: errorStyle),
          SectionTitle(l10n.regSecurityTitle),
          ItemCard(
            icon: Icons.lock_outline_rounded,
            title: l10n.regLoginWith,
            subtitle: l10n.regLoginInfo(ltr(email)),
          ),
          SectionTitle(l10n.regRecoveryTitle, subtitle: l10n.regRecoveryHint),
          RadioGroup<RecoveryMethod>(
            groupValue: _method,
            onChanged: (value) => setState(() => _method = value),
            child: Column(
              children: [
                for (final method in RecoveryMethod.values)
                  RadioListTile<RecoveryMethod>(
                    contentPadding: EdgeInsets.zero,
                    value: method,
                    title: Text(methodLabel(method), style: context.textTheme.bodyMedium),
                  ),
              ],
            ),
          ),
          if (_method == RecoveryMethod.otherPhone)
            TextField(
              controller: _otherPhone,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              onChanged: (_) {
                clearServerError('recoveryPhone');
                if (_showErrors) setState(() {});
              },
              decoration: InputDecoration(
                labelText: l10n.recOtherPhone,
                errorText: serverError('recoveryPhone') ??
                    (_showErrors && !_otherPhoneValid ? l10n.phoneInvalid : null),
              ),
            ),
          if (_showErrors && _method == null) Text(l10n.fieldRequired, style: errorStyle),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
