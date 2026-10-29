import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/features/campaigns/domain/campaign_usecases.dart';
import 'package:x_ten/features/campaigns/presentation/ad_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';
import 'package:x_ten/features/marketplace/domain/entities/market_influencer.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

/// Create an ad request for the selected influencer, either from
/// a template or as a free-text request, then send it to the platform.
class CampaignCreationScreen extends StatefulWidget {
  final MarketInfluencer? influencer;

  const CampaignCreationScreen({
    super.key,
    this.influencer,
  });

  @override
  State<CampaignCreationScreen> createState() =>
      _CampaignCreationScreenState();
}

class _CampaignCreationScreenState
    extends State<CampaignCreationScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);
  static const Color _error = Color(0xFFFF6B6B);

  late final TextEditingController _travelAddressController;
  late final TextEditingController _presenceController;
  late final TextEditingController _detailsController;
  late final TextEditingController _budgetController;

  bool _requiresTravel = false;
  EntryMode? _entryMode;
  MediaType? _mediaType;
  ContentSource? _contentSource;
  bool? _sampleRequired;
  bool _needsPlatformServices = false;
  final Set<AdFormat> _formats = {};
  final Set<AdPlatform> _platforms = {};
  DateTime? _deadline;
  final List<PendingAttachment> _files = [];

  @override
  void initState() {
    super.initState();
    _travelAddressController = TextEditingController();
    _presenceController = TextEditingController();
    _detailsController = TextEditingController();
    _budgetController = TextEditingController();
  }

  @override
  void dispose() {
    _travelAddressController.dispose();
    _presenceController.dispose();
    _detailsController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  AdBrief get _brief => AdBrief(
        requiresTravel: _requiresTravel,
        travelAddress: _travelAddressController.text,
        presenceRequirements: _presenceController.text,
        entryMode: _entryMode,
        mediaType: _mediaType,
        contentSource: _contentSource,
        sampleRequired: _sampleRequired,
        details: _detailsController.text,
        needsPlatformServices: _needsPlatformServices,
        formats: [for (final f in AdFormat.values) if (_formats.contains(f)) f],
        platforms: [for (final p in AdPlatform.values) if (_platforms.contains(p)) p],
        budget: double.tryParse(_budgetController.text.trim()),
        publishDeadline: _deadline,
      );

  // ============================================================
  // ACTIONS
  // ============================================================

  Future<void> _pickDeadline() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? tomorrow,
      firstDate: tomorrow,
      lastDate: tomorrow.add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() => _deadline = picked);
  }

  Future<void> _pickFile(AttachmentPurpose purpose) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions:
          UploadAdAttachmentUseCase.rulesFor(purpose).extensions.toList(),
    );
    final file = result?.files.singleOrNull;
    final path = file?.path;
    if (file == null || path == null) return;

    setState(() {
      _files.add((
        purpose: purpose,
        file: UploadFile(path: path, name: file.name, size: file.size),
      ));
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final influencer = widget.influencer;
    if (influencer == null) return;

    final brief = _brief;
    final files = [
      for (final f in _files)
        if (f.purpose == AttachmentPurpose.brief ||
            brief.needsReadyContent)
          f,
    ];

    context.read<AdRequestsCubit>().send(
          influencerProfileId: influencer.id,
          brief: brief,
          files: files,
        );
  }

  Future<void> _onState(BuildContext _, AdRequestsState state) async {
    final failure = state.failure;

    if (state.didSucceed(AdRequestsAction.send)) {
      await _showSentDialog();
      if (mounted) context.pop();
    } else if (state.didFail(AdRequestsAction.send) && failure != null) {
      _showSnackBar(campaignFailureText(context, failure));
    }
  }

  Future<void> _showSentDialog() {
    final l10n = context.l10n;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: _surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: _gold.withValues(alpha: 0.18),
              ),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: _gold,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.adSentTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              l10n.adSentBody,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.6,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'حسناً',
                  style: TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1B1B1B),
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<AdRequestsCubit, AdRequestsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.action == AdRequestsAction.send,
      listener: _onState,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            backgroundColor: _background,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'إنشاء حملة إشهارية',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: BlocBuilder<AdRequestsCubit, AdRequestsState>(
                buildWhen: (previous, current) =>
                    previous.failure != current.failure ||
                    previous.status != current.status ||
                    previous.uploadedPaths != current.uploadedPaths,
                builder: (context, state) {
                  final failure = state.failure;
                  String? error(String field) => l10n.adFieldError(failure, field);

                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle(l10n.adInfluencer),
                        const SizedBox(height: 8),
                        _influencerTile(l10n),

                        const SizedBox(height: 18),

                        _switchTile(
                          title: l10n.adRequiresTravel,
                          subtitle: l10n.adRequiresTravelHint,
                          value: _requiresTravel,
                          onChanged: (value) =>
                              setState(() => _requiresTravel = value),
                        ),

                        if (_requiresTravel) ..._travelFields(l10n, error) else ..._entryFields(l10n, error, state),

                        const SizedBox(height: 18),

                        _sectionTitle(l10n.adFormats),
                        const SizedBox(height: 8),
                        _chips<AdFormat>(
                          values: AdFormat.values,
                          label: l10n.adFormat,
                          isSelected: _formats.contains,
                          onTap: (value) => setState(() {
                            _formats.contains(value)
                                ? _formats.remove(value)
                                : _formats.add(value);
                          }),
                        ),
                        _errorText(error('formats')),

                        const SizedBox(height: 18),

                        _sectionTitle(l10n.adPlatforms),
                        const SizedBox(height: 8),
                        _chips<AdPlatform>(
                          values: AdPlatform.values,
                          label: l10n.adPlatform,
                          isSelected: _platforms.contains,
                          onTap: (value) => setState(() {
                            _platforms.contains(value)
                                ? _platforms.remove(value)
                                : _platforms.add(value);
                          }),
                        ),
                        _errorText(error('platforms')),

                        const SizedBox(height: 18),

                        _sectionTitle(l10n.adBudget),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _budgetController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          cursorColor: _gold,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: _inputDecoration(
                            hint: 'مثال: 100000',
                            suffixText: 'دج',
                            prefixIcon: Icons.payments_outlined,
                            errorText: error('budgetAmount'),
                          ),
                        ),

                        const SizedBox(height: 18),

                        _dateTile(
                          label: l10n.adDeadline,
                          date: _deadline,
                          onTap: _pickDeadline,
                        ),
                        _errorText(error('publishDeadline')),

                        const SizedBox(height: 18),

                        _switchTile(
                          title: l10n.adNeedsPlatformServices,
                          value: _needsPlatformServices,
                          onChanged: (value) =>
                              setState(() => _needsPlatformServices = value),
                        ),

                        const SizedBox(height: 18),

                        _filesSection(
                          title: l10n.adBriefFiles,
                          hint: l10n.adBriefFilesHint,
                          purpose: AttachmentPurpose.brief,
                          uploaded: state.uploadedPaths,
                          l10n: l10n,
                        ),

                        const SizedBox(height: 26),

                        _submitButton(
                          label: l10n.adSend,
                          isSubmitting: state.isLoadingFor(AdRequestsAction.send),
                          enabled: widget.influencer != null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _travelFields(
    AppLocalizations l10n,
    String? Function(String field) error,
  ) {
    return [
      const SizedBox(height: 18),
      _sectionTitle(l10n.adTravelAddress),
      const SizedBox(height: 8),
      TextField(
        controller: _travelAddressController,
        cursorColor: _gold,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(
          hint: l10n.adTravelAddress,
          prefixIcon: Icons.location_on_outlined,
          errorText: error('travelAddress'),
        ),
      ),
      const SizedBox(height: 18),
      _sectionTitle(l10n.adPresenceRequirements),
      const SizedBox(height: 8),
      TextField(
        controller: _presenceController,
        minLines: 3,
        maxLines: 6,
        cursorColor: _gold,
        style: const TextStyle(color: Colors.white, height: 1.6),
        decoration: _inputDecoration(
          hint: l10n.adPresenceHint,
          errorText: error('presenceRequirements'),
        ),
      ),
    ];
  }

  List<Widget> _entryFields(
    AppLocalizations l10n,
    String? Function(String field) error,
    AdRequestsState state,
  ) {
    return [
      const SizedBox(height: 18),
      _sectionTitle(l10n.adEntryMode),
      const SizedBox(height: 8),
      Row(
        children: [
          for (final (index, mode) in EntryMode.values.indexed) ...[
            if (index > 0) const SizedBox(width: 12),
            Expanded(
              child: _optionCard(
                title: l10n.adEntryModeLabel(mode),
                subtitle: l10n.adEntryModeDescription(mode),
                icon: mode == EntryMode.template
                    ? Icons.view_quilt_outlined
                    : Icons.edit_note_rounded,
                selected: _entryMode == mode,
                onTap: () => setState(() => _entryMode = mode),
              ),
            ),
          ],
        ],
      ),
      _errorText(error('entryMode')),
      if (_entryMode == EntryMode.template) ...[
        const SizedBox(height: 18),
        _sectionTitle(l10n.adMediaType),
        const SizedBox(height: 8),
        _chips<MediaType>(
          values: MediaType.values,
          label: l10n.adMediaTypeLabel,
          isSelected: (value) => _mediaType == value,
          onTap: (value) => setState(() => _mediaType = value),
        ),
        _errorText(error('mediaType')),
        const SizedBox(height: 18),
        _sectionTitle(l10n.adContentSource),
        const SizedBox(height: 8),
        _chips<ContentSource>(
          values: ContentSource.values,
          label: l10n.adContentSourceLabel,
          isSelected: (value) => _contentSource == value,
          onTap: (value) => setState(() => _contentSource = value),
        ),
        _errorText(error('contentSource')),
        if (_contentSource == ContentSource.ready) ...[
          const SizedBox(height: 18),
          _filesSection(
            title: l10n.adReadyContent,
            hint: l10n.adReadyContentHint,
            purpose: AttachmentPurpose.readyContent,
            uploaded: state.uploadedPaths,
            l10n: l10n,
          ),
          _errorText(error('attachments')),
        ],
        const SizedBox(height: 18),
        _sectionTitle(l10n.adSampleRequired),
        const SizedBox(height: 8),
        _chips<bool>(
          values: const [true, false],
          label: (value) => value ? l10n.yes : l10n.no,
          isSelected: (value) => _sampleRequired == value,
          onTap: (value) => setState(() => _sampleRequired = value),
        ),
        _errorText(error('sampleRequired')),
      ],
      if (_entryMode == EntryMode.freeText) ...[
        const SizedBox(height: 18),
        _sectionTitle(l10n.adDetails),
        const SizedBox(height: 8),
        TextField(
          controller: _detailsController,
          minLines: 4,
          maxLines: 8,
          cursorColor: _gold,
          style: const TextStyle(
            color: Colors.white,
            height: 1.6,
          ),
          decoration: _inputDecoration(
            hint: l10n.adDetailsHint,
            errorText: error('details'),
          ),
        ),
      ],
    ];
  }

  // ============================================================
  // WIDGETS
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _errorText(String? text) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(color: _error, fontSize: 12),
      ),
    );
  }

  Widget _influencerTile(AppLocalizations l10n) {
    final influencer = widget.influencer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline_rounded, color: _gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              influencer?.name ?? l10n.adChooseInfluencer,
              style: TextStyle(
                color: influencer == null
                    ? Colors.white.withValues(alpha: 0.35)
                    : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (influencer == null)
            IconButton(
              onPressed: () => context.go('/advertiser/explore'),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _gold, size: 18),
            ),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: _surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeTrackColor: _gold,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 12,
                ),
              ),
      ),
    );
  }

  Widget _chips<T>({
    required List<T> values,
    required String Function(T value) label,
    required bool Function(T value) isSelected,
    required ValueChanged<T> onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          ChoiceChip(
            selected: isSelected(value),
            label: Text(label(value)),
            onSelected: (_) => onTap(value),
            selectedColor: _gold,
            backgroundColor: _surface,
            side: BorderSide(
              color: isSelected(value)
                  ? _gold
                  : Colors.white.withValues(alpha: 0.08),
            ),
            labelStyle: TextStyle(
              color: isSelected(value) ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _optionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? _gold.withValues(alpha: 0.10) : _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? _gold : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: _gold, size: 22),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filesSection({
    required String title,
    required String hint,
    required AttachmentPurpose purpose,
    required Set<String> uploaded,
    required AppLocalizations l10n,
  }) {
    final files = [for (final f in _files) if (f.purpose == purpose) f];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 4),
        Text(
          hint,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.40),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in files)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: _gold, size: 19),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                if (uploaded.contains(item.file.path))
                  const Icon(Icons.cloud_done_outlined, color: Colors.greenAccent, size: 19)
                else
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _files.remove(item)),
                    icon: const Icon(Icons.close_rounded, color: Colors.white38, size: 19),
                  ),
              ],
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => _pickFile(purpose),
          icon: const Icon(Icons.attach_file_rounded, color: _gold),
          label: Text(
            l10n.adAddFile,
            style: const TextStyle(color: _gold, fontWeight: FontWeight.w700),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _gold.withValues(alpha: 0.35)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton({
    required String label,
    required bool isSubmitting,
    required bool enabled,
  }) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isSubmitting || !enabled ? null : _submit,
        icon: const Icon(Icons.send_rounded),
        label: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: isSubmitting
              ? const SizedBox(
                  key: ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
                  ),
                )
              : Text(
                  label,
                  key: const ValueKey('text'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: Colors.black,
          disabledBackgroundColor: _gold.withValues(alpha: 0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Widget _dateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(label),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: _gold,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      date == null ? 'اختر التاريخ' : formatDay(date),
                      style: TextStyle(
                        color: date == null
                            ? Colors.white.withValues(alpha: 0.35)
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    String? suffixText,
    IconData? prefixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      hintStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.28),
        height: 1.6,
      ),
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: _gold,
        fontWeight: FontWeight.w700,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: _gold, size: 20)
          : null,
      filled: true,
      fillColor: _surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      errorStyle: const TextStyle(color: _error, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _gold, width: 1.3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _error, width: 1.3),
      ),
    );
  }
}
