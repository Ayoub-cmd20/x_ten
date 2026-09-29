import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/localization/localization_extension.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  Future<void> _handleLogout(
      BuildContext context,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            context.l10n.logout,
          ),

          content: Text(
            context.l10n.logoutConfirm,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },

              child: Text(
                context.l10n.cancel,
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },

              child: Text(
                context.l10n.logout,

                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true &&
        context.mounted) {
      // TODO:
      // Call your Auth Repository / Bloc / Cubit here

      // Example later:
      //
      // await authRepository.logout();
      // context.go('/login');
    }
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final errorColor =
        Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings,
        ),
      ),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.language_rounded,
            ),

            title: Text(
              context.l10n.language,
            ),

            trailing: const Icon(
              Icons.chevron_right_rounded,
            ),

            onTap: () {
              context.push(
                '/settings/language',
              );
            },
          ),

          const Divider(),

          ListTile(
            iconColor: errorColor,
            textColor: errorColor,

            leading: const Icon(
              Icons.logout_rounded,
            ),

            title: Text(
              context.l10n.logout,
            ),

            onTap: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }
}