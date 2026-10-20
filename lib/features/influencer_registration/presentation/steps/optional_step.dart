import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

class _CountryRow {
  _CountryRow(String country, double percent)
      : country = TextEditingController(text: country),
        percent = TextEditingController(text: percent > 0 ? percentText(percent) : '');

  final TextEditingController country;
  final TextEditingController percent;

  void dispose() {
    country.dispose();
    percent.dispose();
  }
}

/// المراحل الاختيارية (بالبنفسجي في الوثيقة): حصر الجمهور، المهارات، أنواع المحتوى، معرض الأعمال.
/// موجودة في التسجيل بصح ماشي إلزامية، وتتكمّل حتى بعد التوثيق.
class OptionalStep extends StatefulWidget {
  const OptionalStep({super.key, this.inWizard = true});

  final bool inWizard;

  @override
  State<OptionalStep> createState() => _OptionalStepState();
}

class _OptionalStepState extends State<OptionalStep> {
  late final List<_CountryRow> _countries;
  late final Map<String, TextEditingController> _regions;
  late final Map<String, TextEditingController> _gender;
  late final Map<String, TextEditingController> _ages;
  late final Map<String, TextEditingController> _languages;
  late final Map<String, TextEditingController> _content;
  late bool _regionsUnspecified;
  late List<String> _topPlatforms;
  late List<String> _days;
  late String _fromHour;
  late String _toHour;
  late String _purchasing;
  late List<String> _skills;
  late List<String> _contentTypes;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final optional = context.read<RegistrationCubit>().state.registration?.optional ?? const OptionalInfo();
    final audience = optional.audience;
    _countries = [for (final c in audience.countries) _CountryRow(c.country, c.percent)];
    if (_countries.isEmpty) _countries.add(_CountryRow('', 0));
    _regions = percentControllers(RegistrationCatalog.audienceRegions, audience.regions);
    _gender = percentControllers(RegistrationCatalog.audienceGenders, audience.gender);
    _ages = percentControllers(RegistrationCatalog.audienceAges, audience.ages);
    _languages = percentControllers(RegistrationCatalog.audienceLanguages, audience.languages);
    _content = percentControllers(RegistrationCatalog.audienceContent, audience.contentEngagement);
    _regionsUnspecified = audience.regionsUnspecified;
    _topPlatforms = [...audience.topPlatforms];
    _days = [...audience.activityDays];
    _fromHour = audience.fromHour;
    _toHour = audience.toHour;
    _purchasing = audience.purchasingPower;
    _skills = [...optional.skills];
    _contentTypes = [...optional.contentTypes];
  }

  @override
  void dispose() {
    for (final row in _countries) {
      row.dispose();
    }
    for (final group in [_regions, _gender, _ages, _languages, _content]) {
      for (final c in group.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Audience get _audience => Audience(
        countries: [
          for (final row in _countries)
            if (row.country.text.trim().isNotEmpty && percentOf(row.percent) > 0)
              CountryShare(country: row.country.text.trim(), percent: percentOf(row.percent)),
        ],
        regions: _regionsUnspecified ? const {} : percentValues(_regions),
        regionsUnspecified: _regionsUnspecified,
        gender: percentValues(_gender),
        ages: percentValues(_ages),
        languages: percentValues(_languages),
        topPlatforms: _topPlatforms,
        activityDays: _days,
        fromHour: _fromHour,
        toHour: _toHour,
        contentEngagement: percentValues(_content),
        purchasingPower: _purchasing,
      );

  bool get _skillsValid =>
      _skills.isEmpty ||
      (_skills.length >= RegistrationCatalog.minSkills && _skills.length <= RegistrationCatalog.maxSkills);

  void _save() {
    FocusScope.of(context).unfocus();
    final audience = _audience;
    if (audience.unbalanced.isNotEmpty || !_skillsValid) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveSection(
          OptionalInfo(audience: audience, skills: _skills, contentTypes: _contentTypes),
          advance: widget.inWizard,
        );
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didFail(RegistrationAction.saveSection) && failure != null) {
      if (failure is ValidationFailure && (failure.details['audience'] != null || failure.details['skills'] != null)) {
        setState(() => _showErrors = true);
      }
      showRegistrationFailure(context, failure);
    } else if (!widget.inWizard && state.didSucceed(RegistrationAction.saveSection)) {
      showSavedSnackBar(context);
    }
  }

  Future<void> _pickTime(bool from) async {
    final current = from ? _fromHour : _toHour;
    final parts = current.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: parts.length == 2
          ? TimeOfDay(hour: int.tryParse(parts[0]) ?? 18, minute: int.tryParse(parts[1]) ?? 0)
          : const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked == null) return;
    final text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    setState(() {
      if (from) {
        _fromHour = text;
      } else {
        _toHour = text;
      }
    });
  }

  double get _countriesTotal => _countries.fold(0, (sum, row) => sum + percentOf(row.percent));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<RegistrationCubit>();
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveSection));
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    void refresh() => setState(() {});

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: widget.inWizard
            ? StepActions(isLoading: isSaving, onBack: cubit.back, onNext: _save)
            : PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
        children: [
          _OptionalBanner(text: l10n.regOptionalHint),

          // ---------------- حصر الجمهور ----------------
          _Header(title: l10n.regAudienceTitle),
          SectionTitle(l10n.audCountries, trailing: TotalBadge(total: _countriesTotal)),
          for (final row in _countries)
            Padding(
              key: ObjectKey(row),
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: row.country,
                      onChanged: (_) => refresh(),
                      decoration: InputDecoration(labelText: l10n.audCountryName, isDense: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(flex: 2, child: PercentField(label: '', controller: row.percent, onChanged: refresh)),
                  IconButton(
                    tooltip: l10n.delete,
                    onPressed: _countries.length == 1
                        ? null
                        : () {
                            setState(() => _countries.remove(row));
                            WidgetsBinding.instance.addPostFrameCallback((_) => row.dispose());
                          },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => setState(() => _countries.add(_CountryRow('', 0))),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.audAddCountry),
            ),
          ),
          if (_showErrors && !totals100(_audience.countryShares)) Text(l10n.audienceMustTotal, style: errorStyle),
          SectionTitle(l10n.audRegions, subtitle: l10n.audRegionsHint),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.audRegionsUnspecified, style: context.textTheme.bodyMedium),
            value: _regionsUnspecified,
            onChanged: (value) => setState(() => _regionsUnspecified = value),
          ),
          if (!_regionsUnspecified)
            PercentGroup(
              title: '',
              controllers: _regions,
              labelOf: l10n.regionLabel,
              onChanged: refresh,
              showError: _showErrors,
            ),
          PercentGroup(
            title: l10n.audGender,
            controllers: _gender,
            labelOf: l10n.audienceGenderLabel,
            onChanged: refresh,
            showError: _showErrors,
          ),
          PercentGroup(
            title: l10n.audAges,
            controllers: _ages,
            labelOf: l10n.ageLabel,
            onChanged: refresh,
            showError: _showErrors,
          ),
          PercentGroup(
            title: l10n.audLanguages,
            controllers: _languages,
            labelOf: l10n.audienceLanguageLabel,
            columns: 2,
            onChanged: refresh,
            showError: _showErrors,
          ),
          SectionTitle(l10n.audTopPlatforms, subtitle: l10n.audTopPlatformsHint),
          RankedPicker(
            options: RegistrationCatalog.audiencePlatforms,
            selected: _topPlatforms,
            max: RegistrationCatalog.maxTopPlatforms,
            labelOf: l10n.platformId,
            onChanged: (value) => setState(() => _topPlatforms = value),
          ),
          SectionTitle(l10n.audActivity),
          Text(l10n.audPeakDays, style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          ChoiceWrap(
            options: RegistrationCatalog.weekDays,
            selected: _days,
            labelOf: l10n.dayLabel,
            onChanged: (value) => setState(() => _days = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.audPeakHours, style: context.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickTime(true),
                  icon: const Icon(Icons.schedule_rounded),
                  label: Text('${l10n.audFrom} ${_fromHour.isEmpty ? '—' : ltr(_fromHour)}'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickTime(false),
                  icon: const Icon(Icons.schedule_rounded),
                  label: Text('${l10n.audTo} ${_toHour.isEmpty ? '—' : ltr(_toHour)}'),
                ),
              ),
            ],
          ),
          PercentGroup(
            title: l10n.audContent,
            controllers: _content,
            labelOf: l10n.audienceContentLabel,
            columns: 2,
            onChanged: refresh,
            showError: _showErrors,
          ),
          SectionTitle(l10n.audPurchasing),
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final id in RegistrationCatalog.purchasingPower)
                ChoiceChip(
                  label: Text(l10n.purchasingLabel(id)),
                  selected: _purchasing == id,
                  onSelected: (on) => setState(() => _purchasing = on ? id : ''),
                ),
            ],
          ),

          // ---------------- المهارات ----------------
          _Header(title: l10n.regSkillsTitle),
          Text(
            l10n.regSkillsHint(RegistrationCatalog.minSkills, RegistrationCatalog.maxSkills),
            style: context.textTheme.bodySmall,
          ),
          for (final MapEntry(key: group, value: skills) in RegistrationCatalog.skillGroups.entries) ...[
            SectionTitle(l10n.skillGroupLabel(group)),
            ChoiceWrap(
              options: skills,
              selected: _skills,
              max: RegistrationCatalog.maxSkills,
              labelOf: l10n.skillLabel,
              onChanged: (value) => setState(() => _skills = value),
            ),
          ],
          if (_showErrors && !_skillsValid)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.regSkillsHint(RegistrationCatalog.minSkills, RegistrationCatalog.maxSkills),
                style: errorStyle,
              ),
            ),

          // ---------------- أنواع المحتوى الإعلاني ----------------
          _Header(title: l10n.regContentTypesTitle),
          RankedPicker(
            options: RegistrationCatalog.adContentTypes,
            selected: _contentTypes,
            labelOf: l10n.adContentTypeLabel,
            onChanged: (value) => setState(() => _contentTypes = value),
          ),

          // ---------------- معرض الأعمال ----------------
          _Header(title: l10n.regPortfolioTitle),
          const _PortfolioSection(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

void showSavedSnackBar(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.regSaved)));

