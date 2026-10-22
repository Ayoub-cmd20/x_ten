import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/theme/app_dimens.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/step_form.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/features/company_profile/presentation/company_labels.dart';
import 'package:x_ten/features/company_profile/presentation/widgets/company_documents.dart';

class CompanyLegalDocuments extends StatelessWidget {
  const CompanyLegalDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final type in CompanyCatalog.businessDocuments)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: CompanyDocumentTile(
              type: type,
              slot: type,
              document: state.documentOf(type),
              onUpload: (file, acceptUnreadable) => cubit.uploadDocument(type, file, acceptUnreadable: acceptUnreadable),
            ),
          ),
      ],
    );
  }
}

class CompanyLicenses extends StatelessWidget {
  const CompanyLicenses({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CompanyCubit>().state;
    final cubit = context.read<CompanyCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final license in state.documentsOf(CompanyDocumentType.license))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ItemCard(
              icon: Icons.verified_outlined,
              highlight: companyDocumentColor(license),
              title: license.description.isEmpty ? l10n.docLicense : license.description,
              subtitle: license.review == DocumentReview.pending
                  ? l10n.docReviewPending
                  : l10n.documentReviewLabel(license),
              trailing: state.isLoadingFor(CompanyAction.deleteDocument, license.id)
                  ? const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: AppLoader.small())
                  : IconButton(
                      tooltip: l10n.delete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: state.isLoading ? null : () => cubit.deleteDocument(license),
                    ),
            ),
          ),
        CompanyDocumentTile(
          type: CompanyDocumentType.license,
          slot: CompanyDocumentType.license,
          title: l10n.companyAddLicense,
          document: null,
          onUpload: (file, acceptUnreadable) =>
              cubit.uploadDocument(CompanyDocumentType.license, file, acceptUnreadable: acceptUnreadable),
        ),
      ],
    );
  }
}
