import 'package:equatable/equatable.dart';

export 'package:x_ten/core/utils/upload_file.dart';

enum AdFormat { post, reel, story }

enum AdPlatform { instagram, tiktok, facebook, x }

enum EntryMode { template, freeText }

enum MediaType { image, video }

enum ContentSource { ready, influencer }

enum AttachmentPurpose { brief, readyContent }

enum AdRequestStatus {
  draft,
  submitted,
  awaitingInfluencer,
  influencerReplied,
  clientReviewing,
  clientReplied,
  agreed,
  rejected,
  unknown,
}

enum AdParty { client, platform, influencer, unknown }

enum AdEventAction {
  submitted,
  forwarded,
  modificationSent,
  modificationAccepted,
  modificationRefused,
  influencerChanged,
  influencerAccepted,
  influencerCounterOffer,
  influencerUnclear,
  influencerDeclined,
  rejected,
  unknown,
}

enum InfluencerTab { requested, discussing }

extension AdRequestStatusX on AdRequestStatus {
  bool get isOpen => const {
        AdRequestStatus.submitted,
        AdRequestStatus.awaitingInfluencer,
        AdRequestStatus.influencerReplied,
        AdRequestStatus.clientReviewing,
        AdRequestStatus.clientReplied,
      }.contains(this);
}

class AdAttachment extends Equatable {
  const AdAttachment({
    required this.id,
    required this.purpose,
    this.fileName = '',
    this.downloadUrl = '',
  });

  final int id;
  final AttachmentPurpose purpose;
  final String fileName;
  final String downloadUrl;

  @override
  List<Object?> get props => [id, purpose, fileName, downloadUrl];
}

class PendingModification extends Equatable {
  const PendingModification({this.message = '', this.proposedBudget, this.createdAt});

  final String message;
  final double? proposedBudget;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [message, proposedBudget, createdAt];
}

class AdClient extends Equatable {
  const AdClient({
    this.companyId = 0,
    this.name = '',
    this.address = '',
    this.isVerified = false,
    this.successfulDeals = 0,
  });

  final int companyId;
  final String name;
  final String address;
  final bool isVerified;
  final int successfulDeals;

  @override
  List<Object?> get props => [companyId, name, address, isVerified, successfulDeals];
}

class AdBrief extends Equatable {
  const AdBrief({
    this.requiresTravel = false,
    this.travelAddress = '',
    this.presenceRequirements = '',
    this.entryMode,
    this.mediaType,
    this.contentSource,
    this.sampleRequired,
    this.details = '',
    this.needsPlatformServices = false,
    this.formats = const [],
    this.platforms = const [],
    this.budget,
    this.publishDeadline,
  });

  final bool requiresTravel;
  final String travelAddress;
  final String presenceRequirements;
  final EntryMode? entryMode;
  final MediaType? mediaType;
  final ContentSource? contentSource;
  final bool? sampleRequired;
  final String details;
  final bool needsPlatformServices;
  final List<AdFormat> formats;
  final List<AdPlatform> platforms;
  final double? budget;
  final DateTime? publishDeadline;

  bool get needsReadyContent =>
      !requiresTravel && entryMode == EntryMode.template && contentSource == ContentSource.ready;

  @override
  List<Object?> get props => [
        requiresTravel,
        travelAddress,
        presenceRequirements,
        entryMode,
        mediaType,
        contentSource,
        sampleRequired,
        details,
        needsPlatformServices,
        formats,
        platforms,
        budget,
        publishDeadline,
      ];
}

class AdRequest extends Equatable {
  const AdRequest({
    required this.id,
    required this.code,
    required this.brief,
    required this.status,
    this.influencerName = '',
    this.influencerProfileId,
    this.client,
    this.currency = 'DZD',
    this.submittedAt,
    this.forwardedAt,
    this.agreedAt,
    this.rejectedAt,
    this.rejectedBy = AdParty.unknown,
    this.rejectionReason = '',
    this.attachments = const [],
    this.pendingModification,
    this.createdAt,
  });

  final int id;
  final String code;
  final AdBrief brief;
  final AdRequestStatus status;
  final String influencerName;
  final int? influencerProfileId;
  final AdClient? client;
  final String currency;
  final DateTime? submittedAt;
  final DateTime? forwardedAt;
  final DateTime? agreedAt;
  final DateTime? rejectedAt;
  final AdParty rejectedBy;
  final String rejectionReason;
  final List<AdAttachment> attachments;
  final PendingModification? pendingModification;
  final DateTime? createdAt;

  bool get isDraft => status == AdRequestStatus.draft;

  List<AdAttachment> attachmentsFor(AttachmentPurpose purpose) =>
      [for (final a in attachments) if (a.purpose == purpose) a];

  @override
  List<Object?> get props => [
        id,
        code,
        brief,
        status,
        influencerName,
        influencerProfileId,
        client,
        currency,
        submittedAt,
        forwardedAt,
        agreedAt,
        rejectedAt,
        rejectedBy,
        rejectionReason,
        attachments,
        pendingModification,
        createdAt,
      ];
}

class AdEvent extends Equatable {
  const AdEvent({
    required this.id,
    required this.action,
    required this.party,
    this.message = '',
    this.proposedBudget,
    this.createdAt,
  });

  final int id;
  final AdEventAction action;
  final AdParty party;
  final String message;
  final double? proposedBudget;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, action, party, message, proposedBudget, createdAt];
}

class InfluencerTabCounts extends Equatable {
  const InfluencerTabCounts({this.requested = 0, this.discussing = 0});

  final int requested;
  final int discussing;

  int of(InfluencerTab tab) => switch (tab) {
        InfluencerTab.requested => requested,
        InfluencerTab.discussing => discussing,
      };

  @override
  List<Object?> get props => [requested, discussing];
}

class AdRequestBundle extends Equatable {
  const AdRequestBundle({required this.request, this.events = const []});

  final AdRequest request;
  final List<AdEvent> events;

  @override
  List<Object?> get props => [request, events];
}