class _OptionalBanner extends StatelessWidget {
  const _OptionalBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.accentPurple.withValues(alpha: 0.12),
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const Icon(Icons.schedule_outlined, color: AppColors.accentPurple),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(text, style: context.textTheme.bodySmall)),
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xxl),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: const BoxDecoration(color: AppColors.accentPurple, borderRadius: AppRadius.pillAll),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(title, style: context.textTheme.titleMedium)),
          ],
        ),
      );
}

class _PortfolioSection extends StatelessWidget {
  const _PortfolioSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.sm),
        if (state.portfolio.isEmpty)
          EmptyHint(icon: Icons.collections_outlined, text: l10n.portfolioEmpty)
        else
          for (final item in state.portfolio)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ItemCard(
                icon: item.fileName.isNotEmpty ? Icons.attach_file_rounded : Icons.link_rounded,
                title: item.title,
                subtitle: item.fileName.isNotEmpty ? item.fileName : item.link,
                trailing: state.isLoadingFor(RegistrationAction.deletePortfolio, item.id)
                    ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
                    : IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: state.isLoading ? null : () => cubit.deletePortfolioItem(item.id),
                      ),
              ),
            ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _PortfolioForm())),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.addPortfolioItem),
          ),
        ),
      ],
    );
  }
}

class _PortfolioForm extends StatefulWidget {
  const _PortfolioForm();

