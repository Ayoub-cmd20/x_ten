import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/constants/app_constants.dart';
import 'package:x_ten/core/enums/role.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/session/session_notifier.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/auth_entities.dart';
import 'package:x_ten/features/auth/domain/auth_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RegisterUseCase register,
    required VerifyPhoneUseCase verifyPhone,
    required ResendOtpUseCase resendOtp,
    required SelectRoleUseCase selectRole,
    required LoginUseCase login,
    required RequestPasswordResetUseCase requestPasswordReset,
    required ConfirmPasswordResetUseCase confirmPasswordReset,
    required GetCurrentUserUseCase getCurrentUser,
    required CheckSessionUseCase checkSession,
    required LogoutUseCase logout,
    required SessionNotifier session,
  })  : _register = register,
        _verifyPhone = verifyPhone,
        _resendOtp = resendOtp,
        _selectRole = selectRole,
        _login = login,
        _requestPasswordReset = requestPasswordReset,
        _confirmPasswordReset = confirmPasswordReset,
        _getCurrentUser = getCurrentUser,
        _checkSession = checkSession,
        _logout = logout,
        super(const AuthState()) {
    _sessionSubscription = session.stream.listen(_onSessionEnded);
  }

  final RegisterUseCase _register;
  final VerifyPhoneUseCase _verifyPhone;
  final ResendOtpUseCase _resendOtp;
  final SelectRoleUseCase _selectRole;
  final LoginUseCase _login;
  final RequestPasswordResetUseCase _requestPasswordReset;
  final ConfirmPasswordResetUseCase _confirmPasswordReset;
  final GetCurrentUserUseCase _getCurrentUser;
  final CheckSessionUseCase _checkSession;
  final LogoutUseCase _logout;
  late final StreamSubscription<SessionEndReason> _sessionSubscription;

  static int get _cooldown => AppConstants.otpResendCooldown.inSeconds;

  Future<void> checkSession() async {
    emit(state.copyWith(action: AuthAction.checkSession, status: AuthStatus.loading, failure: null));

    if (!await _checkSession()) {
      if (!isClosed) emit(const AuthState(action: AuthAction.checkSession, status: AuthStatus.success));
      return;
    }

    final result = await _getCurrentUser(const NoParams());
    if (isClosed) return;

    switch (result) {
      case Ok(:final value) when value.role.canUseApp:
        emit(state.copyWith(status: AuthStatus.success, user: value, role: value.role));
      case Ok() || Err(failure: UnauthorizedFailure() || PermissionFailure()):
        await _logout();
        if (!isClosed) emit(const AuthState(action: AuthAction.checkSession, status: AuthStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: AuthStatus.failure, failure: failure));
    }
  }

  Future<void> login({required String email, required String password}) => _run<AuthSession>(
        AuthAction.login,
        () async {
          final result = await _login((email: email, password: password));
          if (result case Ok(:final value) when !value.role.canUseApp) {
            await _logout();
            return const Err<AuthSession>(PermissionFailure());
          }
          return result;
        },
        (current, session) => current.copyWith(role: session.role),
      );

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) =>
      _run<String>(
        AuthAction.register,
        () => _register((fullName: fullName, email: email, phone: phone, password: password)),
        (current, token) => current.copyWith(
          registrationToken: token,
          registrationPhone: normalizePhone(phone),
          otpRound: current.otpRound + 1,
          resendAfter: _cooldown,
        ),
      );

  Future<void> verifyPhone(String otp) async {
    final token = state.registrationToken;
    if (token == null) return;
    await _run<void>(
      AuthAction.verifyPhone,
      () => _verifyPhone((registrationToken: token, otp: otp)),
      (current, _) => current,
    );
  }

  Future<void> resendOtp() async {
    final token = state.registrationToken;
    if (token == null) return;
    await _resend(AuthAction.resendOtp, () => _resendOtp(token), (current) => current);
  }

  Future<void> selectRole(Role role) async {
    final token = state.registrationToken;
    if (token == null) return;
    await _run<AuthSession>(
      AuthAction.selectRole,
      () => _selectRole((registrationToken: token, role: role)),
      (current, session) => current.copyWith(
        role: session.role,
        registrationToken: null,
        registrationPhone: null,
      ),
    );
  }

  Future<void> requestPasswordReset(String phone) => _resend(
        AuthAction.requestPasswordReset,
        () => _requestPasswordReset(phone),
        (current) => current.copyWith(resetPhone: normalizePhone(phone)),
      );

  Future<void> confirmPasswordReset({required String otp, required String newPassword}) async {
    final phone = state.resetPhone;
    if (phone == null) return;
    await _run<void>(
      AuthAction.confirmPasswordReset,
      () => _confirmPasswordReset((phone: phone, otp: otp, newPassword: newPassword)),
      (current, _) => current.copyWith(resetPhone: null, role: null, user: null),
    );
  }

  void cancelPasswordReset() {
    if (state.isLoading) return;
    emit(state.copyWith(action: AuthAction.none, status: AuthStatus.idle, failure: null, resetPhone: null));
  }

  Future<void> logout() async {
    await _logout();
    if (!isClosed) emit(const AuthState());
  }

  Future<void> _run<T>(
    AuthAction action,
    Future<Result<T>> Function() request,
    AuthState Function(AuthState current, T value) onSuccess,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: action, status: AuthStatus.loading, failure: null));

    final result = await request();
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(onSuccess(state, value).copyWith(action: action, status: AuthStatus.success));
      case Err(:final failure):
        emit(state.copyWith(action: action, status: AuthStatus.failure, failure: failure));
    }
  }

  Future<void> _resend(
    AuthAction action,
    Future<Result<void>> Function() request,
    AuthState Function(AuthState current) onSuccess,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: action, status: AuthStatus.loading, failure: null));

    final result = await request();
    if (isClosed) return;

    switch (result) {
      case Ok():
        emit(onSuccess(state).copyWith(
          action: action,
          status: AuthStatus.success,
          otpRound: state.otpRound + 1,
          resendAfter: _cooldown,
        ));
      case Err(failure: final ThrottledFailure throttled) when throttled.retryAfter != null:
        emit(state.copyWith(
          action: action,
          status: AuthStatus.failure,
          failure: throttled,
          otpRound: state.otpRound + 1,
          resendAfter: throttled.retryAfter,
        ));
      case Err(:final failure):
        emit(state.copyWith(action: action, status: AuthStatus.failure, failure: failure));
    }
  }

  void _onSessionEnded(SessionEndReason reason) {
    if (isClosed || state.role == null) return;
    emit(AuthState(action: AuthAction.sessionEnded, status: AuthStatus.success, sessionEndReason: reason));
  }

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    return super.close();
  }
}
