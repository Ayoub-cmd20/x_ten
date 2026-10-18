import 'package:dio/dio.dart';
import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/features/campaigns/data/campaign_models.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';

Paginated<T> _page<T>(Object? data, T Function(Json json) item) => switch (data) {
      final List list => Paginated(count: list.length, items: [for (final e in list) item(e as Json)]),
      final Json json => parsePaginated(json, item),
      _ => const Paginated.empty(),
    };

List<AdEventModel> _events(Object? data) => [
      for (final item in switch (data) {
        final List list => list,
        {ApiKeys.results: final List results} => results,
        _ => const <Object?>[],
      })
        AdEventModel.fromJson(item as Json),
    ];

abstract interface class CampaignRemoteDataSource {
  Future<Paginated<AdRequestModel>> getAdRequests({AdRequestStatus? status, int page = 1});

  Future<AdRequestModel> getAdRequest(int id);

  Future<List<AdEventModel>> getAdRequestEvents(int id);

  Future<AdRequestModel> createAdRequest(Json body);

  Future<AdRequestModel> updateAdRequest(int id, Json body);

  Future<void> deleteAdRequest(int id);

  Future<AdAttachmentModel> uploadAttachment(int id, AttachmentPurpose purpose, UploadFile file);

  Future<void> deleteAttachment(int attachmentId);

  Future<AdRequestModel> postAction(String path, [Json? body]);

  Future<InfluencerTabCountsModel> getInfluencerTabs();

  Future<Paginated<AdRequestModel>> getInfluencerRequests({required InfluencerTab tab, int page = 1});

  Future<AdRequestModel> getInfluencerRequest(int id);

  Future<List<AdEventModel>> getInfluencerRequestEvents(int id);
}

class CampaignRemoteDataSourceImpl implements CampaignRemoteDataSource {
  const CampaignRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<Paginated<AdRequestModel>> getAdRequests({AdRequestStatus? status, int page = 1}) async => _page(
        await _api.get(ApiEndpoints.adRequests, query: {ApiKeys.status: ?status?.name, ApiKeys.page: page}),
        AdRequestModel.fromJson,
      );

  @override
  Future<AdRequestModel> getAdRequest(int id) async =>
      AdRequestModel.fromJson(await _api.get(ApiEndpoints.adRequest(id)) as Json);

  @override
  Future<List<AdEventModel>> getAdRequestEvents(int id) async =>
      _events(await _api.get(ApiEndpoints.adRequestEvents(id)));

  @override
  Future<AdRequestModel> createAdRequest(Json body) async =>
      AdRequestModel.fromJson(await _api.post(ApiEndpoints.adRequests, data: body) as Json);

  @override
  Future<AdRequestModel> updateAdRequest(int id, Json body) async =>
      AdRequestModel.fromJson(await _api.patch(ApiEndpoints.adRequest(id), data: body) as Json);

  @override
  Future<void> deleteAdRequest(int id) => _api.delete(ApiEndpoints.adRequest(id));

  @override
  Future<AdAttachmentModel> uploadAttachment(int id, AttachmentPurpose purpose, UploadFile file) async {
    final form = FormData.fromMap({
      ApiKeys.purpose: purpose.name,
      ApiKeys.file: await MultipartFile.fromFile(file.path, filename: file.name),
    });
    return AdAttachmentModel.fromJson(await _api.post(ApiEndpoints.adRequestAttachments(id), data: form) as Json);
  }

  @override
  Future<void> deleteAttachment(int attachmentId) => _api.delete(ApiEndpoints.adRequestAttachment(attachmentId));

  @override
  Future<AdRequestModel> postAction(String path, [Json? body]) async =>
      AdRequestModel.fromJson(await _api.post(path, data: body ?? const <String, dynamic>{}) as Json);

  @override
  Future<InfluencerTabCountsModel> getInfluencerTabs() async =>
      InfluencerTabCountsModel.fromJson(await _api.get(ApiEndpoints.influencerRequestTabs) as Json);

  @override
  Future<Paginated<AdRequestModel>> getInfluencerRequests({required InfluencerTab tab, int page = 1}) async => _page(
        await _api.get(ApiEndpoints.influencerRequests, query: {ApiKeys.tab: tab.name, ApiKeys.page: page}),
        AdRequestModel.fromJson,
      );

  @override
  Future<AdRequestModel> getInfluencerRequest(int id) async =>
      AdRequestModel.fromJson(await _api.get(ApiEndpoints.influencerRequest(id)) as Json);

  @override
  Future<List<AdEventModel>> getInfluencerRequestEvents(int id) async =>
      _events(await _api.get(ApiEndpoints.influencerRequestEvents(id)));
}
