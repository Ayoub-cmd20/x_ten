import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/feedback/empty_view.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/auth_widgets.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otp = TextEditingController();
  String? _otpError;

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  void _verify() {
    FocusScope.of(context).unfocus();
    if (!Validators.isOtp(_otp.text)) {
      setState(() => _otpError = context.l10n.otpInvalid);
      return;
    }
    context.read<AuthCubit>().verifyPhone(_otp.text);
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final l10n = context.l10n;
    final failure = state.failure;

    if (state.didSucceed(AuthAction.verifyPhone)) {
      context.go(AuthRoutes.accountType);
    } else if (state.didSucceed(AuthAction.resendOtp)) {
      _otp.clear();
      showSuccessSnackBar(context, l10n.codeResent);
    } else if (state.status == AuthStatus.failure && failure != null) {
      if (failure is ValidationFailure && failure.fieldError('registrationToken') != null) {
        showErrorSnackBar(context, l10n.registrationExpired);
        context.go(AuthRoutes.signup);
      } else if (failure is ValidationFailure && failure.fieldError('otp') != null) {
        setState(() => _otpError = failure.fieldError('otp'));
      } else {
        showFailure(context, failure);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<AuthCubit>().state;
    final phone = state.registrationPhone;

    if (state.registrationToken == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyView(
          icon: Icons.timer_off_outlined,
          title: l10n.registrationExpired,
          action: FilledButton(
            onPressed: () => context.go(AuthRoutes.signup),
            child: Text(l10n.startOver),
          ),
        ),
      );
    }

    final isVerifying = state.isLoadingFor(AuthAction.verifyPhone);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          (current.action == AuthAction.verifyPhone || current.action == AuthAction.resendOtp) &&
          previous.status != current.status,
      listener: _onAuthChanged,
      child: AuthScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              icon: Icons.lock_person_outlined,
              title: l10n.otpTitle,
              subtitle: l10n.otpSentTo(ltr(phone ?? '')),
            ),
            const SizedBox(height: AppSpacing.xxl),
            OtpInput(
              controller: _otp,
              enabled: !isVerifying,
              errorText: _otpError,
              onChanged: (_) {
                if (_otpError != null) setState(() => _otpError = null);
              },
              onCompleted: (_) => _verify(),
            ),
            const SizedBox(height: AppSpacing.md),
            ResendCodeButton(
              round: state.otpRound,
              seconds: state.resendAfter,
              enabled: !state.isLoading,
              onResend: () => context.read<AuthCubit>().resendOtp(),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: l10n.verify,
              icon: Icons.verified_outlined,
              isLoading: isVerifying,
              onPressed: _verify,
            ),
          ],
        ),
      ),
    );
  }
}
