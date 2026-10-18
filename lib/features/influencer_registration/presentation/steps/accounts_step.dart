import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_widgets.dart';

IconData platformIcon(SocialPlatform platform) => switch (platform) {
      SocialPlatform.facebook => Icons.facebook_rounded,
      SocialPlatform.instagram => Icons.camera_alt_outlined,
      SocialPlatform.tiktok => Icons.music_note_rounded,
      SocialPlatform.youtube => Icons.smart_display_outlined,
      SocialPlatform.snapchat => Icons.chat_bubble_outline_rounded,
      SocialPlatform.x => Icons.alternate_email_rounded,
      SocialPlatform.linkedin => Icons.work_outline_rounded,
      SocialPlatform.website => Icons.language_rounded,
      SocialPlatform.blog => Icons.article_outlined,
      SocialPlatform.other => Icons.link_rounded,
    };

class AccountsStep extends StatefulWidget {
  const AccountsStep({super.key});

  @override
  State<AccountsStep> createState() => _AccountsStepState();
}

class _AccountsStepState extends State<AccountsStep> {
  bool _showErrors = false;

  void _next() {
    final cubit = context.read<RegistrationCubit>();
    if (cubit.state.socialAccounts.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.next();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final compact = NumberFormat.compact(locale: Localizations.localeOf(context).toLanguageTag());

    return StepBody(
      actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
      children: [
        SectionTitle(
          l10n.socialAccounts,
          subtitle: l10n.socialAccountsHint,
          trailing: TextButton.icon(
            onPressed: () => showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _SocialAccountForm())),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.add),
          ),
        ),
        if (state.socialAccounts.isEmpty)
          EmptyHint(icon: Icons.person_add_alt_1_outlined, text: l10n.socialAccountsEmpty)
        else
          for (final account in state.socialAccounts)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ItemCard(
                icon: platformIcon(account.platform),
                title: '${l10n.platform(account.platform)} · @${account.username}',
                subtitle: [
                  account.accountName,
                  if (account.followers > 0) l10n.followersCount(ltr(compact.format(account.followers))),
                ].join(' · '),
                trailing: state.isLoadingFor(RegistrationAction.deleteSocial, account.id)
                    ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
                    : IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: state.isLoading ? null : () => cubit.deleteSocialAccount(account.id),
                      ),
              ),
            ),
        if (_showErrors && state.socialAccounts.isEmpty)
          Text(l10n.socialAccountsEmpty, style: context.textTheme.bodySmall?.copyWith(color: AppColors.error)),
        SectionTitle(
          l10n.portfolioTitle,
          subtitle: l10n.optional,
          trailing: TextButton.icon(
            onPressed: () => showFormSheet<void>(context, BlocProvider.value(value: cubit, child: const _PortfolioForm())),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.add),
          ),
        ),
        if (state.portfolio.isEmpty)
          EmptyHint(icon: Icons.collections_outlined, text: l10n.portfolioEmpty)
        else
          for (final item in state.portfolio)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ItemCard(
                icon: Icons.play_circle_outline_rounded,
                title: item.title,
                subtitle: item.description,
                trailing: state.isLoadingFor(RegistrationAction.deletePortfolio, item.id)
                    ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
                    : IconButton(
                        tooltip: l10n.delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: state.isLoading ? null : () => cubit.deletePortfolioItem(item.id),
                      ),
              ),
            ),
      ],
    );
  }
}

class _SocialAccountForm extends StatefulWidget {
  const _SocialAccountForm();

  @override
  State<_SocialAccountForm> createState() => _SocialAccountFormState();
}

class _SocialAccountFormState extends State<_SocialAccountForm> with ServerFieldErrors {
  static const _fields = ['platform', 'facebookAccountType', 'url', 'accountName', 'username', 'followers', 'description'];

  final _formKey = GlobalKey<FormState>();
  final _url = TextEditingController();
  final _accountName = TextEditingController();
  final _username = TextEditingController();
  final _followers = TextEditingController();
  final _description = TextEditingController();
  SocialPlatform _platform = SocialPlatform.instagram;
  FacebookAccountType _facebookType = FacebookAccountType.page;

