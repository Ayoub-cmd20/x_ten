import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/storage/app_preferences.dart';

class OnboardingCubit extends Cubit<bool> {
  OnboardingCubit(this._prefs) : super(_prefs.hasSeenOnboarding);

  final AppPreferences _prefs;

  bool get completed => state;

  Future<void> complete() async {
    await _prefs.markOnboardingSeen();
    emit(true);
  }
}
