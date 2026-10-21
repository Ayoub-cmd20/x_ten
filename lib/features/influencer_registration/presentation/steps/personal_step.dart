import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/document_tiles.dart';

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
  late IdentityKind _identity;

  @override
  void initState() {
    super.initState();
    final seed = context.read<RegistrationCubit>().state.personalSeed;
    _firstName = TextEditingController(text: seed.firstName);
    _lastName = TextEditingController(text: seed.lastName);
    _birthPlace = TextEditingController(text: seed.birthPlace);
    _birthDate = seed.birthDate;
    _entityType = seed.entityType;
    _identity = initialIdentityKind(context.read<RegistrationCubit>().state);
  }

  /// الوثيقة تقرات: نعمّرو الاسم واللقب وتاريخ ومكان الميلاد (المؤثر يراجع)
  void _fillFrom(RegistrationDocument document) {
    final scanned = document.scanned;
    if (!scanned.hasIdentity) return;
    setState(() {
      if (scanned.firstName.isNotEmpty) _firstName.text = scanned.firstName;
      if (scanned.lastName.isNotEmpty) _lastName.text = scanned.lastName;
      if (scanned.birthPlace.isNotEmpty) _birthPlace.text = scanned.birthPlace;
      _birthDate = scanned.birthDate ?? _birthDate;
    });
    clearServerErrors();
    showSuccessSnackBar(context, context.l10n.scanFilled);
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.uploadDocument)) {
      final type = state.target;
      if (type is DocumentType && RegistrationCatalog.identityDocuments.contains(type)) {
        if (state.documentOf(type) case final document?) _fillFrom(document);
      }
      return;
    }
    if (state.status != OperationStatus.failure || failure == null) return;
    if (state.action == RegistrationAction.saveSection) {
      handleFailure(failure, _fields);
    } else if (state.action == RegistrationAction.uploadDocument && !isUnrecognized(failure)) {
      showRegistrationFailure(context, failure);
    } else if (state.action == RegistrationAction.deleteDocument) {
      showRegistrationFailure(context, failure);
    }
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
    final first = DateTime(now.year - 90);
    final last = DateTime(now.year - 13, now.month, now.day);
    // التاريخ المقروء من الوثيقة قد يكون خارج المجال
    var initial = _birthDate ?? DateTime(now.year - 20);
    if (initial.isAfter(last)) initial = last;
    if (initial.isBefore(first)) initial = first;
    final picked = await showDatePicker(context: context, initialDate: initial, firstDate: first, lastDate: last);
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    final hasIdentity = context.read<RegistrationCubit>().state.hasIdentity;
    if (!valid || !hasIdentity || _birthDate == null || _entityType == null) {
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
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onNext: _submit),
          children: [
            _ScanBanner(title: l10n.scanFromIdTitle, text: l10n.scanFromIdHint),
            const SizedBox(height: AppSpacing.md),
            IdentityDocuments(
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

class _ScanBanner extends StatelessWidget {
  const _ScanBanner({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.document_scanner_outlined, color: AppColors.gold),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(text, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      );
}
