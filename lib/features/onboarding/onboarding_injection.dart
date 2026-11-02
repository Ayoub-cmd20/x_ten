import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/features/onboarding/presentation/cubit/onboarding_cubit.dart';

void initOnboardingFeature() {
  sl.registerLazySingleton<OnboardingCubit>(() => OnboardingCubit(sl()));
}
