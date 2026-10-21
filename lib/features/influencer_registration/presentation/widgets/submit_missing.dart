import 'package:flutter/material.dart';
import 'package:x_ten/core/constants/api_keys.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_colors.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_cubit.dart';
import 'package:x_ten/features/influencer_registration/presentation/registration_labels.dart';

typedef SubmitMissing = ({String label, RegistrationStep step});

List<SubmitMissing> submitMissingFrom(BuildContext context, ValidationFailure failure) {
  final l10n = context.l10n;
  final details = failure.details;
  bool has(String key) => details.containsKey(key);
  return [
    if ([ApiKeys.firstName, ApiKeys.lastName, ApiKeys.birthDate, ApiKeys.birthPlace, ApiKeys.entityType].any(has))
      (label: l10n.regStepPersonal, step: RegistrationStep.personal),
    for (final type in failure.missingDocuments.map((t) => enumFromApi(DocumentType.values, t, DocumentType.other)))
      (
        label: l10n.missingDocumentsWarning(l10n.documentLabel(type)),
        step: type == DocumentType.ccpCheque ? RegistrationStep.financial : RegistrationStep.personal,
      ),
    if ([
      ApiKeys.displayName,
      ApiKeys.bio,
      ApiKeys.primaryCategories,
      ApiKeys.contentLanguages,
      ApiKeys.addressLanguages,
      'profileImage',
    ].any(has))
      (label: l10n.regStepProfile, step: RegistrationStep.profile),
    if ([ApiKeys.phone, ApiKeys.whatsapp, ApiKeys.email].any(has))
      (label: l10n.regStepContact, step: RegistrationStep.contact),
    if (has(ApiKeys.socialAccounts)) (label: l10n.socialAccountsEmpty, step: RegistrationStep.accounts),
    if (has(ApiKeys.financialAccounts)) (label: l10n.regStepFinancial, step: RegistrationStep.financial),
  ];
}

class SubmitMissingBox extends StatelessWidget {
  const SubmitMissingBox({required this.items, required this.onFix});

  final List<SubmitMissing> items;
  final ValueChanged<RegistrationStep> onFix;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.submitMissingTitle, style: context.textTheme.titleSmall?.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.xs),
          for (final item in items)
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(item.label, style: context.textTheme.bodySmall)),
                TextButton(onPressed: () => onFix(item.step), child: Text(l10n.fix)),
              ],
            ),
        ],
      ),
    );
  }
}
