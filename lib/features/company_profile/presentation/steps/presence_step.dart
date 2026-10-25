import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/photo_picker.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/steps/accounts_step.dart' show platformIcon;

const _hosts = {
  'facebook.com': SocialPlatform.facebook,
  'fb.com': SocialPlatform.facebook,
  'instagram.com': SocialPlatform.instagram,
  'tiktok.com': SocialPlatform.tiktok,
  'youtube.com': SocialPlatform.youtube,
  'youtu.be': SocialPlatform.youtube,
  'snapchat.com': SocialPlatform.snapchat,
  'x.com': SocialPlatform.x,
  'twitter.com': SocialPlatform.x,
  'linkedin.com': SocialPlatform.linkedin,
  't.me': SocialPlatform.telegram,
};

String _normalizeUrl(String raw) {
  final text = raw.trim();
  if (text.isEmpty) {
    return text;
  }
  return RegExp(r'^https?://', caseSensitive: false).hasMatch(text) ? text : 'https://$text';
}

MarketingPage _guess(String url) {
  final host = (Uri.tryParse(url)?.host ?? '').toLowerCase().replaceFirst(RegExp(r'^(www|m|web|business)\.'), '');
  final platform = _hosts.entries.where((e) => host == e.key || host.endsWith('.${e.key}')).firstOrNull?.value;
  return MarketingPage(url: url, platform: platform ?? SocialPlatform.website);
}

class CompanyPresenceStep extends StatefulWidget {
  const CompanyPresenceStep({super.key});

  @override
  State<CompanyPresenceStep> createState() => _CompanyPresenceStepState();
}

class _CompanyPresenceStepState extends State<CompanyPresenceStep> with ServerFieldErrors {
  static const _fields = ['bio', 'activityAreas', 'activityOther', 'marketingPages'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bio;
  late final TextEditingController _activityOther;
  final _url = TextEditingController();
  late List<String> _areas;
  late List<MarketingPage> _pages;
  String? _urlError;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    final presence = context.read<CompanyCubit>().state.profile?.presence ?? const CompanyPresence();
    _bio = TextEditingController(text: presence.bio);
    _activityOther = TextEditingController(text: presence.activityOther);
    _areas = [...presence.activityAreas];
    _pages = [...presence.marketingPages];
  }

  @override
  void dispose() {
    for (final c in [_bio, _activityOther, _url]) {
      c.dispose();
    }
    super.dispose();
  }

  void _listener(BuildContext context, CompanyState state) {
    final failure = state.failure;
    if (failure == null || state.status != CompanyStatus.failure) {
      return;
    }
    if (state.action == CompanyAction.saveSection) {
      handleFailure(failure, _fields);
    } else if (state.action == CompanyAction.uploadPhoto || state.action == CompanyAction.deletePhoto) {
      showRegistrationFailure(context, failure);
    }
  }

  void _addPage() {
    final l10n = context.l10n;
    final url = _normalizeUrl(_url.text);
    final uri = Uri.tryParse(url);
    final valid = uri != null && uri.host.contains('.');
    setState(() {
      if (!valid) {
        _urlError = l10n.urlInvalid;
      } else if (_pages.length >= CompanyCatalog.maxMarketingPages) {
        _urlError = l10n.companyPagesLimit(CompanyCatalog.maxMarketingPages);
      } else {
        _urlError = null;
        if (!_pages.any((p) => p.url == url)) {
          _pages = [..._pages, _guess(url)];
        }
        _url.clear();
      }
    });
    clearServerError('marketingPages');
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final valid = _formKey.currentState?.validate() ?? false;
    final state = context.read<CompanyCubit>().state;
    if (!valid || _areas.isEmpty || state.profile?.profileImageUrl == null) {
      setState(() => _showErrors = true);
      return;
    }
    if (_url.text.trim().isNotEmpty) {
      _addPage();
    }
    context.read<CompanyCubit>().saveSection(CompanyPresence(
          bio: _bio.text,
          activityAreas: _areas,
          activityOther: _activityOther.text,
          marketingPages: _pages,
        ));
  }

