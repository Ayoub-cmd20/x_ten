import 'package:flutter/material.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/app_motion.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/feedback/app_snackbar.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/press_scale.dart';

String ltr(String text) => '\u2066$text\u2069';

String req(String label) => '$label *';

class RequiredFieldsNote extends StatelessWidget {
  const RequiredFieldsNote({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg),
        child: Text(
          context.l10n.requiredFieldsNote,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.palette.error),
        ),
      );
}

class UpgradeLink extends StatelessWidget {
  const UpgradeLink({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).textTheme.bodySmall;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${l10n.upgradePrefix} ', style: style),
        InkWell(
          onTap: onTap ?? () {},
          child: Text(
            l10n.upgradeTapHere,
            style: style?.copyWith(color: context.palette.primary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

void showFailure(BuildContext context, Failure failure) =>
    showErrorSnackBar(context, failure.localized(context));

mixin ServerFieldErrors<T extends StatefulWidget> on State<T> {
  final Map<String, String> _serverErrors = {};

  String? serverError(String field) => _serverErrors[field];

  void clearServerError(String field) {
    if (_serverErrors.remove(field) != null) setState(() {});
  }

  void clearServerErrors() {
    if (_serverErrors.isEmpty) return;
    setState(_serverErrors.clear);
  }

  void handleFailure(Failure failure, List<String> fields) {
    if (failure is ValidationFailure) {
      final errors = <String, String>{
        for (final field in fields) field: ?failure.fieldError(field),
      };
      if (errors.isNotEmpty) {
        setState(() => _serverErrors
          ..clear()
          ..addAll(errors));
        return;
      }
    }
    showFailure(context, failure);
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final enabled = !isLoading && onPressed != null;
    return PressScale(
      enabled: enabled,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: AnimatedSwitcher(
          duration: AppMotion.fast,
          child: isLoading
              ? AppLoader.small(key: const ValueKey('loading'), color: context.palette.onGoldFill)
              : icon == null
                  ? Text(label, key: const ValueKey('label'))
                  : Row(
                      key: const ValueKey('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(icon, size: 20),
                      ],
                    ),
        ),
      ),
    );
  }
}
