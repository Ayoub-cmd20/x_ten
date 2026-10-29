import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/theme_mode_button.dart';
import 'package:x_ten/features/auth/presentation/auth_routes.dart';
import 'package:x_ten/features/auth/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final router = GoRouter.of(context);
    await context.read<AuthCubit>().logout();
    router.go(AuthRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
        actions: [
          const ThemeModeButton(),
          IconButton(
            tooltip: context.l10n.logout,
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(child: Text(context.l10n.comingSoon)),
    );
  }
}
