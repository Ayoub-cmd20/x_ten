import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_repository.dart';

typedef SaveSectionParams = ({int? id, RegistrationSection section});
typedef ProfileImageParams = ({int id, UploadFile image});
typedef SocialUrlParams = ({int registrationId, String url});
typedef SocialDetailsParams = ({int id, String accountName, int followers});
typedef PortfolioParams = ({
  int registrationId,
  PortfolioItem item,
  UploadFile? file,
});
typedef FinancialAccountParams = ({
  int registrationId,
  FinancialAccount account,
});
typedef DocumentParams = ({
  int registrationId,
  DocumentType type,
  UploadFile file,
  int? financialAccountId,
  bool acceptUnreadable,
});
typedef ScanFileParams = ({int id, UploadFile file});
typedef AudienceScanParams = ({
  int registrationId,
  List<UploadFile> images,
  String platform,
  String language,
});

const portfolioFileRules = FileRules(
  extensions: {'jpg', 'jpeg', 'png', 'webp', 'pdf', 'mp4', 'mov'},
  maxBytes: 50 * 1024 * 1024,
);

ValidationFailure _invalid(String field, String error) =>
    ValidationFailure(details: {field: error});

Failure? checkFile(UploadFile file, FileRules rules) =>
    switch (rules.check(fileName: file.name, sizeInBytes: file.size)) {
      FileCheck.ok => null,
      FileCheck.badExtension => _invalid('file', 'badExtension'),
      FileCheck.tooLarge => _invalid('file', 'tooLarge'),
    };

String _digits(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

String _phone(String value) =>
    value.trim().replaceAll(RegExp(r'[\s\-().]'), '');

Result<RegistrationSection> cleanSection(RegistrationSection section) =>
    switch (section) {
      final PersonalInfo personal => Ok(
        PersonalInfo(
          firstName: personal.firstName.trim(),
          lastName: personal.lastName.trim(),
          nationalId: _digits(personal.nationalId),
          birthDate: personal.birthDate,
          birthPlace: personal.birthPlace.trim(),
          entityType: personal.entityType,
        ),
      ),
      final ProfileInfo profile => _cleanProfile(profile),
      final ContactInfo contact => Ok(
        ContactInfo(
          phone: _phone(contact.phone),
          whatsapp: _phone(contact.whatsapp),
          email: contact.email.trim().toLowerCase(),
          backupPhone: _phone(contact.backupPhone),
          deliveryAddress: contact.deliveryAddress.trim().replaceAll(RegExp(r'\s+'), ' '),
        ),
      ),
      final OptionalInfo optional => _cleanOptional(optional),
      final ConsentInfo consents => consents.all
          ? Ok(consents)
          : Err(_invalid('consents', 'required')),
    };

Result<RegistrationSection> _cleanProfile(ProfileInfo profile) {
  if (profile.primaryCategories.isEmpty) {
    return Err(_invalid('primaryCategories', 'required'));
  }
  if (profile.contentLanguages.isEmpty) {
    return Err(_invalid('contentLanguages', 'required'));
  }
  if (profile.addressLanguages.isEmpty) {
    return Err(_invalid('addressLanguages', 'required'));
  }
  final languages = [
    for (final language in profile.contentLanguages)
      ContentLanguage(
        code: language.code,
        level: language.level,
        name: language.code == RegistrationCatalog.otherLanguage
            ? language.name.trim()
            : '',
      ),
  ];
  if (languages.any(
    (l) => l.code == RegistrationCatalog.otherLanguage && l.name.isEmpty,
  )) {
    return Err(_invalid('contentLanguages', 'otherName'));
  }
  return Ok(
    ProfileInfo(
      displayName: profile.displayName.trim(),
      primaryCategories: profile.primaryCategories,
      secondaryCategories: [
        for (final c in profile.secondaryCategories)
          if (!profile.primaryCategories.contains(c)) c,
      ],
      contentLanguages: languages,
      addressLanguages: profile.addressLanguages
          .take(RegistrationCatalog.maxAddressLanguages)
          .toList(),
    ),
  );
}

Result<RegistrationSection> _cleanOptional(OptionalInfo info) {
  if (info.audience.unbalanced case final groups when groups.isNotEmpty) {
    return Err(ValidationFailure(details: {'audience': groups}));
  }
  Map<String, double> positive(Map<String, double> shares) => {
    for (final entry in shares.entries)
      if (entry.value > 0) entry.key: entry.value,
  };
  final audience = info.audience;
  return Ok(
    OptionalInfo(
      bio: info.bio.trim(),
      contentTypes: info.contentTypes.take(RegistrationCatalog.maxAdContentTypes).toList(),
      audience: Audience(
        countries: [
          for (final c in audience.countries)
            if (c.country.isNotEmpty && c.percent > 0)
              CountryShare(country: c.country, percent: c.percent, regions: positive(c.regions)),
        ],
        gender: positive(audience.gender),
        ages: positive(audience.ages),
        languages: positive(audience.languages),
        topPlatforms: audience.topPlatforms
            .take(RegistrationCatalog.maxTopPlatforms)
            .toList(),
        activityDays: audience.activityDays,
        fromHour: audience.fromHour,
        toHour: audience.toHour,
        contentEngagement: audience.contentEngagement,
      ),
    ),
  );
}

class LoadCurrentRegistrationUseCase
    implements UseCase<RegistrationBundle, NoParams> {
  const LoadCurrentRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationBundle>> call(NoParams params) =>
      _repository.loadCurrent();
}

class SaveSectionUseCase implements UseCase<Registration, SaveSectionParams> {
  const SaveSectionUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SaveSectionParams params) async {
    final cleaned = cleanSection(params.section);
    if (cleaned case Err(:final failure)) {
      return Err(failure);
    }
    final section = (cleaned as Ok<RegistrationSection>).value;
    final id = params.id;
    if (id != null) {
      return _repository.saveSection(id, section);
    }
    if (section is! PersonalInfo) {
      return Err(_invalid('registration', 'required'));
    }
    return _repository.create(section);
  }
}

