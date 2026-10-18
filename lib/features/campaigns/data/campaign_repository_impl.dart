import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/campaigns/data/campaign_models.dart';
import 'package:x_ten/features/campaigns/data/campaign_remote_data_source.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/features/campaigns/domain/campaign_repository.dart';

class AdRequestRepositoryImpl implements AdRequestRepository {
  const AdRequestRepositoryImpl(this._remote);

  final CampaignRemoteDataSource _remote;

  @override
  Future<Result<Paginated<AdRequest>>> list({AdRequestStatus? status, int page = 1}) =>
      guard(() => _remote.getAdRequests(status: status, page: page));

  @override
  Future<Result<AdRequestBundle>> details(int id) => guard(() async {
        final request = await _remote.getAdRequest(id);
        final events = await _remote.getAdRequestEvents(id);
        return AdRequestBundle(request: request, events: events);
      });

  @override
  Future<Result<AdRequest>> create(int influencerProfileId, AdBrief brief) =>
      guard(() => _remote.createAdRequest(CampaignJson.create(influencerProfileId, brief)));

  @override
  Future<Result<AdRequest>> update(int id, AdBrief brief) =>
      guard(() => _remote.updateAdRequest(id, CampaignJson.brief(brief)));

  @override
  Future<Result<void>> delete(int id) => guard(() => _remote.deleteAdRequest(id));

  @override
  Future<Result<AdAttachment>> uploadAttachment(int id, AttachmentPurpose purpose, UploadFile file) =>
      guard(() => _remote.uploadAttachment(id, purpose, file));

  @override
  Future<Result<void>> deleteAttachment(int attachmentId) => guard(() => _remote.deleteAttachment(attachmentId));

  @override
  Future<Result<AdRequest>> submit(int id) => guard(() => _remote.postAction(ApiEndpoints.adRequestSubmit(id)));

  @override
  Future<Result<AdRequest>> reject(int id, String reason) =>
      guard(() => _remote.postAction(ApiEndpoints.adRequestReject(id), CampaignJson.reason(reason)));

  @override
  Future<Result<AdRequest>> acceptModification(int id, String message) => guard(
        () => _remote.postAction(ApiEndpoints.adRequestAcceptModification(id), CampaignJson.message(message)),
      );

  @override
  Future<Result<AdRequest>> refuseModification(int id, String message) => guard(
        () => _remote.postAction(ApiEndpoints.adRequestRefuseModification(id), CampaignJson.message(message)),
      );
}

class InfluencerRequestRepositoryImpl implements InfluencerRequestRepository {
  const InfluencerRequestRepositoryImpl(this._remote);

  final CampaignRemoteDataSource _remote;

  @override
  Future<Result<InfluencerTabCounts>> tabs() => guard(_remote.getInfluencerTabs);

  @override
  Future<Result<Paginated<AdRequest>>> list({required InfluencerTab tab, int page = 1}) =>
      guard(() => _remote.getInfluencerRequests(tab: tab, page: page));

  @override
  Future<Result<AdRequestBundle>> details(int id) => guard(() async {
        final request = await _remote.getInfluencerRequest(id);
        final events = await _remote.getInfluencerRequestEvents(id);
        return AdRequestBundle(request: request, events: events);
      });

  @override
  Future<Result<AdRequest>> accept(int id, String message) =>
      guard(() => _remote.postAction(ApiEndpoints.influencerRequestAccept(id), CampaignJson.message(message)));

  @override
  Future<Result<AdRequest>> counterOffer(int id, String message, double? proposedBudget) => guard(
        () => _remote.postAction(
          ApiEndpoints.influencerRequestCounterOffer(id),
          CampaignJson.counterOffer(message, proposedBudget),
        ),
      );

  @override
  Future<Result<AdRequest>> markUnclear(int id, String message) =>
      guard(() => _remote.postAction(ApiEndpoints.influencerRequestUnclear(id), CampaignJson.message(message)));

  @override
  Future<Result<AdRequest>> decline(int id, String reason) =>
      guard(() => _remote.postAction(ApiEndpoints.influencerRequestDecline(id), CampaignJson.reason(reason)));
}
