import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with ServerFieldErrors {
  final _phoneForm = GlobalKey<FormState>();
  final _resetForm = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().cancelPasswordReset();
  }

  @override
  void dispose() {
    _phone.dispose();
    _otp.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _requestCode() {
    FocusScope.of(context).unfocus();
    if (!(_phoneForm.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().requestPasswordReset(_phone.text);
  }

  void _resendCode() {
    _resending = true;
    context.read<AuthCubit>().requestPasswordReset(_phone.text);
  }

  void _confirmReset() {
    FocusScope.of(context).unfocus();
    if (!(_resetForm.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().confirmPasswordReset(otp: _otp.text, newPassword: _password.text);
  }

  void _changePhone() {
    _otp.clear();
    _password.clear();
    _confirm.clear();
    clearServerErrors();
    context.read<AuthCubit>().cancelPasswordReset();
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final l10n = context.l10n;
    final failure = state.failure;

    if (state.didSucceed(AuthAction.confirmPasswordReset)) {
      showSuccessSnackBar(context, l10n.passwordResetSuccess);
      context.go(AuthRoutes.login);
    } else if (state.didSucceed(AuthAction.requestPasswordReset)) {
      if (_resending) showSuccessSnackBar(context, l10n.codeResent);
      _resending = false;
    } else if (state.status == AuthStatus.failure && failure != null) {
      _resending = false;
      handleFailure(failure, const ['phone', 'otp', 'newPassword']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final resetPhone = state.resetPhone;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          (current.action == AuthAction.requestPasswordReset ||
              current.action == AuthAction.confirmPasswordReset) &&
          previous.status != current.status,
      listener: _onAuthChanged,
      child: AuthScaffold(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: resetPhone == null ? _buildPhoneStep(state) : _buildResetStep(state, resetPhone),
        ),
      ),
    );
  }

  Widget _buildPhoneStep(AuthState state) {
    final l10n = context.l10n;
    final isLoading = state.isLoadingFor(AuthAction.requestPasswordReset);

    return Form(
      key: _phoneForm,
      child: Column(
        key: const ValueKey('phone-step'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeader(
            icon: Icons.lock_reset_rounded,
            title: l10n.forgotPasswordTitle,
            subtitle: l10n.forgotPasswordSubtitle,
          ),
          const SizedBox(height: AppSpacing.xxl),
          TextFormField(
            controller: _phone,
            enabled: !isLoading,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.telephoneNumber],
            forceErrorText: serverError('phone'),
            onChanged: (_) => clearServerError('phone'),
            decoration: InputDecoration(
              labelText: l10n.phone,
              hintText: '05XXXXXXXX',
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              final phone = value?.trim() ?? '';
              if (phone.isEmpty) return l10n.phoneRequired;
              if (!Validators.isAlgerianMobile(phone)) return l10n.phoneInvalid;
              return null;
            },
            onFieldSubmitted: (_) => _requestCode(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(label: l10n.sendCode, isLoading: isLoading, onPressed: _requestCode),
        ],
      ),
    );
  }

  Widget _buildResetStep(AuthState state, String phone) {
    final l10n = context.l10n;
    final isLoading = state.isLoadingFor(AuthAction.confirmPasswordReset);

    return Form(
      key: _resetForm,
      child: Column(
        key: const ValueKey('reset-step'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthHeader(
            icon: Icons.password_rounded,
            title: l10n.resetPassword,
            subtitle: l10n.resetCodeSubtitle(ltr(phone)),
          ),
          const SizedBox(height: AppSpacing.xxl),
          OtpInput(
            controller: _otp,
            enabled: !isLoading,
            errorText: serverError('otp'),
            onChanged: (_) => clearServerError('otp'),
          ),
          ResendCodeButton(
            round: state.otpRound,
            seconds: state.resendAfter,
            enabled: !state.isLoading,
            onResend: _resendCode,
          ),
          const SizedBox(height: AppSpacing.md),
          PasswordField(
            controller: _password,
            enabled: !isLoading,
            label: l10n.newPassword,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            errorText: serverError('newPassword'),
            onChanged: (_) => clearServerError('newPassword'),
            validator: (value) {
              final password = value ?? '';
              if (password.isEmpty) return l10n.passwordRequired;
              if (!Validators.isStrongPassword(password)) return l10n.passwordWeak;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          PasswordField(
            controller: _confirm,
            enabled: !isLoading,
            label: l10n.confirmPassword,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) => value != _password.text ? l10n.passwordsDoNotMatch : null,
            onSubmitted: (_) => _confirmReset(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          PrimaryButton(label: l10n.resetPassword, isLoading: isLoading, onPressed: _confirmReset),
          const SizedBox(height: AppSpacing.sm),
          TextButton(onPressed: isLoading ? null : _changePhone, child: Text(l10n.changePhone)),
        ],
      ),
    );
  }
}
