import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:x_ten/core/localization/locale_cubit.dart';
import 'package:x_ten/core/network/api_consumer.dart';
import 'package:x_ten/core/network/dio_consumer.dart';
import 'package:x_ten/core/network/dio_factory.dart';
import 'package:x_ten/core/session/session_notifier.dart';
import 'package:x_ten/core/storage/app_preferences.dart';
import 'package:x_ten/core/storage/token_storage.dart';
import 'package:x_ten/features/auth/auth_injection.dart';
import 'package:x_ten/features/company_profile/company_injection.dart';
import 'package:x_ten/features/influencer_registration/registration_injection.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final preferences = await SharedAppPreferences.create();
  final tokenStorage = SecureTokenStorage(const FlutterSecureStorage());

  if (preferences.isFirstLaunch) {
    await tokenStorage.clear();
    await preferences.markLaunched();
  }
  await tokenStorage.init();

  sl
    ..registerSingleton<AppPreferences>(preferences)
    ..registerSingleton<TokenStorage>(tokenStorage)
    ..registerLazySingleton<SessionNotifier>(SessionNotifier.new)
    ..registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()))
    ..registerLazySingleton<Dio>(
      () => DioFactory.create(storage: sl(), session: sl(), preferences: sl()),
    )
    ..registerLazySingleton<ApiConsumer>(() => DioConsumer(sl()));

  initAuthFeature();
  initRegistrationFeature();
  initCompanyFeature();
}