  @override
  void dispose() {
    for (final c in [_url, _accountName, _username, _followers, _description]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().addSocialAccount(SocialAccount(
          platform: _platform,
          facebookAccountType: _platform == SocialPlatform.facebook ? _facebookType : null,
          url: _url.text,
          accountName: _accountName.text,
          username: _username.text,
          followers: int.tryParse(_followers.text) ?? 0,
          description: _description.text,
        ));
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      Navigator.of(context).pop();
    } else if (state.status == OperationStatus.failure) {
      handleFailure(state.failure!, _fields);
    }
  }

  TextFormField _field(TextEditingController c, String field, String label,
          {TextInputType? keyboard, TextDirection? direction, FormFieldValidator<String>? validator, int maxLines = 1}) =>
      TextFormField(
        controller: c,
        keyboardType: keyboard,
        textDirection: direction,
        maxLines: maxLines,
        minLines: 1,
        forceErrorText: serverError(field),
        onChanged: (_) => clearServerError(field),
        decoration: InputDecoration(labelText: label),
        validator: validator,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.addSocial));
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => current.action == RegistrationAction.addSocial && previous.status != current.status,
      listener: _onChanged,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.addSocialAccount, style: context.textTheme.titleMedium),
            gap,
            DropdownButtonFormField<SocialPlatform>(
              initialValue: _platform,
              decoration: InputDecoration(labelText: l10n.platformLabel),
              items: [
                for (final platform in SocialPlatform.values)
                  DropdownMenuItem(
                    value: platform,
                    child: Row(
                      children: [
                        Icon(platformIcon(platform), size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(l10n.platform(platform)),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) => setState(() => _platform = value ?? _platform),
            ),
            if (_platform == SocialPlatform.facebook) ...[
              gap,
              SegmentedButton<FacebookAccountType>(
                segments: [
                  for (final type in FacebookAccountType.values)
                    ButtonSegment(value: type, label: Text(l10n.facebookType(type))),
                ],
                selected: {_facebookType},
                onSelectionChanged: (value) => setState(() => _facebookType = value.first),
              ),
            ],
            gap,
            _field(
              _url,
              'url',
              l10n.accountUrl,
              keyboard: TextInputType.url,
              direction: TextDirection.ltr,
              validator: (v) => urlText(context, v),
            ),
            gap,
            Row(
              children: [
                Expanded(
                  child: _field(
                    _username,
                    'username',
                    l10n.username,
                    direction: TextDirection.ltr,
                    validator: (v) => requiredText(context, v),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _field(
                    _followers,
                    'followers',
                    l10n.followers,
                    keyboard: TextInputType.number,
                    direction: TextDirection.ltr,
                  ),
                ),
              ],
            ),
            gap,
            _field(_accountName, 'accountName', l10n.accountName, validator: (v) => requiredText(context, v)),
            gap,
            _field(_description, 'description', l10n.descriptionOptional, maxLines: 3),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _PortfolioForm extends StatefulWidget {
  const _PortfolioForm();

  @override
  State<_PortfolioForm> createState() => _PortfolioFormState();
}

class _PortfolioFormState extends State<_PortfolioForm> with ServerFieldErrors {
  static const _fields = ['title', 'description', 'link', 'mediaUrls'];

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _link = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _link.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().addPortfolioItem(
          PortfolioItem(title: _title.text, description: _description.text, link: _link.text),
        );
  }

  void _onChanged(BuildContext context, RegistrationState state) {
    if (state.status == OperationStatus.success) {
      Navigator.of(context).pop();
    } else if (state.status == OperationStatus.failure) {
      handleFailure(state.failure!, _fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.addPortfolio));
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
              validator: (v) => urlText(context, v),
            ),
            gap,
            TextFormField(
              controller: _description,
              maxLines: 3,
              minLines: 2,
              forceErrorText: serverError('description'),
              onChanged: (_) => clearServerError('description'),
              decoration: InputDecoration(labelText: l10n.portfolioItemDescription, alignLabelWithHint: true),
              validator: (v) => requiredText(context, v),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
