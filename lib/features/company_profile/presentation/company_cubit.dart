import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/company_profile/domain/company_entities.dart';
import 'package:x_ten/features/company_profile/domain/company_usecases.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit({
    required LoadCompanyUseCase load,
    required SaveBusinessTypeUseCase saveType,
    required SaveCompanySectionUseCase saveSection,
    required UploadCompanyPhotoUseCase uploadPhoto,
    required DeleteCompanyPhotoUseCase deletePhoto,
    required UploadCompanyDocumentUseCase uploadDocument,
    required DeleteCompanyDocumentUseCase deleteDocument,
    required AddCompanyFinancialAccountUseCase addFinancial,
    required DeleteCompanyFinancialAccountUseCase deleteFinancial,
    required ReadCompanyFinancialDocumentUseCase readFinancial,
    required SubmitCompanyUseCase submit,
  })  : _load = load,
        _saveType = saveType,
        _saveSection = saveSection,
        _uploadPhoto = uploadPhoto,
        _deletePhoto = deletePhoto,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        _addFinancial = addFinancial,
        _deleteFinancial = deleteFinancial,
        _readFinancial = readFinancial,
        _submit = submit,
        super(const CompanyState());

  final LoadCompanyUseCase _load;
  final SaveBusinessTypeUseCase _saveType;
  final SaveCompanySectionUseCase _saveSection;
  final UploadCompanyPhotoUseCase _uploadPhoto;
  final DeleteCompanyPhotoUseCase _deletePhoto;
  final UploadCompanyDocumentUseCase _uploadDocument;
  final DeleteCompanyDocumentUseCase _deleteDocument;
  final AddCompanyFinancialAccountUseCase _addFinancial;
  final DeleteCompanyFinancialAccountUseCase _deleteFinancial;
  final ReadCompanyFinancialDocumentUseCase _readFinancial;
  final SubmitCompanyUseCase _submit;

  Future<void> load() async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(action: CompanyAction.load, status: CompanyStatus.loading, failure: null));

    final result = await _load(const NoParams());
    if (isClosed) {
      return;
    }

    switch (result) {
      case Ok(:final value):
        final next = state.copyWith(
          loaded: true,
          profile: value.profile,
          documents: value.documents,
          financialAccounts: value.financialAccounts,
        );
        emit(next.copyWith(action: CompanyAction.load, status: CompanyStatus.success, step: _resumeStep(next)));
      case Err(:final failure):
        emit(state.copyWith(action: CompanyAction.load, status: CompanyStatus.failure, failure: failure));
    }
  }

  void goTo(CompanyStep step) {
    if (state.isLoading || !state.canOpen(step)) {
      return;
    }
    emit(state.copyWith(step: step, action: CompanyAction.none, status: CompanyStatus.idle, failure: null));
  }

  void back() {
    final index = state.step.index;
    if (index > 0) {
      goTo(CompanyStep.values[index - 1]);
    }
  }

  void next() {
    final index = state.step.index;
    if (index < CompanyStep.values.length - 1) {
      goTo(CompanyStep.values[index + 1]);
    }
  }

  static CompanyStep _after(CompanyStep step) =>
      step.index < CompanyStep.values.length - 1 ? CompanyStep.values[step.index + 1] : step;

  Future<void> saveType(BusinessType type) => _save(
        CompanyAction.saveType,
        () => _saveType((type: type, exists: state.profile != null)),
        (current, profile) => current.copyWith(profile: profile, step: CompanyStep.personal),
      );

  Future<void> saveSection(CompanySection section) async {
    final profile = state.profile;
    final type = state.businessType;
    if (profile == null || type == null || state.isLoading) {
      return;
    }
    if (cleanCompanySection(type, section) case Ok(:final value) when profile.hasSaved(value)) {
      emit(state.copyWith(
        action: CompanyAction.saveSection,
        status: CompanyStatus.success,
        failure: null,
        step: _after(state.step),
      ));
      return;
    }
    await _save(
      CompanyAction.saveSection,
      () => _saveSection((type: type, section: section)),
      (current, saved) => current.copyWith(profile: saved, step: _after(current.step)),
    );
  }

  Future<void> uploadPhoto(UploadFile image) => _save(
        CompanyAction.uploadPhoto,
        () => _uploadPhoto(image),
        (current, profile) => current.copyWith(profile: profile),
      );

  Future<void> deletePhoto() async {
    final profile = state.profile;
    if (profile == null) {
      return;
    }
    await _save<void>(
      CompanyAction.deletePhoto,
      () => _deletePhoto(const NoParams()),
      (current, _) => current.copyWith(profile: profile.withoutImage()),
    );
  }

  Future<void> uploadDocument(
    CompanyDocumentType type,
    UploadFile file, {
    int? financialAccountId,
    String description = '',
    bool acceptUnreadable = false,
  }) =>
      _save(
        CompanyAction.uploadDocument,
        () => _uploadDocument((
          type: type,
          file: file,
          financialAccountId: financialAccountId,
          description: description,
          acceptUnreadable: acceptUnreadable,
        )),
        (current, document) => current.copyWith(documents: [
          for (final d in current.documents)
            if (!_replaces(document, d)) d,
          document,
        ]),
        target: financialAccountId ?? type,
      );

  static bool _replaces(CompanyDocument added, CompanyDocument old) {
    if (added.type == CompanyDocumentType.license || added.type == CompanyDocumentType.other) {
      return false;
    }
    const identity = CompanyCatalog.identityDocuments;
    if (identity.contains(added.type) && identity.contains(old.type)) {
      return added.type == CompanyDocumentType.passport ||
          old.type == CompanyDocumentType.passport ||
          old.type == added.type;
    }
    return old.type == added.type && old.financialAccountId == added.financialAccountId;
  }

  Future<void> deleteDocument(CompanyDocument document) => _save<void>(
        CompanyAction.deleteDocument,
        () => _deleteDocument(document.id),
        (current, _) => current.copyWith(documents: [for (final d in current.documents) if (d.id != document.id) d]),
        target: document.id,
      );

  Future<void> addFinancialAccount(FinancialAccount account) => _save(
        CompanyAction.addFinancial,
        () => _addFinancial(account),
        (current, added) => current.copyWith(financialAccounts: [...current.financialAccounts, added]),
      );

  Future<void> deleteFinancialAccount(int id) => _save<void>(
        CompanyAction.deleteFinancial,
        () => _deleteFinancial(id),
        (current, _) => current.copyWith(
          financialAccounts: [for (final a in current.financialAccounts) if (a.id != id) a],
          documents: [for (final d in current.documents) if (d.financialAccountId != id) d],
        ),
        target: id,
      );

  Future<void> readFinancialDocument(UploadFile file) => _save(
        CompanyAction.readFinancial,
        () => _readFinancial(file),
        (current, account) => current.copyWith(readAccount: account),
      );

  Future<void> submit(CompanyConsents consents) => _save(
        CompanyAction.submit,
        () => _submit((consents: consents, consentsSaved: state.profile?.hasSaved(consents) ?? false)),
        (current, profile) => current.copyWith(profile: profile),
      );

  Future<void> _save<T>(
    CompanyAction action,
    Future<Result<T>> Function() request,
    CompanyState Function(CompanyState current, T value) onSuccess, {
    Object? target,
  }) async {
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(action: action, status: CompanyStatus.loading, failure: null, target: target));

    final result = await request();
    if (isClosed) {
      return;
    }

    switch (result) {
      case Ok(:final value):
        emit(onSuccess(state, value).copyWith(action: action, status: CompanyStatus.success));
      case Err(:final failure):
        emit(state.copyWith(action: action, status: CompanyStatus.failure, failure: failure));
    }
  }

  static CompanyStep _resumeStep(CompanyState state) {
    final profile = state.profile;
    if (profile == null || profile.businessType == null) {
      return CompanyStep.type;
    }
    final personal = profile.personal;
    if (!state.hasIdentity || personal.firstName.isEmpty || personal.idNumber.isEmpty || personal.role.isEmpty) {
      return CompanyStep.personal;
    }
    final business = profile.business;
    final named = profile.isRegistered ? business.companyName.isNotEmpty : business.accountName.isNotEmpty;
    if (!named || business.wilaya.isEmpty || business.address.isEmpty) {
      return CompanyStep.business;
    }
    if (profile.presence.activityAreas.isEmpty || profile.profileImageUrl == null) {
      return CompanyStep.presence;
    }
    if (profile.contact.phone.isEmpty) {
      return CompanyStep.contact;
    }
    return CompanyStep.finish;
  }
}
