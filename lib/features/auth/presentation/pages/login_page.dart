import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_header.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:x_ten/features/auth/presentation/widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with ServerFieldErrors {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().login(email: _email.text, password: _password.text);
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final role = state.role;
    final failure = state.failure;
    if (state.status == AuthStatus.success && role != null) {
      context.go(AuthRoutes.homeFor(role));
    } else if (state.status == AuthStatus.failure && failure != null) {
      if (failure is PermissionFailure) {
        showErrorSnackBar(context, context.l10n.loginUnsupportedAccount);
      } else {
        handleFailure(failure, const ['email', 'password']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select((AuthCubit cubit) => cubit.state.isLoadingFor(AuthAction.login));

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.action == AuthAction.login && previous.status != current.status,
      listener: _onAuthChanged,
      child: AuthScaffold(
        withAppBar: false,
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(title: l10n.welcomeBack, subtitle: l10n.loginSubtitle),
                const SizedBox(height: AppSpacing.xxxl),
                TextFormField(
                  controller: _email,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email, AutofillHints.username],
                  forceErrorText: serverError('email'),
                  onChanged: (_) => clearServerError('email'),
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: 'email@example.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return l10n.emailRequired;
                    if (!Validators.isEmail(email)) return l10n.emailInvalid;
                    return null;
                  },
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: AppSpacing.lg),
                PasswordField(
                  controller: _password,
                  focusNode: _passwordFocus,
                  enabled: !isLoading,
                  label: l10n.password,
                  hint: l10n.passwordHint,
                  errorText: serverError('password'),
                  onChanged: (_) => clearServerError('password'),
                  validator: (value) => (value ?? '').isEmpty ? l10n.passwordRequired : null,
                  onSubmitted: (_) => _submit(),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.push(AuthRoutes.forgotPassword),
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: l10n.login,
                  icon: Icons.arrow_forward_rounded,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.xxl),
                AuthFooterLink(
                  question: l10n.dontHaveAccount,
                  action: l10n.createAccount,
                  onTap: isLoading ? null : () => context.push(AuthRoutes.signup),
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
