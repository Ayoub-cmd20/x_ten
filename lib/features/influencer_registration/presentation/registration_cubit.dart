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
    required SaveSectionUseCase saveSection,
    required StartNewAttemptUseCase startNewAttempt,
    required SubmitRegistrationUseCase submit,
    required UploadProfileImageUseCase uploadPhoto,
    required DeleteProfileImageUseCase deletePhoto,
    required AddSocialAccountUseCase addSocial,
    required UpdateSocialAccountUseCase updateSocial,
    required RefreshSocialAccountUseCase refreshSocial,
    required DeleteSocialAccountUseCase deleteSocial,
    required AddPortfolioItemUseCase addPortfolio,
    required DeletePortfolioItemUseCase deletePortfolio,
    required AddFinancialAccountUseCase addFinancial,
    required DeleteFinancialAccountUseCase deleteFinancial,
    required UploadDocumentUseCase uploadDocument,
    required DeleteDocumentUseCase deleteDocument,
    required GetCurrentUserUseCase getCurrentUser,
  })  : _loadCurrent = loadCurrent,
        _saveSection = saveSection,
        _startNewAttempt = startNewAttempt,
        _submit = submit,
        _uploadPhoto = uploadPhoto,
        _deletePhoto = deletePhoto,
        _addSocial = addSocial,
        _updateSocial = updateSocial,
        _refreshSocial = refreshSocial,
        _deleteSocial = deleteSocial,
        _addPortfolio = addPortfolio,
        _deletePortfolio = deletePortfolio,
        _addFinancial = addFinancial,
        _deleteFinancial = deleteFinancial,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        _getCurrentUser = getCurrentUser,
        super(const RegistrationState());

  final LoadCurrentRegistrationUseCase _loadCurrent;
  final SaveSectionUseCase _saveSection;
  final StartNewAttemptUseCase _startNewAttempt;
  final SubmitRegistrationUseCase _submit;
  final UploadProfileImageUseCase _uploadPhoto;
  final DeleteProfileImageUseCase _deletePhoto;
  final AddSocialAccountUseCase _addSocial;
  final UpdateSocialAccountUseCase _updateSocial;
  final RefreshSocialAccountUseCase _refreshSocial;
  final DeleteSocialAccountUseCase _deleteSocial;
  final AddPortfolioItemUseCase _addPortfolio;
  final DeletePortfolioItemUseCase _deletePortfolio;
  final AddFinancialAccountUseCase _addFinancial;
  final DeleteFinancialAccountUseCase _deleteFinancial;
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
        if (account == null) {
          if (await _getCurrentUser(const NoParams()) case Ok(value: final user)) account = user;
          if (isClosed) return;
        }
        final next = state.copyWith(
          loaded: true,
          registration: registration,
          account: account,
          socialAccounts: value.socialAccounts,
          portfolio: value.portfolio,
          financialAccounts: value.financialAccounts,
          documents: value.documents,
          meeting: value.meeting,
        );
        emit(next.copyWith(
          action: RegistrationAction.load,
          status: OperationStatus.success,
          step: _resumeStep(next),
        ));
      case Err(:final failure):
        emit(state.copyWith(action: RegistrationAction.load, status: OperationStatus.failure, failure: failure));
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

  /// يحفظ القسم ويروح للخطوة اللي بعدو (لو [advance]).
  Future<void> saveSection(RegistrationSection section, {bool advance = true}) => _save(
        RegistrationAction.saveSection,
        () => _saveSection((id: _id, section: section)),
        (current, registration) {
          final index = current.step.index + 1;
          final next = advance && index < RegistrationStep.values.length ? RegistrationStep.values[index] : current.step;
          return current.copyWith(registration: registration, step: next);
        },
      );

  Future<void> submit() async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.submit,
      () => _submit(id),
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
        financialAccounts: const [],
        documents: const [],
        meeting: null,
        step: RegistrationStep.accounts,
      ),
    );
  }

  // ---------- الصورة ----------

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
      (current, _) => current.copyWith(
        registration: registration.copyWith(profileImageUrl: null, updatedAt: DateTime.now()),
      ),
    );
  }

  // ---------- حسابات التواصل ----------

  Future<void> addSocialAccount(String url) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.addSocial,
      () => _addSocial((registrationId: id, url: url)),
      (current, added) => current.copyWith(socialAccounts: [...current.socialAccounts, added]),
    );
  }

  Future<void> updateSocialAccount(int accountId, {required String accountName, required int followers}) => _save(
        RegistrationAction.updateSocial,
        () => _updateSocial((id: accountId, accountName: accountName, followers: followers)),
        (current, updated) => current.copyWith(socialAccounts: _replace(current.socialAccounts, updated)),
        target: accountId,
      );

  Future<void> refreshSocialAccount(int accountId) => _save(
        RegistrationAction.refreshSocial,
        () => _refreshSocial(accountId),
        (current, updated) => current.copyWith(socialAccounts: _replace(current.socialAccounts, updated)),
        target: accountId,
      );

  Future<void> deleteSocialAccount(int accountId) => _save<void>(
        RegistrationAction.deleteSocial,
        () => _deleteSocial(accountId),
        (current, _) => current.copyWith(
          socialAccounts: [for (final a in current.socialAccounts) if (a.id != accountId) a],
        ),
        target: accountId,
      );

  // ---------- معرض الأعمال ----------

  Future<void> addPortfolioItem(PortfolioItem item, UploadFile? file) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.addPortfolio,
      () => _addPortfolio((registrationId: id, item: item, file: file)),
      (current, added) => current.copyWith(portfolio: [...current.portfolio, added]),
    );
  }

  Future<void> deletePortfolioItem(int itemId) => _save<void>(
        RegistrationAction.deletePortfolio,
        () => _deletePortfolio(itemId),
        (current, _) => current.copyWith(portfolio: [for (final p in current.portfolio) if (p.id != itemId) p]),
        target: itemId,
      );

  // ---------- المالية ----------

  Future<void> addFinancialAccount(FinancialAccount account) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.addFinancial,
      () => _addFinancial((registrationId: id, account: account)),
      (current, added) => current.copyWith(financialAccounts: [...current.financialAccounts, added]),
    );
  }

  Future<void> deleteFinancialAccount(int accountId) => _save<void>(
        RegistrationAction.deleteFinancial,
        () => _deleteFinancial(accountId),
        (current, _) => current.copyWith(
          financialAccounts: [for (final a in current.financialAccounts) if (a.id != accountId) a],
          documents: [for (final d in current.documents) if (d.financialAccountId != accountId) d],
        ),
        target: accountId,
      );

  // ---------- الوثائق ----------

  /// [target] يميّز الخانة اللي راهي تترفع (النوع، أو الحساب المالي).
  Future<void> uploadDocument(
    DocumentType type,
    UploadFile file, {
    int? financialAccountId,
    DocumentCheck check = DocumentCheck.notChecked,
  }) async {
    final id = _id;
    if (id == null) return;
    await _save(
      RegistrationAction.uploadDocument,
      () => _uploadDocument((
        registrationId: id,
        type: type,
        file: file,
        financialAccountId: financialAccountId,
        check: check,
      )),
      (current, document) => current.copyWith(documents: [
        for (final d in current.documents)
          if (type == DocumentType.other || d.type != type || d.financialAccountId != financialAccountId) d,
        document,
      ]),
      target: financialAccountId ?? type,
    );
  }

  Future<void> deleteDocument(RegistrationDocument document) => _save<void>(
        RegistrationAction.deleteDocument,
        () => _deleteDocument(document.id),
        (current, _) => current.copyWith(documents: [for (final d in current.documents) if (d.id != document.id) d]),
        target: document.financialAccountId ?? document.type,
      );

  // ---------- داخلي ----------

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

  static List<SocialAccount> _replace(List<SocialAccount> accounts, SocialAccount updated) =>
      [for (final a in accounts) a.id == updated.id ? updated : a];

  /// نرجعو للخطوة الأولى الناقصة (الأقسام الاختيارية ما توقفش).
  static RegistrationStep _resumeStep(RegistrationState state) {
    final registration = state.registration;
    if (registration == null || !registration.personal.isComplete) return RegistrationStep.personal;
    if (!registration.profile.isComplete) return RegistrationStep.profile;
    if (!registration.contact.isComplete) return RegistrationStep.contact;
    if (state.socialAccounts.isEmpty) return RegistrationStep.accounts;
    if (!state.financialComplete) return RegistrationStep.financial;
    if (!registration.security.isComplete) return RegistrationStep.security;
    if (registration.profileImageUrl == null) return RegistrationStep.photo;
    return RegistrationStep.documents;
  }
}
