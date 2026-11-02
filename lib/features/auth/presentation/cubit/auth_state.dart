part of 'auth_cubit.dart';

enum AuthAction {
  none,
  checkSession,
  login,
  register,
  verifyPhone,
  resendOtp,
  selectRole,
  requestPasswordReset,
  confirmPasswordReset,
  sessionEnded,
}

enum AuthStatus { idle, loading, success, failure }

final class AuthState extends Equatable {
  const AuthState({
    this.action = AuthAction.none,
    this.status = AuthStatus.idle,
    this.failure,
    this.user,
    this.role,
    this.registrationToken,
    this.registrationPhone,
    this.resetPhone,
    this.otpRound = 0,
    this.resendAfter = 0,
    this.sessionEndReason,
  });

  static const _keep = Object();

  final AuthAction action;
  final AuthStatus status;
  final Failure? failure;
  final User? user;
  final Role? role;
  final String? registrationToken;
  final String? registrationPhone;
  final String? resetPhone;
  final int otpRound;
  final int resendAfter;
  final SessionEndReason? sessionEndReason;

  bool get isLoading => status == AuthStatus.loading;

  bool isLoadingFor(AuthAction value) => isLoading && action == value;

  bool didSucceed(AuthAction value) => action == value && status == AuthStatus.success;

  AuthState copyWith({
    AuthAction? action,
    AuthStatus? status,
    Object? failure = _keep,
    Object? user = _keep,
    Object? role = _keep,
    Object? registrationToken = _keep,
    Object? registrationPhone = _keep,
    Object? resetPhone = _keep,
    int? otpRound,
    int? resendAfter,
  }) =>
      AuthState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        user: identical(user, _keep) ? this.user : user as User?,
        role: identical(role, _keep) ? this.role : role as Role?,
        registrationToken:
            identical(registrationToken, _keep) ? this.registrationToken : registrationToken as String?,
        registrationPhone:
            identical(registrationPhone, _keep) ? this.registrationPhone : registrationPhone as String?,
        resetPhone: identical(resetPhone, _keep) ? this.resetPhone : resetPhone as String?,
        otpRound: otpRound ?? this.otpRound,
        resendAfter: resendAfter ?? this.resendAfter,
        sessionEndReason: sessionEndReason,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        user,
        role,
        registrationToken,
        registrationPhone,
        resetPhone,
        otpRound,
        resendAfter,
        sessionEndReason,
      ];
}
