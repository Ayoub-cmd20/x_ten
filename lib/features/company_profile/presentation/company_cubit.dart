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
    required SaveCompanyInfoUseCase saveInfo,
    required SaveCompanyContactUseCase saveContact,
    required SubmitCompanyUseCase submit,
    required UploadCompanyDocumentUseCase uploadDocument,
    required DeleteCompanyDocumentUseCase deleteDocument,
  })  : _load = load,
        _saveType = saveType,
        _saveInfo = saveInfo,
        _saveContact = saveContact,
        _submit = submit,
        _uploadDocument = uploadDocument,
        _deleteDocument = deleteDocument,
        super(const CompanyState());

  final LoadCompanyUseCase _load;
  final SaveBusinessTypeUseCase _saveType;
  final SaveCompanyInfoUseCase _saveInfo;
  final SaveCompanyContactUseCase _saveContact;
  final SubmitCompanyUseCase _submit;
  final UploadCompanyDocumentUseCase _uploadDocument;
  final DeleteCompanyDocumentUseCase _deleteDocument;

  Future<void> load() async {
    if (state.isLoading) return;
    emit(state.copyWith(action: CompanyAction.load, status: CompanyStatus.loading, failure: null));

    final result = await _load(const NoParams());
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        final next = state.copyWith(loaded: true, profile: value.profile, documents: value.documents);
        emit(next.copyWith(action: CompanyAction.load, status: CompanyStatus.success, step: _resumeStep(next)));
      case Err(:final failure):
        emit(state.copyWith(status: CompanyStatus.failure, failure: failure));
    }
  }

  void goTo(CompanyStep step) {
    if (state.isLoading || !state.canOpen(step)) return;
    emit(state.copyWith(step: step, action: CompanyAction.none, status: CompanyStatus.idle, failure: null));
  }

  void back() {
    final steps = state.steps;
    final index = steps.indexOf(state.step);
    if (index > 0) goTo(steps[index - 1]);
  }

  void next() {
    final steps = state.steps;
    final index = steps.indexOf(state.step);
    if (index >= 0 && index < steps.length - 1) goTo(steps[index + 1]);
  }

  CompanyStep _after(CompanyState current, CompanyStep step) {
    final steps = current.steps;
    final index = steps.indexOf(step);
    return index >= 0 && index < steps.length - 1 ? steps[index + 1] : step;
  }

  Future<void> saveType(BusinessType type) => _save(
        CompanyAction.saveType,
        () => _saveType((type: type, exists: state.profile != null)),
        (current, profile) => current.copyWith(profile: profile, step: CompanyStep.info),
      );

  Future<void> saveInfo(CompanyInfo info) async {
    final type = state.businessType;
    if (type == null) return;
    await _save(
      CompanyAction.saveInfo,
      () => _saveInfo((type: type, info: info)),
      (current, profile) => current.copyWith(profile: profile, step: CompanyStep.contact),
    );
  }

  Future<void> saveContact(CompanyContact contact) => _save(
        CompanyAction.saveContact,
        () => _saveContact(contact),
        (current, profile) {
          final updated = current.copyWith(profile: profile);
          return updated.copyWith(step: _after(updated, CompanyStep.contact));
        },
      );

  Future<void> submit(CompanyConsents consents) => _save(
        CompanyAction.submit,
        () => _submit(consents),
        (current, profile) => current.copyWith(profile: profile),
      );

  Future<void> uploadDocument(CompanyDocumentType type, UploadFile file) => _save(
        CompanyAction.uploadDocument,
        () => _uploadDocument((type: type, file: file, replacing: state.documentOf(type))),
        (current, document) => current.copyWith(documents: [
          for (final d in current.documents)
            if (d.type != type) d,
          document,
        ]),
        target: type,
      );

  Future<void> deleteDocument(CompanyDocument document) => _save<void>(
        CompanyAction.deleteDocument,
        () => _deleteDocument(document.id),
        (current, _) => current.copyWith(documents: [for (final d in current.documents) if (d.id != document.id) d]),
        target: document.type,
      );

  Future<void> _save<T>(
    CompanyAction action,
    Future<Result<T>> Function() request,
    CompanyState Function(CompanyState current, T value) onSuccess, {
    Object? target,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: action, status: CompanyStatus.loading, failure: null, target: target));

    final result = await request();
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(onSuccess(state, value).copyWith(action: action, status: CompanyStatus.success));
      case Err(:final failure):
        emit(state.copyWith(action: action, status: CompanyStatus.failure, failure: failure));
    }
  }

  static CompanyStep _resumeStep(CompanyState state) {
    final profile = state.profile;
    if (profile == null || profile.businessType == null) return CompanyStep.type;
    final info = profile.info;
    if (info.ownerName.isEmpty || info.address.isEmpty) return CompanyStep.info;
    if (profile.contact.phone.isEmpty || profile.contact.email.isEmpty) return CompanyStep.contact;
    if (state.missingDocuments.isNotEmpty) return CompanyStep.documents;
    return CompanyStep.review;
  }
}
