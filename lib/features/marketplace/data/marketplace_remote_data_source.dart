import 'package:x_ten/core/constants/api_endpoints.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/features/marketplace/data/marketplace_models.dart';

abstract interface class MarketplaceRemoteDataSource {
  Future<Paginated<MarketInfluencerModel>> getInfluencers({String? category, String search = '', int page = 1});

  Future<MarketInfluencerModel> getInfluencer(int id);
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  const MarketplaceRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<Paginated<MarketInfluencerModel>> getInfluencers({String? category, String search = '', int page = 1}) async {
    final data = await _api.get(
      ApiEndpoints.marketplaceInfluencers,
      query: {
        ApiKeys.category: ?category,
        if (search.isNotEmpty) ApiKeys.search: search,
        ApiKeys.page: page,
      },
    );
    return switch (data) {
      final List list => Paginated(
          count: list.length,
          items: [for (final item in list) MarketInfluencerModel.fromJson(item as Json)],
        ),
      final Json json => parsePaginated(json, MarketInfluencerModel.fromJson),
      _ => const Paginated.empty(),
    };
  }

  @override
  Future<MarketInfluencerModel> getInfluencer(int id) async =>
      MarketInfluencerModel.fromJson(await _api.get(ApiEndpoints.marketplaceInfluencer(id)) as Json);
}
