import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

class BasicInfoStep extends StatefulWidget {
  const BasicInfoStep({super.key});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> with ServerFieldErrors {
  static const _fields = ['firstName', 'lastName', 'displayName', 'birthDate', 'birthPlace', 'bio', 'skills', 'whatsapp'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _displayName;
  late final TextEditingController _birthPlace;
  late final TextEditingController _bio;
  late final TextEditingController _skills;
  late final TextEditingController _whatsapp;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    final seed = context.read<RegistrationCubit>().state.basicSeed;
    _firstName = TextEditingController(text: seed.firstName);
    _lastName = TextEditingController(text: seed.lastName);
    _displayName = TextEditingController(text: seed.displayName);
    _birthPlace = TextEditingController(text: seed.birthPlace);
    _bio = TextEditingController(text: seed.bio);
    _skills = TextEditingController(text: seed.skills);
    _whatsapp = TextEditingController(text: seed.whatsapp);
    _birthDate = seed.birthDate;
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _displayName, _birthPlace, _bio, _skills, _whatsapp]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 90),
      lastDate: DateTime(now.year - 13, now.month, now.day),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().saveBasic(BasicInfo(
          firstName: _firstName.text,
          lastName: _lastName.text,
          displayName: _displayName.text,
          birthDate: _birthDate,
          birthPlace: _birthPlace.text,
          bio: _bio.text,
          skills: _skills.text,
          whatsapp: _whatsapp.text,
        ));
  }

  TextFormField _field(
    TextEditingController controller,
    String field,
    String label, {
    String? hint,
    int maxLines = 1,
    bool required = true,
    TextInputType? keyboard,
    TextDirection? direction,
    FormFieldValidator<String>? validator,
  }) =>
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: 1,
        keyboardType: keyboard ?? (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
        textDirection: direction,
        textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: label, hintText: hint, alignLabelWithHint: maxLines > 1),
        validator: validator ?? (required ? (value) => requiredText(context, value) : null),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveBasic));
    final locale = Localizations.localeOf(context).toLanguageTag();
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.saveBasic && current.status == OperationStatus.failure,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onNext: _submit),
          children: [
            Row(
              children: [
                Expanded(child: _field(_firstName, 'firstName', l10n.firstName)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _field(_lastName, 'lastName', l10n.lastName)),
              ],
            ),
            gap,
            _field(_displayName, 'displayName', l10n.displayName, hint: l10n.displayNameHint),
            gap,
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: AppRadius.lgAll,
                    onTap: _pickBirthDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.dateOfBirth,
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                        errorText: serverError('birthDate'),
                      ),
                      child: Text(
                        switch (_birthDate) {
                          final date? => DateFormat.yMMMd(locale).format(date),
                          null => '—',
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _field(_birthPlace, 'birthPlace', l10n.birthPlace)),
              ],
            ),
            gap,
            _field(_bio, 'bio', l10n.bio, hint: l10n.bioHint, maxLines: 4),
            gap,
            _field(_skills, 'skills', l10n.skills, hint: l10n.skillsHint, maxLines: 2),
            gap,
            _field(
              _whatsapp,
              'whatsapp',
              l10n.whatsapp,
              keyboard: TextInputType.phone,
              direction: TextDirection.ltr,
              required: false,
              validator: (value) {
                final phone = value?.trim() ?? '';
                if (phone.isEmpty || Validators.isAlgerianMobile(phone) || phone.startsWith('+')) return null;
                return l10n.phoneInvalid;
              },
            ),
          ],
        ),
      ),
    );
  }
}
