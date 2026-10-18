import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/auth/data/auth_remote_data_source.dart';
import 'package:x_ten/features/auth/data/auth_repository_impl.dart';
import 'package:x_ten/features/auth/domain/auth_repository.dart';
import 'package:x_ten/features/auth/domain/auth_usecases.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';

void initAuthFeature() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remote: sl(), tokens: sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => VerifyPhoneUseCase(sl()))
    ..registerLazySingleton(() => ResendOtpUseCase(sl()))
    ..registerLazySingleton(() => SelectRoleUseCase(sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RequestPasswordResetUseCase(sl()))
    ..registerLazySingleton(() => ConfirmPasswordResetUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerLazySingleton(() => CheckSessionUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(
      () => AuthCubit(
        register: sl(),
        verifyPhone: sl(),
        resendOtp: sl(),
        selectRole: sl(),
        login: sl(),
        requestPasswordReset: sl(),
        confirmPasswordReset: sl(),
        getCurrentUser: sl(),
        checkSession: sl(),
        logout: sl(),
        session: sl(),
      ),
    );
}
