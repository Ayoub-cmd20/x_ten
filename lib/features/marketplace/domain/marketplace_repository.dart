import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_entities.dart';

abstract interface class MarketplaceRepository {
  Future<Result<Paginated<MarketInfluencer>>> influencers({String? category, String search = '', int page = 1});

  Future<Result<MarketInfluencer>> influencer(int id);
}
