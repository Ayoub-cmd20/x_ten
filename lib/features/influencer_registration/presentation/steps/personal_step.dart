import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

/// المعلومات الشخصية للمسجل.
class PersonalStep extends StatefulWidget {
  const PersonalStep({super.key});

  @override
  State<PersonalStep> createState() => _PersonalStepState();
}

class _PersonalStepState extends State<PersonalStep> with ServerFieldErrors {
  static const _fields = ['firstName', 'lastName', 'birthDate', 'birthPlace', 'entityType'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _birthPlace;
  DateTime? _birthDate;
  EntityType? _entityType;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final seed = context.read<RegistrationCubit>().state.personalSeed;
    _firstName = TextEditingController(text: seed.firstName);
    _lastName = TextEditingController(text: seed.lastName);
    _birthPlace = TextEditingController(text: seed.birthPlace);
    _birthDate = seed.birthDate;
    _entityType = seed.entityType;
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _birthPlace]) {
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
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || _birthDate == null || _entityType == null) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveSection(PersonalInfo(
          firstName: _firstName.text,
          lastName: _lastName.text,
          birthDate: _birthDate,
          birthPlace: _birthPlace.text,
          entityType: _entityType,
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
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveSection));
    final locale = Localizations.localeOf(context).toLanguageTag();
    const gap = SizedBox(height: AppSpacing.md);
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => current.didFail(RegistrationAction.saveSection) && previous != current,
      listener: (context, state) => handleFailure(state.failure!, _fields),
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onNext: _submit),
          children: [
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
            InkWell(
              borderRadius: AppRadius.lgAll,
              onTap: _pickBirthDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateOfBirth,
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                  errorText: serverError('birthDate') ?? (_showErrors && _birthDate == null ? l10n.fieldRequired : null),
                ),
                child: Text(
                  switch (_birthDate) {
                    final date? => DateFormat.yMMMd(locale).format(date),
                    null => '—',
                  },
                ),
              ),
            ),
            gap,
            _field(_birthPlace, 'birthPlace', l10n.birthPlace),
            SectionTitle(l10n.regEntityQuestion),
            RadioGroup<EntityType>(
              groupValue: _entityType,
              onChanged: (value) => setState(() => _entityType = value),
              child: Column(
                children: [
                  for (final type in EntityType.values)
                    RadioListTile<EntityType>(
                      contentPadding: EdgeInsets.zero,
                      value: type,
                      title: Text(l10n.entityTypeLabel(type), style: context.textTheme.bodyMedium),
                    ),
                ],
              ),
            ),
            if (_showErrors && _entityType == null) Text(l10n.fieldRequired, style: errorStyle),
          ],
        ),
      ),
    );
  }
}
