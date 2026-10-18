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
    ..registerLazySingleton(() => CreateRegistrationUseCase(sl()))
    ..registerLazySingleton(() => StartNewAttemptUseCase(sl()))
    ..registerLazySingleton(() => UpdateBasicInfoUseCase(sl()))
    ..registerLazySingleton(() => UpdateProfileUseCase(sl()))
    ..registerLazySingleton(() => UpdateFinancialUseCase(sl()))
    ..registerLazySingleton(() => SubmitRegistrationUseCase(sl()))
    ..registerLazySingleton(() => UploadProfileImageUseCase(sl()))
    ..registerLazySingleton(() => DeleteProfileImageUseCase(sl()))
    ..registerLazySingleton(() => AddSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => DeleteSocialAccountUseCase(sl()))
    ..registerLazySingleton(() => AddPortfolioItemUseCase(sl()))
    ..registerLazySingleton(() => DeletePortfolioItemUseCase(sl()))
    ..registerLazySingleton(() => UploadDocumentUseCase(sl()))
    ..registerLazySingleton(() => DeleteDocumentUseCase(sl()))
    ..registerFactory(
      () => RegistrationCubit(
        loadCurrent: sl(),
        create: sl(),
        startNewAttempt: sl(),
        updateBasic: sl(),
        updateProfile: sl(),
        updateFinancial: sl(),
        submit: sl(),
        uploadPhoto: sl(),
        deletePhoto: sl(),
        addSocial: sl(),
        deleteSocial: sl(),
        addPortfolio: sl(),
        deletePortfolio: sl(),
        uploadDocument: sl(),
        deleteDocument: sl(),
        getCurrentUser: sl(),
      ),
    );
}
