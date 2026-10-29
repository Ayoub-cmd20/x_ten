import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
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
      SocialPlatform.telegram => Icons.send_rounded,
      SocialPlatform.website => Icons.language_rounded,
      SocialPlatform.blog => Icons.article_outlined,
      SocialPlatform.other => Icons.link_rounded,
    };

/// معلومات حسابات التواصل الإجتماعي: يحط الرابط ويدرك تقديم، والباقي يتعمّر وحدو.
class AccountsStep extends StatefulWidget {
  const AccountsStep({super.key});

  @override
  State<AccountsStep> createState() => _AccountsStepState();
}

class _AccountsStepState extends State<AccountsStep> {
  final _url = TextEditingController();
  String? _urlError;
  bool _showErrors = false;
  final Map<int, int> _screenshotAttempts = {};

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  void _add() {
    FocusScope.of(context).unfocus();
    final url = _url.text.trim();
    if (url.isEmpty) {
      setState(() => _urlError = context.l10n.fieldRequired);
      return;
    }
    context.read<RegistrationCubit>().addSocialAccount(url);
  }

  void _next() {
    final cubit = context.read<RegistrationCubit>();
    final accounts = cubit.state.socialAccounts;
    if (accounts.isEmpty || accounts.any((a) => a.needsDetails)) {
      setState(() => _showErrors = true);
      return;
    }
    cubit.next();
  }

  Future<void> _uploadScreenshot(SocialAccount account) async {
    final file = await pickScreenshot();
    if (file == null || !mounted) return;
    await context.read<RegistrationCubit>().applySocialScreenshot(account.id, file);
  }

  void _onScreenshotFailed(BuildContext context, RegistrationState state) {
    final failure = state.failure!;
    final accountId = state.target;
    final account = state.socialAccounts.where((a) => a.id == accountId).firstOrNull;
    final l10n = context.l10n;
    if (account != null && isOcrUnavailable(failure)) {
      showErrorSnackBar(context, l10n.ocrUnavailable);
      _openDetails(account);
      return;
    }
    if (account != null && isUnrecognized(failure)) {
      final attempts = (_screenshotAttempts[account.id] ?? 0) + 1;
      _screenshotAttempts[account.id] = attempts;
      const max = RegistrationCatalog.maxScanAttempts;
      if (attempts < max) {
        showErrorSnackBar(context, l10n.screenshotUnrecognizedRetry(attempts, max));
      } else {
        // بعد 3 محاولات: يدخل الأرقام يدوياً (تتراجع في الاجتماع)
        _screenshotAttempts.remove(account.id);
        showErrorSnackBar(context, l10n.screenshotManualAfterTries);
        _openDetails(account);
      }
      return;
    }
    showRegistrationFailure(context, failure);
  }

  void _listener(BuildContext context, RegistrationState state) {
    if (state.didSucceed(RegistrationAction.socialScreenshot)) {
      if (state.target case final int id) _screenshotAttempts.remove(id);
      showSuccessSnackBar(context, context.l10n.screenshotApplied);
      return;
    }
    if (state.didFail(RegistrationAction.socialScreenshot)) {
      _onScreenshotFailed(context, state);
      return;
    }
    if (state.didSucceed(RegistrationAction.addSocial)) {
      _url.clear();
      setState(() => _urlError = null);
      final added = state.socialAccounts.lastOrNull;
      if (added != null && added.needsDetails) _askScreenshot(added);
    } else if (state.didFail(RegistrationAction.addSocial)) {
      final failure = state.failure!;
      final field = failure is ValidationFailure ? failure.fieldError('url') : null;
      if (field != null) {
        setState(() => _urlError = field == 'duplicate' ? context.l10n.regSocialDuplicate : context.l10n.urlInvalid);
      } else {
        showRegistrationFailure(context, failure);
      }
    } else if (state.didFail(RegistrationAction.refreshSocial) || state.didFail(RegistrationAction.deleteSocial)) {
      showRegistrationFailure(context, state.failure!);
    }
  }

