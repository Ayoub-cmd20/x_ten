import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:x_ten/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:x_ten/features/auth/domain/repositories/auth_repository.dart';
import 'package:x_ten/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/login_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/logout_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/register_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/select_role_usecase.dart';
import 'package:x_ten/features/auth/domain/usecases/verify_phone_usecase.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';

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