  void _toggle(String area, bool on, int max) {
    setState(() {
      if (!on) {
        _areas = [for (final a in _areas) if (a != area) a];
      } else if (_areas.length < max) {
        _areas = [..._areas, area];
      }
    });
    clearServerError('activityAreas');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final state = context.watch<CompanyCubit>().state;
    final profile = state.profile;
    final url = profile?.profileImageUrl;
    final max = CompanyCatalog.maxActivities(state.businessType ?? BusinessType.individualActivity);
    final errorStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.error);
    final areasError = serverError('activityAreas') ?? (_showErrors && _areas.isEmpty ? l10n.fieldRequired : null);
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
            PhotoPicker(
              url: url,
              cacheKey: url == null ? null : '$url#${profile?.updatedAt?.millisecondsSinceEpoch}',
              busy: state.isLoadingFor(CompanyAction.uploadPhoto) || state.isLoadingFor(CompanyAction.deletePhoto),
              showError: _showErrors,
              subtitle: req(l10n.companyPhotoSubtitle),
              onPicked: cubit.uploadPhoto,
              onRemove: cubit.deletePhoto,
            ),
            gap,
            TextFormField(
              controller: _bio,
              minLines: 3,
              maxLines: 6,
              maxLength: 1000,
              forceErrorText: serverError('bio'),
              onChanged: (_) => clearServerError('bio'),
              decoration: InputDecoration(labelText: req(l10n.companyBio), hintText: l10n.companyBioHint),
              validator: (value) => requiredText(context, value),
            ),
            SectionTitle(
              req(l10n.companyActivitiesTitle),
              subtitle: l10n.companyActivitiesMax(max),
              trailing: Text('${_areas.length}/$max', style: context.textTheme.labelMedium),
            ),
            if (_areas.isNotEmpty)
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final area in _areas)
                    InputChip(label: Text(l10n.activityArea(area)), onDeleted: () => _toggle(area, false, max)),
                ],
              ),
            if (areasError != null)
              Padding(padding: const EdgeInsets.only(top: AppSpacing.xs), child: Text(areasError, style: errorStyle)),
            const SizedBox(height: AppSpacing.xs),
            for (final sector in CompanyCatalog.sectors.entries)
              _SectorTile(
                title: l10n.activitySector(sector.key),
                areas: sector.value,
                selected: _areas,
                full: _areas.length >= max,
                onToggle: (area, on) => _toggle(area, on, max),
              ),
            if (_areas.contains(CompanyCatalog.otherActivity)) ...[
              gap,
              TextFormField(
                controller: _activityOther,
                forceErrorText: serverError('activityOther'),
                onChanged: (_) => clearServerError('activityOther'),
                decoration: InputDecoration(labelText: req(l10n.companyActivityOtherHint)),
                validator: (value) => requiredText(context, value),
              ),
            ],
            SectionTitle(l10n.companyPagesTitle, subtitle: l10n.companyPagesHint),
            for (final page in _pages)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ItemCard(
                  icon: platformIcon(page.platform),
                  title: l10n.platform(page.platform),
                  subtitle: ltr(page.url),
                  trailing: IconButton(
                    tooltip: l10n.delete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => setState(() => _pages = [for (final p in _pages) if (p.url != page.url) p]),
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _url,
                    keyboardType: TextInputType.url,
                    textDirection: TextDirection.ltr,
                    onSubmitted: (_) => _addPage(),
                    decoration: InputDecoration(
                      labelText: l10n.accountUrl,
                      errorText: _urlError ?? serverError('marketingPages'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: IconButton.filledTonal(
                    tooltip: l10n.add,
                    onPressed: _addPage,
                    icon: const Icon(Icons.add_rounded),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectorTile extends StatelessWidget {
  const _SectorTile({
    required this.title,
    required this.areas,
    required this.selected,
    required this.full,
    required this.onToggle,
  });

  final String title;
  final List<String> areas;
  final List<String> selected;
  final bool full;
  final void Function(String area, bool on) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = areas.where(selected.contains).length;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: AppSpacing.sm),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(title, style: context.textTheme.bodyMedium),
      trailing: count == 0
          ? null
          : CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.gold,
              child: Text('$count', style: context.textTheme.labelSmall?.copyWith(color: AppColors.background)),
            ),
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final area in areas)
              FilterChip(
                label: Text(l10n.activityArea(area)),
                selected: selected.contains(area),
                showCheckmark: false,
                onSelected: !selected.contains(area) && full ? null : (on) => onToggle(area, on),
              ),
          ],
        ),
      ],
    );
  }
}
