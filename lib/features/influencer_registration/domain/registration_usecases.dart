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
typedef PortfolioParams = ({int registrationId, PortfolioItem item, UploadFile? file});
typedef FinancialAccountParams = ({int registrationId, FinancialAccount account});
typedef DocumentParams = ({
  int registrationId,
  DocumentType type,
  UploadFile file,
  int? financialAccountId,
  DocumentCheck check,
});

/// ملفات معرض الأعمال: صور وفيديو وPDF حتى 50MB
const portfolioFileRules = FileRules(
  extensions: {'jpg', 'jpeg', 'png', 'webp', 'pdf', 'mp4', 'mov'},
  maxBytes: 50 * 1024 * 1024,
);

ValidationFailure _invalid(String field, String error) => ValidationFailure(details: {field: error});

Failure? checkFile(UploadFile file, FileRules rules) => switch (rules.check(fileName: file.name, sizeInBytes: file.size)) {
      FileCheck.ok => null,
      FileCheck.badExtension => _invalid('file', 'badExtension'),
      FileCheck.tooLarge => _invalid('file', 'tooLarge'),
    };

String _digits(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

String _phone(String value) => value.trim().replaceAll(RegExp(r'[\s\-().]'), '');

/// تنظيف + قواعد الوثائق قبل ما نبعثو للسيرفر.
Result<RegistrationSection> _cleanSection(RegistrationSection section) => switch (section) {
      final PersonalInfo personal => Ok(PersonalInfo(
          firstName: personal.firstName.trim(),
          lastName: personal.lastName.trim(),
          birthDate: personal.birthDate,
          birthPlace: personal.birthPlace.trim(),
          entityType: personal.entityType,
        )),
      final ProfileInfo profile => _cleanProfile(profile),
      final ContactInfo contact => Ok(ContactInfo(
          phone: _phone(contact.phone),
          whatsapp: _phone(contact.whatsapp),
          email: contact.email.trim().toLowerCase(),
        )),
      final OptionalInfo optional => _cleanOptional(optional),
      final SecurityInfo security => _cleanSecurity(security),
    };

Result<RegistrationSection> _cleanProfile(ProfileInfo profile) {
  if (profile.primaryCategories.isEmpty) return Err(_invalid('primaryCategories', 'required'));
  if (profile.contentLanguages.isEmpty) return Err(_invalid('contentLanguages', 'required'));
  if (profile.addressLanguages.isEmpty) return Err(_invalid('addressLanguages', 'required'));
  final languages = [
    for (final language in profile.contentLanguages)
      ContentLanguage(
        code: language.code,
        level: language.level,
        name: language.code == RegistrationCatalog.otherLanguage ? language.name.trim() : '',
      ),
  ];
  if (languages.any((l) => l.code == RegistrationCatalog.otherLanguage && l.name.isEmpty)) {
    return Err(_invalid('contentLanguages', 'otherName'));
  }
  return Ok(ProfileInfo(
    displayName: profile.displayName.trim(),
    primaryCategories: profile.primaryCategories,
    secondaryCategories: [
      for (final c in profile.secondaryCategories)
        if (!profile.primaryCategories.contains(c)) c,
    ],
    bio: profile.bio.trim(),
    contentLanguages: languages,
    addressLanguages: profile.addressLanguages.take(RegistrationCatalog.maxAddressLanguages).toList(),
  ));
}

Result<RegistrationSection> _cleanOptional(OptionalInfo info) {
  final skills = info.skills;
  if (skills.isNotEmpty && (skills.length < RegistrationCatalog.minSkills || skills.length > RegistrationCatalog.maxSkills)) {
    return Err(_invalid('skills', 'count'));
  }
  if (info.audience.unbalanced case final groups when groups.isNotEmpty) {
    return Err(ValidationFailure(details: {'audience': groups}));
  }
  Map<String, double> positive(Map<String, double> shares) => {
        for (final entry in shares.entries)
          if (entry.value > 0) entry.key: entry.value,
      };
  final audience = info.audience;
  return Ok(OptionalInfo(
    skills: skills,
    contentTypes: info.contentTypes,
    audience: Audience(
      countries: [
        for (final c in audience.countries)
          if (c.country.trim().isNotEmpty && c.percent > 0) CountryShare(country: c.country.trim(), percent: c.percent),
      ],
      regions: audience.regionsUnspecified ? const {} : positive(audience.regions),
      regionsUnspecified: audience.regionsUnspecified,
      gender: positive(audience.gender),
      ages: positive(audience.ages),
      languages: positive(audience.languages),
      topPlatforms: audience.topPlatforms.take(RegistrationCatalog.maxTopPlatforms).toList(),
      activityDays: audience.activityDays,
      fromHour: audience.fromHour,
      toHour: audience.toHour,
      contentEngagement: positive(audience.contentEngagement),
      purchasingPower: audience.purchasingPower,
    ),
  ));
}

Result<RegistrationSection> _cleanSecurity(SecurityInfo info) {
  if (!info.acceptedPrivacy || !info.acceptedTerms) return Err(_invalid('consents', 'required'));
  final method = info.recoveryMethod;
  if (method == null) return Err(_invalid('recoveryMethod', 'required'));
  final phone = method == RecoveryMethod.otherPhone ? _phone(info.recoveryPhone) : '';
  if (method == RecoveryMethod.otherPhone && phone.isEmpty) return Err(_invalid('recoveryPhone', 'required'));
  return Ok(SecurityInfo(acceptedPrivacy: true, acceptedTerms: true, recoveryMethod: method, recoveryPhone: phone));
}

class LoadCurrentRegistrationUseCase implements UseCase<RegistrationBundle, NoParams> {
  const LoadCurrentRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationBundle>> call(NoParams params) => _repository.loadCurrent();
}

/// يحفظ قسم واحد. أول قسم (المعلومات الشخصية) ينشئ الملف.
class SaveSectionUseCase implements UseCase<Registration, SaveSectionParams> {
  const SaveSectionUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SaveSectionParams params) async {
    final cleaned = _cleanSection(params.section);
    if (cleaned case Err(:final failure)) return Err(failure);
    final section = (cleaned as Ok<RegistrationSection>).value;
    final id = params.id;
    if (id != null) return _repository.saveSection(id, section);
    if (section is! PersonalInfo) return Err(_invalid('registration', 'required'));
    return _repository.create(section);
  }
}

