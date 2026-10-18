import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';

abstract interface class AdRequestRepository {
  Future<Result<Paginated<AdRequest>>> list({AdRequestStatus? status, int page = 1});

  Future<Result<AdRequestBundle>> details(int id);

  Future<Result<AdRequest>> create(int influencerProfileId, AdBrief brief);

  Future<Result<AdRequest>> update(int id, AdBrief brief);

  Future<Result<void>> delete(int id);

  Future<Result<AdAttachment>> uploadAttachment(int id, AttachmentPurpose purpose, UploadFile file);

  Future<Result<void>> deleteAttachment(int attachmentId);

  Future<Result<AdRequest>> submit(int id);

  Future<Result<AdRequest>> reject(int id, String reason);

  Future<Result<AdRequest>> acceptModification(int id, String message);

  Future<Result<AdRequest>> refuseModification(int id, String message);
}

abstract interface class InfluencerRequestRepository {
  Future<Result<InfluencerTabCounts>> tabs();

  Future<Result<Paginated<AdRequest>>> list({required InfluencerTab tab, int page = 1});

  Future<Result<AdRequestBundle>> details(int id);

  Future<Result<AdRequest>> accept(int id, String message);

  Future<Result<AdRequest>> counterOffer(int id, String message, double? proposedBudget);

  Future<Result<AdRequest>> markUnclear(int id, String message);

  Future<Result<AdRequest>> decline(int id, String reason);
}
