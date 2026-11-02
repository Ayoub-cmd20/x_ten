import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/theme/theme_context.dart';
import 'package:x_ten/core/widgets/form_helpers.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';

class BusinessTypeStep extends StatefulWidget {
  const BusinessTypeStep({super.key});

  @override
  State<BusinessTypeStep> createState() => _BusinessTypeStepState();
}

class _BusinessTypeStepState extends State<BusinessTypeStep> {
  BusinessType? _selected;

  @override
  void initState() {
    super.initState();
    _selected = context.read<CompanyCubit>().state.businessType;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CompanyCubit>();
    final isSaving = context.select((CompanyCubit c) => c.state.isLoadingFor(CompanyAction.saveType));
    final selected = _selected;

    return BlocListener<CompanyCubit, CompanyState>(
      listenWhen: (previous, current) => current.didFail(CompanyAction.saveType) && previous.status != current.status,
      listener: (context, state) => showRegistrationFailure(context, state.failure!),
      child: StepBody(
        requiredNote: true,
        actions: StepActions(
          isLoading: isSaving,
          onNext: selected == null
              ? null
              : () {
                  if (selected == cubit.state.businessType) {
                    cubit.next();
                  } else {
                    cubit.saveType(selected);
                  }
                },
        ),
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(req(l10n.businessTypeQuestion), style: context.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.businessTypeHint, style: context.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.xl),
          for (final type in BusinessType.values) ...[
            _ChoiceCard(
              icon: type == BusinessType.registeredBusiness ? Icons.apartment_rounded : Icons.storefront_rounded,
              title: l10n.businessTypeTitle(type),
              description: l10n.businessTypeDescription(type),
              selected: selected == type,
              onTap: isSaving ? null : () => setState(() => _selected = type),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.xxlAll,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: selected ? context.palette.accent.withValues(alpha: 0.08) : colors.surfaceContainer,
            borderRadius: AppRadius.xxlAll,
            border: Border.all(
              color: selected ? context.palette.accent : colors.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.palette.accent.withValues(alpha: 0.12),
                  borderRadius: AppRadius.lgAll,
                ),
                child: Icon(icon, color: context.palette.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(description, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                color: selected ? context.palette.accent : context.palette.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
