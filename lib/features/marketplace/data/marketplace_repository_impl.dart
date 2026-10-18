import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/marketplace/data/marketplace_remote_data_source.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_entities.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  const MarketplaceRepositoryImpl(this._remote);

  final MarketplaceRemoteDataSource _remote;

  @override
  Future<Result<Paginated<MarketInfluencer>>> influencers({String? category, String search = '', int page = 1}) =>
      guard(() => _remote.getInfluencers(category: category, search: search, page: page));

  @override
  Future<Result<MarketInfluencer>> influencer(int id) => guard(() => _remote.getInfluencer(id));
}
