import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/company_profile/data/company_remote_data_source.dart';
import 'package:x_ten/features/company_profile/data/company_repository_impl.dart';
import 'package:x_ten/features/company_profile/domain/company_repository.dart';
import 'package:x_ten/features/company_profile/domain/company_usecases.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';

void initCompanyFeature() {
  sl
    ..registerLazySingleton<CompanyRemoteDataSource>(() => CompanyRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl(sl()))
    ..registerLazySingleton(() => LoadCompanyUseCase(sl()))
    ..registerLazySingleton(() => SaveBusinessTypeUseCase(sl()))
    ..registerLazySingleton(() => SaveCompanySectionUseCase(sl()))
    ..registerLazySingleton(() => UploadCompanyPhotoUseCase(sl()))
    ..registerLazySingleton(() => DeleteCompanyPhotoUseCase(sl()))
    ..registerLazySingleton(() => UploadCompanyDocumentUseCase(sl()))
    ..registerLazySingleton(() => DeleteCompanyDocumentUseCase(sl()))
    ..registerLazySingleton(() => AddCompanyFinancialAccountUseCase(sl()))
    ..registerLazySingleton(() => DeleteCompanyFinancialAccountUseCase(sl()))
    ..registerLazySingleton(() => ReadCompanyFinancialDocumentUseCase(sl()))
    ..registerLazySingleton(() => ReadMarketingScreenshotUseCase(sl()))
    ..registerLazySingleton(() => SubmitCompanyUseCase(sl()))
    ..registerFactory(
      () => CompanyCubit(
        load: sl(),
        saveType: sl(),
        saveSection: sl(),
        uploadPhoto: sl(),
        deletePhoto: sl(),
        uploadDocument: sl(),
        deleteDocument: sl(),
        addFinancial: sl(),
        deleteFinancial: sl(),
        readFinancial: sl(),
        readMarketing: sl(),
        submit: sl(),
      ),
    );
}
