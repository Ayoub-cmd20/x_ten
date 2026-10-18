import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_repository.dart';

typedef SaveBasicParams = ({int id, BasicInfo basic});
typedef SaveProfileParams = ({int id, ProfileInfo profile});
typedef CreateRegistrationParams = ({BasicInfo basic, ProfileInfo profile});
typedef SaveFinancialParams = ({int id, FinancialInfo financial});
typedef SubmitParams = ({int id, Consents consents, NotificationPreferences notifications});
typedef ProfileImageParams = ({int id, UploadFile image});
typedef SocialAccountParams = ({int registrationId, SocialAccount account});
typedef PortfolioParams = ({int registrationId, PortfolioItem item});
typedef DocumentParams = ({int registrationId, DocumentType type, UploadFile file});

const _unbalancedAudience = ValidationFailure(
  message: 'Audience percentages must total 100',
  details: {'audience': 'unbalanced'},
);

const _consentsMissing = ValidationFailure(
  message: 'All consents are required',
  details: {'consents': 'required'},
);

Failure? checkFile(UploadFile file, FileRules rules) => switch (rules.check(fileName: file.name, sizeInBytes: file.size)) {
      FileCheck.ok => null,
      FileCheck.badExtension => const ValidationFailure(details: {'file': 'badExtension'}),
      FileCheck.tooLarge => const ValidationFailure(details: {'file': 'tooLarge'}),
    };

BasicInfo _clean(BasicInfo basic) => BasicInfo(
      firstName: basic.firstName.trim(),
      lastName: basic.lastName.trim(),
      displayName: basic.displayName.trim(),
      birthDate: basic.birthDate,
      birthPlace: basic.birthPlace.trim(),
      bio: basic.bio.trim(),
      skills: basic.skills.trim(),
      whatsapp: basic.whatsapp.trim().replaceAll(RegExp(r'[\s\-().]'), ''),
    );

class LoadCurrentRegistrationUseCase implements UseCase<RegistrationBundle, NoParams> {
  const LoadCurrentRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationBundle>> call(NoParams params) => _repository.loadCurrent();
}

class CreateRegistrationUseCase implements UseCase<Registration, CreateRegistrationParams> {
  const CreateRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(CreateRegistrationParams params) async {
    if (!params.profile.audience.isBalanced) return const Err<Registration>(_unbalancedAudience);
    return _repository.create(basic: _clean(params.basic), profile: params.profile);
  }
}

class StartNewAttemptUseCase implements UseCase<Registration, Registration> {
  const StartNewAttemptUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(Registration previous) async {
    final profile = previous.profile;
    if (profile == null || !profile.audience.isBalanced) return const Err<Registration>(_unbalancedAudience);
    return _repository.create(basic: previous.basic, profile: profile);
  }
}

class UpdateBasicInfoUseCase implements UseCase<Registration, SaveBasicParams> {
  const UpdateBasicInfoUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SaveBasicParams params) => _repository.updateBasic(params.id, _clean(params.basic));
}

class UpdateProfileUseCase implements UseCase<Registration, SaveProfileParams> {
  const UpdateProfileUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SaveProfileParams params) async {
    if (!params.profile.audience.isBalanced) return const Err<Registration>(_unbalancedAudience);
    return _repository.updateProfile(params.id, params.profile);
  }
}

class UpdateFinancialUseCase implements UseCase<Registration, SaveFinancialParams> {
  const UpdateFinancialUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SaveFinancialParams params) {
    final financial = params.financial;
    final clean = FinancialInfo(
      accountType: financial.accountType,
      ccpAccount: financial.usesCcp ? financial.ccpAccount.trim() : '',
      ccpKey: financial.usesCcp ? financial.ccpKey.trim() : '',
      bankName: financial.usesBank ? financial.bankName.trim() : '',
      bankAccount: financial.usesBank ? financial.bankAccount.trim() : '',
      rib: financial.usesBank ? financial.rib.replaceAll(' ', '') : '',
    );
    return _repository.updateFinancial(params.id, clean);
  }
}

class SubmitRegistrationUseCase implements UseCase<Registration, SubmitParams> {
  const SubmitRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<Registration>> call(SubmitParams params) async {
    if (!params.consents.all) return const Err<Registration>(_consentsMissing);
    final saved = await _repository.updateConsents(
      params.id,
      consents: params.consents,
      notifications: params.notifications,
    );
    if (saved case Err()) return saved;
    return _repository.submit(params.id);
  }
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

class AddSocialAccountUseCase implements UseCase<SocialAccount, SocialAccountParams> {
  const AddSocialAccountUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<SocialAccount>> call(SocialAccountParams params) {
    final account = params.account;
    return _repository.addSocialAccount(
      params.registrationId,
      SocialAccount(
        platform: account.platform,
        facebookAccountType: account.platform == SocialPlatform.facebook ? account.facebookAccountType : null,
        url: account.url.trim(),
        accountName: account.accountName.trim(),
        username: account.username.trim().replaceFirst(RegExp('^@'), ''),
        description: account.description.trim(),
        followers: account.followers,
      ),
    );
  }
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
  Future<Result<PortfolioItem>> call(PortfolioParams params) {
    final item = params.item;
    return _repository.addPortfolioItem(
      params.registrationId,
      PortfolioItem(
        title: item.title.trim(),
        description: item.description.trim(),
        link: item.link.trim(),
        mediaUrls: [
          for (final url in item.mediaUrls)
            if (url.trim().isNotEmpty) url.trim(),
        ],
      ),
    );
  }
}

class DeletePortfolioItemUseCase implements UseCase<void, int> {
  const DeletePortfolioItemUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deletePortfolioItem(id);
}

class UploadDocumentUseCase implements UseCase<RegistrationDocument, DocumentParams> {
  const UploadDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<RegistrationDocument>> call(DocumentParams params) async {
    if (checkFile(params.file, FileRules.documents) case final failure?) return Err<RegistrationDocument>(failure);
    return _repository.uploadDocument(params.registrationId, params.type, params.file);
  }
}

class DeleteDocumentUseCase implements UseCase<void, int> {
  const DeleteDocumentUseCase(this._repository);

  final RegistrationRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.deleteDocument(id);
}
