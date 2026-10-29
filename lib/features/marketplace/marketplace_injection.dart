import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/marketplace/data/datasources/marketplace_remote_data_source.dart';
import 'package:x_ten/features/marketplace/data/repositories/marketplace_repository_impl.dart';
import 'package:x_ten/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:x_ten/features/marketplace/domain/usecases/get_influencer_usecase.dart';
import 'package:x_ten/features/marketplace/domain/usecases/get_influencers_usecase.dart';
import 'package:x_ten/features/marketplace/presentation/cubit/marketplace_cubit.dart';

void initMarketplaceFeature() {
  sl
    ..registerLazySingleton<MarketplaceRemoteDataSource>(() => MarketplaceRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<MarketplaceRepository>(() => MarketplaceRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetInfluencersUseCase(sl()))
    ..registerLazySingleton(() => GetInfluencerUseCase(sl()))
    ..registerFactory(() => MarketplaceCubit(getInfluencers: sl(), getInfluencer: sl()));
}
