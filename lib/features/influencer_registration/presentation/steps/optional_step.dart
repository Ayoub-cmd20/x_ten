import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/catalog/countries.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/accounts_step.dart' show platformIcon;

class _CountryRow {
  _CountryRow(this.country, double percent, Map<String, double> regions)
      : percent = TextEditingController(text: percent > 0 ? percentText(percent) : ''),
        regions = percentControllers(RegistrationCatalog.audienceRegions, regions);

  _CountryRow.of(CountryShare share) : this(share.country, share.percent, share.regions);

  final String country;
  final TextEditingController percent;
  final Map<String, TextEditingController> regions;

  CountryShare get share => CountryShare(country: country, percent: percentOf(percent), regions: percentValues(regions));

  void dispose() {
    percent.dispose();
    for (final controller in regions.values) {
      controller.dispose();
    }
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
  late final TextEditingController _bio;
  late final Map<String, TextEditingController> _gender;
  late final Map<String, TextEditingController> _ages;
  late final Map<String, TextEditingController> _languages;
  late List<String> _topPlatforms;
  late List<String> _days;
  late String _fromHour;
  late String _toHour;
  late List<String> _engagement;
  late List<String> _contentTypes;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final registration = context.read<RegistrationCubit>().state.registration;
    final optional = registration?.optional ?? const OptionalInfo();
    final audience = optional.audience;
    _bio = TextEditingController(text: optional.bio);
    _countries = [for (final c in audience.countries) _CountryRow.of(c)];
    if (_countries.isEmpty) {
      final country = registration?.country ?? '';
      _countries.add(_CountryRow(country.isEmpty ? RegistrationCatalog.defaultCountry : country, 100, const {}));
    }
    _gender = percentControllers(RegistrationCatalog.audienceGenders, audience.gender);
    _ages = percentControllers(RegistrationCatalog.audienceAges, audience.ages);
    _languages = percentControllers(RegistrationCatalog.audienceLanguages, audience.languages);
    _topPlatforms = [...audience.topPlatforms];
    _days = [...audience.activityDays];
    _fromHour = audience.fromHour;
    _toHour = audience.toHour;
    _engagement = [...audience.contentEngagement];
    _contentTypes = [...optional.contentTypes];
  }

