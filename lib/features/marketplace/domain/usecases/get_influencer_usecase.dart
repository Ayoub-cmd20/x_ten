import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/marketplace/domain/entities/market_influencer.dart';
import 'package:x_ten/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetInfluencerUseCase implements UseCase<MarketInfluencer, int> {
  const GetInfluencerUseCase(this._repository);

  final MarketplaceRepository _repository;

  @override
  Future<Result<MarketInfluencer>> call(int id) => _repository.influencer(id);
}
