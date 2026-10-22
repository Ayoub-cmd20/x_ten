import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_repository.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart'
    show checkFile, cleanAccountNumber;

export 'package:x_ten/features/company_profile/domain/company_repository.dart' show CompanyUpload;

typedef SaveTypeParams = ({BusinessType type, bool exists});
typedef SaveCompanySectionParams = ({BusinessType type, CompanySection section});
typedef SubmitCompanyParams = ({CompanyConsents consents, bool consentsSaved});

ValidationFailure _invalid(String field, String error) => ValidationFailure(details: {field: error});

String _phone(String value) => value.trim().replaceAll(RegExp(r'[\s\-().]'), '');

String _identifier(String value) => value.replaceAll(RegExp(r'[\s\-.]'), '').toUpperCase();

String _oneLine(String value) => value.trim().replaceAll(RegExp(r'\s+'), ' ');

Result<CompanySection> cleanCompanySection(BusinessType type, CompanySection section) {
  final registered = type == BusinessType.registeredBusiness;
  return switch (section) {
    final CompanyPersonal personal => _cleanPersonal(type, personal, registered),
    final CompanyBusiness business => _cleanBusiness(business, registered),
    final CompanyPresence presence => _cleanPresence(type, presence),
    final CompanyContact contact => Ok(CompanyContact(
        phone: _phone(contact.phone),
        whatsapp: _phone(contact.whatsapp),
        phone2: registered ? _phone(contact.phone2) : '',
        email: contact.email.trim().toLowerCase(),
      )),
    final CompanyConsents consents => Ok(consents),
  };
}

Result<CompanySection> _cleanPersonal(BusinessType type, CompanyPersonal personal, bool registered) {
  if (!CompanyCatalog.roles(type).contains(personal.role)) {
    return Err(_invalid('role', 'required'));
  }
  final other = personal.role == CompanyCatalog.otherRole ? _oneLine(personal.roleOther) : '';
  if (personal.role == CompanyCatalog.otherRole && other.isEmpty) {
    return Err(_invalid('roleOther', 'required'));
  }
  return Ok(CompanyPersonal(
    firstName: _oneLine(personal.firstName),
    lastName: _oneLine(personal.lastName),
    idNumber: personal.idNumber.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase(),
    birthDate: registered ? personal.birthDate : null,
    role: personal.role,
    roleOther: other,
  ));
}

Result<CompanySection> _cleanBusiness(CompanyBusiness business, bool registered) {
  final branch = registered ? _oneLine(business.branch) : '';
  final source = registered && branch.isNotEmpty ? business.accountNameSource : AccountNameSource.company;
  return Ok(CompanyBusiness(
    accountName: registered ? '' : _oneLine(business.accountName),
    companyName: registered ? _oneLine(business.companyName) : '',
    branch: branch,
    accountNameSource: source,
    wilaya: business.wilaya,
    address: _oneLine(business.address),
    registrationNumber: registered ? _identifier(business.registrationNumber) : '',
    ns: registered ? _identifier(business.ns) : '',
    nif: registered ? _identifier(business.nif) : '',
    capital: business.capital,
  ));
}

Result<CompanySection> _cleanPresence(BusinessType type, CompanyPresence presence) {
  if (presence.activityAreas.isEmpty) {
    return Err(_invalid('activityAreas', 'required'));
  }
  if (presence.activityAreas.length > CompanyCatalog.maxActivities(type)) {
    return Err(_invalid('activityAreas', 'tooMany'));
  }
  final hasOther = presence.activityAreas.contains(CompanyCatalog.otherActivity);
  final other = hasOther ? _oneLine(presence.activityOther) : '';
  if (hasOther && other.isEmpty) {
    return Err(_invalid('activityOther', 'required'));
  }
  final seen = <String>{};
  return Ok(CompanyPresence(
    bio: presence.bio.trim(),
    activityAreas: presence.activityAreas,
    activityOther: other,
    marketingPages: [
      for (final page in presence.marketingPages)
        if (page.url.trim().isNotEmpty && seen.add(page.url.trim()))
          MarketingPage(url: page.url.trim(), platform: page.platform, username: page.username),
    ],
  ));
}

