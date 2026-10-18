part of 'company_cubit.dart';

enum CompanyAction { none, load, saveType, saveInfo, saveContact, uploadDocument, deleteDocument, submit }

enum CompanyStatus { idle, loading, success, failure }

enum CompanyStep { type, info, contact, documents, review }

final class CompanyState extends Equatable {
  const CompanyState({
    this.action = CompanyAction.none,
    this.status = CompanyStatus.idle,
    this.failure,
    this.target,
    this.loaded = false,
    this.profile,
    this.documents = const [],
    this.step = CompanyStep.type,
  });

  static const _keep = Object();

  final CompanyAction action;
  final CompanyStatus status;
  final Failure? failure;
  final Object? target;
  final bool loaded;
  final CompanyProfile? profile;
  final List<CompanyDocument> documents;
  final CompanyStep step;

  bool get isLoading => status == CompanyStatus.loading;

  bool isLoadingFor(CompanyAction value, [Object? item]) =>
      isLoading && action == value && (item == null || target == item);

  bool didSucceed(CompanyAction value) => action == value && status == CompanyStatus.success;

  bool didFail(CompanyAction value) => action == value && status == CompanyStatus.failure;

  BusinessType? get businessType => profile?.businessType;

  List<CompanyStep> get steps => [
        CompanyStep.type,
        CompanyStep.info,
        CompanyStep.contact,
        if (businessType == BusinessType.registeredBusiness) CompanyStep.documents,
        CompanyStep.review,
      ];

  bool canOpen(CompanyStep target) =>
      steps.contains(target) && (target == CompanyStep.type || businessType != null);

  CompanyDocument? documentOf(CompanyDocumentType type) => documents.where((d) => d.type == type).firstOrNull;

  List<CompanyDocumentType> get missingDocuments => [
        for (final type in CompanyCatalog.requiredDocuments(businessType))
          if (documentOf(type) == null) type,
      ];

  CompanyState copyWith({
    CompanyAction? action,
    CompanyStatus? status,
    Object? failure = _keep,
    Object? target = _keep,
    bool? loaded,
    Object? profile = _keep,
    List<CompanyDocument>? documents,
    CompanyStep? step,
  }) =>
      CompanyState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        target: identical(target, _keep) ? this.target : target,
        loaded: loaded ?? this.loaded,
        profile: identical(profile, _keep) ? this.profile : profile as CompanyProfile?,
        documents: documents ?? this.documents,
        step: step ?? this.step,
      );

  @override
  List<Object?> get props => [action, status, failure, target, loaded, profile, documents, step];
}
