import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';

typedef Json = Map<String, dynamic>;

String _string(Object? value) => value as String? ?? '';

int _int(Object? value) => switch (value) {
      final int number => number,
      final String text => int.tryParse(text) ?? 0,
      _ => 0,
    };

double? _double(Object? value) => switch (value) {
      final num number => number.toDouble(),
      final String text => double.tryParse(text),
      _ => null,
    };

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value)?.toLocal() : null;

T? _enum<T extends Enum>(List<T> values, Object? value) => values.where((e) => e.name == value).firstOrNull;

List<T> _enums<T extends Enum>(List<T> values, Object? list) => [
      for (final item in list as List? ?? const []) ?_enum(values, item),
    ];

String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

abstract final class CampaignJson {
  static Json brief(AdBrief brief) => {
        ApiKeys.requiresTravel: brief.requiresTravel,
        ApiKeys.travelAddress: brief.travelAddress,
        ApiKeys.presenceRequirements: brief.presenceRequirements,
        ApiKeys.entryMode: brief.entryMode?.name ?? '',
        ApiKeys.mediaType: brief.mediaType?.name ?? '',
        ApiKeys.contentSource: brief.contentSource?.name ?? '',
        ApiKeys.sampleRequired: brief.sampleRequired,
        ApiKeys.details: brief.details,
        ApiKeys.needsPlatformServices: brief.needsPlatformServices,
        ApiKeys.formats: [for (final f in brief.formats) f.name],
        ApiKeys.platforms: [for (final p in brief.platforms) p.name],
        ApiKeys.budgetAmount: brief.budget?.toStringAsFixed(2),
        ApiKeys.publishDeadline: switch (brief.publishDeadline) {
          final date? => _formatDate(date),
          null => null,
        },
      };

  static Json create(int influencerProfileId, AdBrief brief) => {
        ApiKeys.influencerProfileId: influencerProfileId,
        ...CampaignJson.brief(brief),
      };

  static Json message(String message) => {ApiKeys.message: message};

  static Json reason(String reason) => {ApiKeys.reason: reason};

  static Json counterOffer(String message, double? budget) => {
        ApiKeys.message: message,
        ApiKeys.proposedBudget: ?budget?.toStringAsFixed(2),
      };
}

class AdAttachmentModel extends AdAttachment {
  const AdAttachmentModel({required super.id, required super.purpose, super.fileName, super.downloadUrl});

  factory AdAttachmentModel.fromJson(Json json) => AdAttachmentModel(
        id: _int(json[ApiKeys.id]),
        purpose: _enum(AttachmentPurpose.values, json[ApiKeys.purpose]) ?? AttachmentPurpose.brief,
        fileName: _string(json[ApiKeys.fileName]),
        downloadUrl: _string(json[ApiKeys.downloadUrl]),
      );
}

class AdRequestModel extends AdRequest {
  const AdRequestModel({
    required super.id,
    required super.code,
    required super.brief,
    required super.status,
    super.influencerName,
    super.influencerProfileId,
    super.client,
    super.currency,
    super.submittedAt,
    super.forwardedAt,
    super.agreedAt,
    super.rejectedAt,
    super.rejectedBy,
    super.rejectionReason,
    super.attachments,
    super.pendingModification,
    super.createdAt,
  });

  factory AdRequestModel.fromJson(Json json) {
    final influencer = json[ApiKeys.influencer] as Json?;
    final client = json[ApiKeys.client] as Json?;
    final modification = json[ApiKeys.pendingModification] as Json?;

    return AdRequestModel(
      id: _int(json[ApiKeys.id]),
      code: _string(json[ApiKeys.code]),
      status: _enum(AdRequestStatus.values, json[ApiKeys.status]) ?? AdRequestStatus.unknown,
      brief: AdBrief(
        requiresTravel: json[ApiKeys.requiresTravel] as bool? ?? false,
        travelAddress: _string(json[ApiKeys.travelAddress]),
        presenceRequirements: _string(json[ApiKeys.presenceRequirements]),
        entryMode: _enum(EntryMode.values, json[ApiKeys.entryMode]),
        mediaType: _enum(MediaType.values, json[ApiKeys.mediaType]),
        contentSource: _enum(ContentSource.values, json[ApiKeys.contentSource]),
        sampleRequired: json[ApiKeys.sampleRequired] as bool?,
        details: _string(json[ApiKeys.details]),
        needsPlatformServices: json[ApiKeys.needsPlatformServices] as bool? ?? false,
        formats: _enums(AdFormat.values, json[ApiKeys.formats]),
        platforms: _enums(AdPlatform.values, json[ApiKeys.platforms]),
        budget: _double(json[ApiKeys.budgetAmount]),
        publishDeadline: _date(json[ApiKeys.publishDeadline]),
      ),
      influencerName: _string(influencer?[ApiKeys.name]),
      influencerProfileId: influencer?[ApiKeys.profileId] as int?,
      client: client == null
          ? null
          : AdClient(
              companyId: _int(client[ApiKeys.companyId]),
              name: _string(client[ApiKeys.name]),
              address: _string(client[ApiKeys.address]),
              isVerified: client[ApiKeys.verificationStatus] == 'verified',
              successfulDeals: _int(client[ApiKeys.successfulDeals]),
            ),
      currency: json[ApiKeys.currency] as String? ?? 'DZD',
      submittedAt: _date(json[ApiKeys.submittedAt]),
      forwardedAt: _date(json[ApiKeys.forwardedAt]),
      agreedAt: _date(json[ApiKeys.agreedAt]),
      rejectedAt: _date(json[ApiKeys.rejectedAt]),
      rejectedBy: _enum(AdParty.values, json[ApiKeys.rejectedBy]) ?? AdParty.unknown,
      rejectionReason: _string(json[ApiKeys.rejectionReason]),
      attachments: [
        for (final item in json[ApiKeys.attachments] as List? ?? const []) AdAttachmentModel.fromJson(item as Json),
      ],
      pendingModification: modification == null
          ? null
          : PendingModification(
              message: _string(modification[ApiKeys.message]),
              proposedBudget: _double(modification[ApiKeys.proposedBudget]),
              createdAt: _date(modification[ApiKeys.createdAt]),
            ),
      createdAt: _date(json[ApiKeys.createdAt]),
    );
  }
}

class AdEventModel extends AdEvent {
  const AdEventModel({
    required super.id,
    required super.action,
    required super.party,
    super.message,
    super.proposedBudget,
    super.createdAt,
  });

  factory AdEventModel.fromJson(Json json) => AdEventModel(
        id: _int(json[ApiKeys.id]),
        action: _enum(AdEventAction.values, json[ApiKeys.action]) ?? AdEventAction.unknown,
        party: _enum(AdParty.values, json[ApiKeys.actorParty]) ?? AdParty.unknown,
        message: _string(json[ApiKeys.message]),
        proposedBudget: _double(json[ApiKeys.proposedBudget]),
        createdAt: _date(json[ApiKeys.createdAt]),
      );
}

class InfluencerTabCountsModel extends InfluencerTabCounts {
  const InfluencerTabCountsModel({super.requested, super.discussing});

  factory InfluencerTabCountsModel.fromJson(Json json) => InfluencerTabCountsModel(
        requested: _int(json[ApiKeys.requested]),
        discussing: _int(json[ApiKeys.discussing]),
      );
}
