import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/localization/locale_cubit.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final auth = context.read<AuthCubit>();
    final locale = context.read<LocaleCubit>();

    await Future.wait([
      auth.checkSession(),
      Future<void>.delayed(const Duration(milliseconds: 1200)),
    ]);
    if (!mounted || auth.state.status == AuthStatus.failure) return;

    if (!locale.hasSelectedLanguage) {
      context.go(AuthRoutes.chooseLanguage);
      return;
    }
    final role = auth.state.role;
    context.go(role == null ? AuthRoutes.login : AuthRoutes.homeFor(role));
  }

  @override
  Widget build(BuildContext context) {
    final failure = context.select(
      (AuthCubit cubit) => cubit.state.action == AuthAction.checkSession &&
              cubit.state.status == AuthStatus.failure
          ? cubit.state.failure
          : null,
    );

    return Scaffold(
      body: SafeArea(
        child: failure != null
            ? ErrorView(
                message: failure.localized(context),
                retryLabel: context.l10n.retry,
                onRetry: _start,
              )
            : Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.scale(scale: 0.9 + 0.1 * value, child: child),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png', width: 200),
                      const SizedBox(height: 48),
                      const AppLoader.small(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