  /// المنصة ما تعطيش الأرقام مجاناً: لقطة شاشة للبروفايل (أو إدخال يدوي).
  Future<void> _askScreenshot(SocialAccount account) async {
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.platform(account.platform), style: sheetContext.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(l10n.socialScreenshotHint, style: sheetContext.textTheme.bodySmall),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: l10n.socialScreenshotButton,
                icon: Icons.screenshot_outlined,
                onPressed: () => Navigator.pop(sheetContext, true),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(onPressed: () => Navigator.pop(sheetContext, false), child: Text(l10n.finManualEntry)),
            ],
          ),
        ),
      ),
    );
    if (!mounted || choice == null) return;
    if (choice) {
      await _uploadScreenshot(account);
    } else {
      _openDetails(account);
    }
  }

  void _openDetails(SocialAccount account) {
    final cubit = context.read<RegistrationCubit>();
    showFormSheet<void>(context, BlocProvider.value(value: cubit, child: _AccountDetailsForm(account: account)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RegistrationCubit>().state;
    final cubit = context.read<RegistrationCubit>();
    final compact = NumberFormat.compact(locale: Localizations.localeOf(context).toLanguageTag());
    final adding = state.isLoadingFor(RegistrationAction.addSocial);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status || previous.action != current.action,
      listener: _listener,
      child: StepBody(
        requiredNote: true,
        actions: StepActions(onBack: cubit.back, onNext: _next, nextLabel: l10n.next),
        children: [
          SectionTitle(req(l10n.regSocialTitle), subtitle: l10n.regSocialAutoHint),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _url,
                  keyboardType: TextInputType.url,
                  textDirection: TextDirection.ltr,
                  onChanged: (_) {
                    if (_urlError != null) setState(() => _urlError = null);
                  },
                  onSubmitted: (_) => _add(),
                  decoration: InputDecoration(
                    labelText: l10n.regSocialUrlLabel,
                    hintText: 'https://instagram.com/...',
                    errorText: _urlError,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  // الثيم يعطي الأزرار عرض لا نهائي: داخل Row لازم عرض محدد
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  ),
                  onPressed: adding || state.isLoading ? null : _add,
                  child: adding ? AppLoader.small(color: context.palette.onGoldFill) : Text(l10n.regSocialSubmit),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.socialAccounts.isEmpty)
            EmptyHint(icon: Icons.person_add_alt_1_outlined, text: l10n.socialAccountsEmpty)
          else
            for (final account in state.socialAccounts)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _AccountCard(
                  account: account,
                  followersText: account.followers > 0 ? l10n.followersCount(ltr(compact.format(account.followers))) : '',
                  busy: state.isLoadingFor(RegistrationAction.deleteSocial, account.id) ||
                      state.isLoadingFor(RegistrationAction.refreshSocial, account.id) ||
                      state.isLoadingFor(RegistrationAction.socialScreenshot, account.id),
                  enabled: !state.isLoading,
                  highlightMissing: _showErrors && account.needsDetails,
                  onDetails: () => _openDetails(account),
                  onScreenshot: () => _uploadScreenshot(account),
                  onRefresh: () => cubit.refreshSocialAccount(account.id),
                  onDelete: () => cubit.deleteSocialAccount(account.id),
                ),
              ),
          if (_showErrors && state.socialAccounts.isEmpty)
            Text(l10n.socialAccountsEmpty, style: context.textTheme.bodySmall?.copyWith(color: context.palette.error)),
          if (_showErrors && state.socialAccounts.any((a) => a.needsDetails))
            Text(l10n.regSocialNeedsDetails, style: context.textTheme.bodySmall?.copyWith(color: context.palette.error)),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.account,
    required this.followersText,
    required this.busy,
    required this.enabled,
    required this.highlightMissing,
    required this.onDetails,
    required this.onScreenshot,
    required this.onRefresh,
    required this.onDelete,
  });

  final SocialAccount account;
  final String followersText;
  final bool busy;
  final bool enabled;
  final bool highlightMissing;
  final VoidCallback onDetails;
  final VoidCallback onScreenshot;
  final VoidCallback onRefresh;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final name = account.accountName.isNotEmpty ? account.accountName : account.username;
    final badgeColor = switch (account.source) {
      SocialSource.auto => context.palette.success,
      SocialSource.screenshot => context.palette.primary,
      SocialSource.manual => context.palette.warning,
    };

    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: highlightMissing ? context.palette.error : colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled && !account.isAuto ? onDetails : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              ExternalAvatar(url: account.avatarUrl, fallbackIcon: platformIcon(account.platform), size: 48),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? l10n.platform(account.platform) : name,
                      style: context.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      [l10n.platform(account.platform), if (followersText.isNotEmpty) followersText].join(' · '),
                      style: context.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: AppRadius.pillAll,
                      ),
                      child: Text(
                        switch (account.source) {
                          SocialSource.auto => l10n.regSocialAuto,
                          SocialSource.screenshot => l10n.regSocialFromScreenshot,
                          SocialSource.manual =>
                            account.needsDetails ? l10n.regSocialCompleteManually : l10n.regSocialManual,
                        },
                        style: context.textTheme.labelSmall?.copyWith(color: badgeColor),
                      ),
                    ),
                  ],
                ),
              ),
              if (busy)
                const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
              else ...[
                if (account.isAuto)
                  IconButton(
                    tooltip: l10n.regRefresh,
                    onPressed: enabled ? onRefresh : null,
                    icon: const Icon(Icons.refresh_rounded),
                  )
                else ...[
                
                  IconButton(
                    tooltip: l10n.edit,
                    onPressed: enabled ? onDetails : null,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
                IconButton(
                  tooltip: l10n.delete,
                  onPressed: enabled ? onDelete : null,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// لما المنصة ما تعطيش المعلومات مجاناً: الاسم وعدد المتابعين يدوياً.
class _AccountDetailsForm extends StatefulWidget {
  const _AccountDetailsForm({required this.account});

  final SocialAccount account;

  @override
  State<_AccountDetailsForm> createState() => _AccountDetailsFormState();
}

class _AccountDetailsFormState extends State<_AccountDetailsForm> with ServerFieldErrors {
  static const _fields = ['accountName', 'followers'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _followers;

  @override
  void initState() {
    super.initState();
    final account = widget.account;
    _name = TextEditingController(text: account.accountName.isNotEmpty ? account.accountName : account.username);
    _followers = TextEditingController(text: account.followers > 0 ? '${account.followers}' : '');
  }

  @override
  void dispose() {
    _name.dispose();
    _followers.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegistrationCubit>().updateSocialAccount(
          widget.account.id,
          accountName: _name.text,
          followers: int.tryParse(_followers.text) ?? 0,
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
    final account = widget.account;
    final isSaving = context.select((RegistrationCubit c) => c.state.isLoadingFor(RegistrationAction.updateSocial));
    const gap = SizedBox(height: AppSpacing.md);

    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) =>
          current.action == RegistrationAction.updateSocial && previous.status != current.status,
      listener: _onChanged,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.platform(account.platform), style: context.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xxs),
            Text(account.url, textDirection: TextDirection.ltr, style: context.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.regSocialNeedsDetails, style: context.textTheme.bodySmall),
            gap,
            TextFormField(
              controller: _name,
              forceErrorText: serverError('accountName'),
              onChanged: (_) => clearServerError('accountName'),
              decoration: InputDecoration(labelText: req(l10n.accountName)),
              validator: (v) => requiredText(context, v),
            ),
            gap,
            TextFormField(
              controller: _followers,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              forceErrorText: serverError('followers'),
              onChanged: (_) => clearServerError('followers'),
              decoration: InputDecoration(labelText: req(l10n.followers)),
              validator: (v) => (int.tryParse(v ?? '') ?? 0) > 0 ? null : l10n.fieldRequired,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(label: l10n.save, isLoading: isSaving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