class SubmitRegistrationUseCase implements UseCase<Registration, int> {
  const SubmitRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(int id) => _repository.submit(id);
}

class UploadProfileImageUseCase
    implements UseCase<Registration, ProfileImageParams> {
  const UploadProfileImageUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(ProfileImageParams params) async {
    if (checkFile(params.image, FileRules.images) case final failure?) {
      return Err<Registration>(failure);
    }
    return _repository.uploadProfileImage(params.id, params.image);
  }
}

class DeleteProfileImageUseCase implements UseCase<void, int> {
  const DeleteProfileImageUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteProfileImage(id);
}

class AddSocialAccountUseCase
    implements UseCase<SocialAccount, SocialUrlParams> {
  const AddSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(SocialUrlParams params) async {
    final url = params.url.trim();
    final uri = Uri.tryParse(url.contains('://') ? url : 'https://$url');
    if (url.isEmpty || uri == null || !uri.host.contains('.')) {
      return Err(_invalid('url', 'invalid'));
    }
    return _repository.addSocialAccount(params.registrationId, url);
  }
}

class UpdateSocialAccountUseCase
    implements UseCase<SocialAccount, SocialDetailsParams> {
  const UpdateSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(SocialDetailsParams params) =>
      _repository.updateSocialAccount(
        params.id,
        accountName: params.accountName.trim(),
        followers: params.followers,
      );
}

class RefreshSocialAccountUseCase implements UseCase<SocialAccount, int> {
  const RefreshSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(int id) =>
      _repository.refreshSocialAccount(id);
}

class DeleteSocialAccountUseCase implements UseCase<void, int> {
  const DeleteSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteSocialAccount(id);
}

class ApplySocialScreenshotUseCase
    implements UseCase<SocialAccount, ScanFileParams> {
  const ApplySocialScreenshotUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(ScanFileParams params) async {
    if (checkFile(params.file, FileRules.images) case final failure?) {
      return Err<SocialAccount>(failure);
    }
    return _repository.applySocialScreenshot(params.id, params.file);
  }
}


