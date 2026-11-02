import 'package:flutter/material.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/theme_context.dart';

Future<void> showRegistrationSubmittedDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final l10n = dialogContext.l10n;
        return AlertDialog(
          icon: Icon(Icons.mark_email_read_outlined, color: context.palette.success, size: 48),
          title: Text(l10n.statusSubmittedTitle, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Text(l10n.regSubmittedMessage, style: dialogContext.textTheme.bodyMedium),
          ),
          actions: [
            FilledButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.close)),
          ],
        );
      },
    );
