import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/core/localization/locale_cubit.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/navigation/app_router.dart';
import 'package:x_ten/core/session/session_notifier.dart';
import 'package:x_ten/core/theme/app_theme.dart';
import 'package:x_ten/features/auth/presentation/auth_cubit.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

final _messengerKey = GlobalKey<ScaffoldMessengerState>();

class XTenApp extends StatelessWidget {
  const XTenApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: sl<LocaleCubit>()),
          BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        ],
        child: BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _messengerKey,
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            routerConfig: appRouter,
            theme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => BlocListener<AuthCubit, AuthState>(
              listenWhen: (previous, current) =>
                  current.action == AuthAction.sessionEnded && previous.action != current.action,
              listener: _onSessionEnded,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      );

  static void _onSessionEnded(BuildContext context, AuthState state) {
    final l10n = context.l10n;
    final message = state.sessionEndReason == SessionEndReason.suspended
        ? l10n.accountSuspended
        : l10n.errorSessionExpired;
    appRouter.go(AuthRoutes.login);
    _messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