class ScanAudienceUseCase implements UseCase<Audience, AudienceScanParams> {
  const ScanAudienceUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Audience>> call(AudienceScanParams params) async {
    Audience? merged;
    Failure? lastFailure;
    for (final image in params.images) {
      if (checkFile(image, FileRules.images) case final failure?) {
        lastFailure = failure;
        continue;
      }
      final result = await _repository.scanAudience(
        params.registrationId,
        image,
        platform: params.platform,
        language: params.language,
      );
      switch (result) {
        case Ok(:final value):
          merged = (merged ?? const Audience()).overlay(value);
        case Err(:final failure):
          lastFailure = failure;
         
          if (failure.code == 'ocr_unavailable') {
            return Err(failure);
          }
      }
    }
    if (merged != null) {
      return Ok(merged);
    }
    return Err(lastFailure ?? _invalid('file', 'required'));
  }
}

class CreateDraftRegistrationUseCase
    implements UseCase<Registration, NoParams> {
  const CreateDraftRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(NoParams params) =>
      _repository.createDraft();
}

class AddPortfolioItemUseCase
    implements UseCase<PortfolioItem, PortfolioParams> {
  const AddPortfolioItemUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<PortfolioItem>> call(PortfolioParams params) async {
    final item = params.item;
    final file = params.file;
    if (file != null) {
      if (checkFile(file, portfolioFileRules) case final failure?) {
        return Err<PortfolioItem>(failure);
      }
    } else if (item.link.trim().isEmpty) {
      return Err(_invalid('link', 'required'));
    }
    return _repository.addPortfolioItem(
      params.registrationId,
      PortfolioItem(
        title: item.title.trim(),
        description: item.description.trim(),
        link: item.link.trim(),
      ),
      file,
    );
  }
}

class DeletePortfolioItemUseCase implements UseCase<void, int> {
  const DeletePortfolioItemUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deletePortfolioItem(id);
}

class AddFinancialAccountUseCase
    implements UseCase<FinancialAccount, FinancialAccountParams> {
  const AddFinancialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  static final _number = RegExp(r'^[A-Z0-9]{4,40}$');

  @override
  Future<Result<FinancialAccount>> call(FinancialAccountParams params) async {
    final account = params.account;
    final number = cleanAccountNumber(account.accountNumber);
    final key = _digits(account.accountKey);
    final institution = account.institutionName.trim();
    if (!_number.hasMatch(number)) {
      return Err(_invalid('accountNumber', 'invalid'));
    }
    if (key.isNotEmpty && key.length != 2) {
      return Err(_invalid('accountKey', 'invalid'));
    }
    if (!RegistrationCatalog.financialInstitutions.contains(institution)) {
      return Err(_invalid('institutionName', 'required'));
    }
    return _repository.addFinancialAccount(
      params.registrationId,
      FinancialAccount(
        institutionName: institution,
        accountNumber: number,
        accountKey: key,
      ),
    );
  }
}

String cleanAccountNumber(String value) =>
    value.replaceAll(RegExp(r'[\s\-.]'), '').toUpperCase();

class ReadFinancialDocumentUseCase implements UseCase<FinancialAccount, ScanFileParams> {
  const ReadFinancialDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<FinancialAccount>> call(ScanFileParams params) async {
    if (checkFile(params.file, FileRules.documents) case final failure?) {
      return Err<FinancialAccount>(failure);
    }
    return _repository.readFinancialDocument(params.id, params.file);
  }
}

class DeleteFinancialAccountUseCase implements UseCase<void, int> {
  const DeleteFinancialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteFinancialAccount(id);
}

class UploadDocumentUseCase
    implements UseCase<RegistrationDocument, DocumentParams> {
  const UploadDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationDocument>> call(DocumentParams params) async {
    if (checkFile(params.file, FileRules.documents) case final failure?) {
      return Err<RegistrationDocument>(failure);
    }
    return _repository.uploadDocument(
      params.registrationId,
      params.type,
      params.file,
      financialAccountId: params.financialAccountId,
      acceptUnreadable: params.acceptUnreadable,
    );
  }
}

class DeleteDocumentUseCase implements UseCase<void, int> {
  const DeleteDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteDocument(id);
}