/// محاولة جديدة بعد "يحتاج تعديلات" أو "مرفوض": ننقلو المعلومات القديمة.
class StartNewAttemptUseCase implements UseCase<Registration, Registration> {
  const StartNewAttemptUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(Registration previous) async {
    final created = await _repository.create(previous.personal);
    if (created case Err()) return created;
    var registration = (created as Ok<Registration>).value;
    for (final section in <RegistrationSection>[previous.profile, previous.contact, previous.optional]) {
      final saved = await _repository.saveSection(registration.id, section);
      if (saved case Ok(:final value)) registration = value;
    }
    return Ok(registration);
  }
}

class SubmitRegistrationUseCase implements UseCase<Registration, int> {
  const SubmitRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(int id) => _repository.submit(id);
}

class UploadProfileImageUseCase implements UseCase<Registration, ProfileImageParams> {
  const UploadProfileImageUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(ProfileImageParams params) async {
    if (checkFile(params.image, FileRules.images) case final failure?) return Err<Registration>(failure);
    return _repository.uploadProfileImage(params.id, params.image);
  }
}

class DeleteProfileImageUseCase implements UseCase<void, int> {
  const DeleteProfileImageUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteProfileImage(id);
}

class AddSocialAccountUseCase implements UseCase<SocialAccount, SocialUrlParams> {
  const AddSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(SocialUrlParams params) async {
    final url = params.url.trim();
    final uri = Uri.tryParse(url.contains('://') ? url : 'https://$url');
    if (url.isEmpty || uri == null || !uri.host.contains('.')) return Err(_invalid('url', 'invalid'));
    return _repository.addSocialAccount(params.registrationId, url);
  }
}

class UpdateSocialAccountUseCase implements UseCase<SocialAccount, SocialDetailsParams> {
  const UpdateSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(SocialDetailsParams params) =>
      _repository.updateSocialAccount(params.id, accountName: params.accountName.trim(), followers: params.followers);
}

class RefreshSocialAccountUseCase implements UseCase<SocialAccount, int> {
  const RefreshSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(int id) => _repository.refreshSocialAccount(id);
}

class DeleteSocialAccountUseCase implements UseCase<void, int> {
  const DeleteSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteSocialAccount(id);
}

class AddPortfolioItemUseCase implements UseCase<PortfolioItem, PortfolioParams> {
  const AddPortfolioItemUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<PortfolioItem>> call(PortfolioParams params) async {
    final item = params.item;
    final file = params.file;
    if (file != null) {
      if (checkFile(file, portfolioFileRules) case final failure?) return Err<PortfolioItem>(failure);
    } else if (item.link.trim().isEmpty) {
      return Err(_invalid('link', 'required'));
    }
    return _repository.addPortfolioItem(
      params.registrationId,
      PortfolioItem(title: item.title.trim(), description: item.description.trim(), link: item.link.trim()),
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

class AddFinancialAccountUseCase implements UseCase<FinancialAccount, FinancialAccountParams> {
  const AddFinancialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<FinancialAccount>> call(FinancialAccountParams params) async {
    final account = params.account;
    final number = _digits(account.accountNumber);
    final key = _digits(account.accountKey);
    switch (account.kind) {
      case FinancialKind.ccp:
        if (number.isEmpty || number.length > 12) return Err(_invalid('accountNumber', 'ccp'));
        if (key.length != 2) return Err(_invalid('accountKey', 'ccpKey'));
      case FinancialKind.bank:
        if (number.length != 20) return Err(_invalid('accountNumber', 'rib'));
        if (account.institutionName.trim().isEmpty) return Err(_invalid('institutionName', 'required'));
    }
    return _repository.addFinancialAccount(
      params.registrationId,
      FinancialAccount(
        kind: account.kind,
        institutionName: account.institutionName.trim(),
        accountNumber: number,
        accountKey: account.kind == FinancialKind.ccp ? key : '',
      ),
    );
  }
}

class DeleteFinancialAccountUseCase implements UseCase<void, int> {
  const DeleteFinancialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteFinancialAccount(id);
}

class UploadDocumentUseCase implements UseCase<RegistrationDocument, DocumentParams> {
  const UploadDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationDocument>> call(DocumentParams params) async {
    if (checkFile(params.file, FileRules.documents) case final failure?) return Err<RegistrationDocument>(failure);
    return _repository.uploadDocument(
      params.registrationId,
      params.type,
      params.file,
      financialAccountId: params.financialAccountId,
      check: params.check,
    );
  }
}

class DeleteDocumentUseCase implements UseCase<void, int> {
  const DeleteDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteDocument(id);
}