  @override
  State<_PortfolioForm> createState() => _PortfolioFormState();
}

class _PortfolioFormState extends State<_PortfolioForm> with ServerFieldErrors {
  static const _fields = ['title', 'description', 'link', 'file'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _link = TextEditingController();
  UploadFile? _file;
  bool _showErrors = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: portfolioFileRules.extensions.toList(),
    );
    final file = result?.files.singleOrNull;
    final path = file?.path;
    if (file == null || path == null) return;
    setState(() => _file = UploadFile(path: path, name: file.name, size: file.size));
  }

  void _save() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || (_file == null && _link.text.trim().isEmpty)) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().addPortfolioItem(
          PortfolioItem(title: _title.text, description: _description.text, link: _link.text),
          _file,
        );
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      Navigator.of(context).pop();
    } else if (state.status == OperationStatus.failure) {
      final failure = state.failure!;
      if (failure is ValidationFailure && failure.fieldError('file') != null) {
        showRegistrationFailure(context, failure);
        return;
      }
      handleFailure(failure, _fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.addPortfolio));
    final file = _file;
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.addPortfolio && previous.status != current.status,
      listener: _onChanged,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addPortfolioItem, style: context.textTheme.titleMedium),
            gap,
            TextFormField(
              controller: _title,
              forceErrorText: serverError('title'),
              onChanged: (_) => clearServerError('title'),
              decoration: InputDecoration(labelText: l10n.portfolioItemTitle),
              validator: (v) => requiredText(context, v),
            ),
            gap,
            TextFormField(
              controller: _link,
              keyboardType: TextInputType.url,
              textDirection: TextDirection.ltr,
              forceErrorText: serverError('link'),
              onChanged: (_) => clearServerError('link'),
              decoration: InputDecoration(labelText: l10n.portfolioItemLink),
              validator: (v) => (v ?? '').trim().isEmpty ? null : urlText(context, v),
            ),
            gap,
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: Icon(file == null ? Icons.upload_file_rounded : Icons.task_alt_rounded),
              label: Text(file?.name ?? l10n.regPortfolioFile, overflow: TextOverflow.ellipsis),
            ),
            if (_showErrors && file == null && _link.text.trim().isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  l10n.regPortfolioLinkOrFile,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            gap,
            TextFormField(
              controller: _description,
              maxLines: 3,
              minLines: 2,
              forceErrorText: serverError('description'),
              onChanged: (_) => clearServerError('description'),
              decoration: InputDecoration(labelText: l10n.descriptionOptional, alignLabelWithHint: true),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
