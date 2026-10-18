import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

final _money = NumberFormat('#,##0', 'en');

String formatDzd(double? amount) => amount == null ? '—' : '${_money.format(amount)} دج';

String formatDay(DateTime? date) => date == null ? '—' : '${date.day}/${date.month}/${date.year}';

extension CampaignLabels on AppLocalizations {
  String adStatus(AdRequestStatus status, {bool asClient = false}) => switch (status) {
        AdRequestStatus.draft => adStatusDraft,
        AdRequestStatus.submitted => adStatusSubmitted,
        AdRequestStatus.awaitingInfluencer => adStatusAwaitingInfluencer,
        AdRequestStatus.influencerReplied => adStatusInfluencerReplied,
        AdRequestStatus.clientReviewing => asClient ? adStatusClientReviewingYou : adStatusClientReviewing,
        AdRequestStatus.clientReplied => adStatusClientReplied,
        AdRequestStatus.agreed => adStatusAgreed,
        AdRequestStatus.rejected || AdRequestStatus.unknown => adStatusRejected,
      };

  String adFormat(AdFormat format) => switch (format) {
        AdFormat.post => adFormatPost,
        AdFormat.reel => adFormatReel,
        AdFormat.story => adFormatStory,
      };

  String adPlatform(AdPlatform platform) => switch (platform) {
        AdPlatform.instagram => 'Instagram',
        AdPlatform.tiktok => 'TikTok',
        AdPlatform.facebook => 'Facebook',
        AdPlatform.x => 'X',
      };

  String adEntryModeLabel(EntryMode mode) => switch (mode) {
        EntryMode.template => adEntryTemplate,
        EntryMode.freeText => adEntryFreeText,
      };

  String adEntryModeDescription(EntryMode mode) => switch (mode) {
        EntryMode.template => adEntryTemplateDesc,
        EntryMode.freeText => adEntryFreeTextDesc,
      };

  String adMediaTypeLabel(MediaType type) => switch (type) {
        MediaType.image => adMediaImage,
        MediaType.video => adMediaVideo,
      };

  String adContentSourceLabel(ContentSource source) => switch (source) {
        ContentSource.ready => adSourceReady,
        ContentSource.influencer => adSourceInfluencer,
      };

  String adParty(AdParty party) => switch (party) {
        AdParty.client => adPartyClient,
        AdParty.platform || AdParty.unknown => adPartyPlatform,
        AdParty.influencer => adPartyInfluencer,
      };

  String adEvent(AdEventAction action) => switch (action) {
        AdEventAction.submitted => adEventSubmitted,
        AdEventAction.forwarded => adEventForwarded,
        AdEventAction.modificationSent => adEventModificationSent,
        AdEventAction.modificationAccepted => adEventModificationAccepted,
        AdEventAction.modificationRefused => adEventModificationRefused,
        AdEventAction.influencerChanged => adEventInfluencerChanged,
        AdEventAction.influencerAccepted => adEventInfluencerAccepted,
        AdEventAction.influencerCounterOffer => adEventCounterOffer,
        AdEventAction.influencerUnclear => adEventUnclear,
        AdEventAction.influencerDeclined => adEventDeclined,
        AdEventAction.rejected => adEventRejected,
        AdEventAction.unknown => adEventUnknown,
      };

  String? adFieldError(Failure? failure, String field) {
    if (failure is! ValidationFailure) return null;
    if (field == 'attachments') return failure.missingIn('attachments').isEmpty ? null : adReadyContentMissing;
    return switch (failure.fieldError(field)) {
      null => null,
      'future' => adDeadlineFuture,
      _ => fieldRequired,
    };
  }
}

String campaignFailureText(BuildContext context, Failure failure) {
  final l10n = context.l10n;
  return switch (failure) {
    ValidationFailure() when failure.fieldError('file') == 'badExtension' => l10n.fileBadExtension,
    ValidationFailure() when failure.fieldError('file') == 'tooLarge' => l10n.adFileTooLarge,
    ValidationFailure() => l10n.adCheckFields,
    ServerFailure(code: 'influencer_unavailable') => l10n.adInfluencerUnavailable,
    _ => failure.localized(context),
  };
}
