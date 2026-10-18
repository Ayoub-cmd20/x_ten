import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_repository.dart';

typedef SaveTypeParams = ({BusinessType type, bool exists});
typedef SaveInfoParams = ({BusinessType type, CompanyInfo info});
typedef UploadCompanyDocumentParams = ({CompanyDocumentType type, UploadFile file, CompanyDocument? replacing});

final _spaces = RegExp(r'\s+');

String _digits(String value) => value.replaceAll(_spaces, '');

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

class SaveCompanyInfoUseCase implements UseCase<CompanyProfile, SaveInfoParams> {
  const SaveCompanyInfoUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(SaveInfoParams params) {
    final info = params.info;
    final registered = params.type == BusinessType.registeredBusiness;
    return _repository.updateInfo(
      params.type,
      CompanyInfo(
        ownerName: info.ownerName.trim(),
        address: info.address.trim(),
        companyName: registered ? info.companyName.trim() : '',
        branch: registered ? info.branch.trim() : '',
        registrationNumber: registered ? info.registrationNumber.trim() : '',
        establishmentDate: registered ? info.establishmentDate : null,
        ns: registered ? info.ns.trim() : '',
        nif: registered ? info.nif.trim() : '',
        rib: registered ? _digits(info.rib) : '',
        professionalTitle: registered ? '' : info.professionalTitle.trim(),
        activity: registered ? '' : info.activity.trim(),
        nationalIdNumber: registered ? '' : _digits(info.nationalIdNumber),
        declaredIndividualActivity: !registered && info.declaredIndividualActivity,
      ),
    );
  }
}

class SaveCompanyContactUseCase implements UseCase<CompanyProfile, CompanyContact> {
  const SaveCompanyContactUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(CompanyContact contact) => _repository.updateContact(CompanyContact(
        phone: contact.phone.trim().replaceAll(RegExp(r'[\s\-().]'), ''),
        email: contact.email.trim(),
        website: contact.website.trim(),
        marketingLinks: [
          for (final link in contact.marketingLinks)
            if (link.trim().isNotEmpty) link.trim(),
        ],
      ));
}

class SubmitCompanyUseCase implements UseCase<CompanyProfile, CompanyConsents> {
  const SubmitCompanyUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyProfile>> call(CompanyConsents consents) async {
    if (!consents.all) {
      return const Err<CompanyProfile>(ValidationFailure(details: {'consents': 'required'}));
    }
    final saved = await _repository.updateConsents(consents);
    if (saved case Err()) return saved;
    return _repository.submit();
  }
}

class UploadCompanyDocumentUseCase implements UseCase<CompanyDocument, UploadCompanyDocumentParams> {
  const UploadCompanyDocumentUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<CompanyDocument>> call(UploadCompanyDocumentParams params) async {
    final check = FileRules.documents.check(fileName: params.file.name, sizeInBytes: params.file.size);
    if (check != FileCheck.ok) {
      return Err<CompanyDocument>(ValidationFailure(details: {'file': check.name}));
    }
    if (params.replacing case final old?) {
      final removed = await _repository.deleteDocument(old.id);
      if (removed case Err(:final failure)) return Err<CompanyDocument>(failure);
    }
    return _repository.uploadDocument(params.type, params.file);
  }
}

class DeleteCompanyDocumentUseCase implements UseCase<void, int> {
  const DeleteCompanyDocumentUseCase(this._repository);

  final CompanyRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteDocument(id);
}
