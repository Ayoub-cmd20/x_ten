import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/my_campaigns_screen.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

const _gold = Color(0xFFE5C158);
const _surface = Color(0xFF151515);
const _surface2 = Color(0xFF1B1B1B);

/// Read-only body of an ad request, shared by the advertiser and influencer.
class AdRequestDetailsView extends StatelessWidget {
  const AdRequestDetailsView({
    super.key,
    required this.bundle,
    required this.asClient,
    this.header,
  });

  final AdRequestBundle bundle;
  final bool asClient;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final request = bundle.request;
    final brief = request.brief;
    final client = request.client;
    final modification = request.pendingModification;
    final header = this.header;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _summary(l10n, request),
        if (header != null) ...[
          const SizedBox(height: 16),
          header,
        ],
        if (asClient && modification != null) ...[
          const SizedBox(height: 16),
          _card(
            title: l10n.adPendingModification,
            highlight: true,
            children: [
              if (modification.message.isNotEmpty)
                Text(
                  modification.message,
                  style: const TextStyle(color: Colors.white70, height: 1.7),
                ),
              if (modification.proposedBudget != null) ...[
                const SizedBox(height: 10),
                _row(l10n.adProposedBudget, formatDzd(modification.proposedBudget)),
              ],
            ],
          ),
        ],
        if (request.status == AdRequestStatus.rejected) ...[
          const SizedBox(height: 16),
          _card(
            title: l10n.adRejectedBy(l10n.adParty(request.rejectedBy)),
            children: [
              if (request.rejectionReason.isNotEmpty)
                Text(
                  request.rejectionReason,
                  style: const TextStyle(color: Colors.white70, height: 1.7),
                ),
            ],
          ),
        ],
        if (!asClient && client != null) ...[
          const SizedBox(height: 16),
          _card(
            title: l10n.oppClient,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      client.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (client.isVerified)
                    const Icon(Icons.verified_rounded, color: _gold, size: 18),
                ],
              ),
              if (client.address.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(client.address, style: const TextStyle(color: Colors.white54)),
              ],
              const SizedBox(height: 6),
              if (client.isVerified)
                Text(
                  l10n.oppClientVerified,
                  style: const TextStyle(color: _gold, fontSize: 12),
                ),
              Text(
                l10n.oppClientDeals(client.successfulDeals),
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        _card(
          title: brief.requiresTravel
              ? l10n.adTravel
              : switch (brief.entryMode) {
                  final mode? => l10n.adEntryModeLabel(mode),
                  null => l10n.adDetails,
                },
          children: [
            if (brief.requiresTravel) ...[
              _row(l10n.adTravelAddress, brief.travelAddress),
              const SizedBox(height: 10),
              Text(
                brief.presenceRequirements,
                style: const TextStyle(color: Colors.white70, height: 1.7),
              ),
            ],
            if (brief.entryMode == EntryMode.template) ...[
              if (brief.mediaType case final type?) _row(l10n.adMediaType, l10n.adMediaTypeLabel(type)),
              if (brief.contentSource case final source?)
                _row(l10n.adContentSource, l10n.adContentSourceLabel(source)),
              if (brief.sampleRequired case final sample?)
                _row(l10n.adSampleRequired, sample ? l10n.yes : l10n.no),
            ],
            if (brief.entryMode == EntryMode.freeText)
              Text(
                brief.details,
                style: const TextStyle(color: Colors.white70, height: 1.7),
              ),
            if (brief.needsPlatformServices) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.handyman_outlined, color: _gold, size: 17),
                  const SizedBox(width: 6),
                  Text(
                    l10n.adWithPlatformServices,
                    style: const TextStyle(color: _gold, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ],
        ),
        if (request.attachments.isNotEmpty) ...[
          const SizedBox(height: 16),
          _card(
            title: l10n.adAttachments,
            children: [
              for (final attachment in request.attachments)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _surface2,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        attachment.purpose == AttachmentPurpose.readyContent
                            ? Icons.perm_media_outlined
                            : Icons.description_outlined,
                        color: _gold,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          attachment.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
        if (bundle.events.isNotEmpty) ...[
          const SizedBox(height: 16),
          _card(
            title: l10n.adTimeline,
            children: [
              for (final event in bundle.events.reversed) _event(l10n, event),
            ],
          ),
        ],
      ],
    );
  }

  Widget _summary(AppLocalizations l10n, AdRequest request) {
    final brief = request.brief;
    final color = AdRequestCard.statusColor(request.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _gold.withValues(alpha: 0.12),
            _gold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _gold.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  asClient ? request.influencerName : (request.client?.name ?? ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.adStatus(request.status, asClient: asClient),
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            request.code,
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12),
          ),
          const SizedBox(height: 14),
          _row(l10n.adBudget, formatDzd(brief.budget)),
          _row(l10n.adDeadline, formatDay(brief.publishDeadline)),
          _row(l10n.adFormats, brief.formats.map(l10n.adFormat).join(' • ')),
          _row(l10n.adPlatforms, brief.platforms.map(l10n.adPlatform).join(' • ')),
        ],
      ),
    );
  }

  Widget _event(AppLocalizations l10n, AdEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: _gold, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.adEvent(event.action),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                if (event.message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      event.message,
                      style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.6),
                    ),
                  ),
                if (event.proposedBudget != null)
                  Text(
                    '${l10n.adProposedBudget}: ${formatDzd(event.proposedBudget)}',
                    style: const TextStyle(color: _gold, fontSize: 12.5),
                  ),
                Text(
                  formatDay(event.createdAt),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _card({
    required String title,
    required List<Widget> children,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Colors.orange.withValues(alpha: 0.08) : _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight ? Colors.orange.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// Bottom sheet asking for a message (and optionally a budget).
Future<({String message, double? budget})?> showReplySheet(
  BuildContext context, {
  required String title,
  required String hint,
  required bool messageRequired,
  String? budgetLabel,
}) {
  final messageController = TextEditingController();
  final budgetController = TextEditingController();
  final l10n = context.l10n;

  return showModalBottomSheet<({String message, double? budget})>(
    context: context,
    isScrollControlled: true,
    backgroundColor: _surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      var showError = false;
      return StatefulBuilder(
        builder: (context, setSheetState) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              20,
              16,
              16 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: messageController,
                  minLines: 3,
                  maxLines: 6,
                  autofocus: true,
                  cursorColor: _gold,
                  style: const TextStyle(color: Colors.white, height: 1.6),
                  decoration: _sheetDecoration(
                    hint,
                    errorText: showError ? l10n.fieldRequired : null,
                  ),
                ),
                if (budgetLabel != null) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: budgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    cursorColor: _gold,
                    style: const TextStyle(color: Colors.white),
                    decoration: _sheetDecoration(budgetLabel, suffix: 'دج'),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final message = messageController.text.trim();
                      if (messageRequired && message.isEmpty) {
                        setSheetState(() => showError = true);
                        return;
                      }
                      Navigator.pop(sheetContext, (
                        message: message,
                        budget: double.tryParse(budgetController.text.trim()),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _gold,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      l10n.confirm,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

InputDecoration _sheetDecoration(String hint, {String? errorText, String? suffix}) => InputDecoration(
      hintText: hint,
      errorText: errorText,
      suffixText: suffix,
      suffixStyle: const TextStyle(color: _gold, fontWeight: FontWeight.w700),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.30)),
      filled: true,
      fillColor: _surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _gold),
      ),
    );

/// Gold primary and outlined secondary buttons used at the bottom of details.
class DetailsActionButton extends StatelessWidget {
  const DetailsActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = true,
    this.danger = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary;
  final bool danger;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.redAccent : _gold;
    final child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: primary ? Colors.black : color),
          )
        : Text(label, style: const TextStyle(fontWeight: FontWeight.w800));

    return SizedBox(
      height: 52,
      child: primary
          ? ElevatedButton.icon(
              onPressed: loading ? null : onPressed,
              icon: icon == null || loading ? const SizedBox.shrink() : Icon(icon),
              label: child,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.black,
                disabledBackgroundColor: color.withValues(alpha: 0.45),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            )
          : OutlinedButton.icon(
              onPressed: loading ? null : onPressed,
              icon: icon == null || loading ? const SizedBox.shrink() : Icon(icon, color: color),
              label: DefaultTextStyle.merge(style: TextStyle(color: color), child: child),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withValues(alpha: 0.45)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
    );
  }
}
