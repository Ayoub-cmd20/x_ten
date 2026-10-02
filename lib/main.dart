import 'package:flutter/material.dart';

import 'package:x_ten/core/localization/locale_controller.dart';
import 'package:x_ten/core/navigation/app_router.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await localeController.loadLocale();

  runApp(
    const XTenApp(),
  );
}

class XTenApp extends StatelessWidget {
  const XTenApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return ListenableBuilder(
      listenable:
      localeController,

      builder: (
          context,
          child,
          ) {
        return MaterialApp.router(
          debugShowCheckedModeBanner:
          false,

          routerConfig:
          appRouter,

          title:
          'X Ten',

          locale:
          localeController.locale,

          supportedLocales:
          AppLocalizations
              .supportedLocales,

          localizationsDelegates:
          AppLocalizations
              .localizationsDelegates,

          theme:
          ThemeData(
            brightness:
            Brightness.dark,

            useMaterial3:
            true,

            colorScheme:
            ColorScheme.fromSeed(
              seedColor:
              const Color(
                0xFFE5C158,
              ),
              brightness:
              Brightness.dark,
            ),
          ),
        );
      },
    );
  }
}