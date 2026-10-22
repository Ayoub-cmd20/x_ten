part of 'company_cubit.dart';

enum CompanyAction {
  none,
  load,
  saveType,
  saveSection,
  uploadPhoto,
  deletePhoto,
  uploadDocument,
  deleteDocument,
  addFinancial,
  deleteFinancial,
  readFinancial,
  submit,
}

enum CompanyStatus { idle, loading, success, failure }

enum CompanyStep { type, personal, business, presence, contact, finish }

final class CompanyState extends Equatable {
  const CompanyState({
    this.action = CompanyAction.none,
    this.status = CompanyStatus.idle,
    this.failure,
    this.target,
    this.loaded = false,
    this.profile,
    this.documents = const [],
    this.financialAccounts = const [],
    this.readAccount,
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
  final List<FinancialAccount> financialAccounts;
  final FinancialAccount? readAccount;
  final CompanyStep step;

  bool get isLoading => status == CompanyStatus.loading;

  bool isLoadingFor(CompanyAction value, [Object? item]) =>
      isLoading && action == value && (item == null || target == item);

  bool didSucceed(CompanyAction value) => action == value && status == CompanyStatus.success;

  bool didFail(CompanyAction value) => action == value && status == CompanyStatus.failure;

  BusinessType? get businessType => profile?.businessType;

  bool get isRegistered => businessType == BusinessType.registeredBusiness;

  List<CompanyStep> get steps => CompanyStep.values;

  bool canOpen(CompanyStep target) => target == CompanyStep.type || businessType != null;

  CompanyDocument? documentOf(CompanyDocumentType type, {int? financialAccountId}) => documents
      .where((d) => d.type == type && (financialAccountId == null || d.financialAccountId == financialAccountId))
      .firstOrNull;

  List<CompanyDocument> documentsOf(CompanyDocumentType type) => [for (final d in documents) if (d.type == type) d];

  bool get hasIdCard => documentOf(CompanyDocumentType.identityFront) != null;

  bool get hasIdentity => hasIdCard || documentOf(CompanyDocumentType.passport) != null;

  CompanyDocument? proofOf(int accountId) => documents
      .where((d) => d.financialAccountId == accountId && d.type != CompanyDocumentType.other)
      .firstOrNull;

  bool get financialComplete => financialAccounts.isNotEmpty;

  CompanyState copyWith({
    CompanyAction? action,
    CompanyStatus? status,
    Object? failure = _keep,
    Object? target = _keep,
    bool? loaded,
    Object? profile = _keep,
    List<CompanyDocument>? documents,
    List<FinancialAccount>? financialAccounts,
    Object? readAccount = _keep,
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
        financialAccounts: financialAccounts ?? this.financialAccounts,
        readAccount: identical(readAccount, _keep) ? this.readAccount : readAccount as FinancialAccount?,
        step: step ?? this.step,
      );

  @override
  List<Object?> get props =>
      [action, status, failure, target, loaded, profile, documents, financialAccounts, readAccount, step];
}
