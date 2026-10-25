import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_routes.dart';

class RegistrationReviewBanner extends StatefulWidget {
  const RegistrationReviewBanner({super.key});

  @override
  State<RegistrationReviewBanner> createState() => _RegistrationReviewBannerState();
}

class _RegistrationReviewBannerState extends State<RegistrationReviewBanner> {
  bool _waiting = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final result = await sl<LoadCurrentRegistrationUseCase>()(const NoParams());
    if (!mounted) {
      return;
    }
    if (result case Ok(:final value)) {
      final status = value.registration?.status;
      setState(() => _waiting = status != null && status.isWaiting);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_waiting) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Material(
        color: AppColors.info.withValues(alpha: 0.12),
        borderRadius: AppRadius.lgAll,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: () => context.go(RegistrationRoutes.status),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                const Icon(Icons.manage_search_rounded, color: AppColors.info),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.statusUnderReviewTitle, style: context.textTheme.titleSmall),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(l10n.regViewStatus, style: context.textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