class LoadCompanyUseCase implements UseCase<CompanyBundle, NoParams> {
  const LoadCompanyUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyBundle>> call(NoParams params) => _repository.load();
}

class SaveBusinessTypeUseCase implements UseCase<CompanyProfile, SaveTypeParams> {
  const SaveBusinessTypeUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(SaveTypeParams params) =>
      params.exists ? _repository.updateType(params.type) : _repository.create(params.type);
}

class SaveCompanySectionUseCase implements UseCase<CompanyProfile, SaveCompanySectionParams> {
  const SaveCompanySectionUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(SaveCompanySectionParams params) async =>
      switch (cleanCompanySection(params.type, params.section)) {
        Ok(:final value) => await _repository.saveSection(value),
        Err(:final failure) => Err<CompanyProfile>(failure),
      };
}

class UploadCompanyPhotoUseCase implements UseCase<CompanyProfile, UploadFile> {
  const UploadCompanyPhotoUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(UploadFile image) async {
    if (checkFile(image, FileRules.images) case final failure?) {
      return Err<CompanyProfile>(failure);
    }
    return _repository.uploadPhoto(image);
  }
}

class DeleteCompanyPhotoUseCase implements UseCase<void, NoParams> {
  const DeleteCompanyPhotoUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) => _repository.deletePhoto();
}

class UploadCompanyDocumentUseCase implements UseCase<CompanyDocument, CompanyUpload> {
  const UploadCompanyDocumentUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyDocument>> call(CompanyUpload params) async {
    if (checkFile(params.file, FileRules.documents) case final failure?) {
      return Err<CompanyDocument>(failure);
    }
    return _repository.uploadDocument((
      type: params.type,
      file: params.file,
      financialAccountId: params.financialAccountId,
      description: _oneLine(params.description),
      acceptUnreadable: params.acceptUnreadable,
    ));
  }
}

class DeleteCompanyDocumentUseCase implements UseCase<void, int> {
  const DeleteCompanyDocumentUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteDocument(id);
}

class AddCompanyFinancialAccountUseCase implements UseCase<FinancialAccount, FinancialAccount> {
  const AddCompanyFinancialAccountUseCase(this._repository);

  final CompanyRepository _repository;

  static final _number = RegExp(r'^[A-Z0-9]{4,40}$');

  @override
  Future<Result<FinancialAccount>> call(FinancialAccount account) async {
    final number = cleanAccountNumber(account.accountNumber);
    final institution = _oneLine(account.institutionName);
    if (!_number.hasMatch(number)) {
      return Err(_invalid('accountNumber', 'invalid'));
    }
    if (institution.isEmpty && !RegExp(r'^\d{20}$').hasMatch(number)) {
      return Err(_invalid('institutionName', 'required'));
    }
    return _repository.addFinancialAccount(FinancialAccount(institutionName: institution, accountNumber: number));
  }
}

class DeleteCompanyFinancialAccountUseCase implements UseCase<void, int> {
  const DeleteCompanyFinancialAccountUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteFinancialAccount(id);
}

class ReadCompanyFinancialDocumentUseCase implements UseCase<FinancialAccount, UploadFile> {
  const ReadCompanyFinancialDocumentUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<FinancialAccount>> call(UploadFile file) async {
    if (checkFile(file, FileRules.documents) case final failure?) {
      return Err<FinancialAccount>(failure);
    }
    return _repository.readFinancialDocument(file);
  }
}

class SubmitCompanyUseCase implements UseCase<CompanyProfile, SubmitCompanyParams> {
  const SubmitCompanyUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(SubmitCompanyParams params) async {
    if (!params.consents.all) {
      return Err<CompanyProfile>(_invalid('consents', 'required'));
    }
    if (!params.consentsSaved) {
      if (await _repository.saveSection(params.consents) case Err(:final failure)) {
        return Err<CompanyProfile>(failure);
      }
    }
    return _repository.submit();
  }
}
