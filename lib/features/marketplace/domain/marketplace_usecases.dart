import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_entities.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_repository.dart';

typedef InfluencersParams = ({String? category, String search, int page});

class GetInfluencersUseCase implements UseCase<Paginated<MarketInfluencer>, InfluencersParams> {
  const GetInfluencersUseCase(this._repository);

  final MarketplaceRepository _repository;

  @override
  Future<Result<Paginated<MarketInfluencer>>> call(InfluencersParams params) => _repository.influencers(
        category: params.category,
        search: params.search.trim(),
        page: params.page,
      );
}

class GetInfluencerUseCase implements UseCase<MarketInfluencer, int> {
  const GetInfluencerUseCase(this._repository);

  final MarketplaceRepository _repository;

  @override
  Future<Result<MarketInfluencer>> call(int id) => _repository.influencer(id);
}
