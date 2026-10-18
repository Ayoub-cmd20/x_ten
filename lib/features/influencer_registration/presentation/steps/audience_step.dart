import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

class AudienceStep extends StatefulWidget {
  const AudienceStep({super.key});

  @override
  State<AudienceStep> createState() => _AudienceStepState();
}

class _LocationRow {
  _LocationRow(this.wilaya, double percent) : percent = TextEditingController(text: percentText(percent));

  String? wilaya;
  final TextEditingController percent;
}

class _AudienceStepState extends State<AudienceStep> {
  static const _maxPrimary = 3;
  static const _maxSecondary = 5;

  late List<String> _primary;
  late List<String> _secondary;
  late List<String> _contentTypes;
  late List<String> _interests;
  late final Map<String, TextEditingController> _ages;
  late double _male;
  late final List<_LocationRow> _locations;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final registration = context.read<RegistrationCubit>().state.registration;
    final audience = registration?.audience;
    _primary = [...?registration?.primaryCategories];
    _secondary = [...?registration?.secondaryCategories];
    _contentTypes = [...?registration?.contentTypes];
    _interests = [...?audience?.interests];
    _ages = {
      for (final group in RegistrationCatalog.ageGroups)
        group: TextEditingController(text: percentText(audience?.ageDistribution[group] ?? 0)),
    };
    _male = audience?.malePercentage ?? 50;
    _locations = [
      for (final entry in (audience?.locations ?? const <String, double>{}).entries)
        _LocationRow(_wilayaFromKey(entry.key), entry.value),
    ];
  }

  @override
  void dispose() {
    for (final c in _ages.values) {
      c.dispose();
    }
    for (final row in _locations) {
      row.percent.dispose();
    }
    super.dispose();
  }

  static String _keyOf(String wilaya) => wilaya.toLowerCase();

  static String? _wilayaFromKey(String key) =>
      RegistrationCatalog.wilayas.where((w) => _keyOf(w) == key.toLowerCase()).firstOrNull;

  double get _ageTotal => _ages.values.fold(0, (sum, c) => sum + percentOf(c));

  bool get _valid =>
      _primary.isNotEmpty && _contentTypes.isNotEmpty && (_ageTotal - 100).abs() <= 0.01;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_valid) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveProfile(ProfileInfo(
          primaryCategories: _primary,
          secondaryCategories: _secondary,
          contentTypes: _contentTypes,
          audience: Audience(
            ageDistribution: {for (final entry in _ages.entries) entry.key: percentOf(entry.value)},
            malePercentage: _male,
            femalePercentage: 100 - _male,
            locations: {
              for (final row in _locations)
                if (row.wilaya case final wilaya? when percentOf(row.percent) > 0) _keyOf(wilaya): percentOf(row.percent),
            },
            interests: _interests,
          ),
        ));
  }

  void _onFailure(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (failure is ValidationFailure && failure.details.isNotEmpty && failure.details['audience'] == null) {
      final field = failure.details.keys.first;
      final message = failure.fieldError(field) ?? context.l10n.errorValidation;
      showRegistrationFailure(context, ValidationFailure(message: message));
      return;
    }
    if (failure != null) showRegistrationFailure(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveProfile));
    final usedWilayas = {for (final row in _locations) ?row.wilaya};

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.saveProfile && current.status == OperationStatus.failure,
      listener: _onFailure,
      child: StepBody(
        actions: StepActions(
          isLoading: isSaving,
          onBack: () => context.read<RegistrationCubit>().back(),
          onNext: _submit,
        ),
        children: [
          SectionTitle(l10n.primaryCategories, subtitle: l10n.chooseUpTo(_maxPrimary)),
          ChoiceWrap(
            options: RegistrationCatalog.categories,
            selected: _primary,
            max: _maxPrimary,
            labelOf: l10n.category,
            errorText: _showErrors && _primary.isEmpty ? l10n.selectAtLeastOne : null,
            onChanged: (value) => setState(() {
              _primary = value;
              _secondary = [for (final s in _secondary) if (!value.contains(s)) s];
            }),
          ),
          SectionTitle(l10n.secondaryCategories, subtitle: l10n.optionalChooseUpTo(_maxSecondary)),
          ChoiceWrap(
            options: [for (final c in RegistrationCatalog.categories) if (!_primary.contains(c)) c],
            selected: _secondary,
            max: _maxSecondary,
            labelOf: l10n.category,
            onChanged: (value) => setState(() => _secondary = value),
          ),
          SectionTitle(l10n.contentTypes),
          ChoiceWrap(
            options: RegistrationCatalog.contentTypes,
            selected: _contentTypes,
            labelOf: l10n.contentType,
            errorText: _showErrors && _contentTypes.isEmpty ? l10n.selectAtLeastOne : null,
            onChanged: (value) => setState(() => _contentTypes = value),
          ),
          SectionTitle(l10n.audienceAge, trailing: TotalBadge(total: _ageTotal)),
          Row(
            children: [
              for (final (index, group) in RegistrationCatalog.ageGroups.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: PercentField(label: group, controller: _ages[group]!, onChanged: () => setState(() {})),
                ),
              ],
            ],
          ),
          if (_showErrors && (_ageTotal - 100).abs() > 0.01)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(l10n.audienceMustTotal, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
            ),
          SectionTitle(l10n.audienceGender),
          Row(
            children: [
              Text('${l10n.male} ${ltr('${_male.round()}%')}', style: context.textTheme.labelMedium),
              Expanded(
                child: Slider(
                  value: _male,
                  max: 100,
                  divisions: 20,
                  onChanged: (value) => setState(() => _male = value),
                ),
              ),
              Text('${l10n.female} ${ltr('${(100 - _male).round()}%')}', style: context.textTheme.labelMedium),
            ],
          ),
          SectionTitle(
            l10n.audienceLocations,
            subtitle: l10n.optional,
            trailing: TextButton.icon(
              onPressed: _locations.length >= 5
                  ? null
                  : () => setState(() => _locations.add(_LocationRow(null, 0))),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addLocation),
            ),
          ),
          for (final row in _locations)
            Padding(
              key: ObjectKey(row),
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: row.wilaya,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.wilaya, isDense: true),
                      items: [
                        for (final wilaya in RegistrationCatalog.wilayas)
                          if (wilaya == row.wilaya || !usedWilayas.contains(wilaya))
                            DropdownMenuItem(value: wilaya, child: Text(wilaya)),
                      ],
                      onChanged: (value) => setState(() => row.wilaya = value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    flex: 2,
                    child: PercentField(label: '', controller: row.percent, onChanged: () {}),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _locations.remove(row));
                      WidgetsBinding.instance.addPostFrameCallback((_) => row.percent.dispose());
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          SectionTitle(l10n.audienceInterests, subtitle: l10n.optional),
          ChoiceWrap(
            options: RegistrationCatalog.categories,
            selected: _interests,
            labelOf: l10n.category,
            onChanged: (value) => setState(() => _interests = value),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
