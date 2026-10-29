import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/utils/validators.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_footer_link.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_header.dart';
import 'package:x_ten/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:x_ten/features/auth/presentation/widgets/password_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with ServerFieldErrors {
  static const _fields = ['fullName', 'email', 'phone', 'password'];

  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().register(
          fullName: _fullName.text,
          email: _email.text,
          phone: _phone.text,
          password: _password.text,
        );
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    final failure = state.failure;
    if (state.status == AuthStatus.success) {
      context.push(AuthRoutes.verifyOtp);
    } else if (state.status == AuthStatus.failure && failure != null) {
      handleFailure(failure, _fields);
    }
  }

  void _goToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AuthRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.select((AuthCubit cubit) => cubit.state.isLoadingFor(AuthAction.register));

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current.action == AuthAction.register && previous.status != current.status,
      listener: _onAuthChanged,
      child: AuthScaffold(
        child: Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(title: l10n.signupTitle, subtitle: l10n.signupSubtitle),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _fullName,
                  enabled: !isLoading,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  forceErrorText: serverError('fullName'),
                  onChanged: (_) => clearServerError('fullName'),
                  decoration: InputDecoration(
                    labelText: l10n.username,
                    hintText: l10n.fullNameHint,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: (value) => (value?.trim().length ?? 0) < 3 ? l10n.fullNameRequired : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _email,
                  enabled: !isLoading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
                  autocorrect: false,
                  autofillHints: const [AutofillHints.email],
                  forceErrorText: serverError('email'),
                  onChanged: (_) => clearServerError('email'),
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: 'email@example.com',
                    helperText: l10n.signupEmailNote,
                    helperStyle: Theme.of(context).textTheme.bodySmall,
                  
                    helperMaxLines: 3,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return l10n.emailRequired;
                    if (!Validators.isEmail(email)) return l10n.emailInvalid;
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _phone,
                  enabled: !isLoading,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  textDirection: TextDirection.ltr,
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
                ),
                const SizedBox(height: AppSpacing.lg),
                PasswordField(
                  controller: _password,
                  enabled: !isLoading,
                  label: l10n.password,
                  hint: l10n.passwordHint,
                  autofillHints: const [AutofillHints.newPassword],
                  errorText: serverError('password'),
                  onChanged: (_) => clearServerError('password'),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) return l10n.passwordRequired;
                    if (!Validators.isStrongPassword(password)) return l10n.passwordWeak;
                    return null;
                  },
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                PrimaryButton(label: l10n.createAccount, isLoading: isLoading, onPressed: _submit),
                const SizedBox(height: AppSpacing.xl),
                AuthFooterLink(
                  question: l10n.alreadyHaveAccount,
                  action: l10n.login,
                  onTap: isLoading ? null : _goToLogin,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
