import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/campaigns/data/campaign_remote_data_source.dart';
import 'package:x_ten/features/campaigns/data/campaign_repository_impl.dart';
import 'package:x_ten/features/campaigns/domain/campaign_repository.dart';
import 'package:x_ten/features/campaigns/domain/campaign_usecases.dart';
import 'package:x_ten/features/campaigns/presentation/ad_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/influencer_requests_cubit.dart';

void initCampaignsFeature() {
  sl
    ..registerLazySingleton<CampaignRemoteDataSource>(() => CampaignRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<AdRequestRepository>(() => AdRequestRepositoryImpl(sl()))
    ..registerLazySingleton<InfluencerRequestRepository>(() => InfluencerRequestRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetAdRequestsUseCase(sl()))
    ..registerLazySingleton(() => GetAdRequestUseCase(sl()))
    ..registerLazySingleton(() => SaveAdDraftUseCase(sl()))
    ..registerLazySingleton(() => UploadAdAttachmentUseCase(sl()))
    ..registerLazySingleton(() => SubmitAdRequestUseCase(sl()))
    ..registerLazySingleton(() => DeleteAdDraftUseCase(sl()))
    ..registerLazySingleton(() => RejectAdRequestUseCase(sl()))
    ..registerLazySingleton(() => ReplyToModificationUseCase(sl()))
    ..registerLazySingleton(() => GetInfluencerTabsUseCase(sl()))
    ..registerLazySingleton(() => GetInfluencerRequestsUseCase(sl()))
    ..registerLazySingleton(() => GetInfluencerRequestUseCase(sl()))
    ..registerLazySingleton(() => ReplyToRequestUseCase(sl()))
    ..registerFactory(
      () => AdRequestsCubit(
        getRequests: sl(),
        getRequest: sl(),
        saveDraft: sl(),
        uploadAttachment: sl(),
        submit: sl(),
        deleteDraft: sl(),
        reject: sl(),
        replyModification: sl(),
      ),
    )
    ..registerFactory(
      () => InfluencerRequestsCubit(
        getTabs: sl(),
        getRequests: sl(),
        getRequest: sl(),
        reply: sl(),
      ),
    );
}
