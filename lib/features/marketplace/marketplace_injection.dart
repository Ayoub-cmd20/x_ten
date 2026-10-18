import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/marketplace/data/marketplace_remote_data_source.dart';
import 'package:x_ten/features/marketplace/data/marketplace_repository_impl.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_repository.dart';
import 'package:x_ten/features/marketplace/domain/marketplace_usecases.dart';
import 'package:x_ten/features/marketplace/presentation/marketplace_cubit.dart';

void initMarketplaceFeature() {
  sl
    ..registerLazySingleton<MarketplaceRemoteDataSource>(() => MarketplaceRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<MarketplaceRepository>(() => MarketplaceRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetInfluencersUseCase(sl()))
    ..registerLazySingleton(() => GetInfluencerUseCase(sl()))
    ..registerFactory(() => MarketplaceCubit(getInfluencers: sl(), getInfluencer: sl()));
}
