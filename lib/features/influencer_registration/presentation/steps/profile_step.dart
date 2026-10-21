import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/widgets/profile_photo.dart';

/// معلومات البروفايل: الصورة، إسم الشهرة، المجالات، النبذة، اللغات.
class ProfileStep extends StatefulWidget {
  const ProfileStep({super.key});

  @override
  State<ProfileStep> createState() => _ProfileStepState();
}

class _ProfileStepState extends State<ProfileStep> with ServerFieldErrors {
  static const _fields = [
    'displayName',
    'primaryCategories',
    'secondaryCategories',
    'bio',
    'contentLanguages',
    'addressLanguages',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayName;
  late final TextEditingController _bio;
  late final TextEditingController _otherLanguage;
  late List<String> _primary;
  late List<String> _secondary;
  late Map<String, LanguageLevel> _languages;
  late List<String> _address;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<RegistrationCubit>().state;
    final profile = state.registration?.profile;
    _displayName = TextEditingController(text: profile?.displayName);
    _bio = TextEditingController(text: profile?.bio);
    _primary = [...?profile?.primaryCategories];
    _secondary = [...?profile?.secondaryCategories];
    _languages = {for (final l in profile?.contentLanguages ?? const <ContentLanguage>[]) l.code: l.level};
    _otherLanguage = TextEditingController(
      text: profile?.contentLanguages.where((l) => l.code == RegistrationCatalog.otherLanguage).firstOrNull?.name,
    );
    _address = [...?profile?.addressLanguages];
  }

  @override
  void dispose() {
    _displayName.dispose();
    _bio.dispose();
    _otherLanguage.dispose();
    super.dispose();
  }

  bool get _otherNameMissing =>
      _languages.containsKey(RegistrationCatalog.otherLanguage) && _otherLanguage.text.trim().isEmpty;

  void _toggleLanguage(String code, bool on) => setState(() {
        if (on) {
          _languages[code] = LanguageLevel.good;
        } else {
          _languages.remove(code);
          if (code == RegistrationCatalog.otherLanguage) _address.remove(code);
        }
      });

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    final hasPhoto = context.read<RegistrationCubit>().state.registration?.profileImageUrl != null;
    if (!valid || !hasPhoto || _primary.isEmpty || _languages.isEmpty || _otherNameMissing || _address.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveSection(ProfileInfo(
          displayName: _displayName.text,
          primaryCategories: _primary,
          secondaryCategories: _secondary,
          bio: _bio.text,
          contentLanguages: [
            for (final code in RegistrationCatalog.languages)
              if (_languages[code] case final level?)
                ContentLanguage(
                  code: code,
                  level: level,
                  name: code == RegistrationCatalog.otherLanguage ? _otherLanguage.text : '',
                ),
          ],
          addressLanguages: _address,
        ));
  }

  void _onFailure(BuildContext context, RegistrationState state) {
    final failure = state.failure!;
    if (failure is ValidationFailure && failure.details.keys.any(_fields.contains)) {
      setState(() => _showErrors = true);
    }
    handleFailure(failure, _fields);
  }

  String _languageName(String code) {
    final l10n = context.l10n;
    final other = _otherLanguage.text.trim();
    return code == RegistrationCatalog.otherLanguage && other.isNotEmpty ? other : l10n.languageLabel(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveSection));
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    const maxPrimary = RegistrationCatalog.maxPrimaryCategories;
    const maxSecondary = RegistrationCatalog.maxSecondaryCategories;

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => current.didFail(RegistrationAction.saveSection) && previous != current,
      listener: _onFailure,
      child: Form(
        key: _formKey,
        child: StepBody(
          actions: StepActions(isLoading: isSaving, onBack: context.read<RegistrationCubit>().back, onNext: _submit),
          children: [
            ProfilePhotoPicker(showError: _showErrors),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _displayName,
              forceErrorText: serverError('displayName'),
              onChanged: (_) => clearServerError('displayName'),
              decoration: InputDecoration(labelText: l10n.regDisplayName),
              validator: (value) => requiredText(context, value),
            ),
            SectionTitle(l10n.regPrimaryCategories, subtitle: l10n.chooseUpTo(maxPrimary)),
            ChoiceWrap(
              options: RegistrationCatalog.categories,
              selected: _primary,
              max: maxPrimary,
              labelOf: l10n.category,
              errorText: _showErrors && _primary.isEmpty ? l10n.selectAtLeastOne : serverError('primaryCategories'),
              onChanged: (value) => setState(() {
                _primary = value;
                _secondary = [for (final s in _secondary) if (!value.contains(s)) s];
              }),
            ),
            SectionTitle(l10n.regSecondaryCategories, subtitle: l10n.optionalChooseUpTo(maxSecondary)),
            ChoiceWrap(
              options: [for (final c in RegistrationCatalog.categories) if (!_primary.contains(c)) c],
              selected: _secondary,
              max: maxSecondary,
              labelOf: l10n.category,
              onChanged: (value) => setState(() => _secondary = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _bio,
              maxLines: 5,
              minLines: 3,
              keyboardType: TextInputType.multiline,
              forceErrorText: serverError('bio'),
              onChanged: (_) => clearServerError('bio'),
              decoration: InputDecoration(labelText: l10n.regBio, alignLabelWithHint: true),
              validator: (value) => requiredText(context, value),
            ),
            SectionTitle(l10n.regContentLanguages),
            for (final code in RegistrationCatalog.languages) ...[
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _languages.containsKey(code),
                title: Text(l10n.languageLabel(code), style: context.textTheme.bodyMedium),
                onChanged: (on) => _toggleLanguage(code, on ?? false),
              ),
              if (_languages[code] case final level?) ...[
                if (code == RegistrationCatalog.otherLanguage)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TextField(
                      controller: _otherLanguage,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.regOtherLanguageName,
                        errorText: _showErrors && _otherNameMissing ? l10n.fieldRequired : null,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SegmentedButton<LanguageLevel>(
                    showSelectedIcon: false,
                    segments: [
                      for (final value in LanguageLevel.values)
                        ButtonSegment(value: value, label: Text(l10n.levelLabel(value))),
                    ],
                    selected: {level},
                    onSelectionChanged: (value) => setState(() => _languages[code] = value.first),
                  ),
                ),
              ],
            ],
            if (_showErrors && _languages.isEmpty) Text(l10n.selectAtLeastOne, style: errorStyle),
            SectionTitle(
              l10n.regAddressLanguages,
              subtitle: l10n.regAddressLanguagesHint(RegistrationCatalog.maxAddressLanguages),
            ),
            RankedPicker(
              options: [
                for (final code in RegistrationCatalog.languages)
                  if (code != RegistrationCatalog.otherLanguage || _languages.containsKey(code)) code,
              ],
              selected: _address,
              max: RegistrationCatalog.maxAddressLanguages,
              labelOf: _languageName,
              errorText: _showErrors && _address.isEmpty ? l10n.selectAtLeastOne : serverError('addressLanguages'),
              onChanged: (value) => setState(() => _address = value),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
