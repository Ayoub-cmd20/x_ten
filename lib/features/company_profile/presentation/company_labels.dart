import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/presentation/company_cubit.dart';
import 'package:x_ten/l10n/generated/app_localizations.dart';

extension CompanyLabels on AppLocalizations {
  String companyStepTitle(CompanyStep step) => switch (step) {
        CompanyStep.type => companyStepType,
        CompanyStep.info => companyStepInfo,
        CompanyStep.contact => companyStepContact,
        CompanyStep.documents => documentsTitle,
        CompanyStep.review => stepReview,
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
        CompanyDocumentType.identityDocument => docCompanyIdentity,
        CompanyDocumentType.commercialRegister => docCommercialRegister,
        CompanyDocumentType.companyStamp => docCompanyStamp,
        CompanyDocumentType.cancelledCheque => docCancelledCheque,
        CompanyDocumentType.other => docOther,
      };

  String companyDocumentList(Iterable<CompanyDocumentType> types) =>
      types.map(companyDocumentLabel).join(listSeparator);
}
