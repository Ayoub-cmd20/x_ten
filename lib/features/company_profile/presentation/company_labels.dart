import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

export 'package:x_ten/features/company_profile/presentation/company_catalog_labels.dart';

extension CompanyLabels on AppLocalizations {
  String companyStepTitle(CompanyStep step) => switch (step) {
        CompanyStep.type => companyStepType,
        CompanyStep.personal => companyStepPersonal,
        CompanyStep.business => companyStepBusiness,
        CompanyStep.presence => companyStepPresence,
        CompanyStep.contact => companyStepContact,
        CompanyStep.finish => companyStepFinish,
      };

  String businessTypeTitle(BusinessType type) => switch (type) {
        BusinessType.registeredBusiness => businessRegistered,
        BusinessType.individualActivity => businessIndividual,
      };

  String businessTypeDescription(BusinessType type) => switch (type) {
        BusinessType.registeredBusiness => businessRegisteredDesc,
        BusinessType.individualActivity => businessIndividualDesc,
      };

  String companyDocumentLabel(CompanyDocumentType type) => switch (type) {
        CompanyDocumentType.identityFront => docIdentityFront,
        CompanyDocumentType.identityBack => docIdentityBack,
        CompanyDocumentType.passport => docPassport,
        CompanyDocumentType.ccpCheque => docCcpCheque,
        CompanyDocumentType.financialProof => docFinancialProof,
        CompanyDocumentType.commercialRegister => docCommercialRegister,
        CompanyDocumentType.taxCertificate => docTaxCertificate,
        CompanyDocumentType.license => docLicense,
        CompanyDocumentType.other => docOther,
      };

  String companyDocumentList(Iterable<CompanyDocumentType> types) =>
      types.map(companyDocumentLabel).join(listSeparator);

  String documentReviewLabel(CompanyDocument document) => switch (document.review) {
        DocumentReview.pending => docReviewPending,
        DocumentReview.accepted => docReviewAccepted,
        DocumentReview.rejected => docReviewRejected(document.reviewReason),
      };
}
