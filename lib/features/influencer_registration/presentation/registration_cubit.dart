import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/auth/domain/auth_entities.dart';
import 'package:x_ten/features/auth/domain/auth_usecases.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_entities.dart';
import 'package:x_ten/features/influencer_registration/domain/registration_usecases.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({
    required LoadCurrentRegistrationUseCase loadCurrent,
    required CreateRegistrationUseCase create,
    required StartNewAttemptUseCase startNewAttempt,
    required UpdateBasicInfoUseCase updateBasic,
    required UpdateProfileUseCase updateProfile,
    required UpdateFinancialUseCase updateFinancial,
    required SubmitRegistrationUseCase submit,
    required UploadProfileImageUseCase uploadPhoto,
    required DeleteProfileImageUseCase deletePhoto,
    required AddSocialAccountUseCase addSocial,
    required DeleteSocialAccountUseCase deleteSocial,
    required AddPortfolioItemUseCase addPortfolio,
    required DeletePortfolioItemUseCase deletePortfolio,
    required UploadDocumentUseCase uploadDocument,
    required DeleteDocumentUseCase deleteDocument,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _loadCurrent = loadCurrent,
        _create = create,
        _startNewAttempt = startNewAttempt,
        _updateBasic = updateBasic,
        _updateProfile = updateProfile,
        _updateFinancial = updateFinancial,
        _submit = submit,
        _uploadPhoto = uploadPhoto,
        _deletePhoto = deletePhoto,
        _addSocial = addSocial,
        _deleteSocial = deleteSocial,
        _addPortfolio = addPortfolio,
        _deletePortfolio = deletePortfolio,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        _getCurrentUser = getCurrentUser,
        super(const RegistrationState());

  final LoadCurrentRegistrationUseCase _loadCurrent;
  final CreateRegistrationUseCase _create;
  final StartNewAttemptUseCase _startNewAttempt;
  final UpdateBasicInfoUseCase _updateBasic;
  final UpdateProfileUseCase _updateProfile;
  final UpdateFinancialUseCase _updateFinancial;
  final SubmitRegistrationUseCase _submit;
  final UploadProfileImageUseCase _uploadPhoto;
  final DeleteProfileImageUseCase _deletePhoto;
  final AddSocialAccountUseCase _addSocial;
  final DeleteSocialAccountUseCase _deleteSocial;
  final AddPortfolioItemUseCase _addPortfolio;
  final DeletePortfolioItemUseCase _deletePortfolio;
  final UploadDocumentUseCase _uploadDocument;
  final DeleteDocumentUseCase _deleteDocument;
  final GetCurrentUserUseCase _getCurrentUser;

  int? get _id => state.registration?.id;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(action: RegistrationAction.load, status: OperationStatus.loading, failure: null));

    final result = await _loadCurrent(const NoParams());
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        final registration = value.registration;
        User? account = state.account;
        if (registration == null && account == null) {
          if (await _getCurrentUser(const NoParams()) case Ok(value: final user)) account = user;
          if (isClosed) return;
        }
        final next = state.copyWith(
          loaded: true,
          registration: registration,
          account: account,
          socialAccounts: value.socialAccounts,
          portfolio: value.portfolio,
          documents: value.documents,
          meeting: value.meeting,
        );
        emit(next.copyWith(
          action: RegistrationAction.load,
          status: OperationStatus.success,
          step: _resumeStep(next),
        ));
      case Err(:final failure):
        emit(state.copyWith(status: OperationStatus.failure, failure: failure));
    }
  }

  void goTo(RegistrationStep step) {
    if (state.isLoading || step.index > state.furthestAllowed.index) return;
    emit(state.copyWith(step: step, action: RegistrationAction.none, status: OperationStatus.idle, failure: null));
  }

  void next() {
    final index = state.step.index + 1;
    if (index < RegistrationStep.values.length) goTo(RegistrationStep.values[index]);
  }

  void back() {
    final index = state.step.index - 1;
    if (index >= 0) goTo(RegistrationStep.values[index]);
  }

  void setNotifications(NotificationPreferences notifications) => emit(state.copyWith(notifications: notifications));

  Future<void> saveBasic(BasicInfo basic) async {
    final id = _id;
    if (id == null) {
      emit(state.copyWith(
        pendingBasic: basic,
        step: RegistrationStep.audience,
        action: RegistrationAction.saveBasic,
        status: OperationStatus.success,
        failure: null,
      ));
      return;
    }
    await _save(
      RegistrationAction.saveBasic,
      () => _updateBasic((id: id, basic: basic)),
      (current, registration) => current.copyWith(registration: registration, step: RegistrationStep.audience),
    );
  }

  Future<void> saveProfile(ProfileInfo profile) async {
    final id = _id;
    final pending = state.pendingBasic;
    if (id == null && pending == null) return;
    await _save(
      RegistrationAction.saveProfile,
      () => id == null ? _create((basic: pending!, profile: profile)) : _updateProfile((id: id, profile: profile)),
      (current, registration) => current.copyWith(
        registration: registration,
        pendingBasic: null,
        step: RegistrationStep.accounts,
      ),
    );
  }

  Future<void> saveFinancial(FinancialInfo financial) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.saveFinancial,
      () => _updateFinancial((id: id, financial: financial)),
      (current, registration) => current.copyWith(registration: registration, step: RegistrationStep.review),
    );
  }

  Future<void> submit(Consents consents) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.submit,
      () => _submit((id: id, consents: consents, notifications: state.notifications)),
      (current, registration) => current.copyWith(registration: registration),
    );
  }

  Future<void> startNewAttempt() async {
    final previous = state.registration;
    if (previous == null || !previous.canStartNewAttempt) return;
    await _save(
      RegistrationAction.newAttempt,
      () => _startNewAttempt(previous),
      (current, registration) => current.copyWith(
        registration: registration,
        socialAccounts: const [],
        portfolio: const [],
        documents: const [],
        meeting: null,
        step: RegistrationStep.accounts,
      ),
    );
  }

  Future<void> uploadPhoto(UploadFile image) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.uploadPhoto,
      () => _uploadPhoto((id: id, image: image)),
      (current, registration) => current.copyWith(registration: registration),
    );
  }

  Future<void> deletePhoto() async {
    final id = _id;
    final registration = state.registration;
    if (id == null || registration == null) return;
    await _save<void>(
      RegistrationAction.deletePhoto,
      () => _deletePhoto(id),
      (current, _) => current.copyWith(registration: _withoutPhoto(registration)),
    );
  }

  Future<void> addSocialAccount(SocialAccount account) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.addSocial,
      () => _addSocial((registrationId: id, account: account)),
      (current, added) => current.copyWith(socialAccounts: [...current.socialAccounts, added]),
    );
  }

  Future<void> deleteSocialAccount(int accountId) => _save<void>(
        RegistrationAction.deleteSocial,
        () => _deleteSocial(accountId),
        (current, _) => current.copyWith(
          socialAccounts: [for (final a in current.socialAccounts) if (a.id != accountId) a],
        ),
        target: accountId,
      );

  Future<void> addPortfolioItem(PortfolioItem item) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.addPortfolio,
      () => _addPortfolio((registrationId: id, item: item)),
      (current, added) => current.copyWith(portfolio: [...current.portfolio, added]),
    );
  }

  Future<void> deletePortfolioItem(int itemId) => _save<void>(
        RegistrationAction.deletePortfolio,
        () => _deletePortfolio(itemId),
        (current, _) => current.copyWith(portfolio: [for (final p in current.portfolio) if (p.id != itemId) p]),
        target: itemId,
      );

  Future<void> uploadDocument(DocumentType type, UploadFile file) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.uploadDocument,
      () => _uploadDocument((registrationId: id, type: type, file: file)),
      (current, document) => current.copyWith(documents: [
        for (final d in current.documents)
          if (type == DocumentType.other || d.type != type) d,
        document,
      ]),
      target: type,
    );
  }

  Future<void> deleteDocument(RegistrationDocument document) => _save<void>(
        RegistrationAction.deleteDocument,
        () => _deleteDocument(document.id),
        (current, _) => current.copyWith(documents: [for (final d in current.documents) if (d.id != document.id) d]),
        target: document.type,
      );

  Future<void> _save<T>(
    RegistrationAction action,
    Future<Result<T>> Function() request,
    RegistrationState Function(RegistrationState current, T value) onSuccess, {
    Object? target,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: action, status: OperationStatus.loading, failure: null, target: target));

    final result = await request();
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(onSuccess(state, value).copyWith(action: action, status: OperationStatus.success));
      case Err(:final failure):
        emit(state.copyWith(action: action, status: OperationStatus.failure, failure: failure));
    }
  }

  static RegistrationStep _resumeStep(RegistrationState state) {
    final registration = state.registration;
    if (registration == null || registration.basic.birthPlace.isEmpty) return RegistrationStep.basicInfo;
    if (registration.audience == null) return RegistrationStep.audience;
    if (state.socialAccounts.isEmpty) return RegistrationStep.accounts;
    final financial = registration.financial;
    if (financial == null || state.missingDocuments(financial.accountType).isNotEmpty) {
      return RegistrationStep.financial;
    }
    return RegistrationStep.review;
  }

  static Registration _withoutPhoto(Registration r) => Registration(
        id: r.id,
        attemptNumber: r.attemptNumber,
        isCurrent: r.isCurrent,
        basic: r.basic,
        email: r.email,
        phone: r.phone,
        primaryCategories: r.primaryCategories,
        secondaryCategories: r.secondaryCategories,
        contentTypes: r.contentTypes,
        consents: r.consents,
        status: r.status,
        audience: r.audience,
        financial: r.financial,
        submittedAt: r.submittedAt,
        updatedAt: DateTime.now(),
      );
}