  @override
  void dispose() {
    _bio.dispose();
    for (final row in _countries) {
      row.dispose();
    }
    for (final group in [_gender, _ages, _languages]) {
      for (final c in group.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Audience get _audience => Audience(
        countries: [
          for (final row in _countries)
            if (percentOf(row.percent) > 0) row.share,
        ],
        gender: percentValues(_gender),
        ages: percentValues(_ages),
        languages: percentValues(_languages),
        topPlatforms: _topPlatforms,
        activityDays: _days,
        fromHour: _fromHour,
        toHour: _toHour,
        contentEngagement: _engagement,
      );

  void _save() {
    FocusScope.of(context).unfocus();
    final audience = _audience;
    if (audience.unbalanced.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    context.read<RegistrationCubit>().saveSection(
          OptionalInfo(bio: _bio.text, audience: audience, contentTypes: _contentTypes),
          advance: widget.inWizard,
        );
  }

  /// لقطات Insights: نختارو المنصة، ثم الصور، والسيرفر يقرا النسب.
  Future<void> _scanInsights() async {
    final l10n = context.l10n;
    final platform = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(l10n.audScanPlatform, style: sheetContext.textTheme.titleMedium)),
            for (final id in RegistrationCatalog.insightsPlatforms)
              ListTile(
                leading: Icon(platformIcon(SocialPlatform.values.byName(id))),
                title: Text(l10n.platformId(id)),
                onTap: () => Navigator.pop(sheetContext, id),
              ),
          ],
        ),
      ),
    );
    if (platform == null || !mounted) return;
    final images = await pickScreenshots();
    if (images.isEmpty || !mounted) return;
    await context.read<RegistrationCubit>().scanAudience(
          images,
          platform: platform,
          language: Localizations.localeOf(context).languageCode,
        );
  }

  void _setGroup(Map<String, TextEditingController> controllers, Map<String, double> values) {
    if (values.isEmpty) return;
    for (final MapEntry(:key, value: controller) in controllers.entries) {
      final value = values[key] ?? 0.0;
      controller.text = value > 0 ? percentText(value) : '';
    }
  }

  /// النتيجة تعمّر الاستمارة: الأقسام اللي قريناها تعوّض القيم القديمة، والمؤثر يراجع ويحفظ.
  void _applyScan(Audience scan) {
    setState(() {
      if (scan.countries.isNotEmpty) {
        final old = [..._countries];
        _countries
          ..clear()
          ..addAll([for (final c in scan.countries) _CountryRow.of(c)]);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final row in old) {
            row.dispose();
          }
        });
      }
      _setGroup(_gender, scan.gender);
      _setGroup(_ages, scan.ages);
      _setGroup(_languages, scan.languages);
      if (scan.contentEngagement.isNotEmpty) {
        _engagement = [...scan.contentEngagement];
      }
    });
  }

  void _listener(BuildContext context, RegistrationState state) {
    final failure = state.failure;
    if (state.didSucceed(RegistrationAction.scanAudience)) {
      final scan = state.scannedAudience;
      if (scan != null) {
        _applyScan(scan);
        showSuccessSnackBar(context, context.l10n.audScanDone(scan.filledGroups));
      }
      return;
    }
    if (state.didFail(RegistrationAction.scanAudience) && failure != null) {
      showRegistrationFailure(context, failure);
      return;
    }
    if (state.didFail(RegistrationAction.saveSection) && failure != null) {
      if (failure is ValidationFailure && failure.details['audience'] != null) {
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

  Future<void> _addCountry() async {
    final taken = {for (final row in _countries) row.country};
    final code = await pickCountry(context, exclude: taken);
    if (code == null || !mounted) {
      return;
    }
    setState(() => _countries.add(_CountryRow(code, 0, const {})));
  }

  void _removeCountry(_CountryRow row) {
    setState(() => _countries.remove(row));
    WidgetsBinding.instance.addPostFrameCallback((_) => row.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<RegistrationCubit>();
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.saveSection));
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: context.palette.error);
    void refresh() => setState(() {});

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        actions: widget.inWizard
            ? StepActions(
                isLoading: isSaving,
                onBack: cubit.back,
                onNext: _save,
                onSkip: cubit.next,
                skipLabel: l10n.regSkipOptional,
              )
            : PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
        children: [
          _OptionalBanner(text: l10n.regOptionalHint),
          _Header(title: l10n.regBioOptional),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _bio,
            maxLines: 5,
            minLines: 3,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(labelText: l10n.regBio, hintText: l10n.bioHint, alignLabelWithHint: true),
          ),
          _Header(title: l10n.regAudienceTitle),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.audScanHint, style: context.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          OutlinedButton.icon(
            onPressed: context.select((RegistrationCubit c) => c.state.isLoading) ? null : _scanInsights,
            icon: context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.scanAudience))
                ? const AppLoader.small()
                : const Icon(Icons.insights_outlined),
            label: Text(l10n.audScanTitle),
          ),
          SectionTitle(l10n.audCountries, trailing: TotalBadge(total: _countriesTotal)),
          for (final row in _countries)
            _CountryCard(
              key: ObjectKey(row),
              row: row,
              showErrors: _showErrors,
              onChanged: refresh,
              onRemove: _countries.length == 1 ? null : () => _removeCountry(row),
            ),
          if (_showErrors && !totals100(_audience.countryShares)) Text(l10n.audienceMustTotal, style: errorStyle),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: _addCountry,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.audAddCountry),
            ),
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
          SectionTitle(l10n.audContent, subtitle: l10n.audContentRankHint),
          RankedPicker(
            options: RegistrationCatalog.audienceContent,
            selected: _engagement,
            labelOf: l10n.audienceContentLabel,
            onChanged: (value) => setState(() => _engagement = value),
          ),

          // ---------------- أنواع المحتوى الإعلاني ----------------
          _Header(title: l10n.regContentTypesTitle),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.chooseUpTo(RegistrationCatalog.maxAdContentTypes), style: context.textTheme.bodySmall),
          const UpgradeLink(),
          const SizedBox(height: AppSpacing.sm),
          RankedPicker(
            options: RegistrationCatalog.adContentTypes,
            selected: _contentTypes,
            max: RegistrationCatalog.maxAdContentTypes,
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

Future<String?> pickCountry(BuildContext context, {Set<String> exclude = const {}}) {
  final language = Localizations.localeOf(context).languageCode;
  final codes = [for (final code in Countries.codes) if (!exclude.contains(code)) code]
    ..sort((a, b) => Countries.name(a, language).compareTo(Countries.name(b, language)));
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _CountryPicker(codes: codes, language: language),
  );
}

class _CountryPicker extends StatefulWidget {
  const _CountryPicker({required this.codes, required this.language});

  final List<String> codes;
  final String language;

  @override
  State<_CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<_CountryPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final codes = [
      for (final code in widget.codes)
        if (query.isEmpty || Countries.name(code, widget.language).toLowerCase().contains(query)) code,
    ];
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: context.l10n.audCountryName,
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: codes.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(Countries.name(codes[index], widget.language)),
                  onTap: () => Navigator.pop(context, codes[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  const _CountryCard({
    super.key,
    required this.row,
    required this.showErrors,
    required this.onChanged,
    required this.onRemove,
  });

  final _CountryRow row;
  final bool showErrors;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final language = Localizations.localeOf(context).languageCode;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: context.palette.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.public_rounded, color: context.palette.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(Countries.name(row.country, language), style: context.textTheme.titleSmall)),
              SizedBox(width: 96, child: PercentField(label: '', controller: row.percent, onChanged: onChanged)),
              IconButton(tooltip: l10n.delete, onPressed: onRemove, icon: const Icon(Icons.close_rounded)),
            ],
          ),
          PercentGroup(
            title: l10n.audRegionsIn(Countries.name(row.country, language)),
            subtitle: l10n.audRegionsHint,
            controllers: row.regions,
            labelOf: l10n.regionLabel,
            onChanged: onChanged,
            showError: showErrors,
          ),
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
          color: context.palette.accent.withValues(alpha: 0.12),
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: context.palette.accent.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule_outlined, color: context.palette.accent),
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
              decoration: BoxDecoration(color: context.palette.accent, borderRadius: AppRadius.pillAll),
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
                  style: context.textTheme.bodySmall?.copyWith(color: context.palette.error),
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
