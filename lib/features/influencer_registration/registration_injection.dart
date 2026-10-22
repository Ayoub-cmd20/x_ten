import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/influencer_registration/data/registration_remote_data_source.dart';
import 'package:x_ten/features/influencer_registration/data/registration_repository_impl.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_repository.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';

void initRegistrationFeature() {
  sl
    ..registerLazySingleton<RegistrationRemoteDataSource>(() => RegistrationRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<RegistrationRepository>(() => RegistrationRepositoryImpl(sl()))
    ..registerLazySingleton(() => LoadCurrentRegistrationUseCase(sl()))
    ..registerLazySingleton(() => SaveSectionUseCase(sl()))
    ..registerLazySingleton(() => StartNewAttemptUseCase(sl()))
    ..registerLazySingleton(() => SubmitRegistrationUseCase(sl()))
    ..registerLazySingleton(() => UploadProfileImageUseCase(sl()))
    ..registerLazySingleton(() => DeleteProfileImageUseCase(sl()))
    ..registerLazySingleton(() => AddSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => UpdateSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => RefreshSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => DeleteSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => AddPortfolioItemUseCase(sl()))
    ..registerLazySingleton(() => DeletePortfolioItemUseCase(sl()))
    ..registerLazySingleton(() => AddFinancialAccountUseCase(sl()))
    ..registerLazySingleton(() => DeleteFinancialAccountUseCase(sl()))
    ..registerLazySingleton(() => UploadDocumentUseCase(sl()))
    ..registerLazySingleton(() => DeleteDocumentUseCase(sl()))
    ..registerLazySingleton(() => CreateDraftRegistrationUseCase(sl()))
    ..registerLazySingleton(() => ReadFinancialDocumentUseCase(sl()))
    ..registerLazySingleton(() => ApplySocialScreenshotUseCase(sl()))
    ..registerLazySingleton(() => ScanAudienceUseCase(sl()))
    ..registerFactory(
      () => RegistrationCubit(
        loadCurrent: sl(),
        saveSection: sl(),
        startNewAttempt: sl(),
        submit: sl(),
        uploadPhoto: sl(),
        deletePhoto: sl(),
        addSocial: sl(),
        updateSocial: sl(),
        refreshSocial: sl(),
        deleteSocial: sl(),
        addPortfolio: sl(),
        deletePortfolio: sl(),
        addFinancial: sl(),
        deleteFinancial: sl(),
        uploadDocument: sl(),
        deleteDocument: sl(),
        createDraft: sl(),
        readFinancial: sl(),
        socialScreenshot: sl(),
        scanAudience: sl(),
        getCurrentUser: sl(),
      ),
    );
}
