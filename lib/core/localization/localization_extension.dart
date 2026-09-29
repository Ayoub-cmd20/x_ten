import 'package:flutter/widgets.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

extension LocalizationExtension
on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this);
}