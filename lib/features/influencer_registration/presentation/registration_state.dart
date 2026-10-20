part of 'registration_cubit.dart';

enum RegistrationAction {
  none,
  load,
  saveSection,
  addSocial,
  updateSocial,
  refreshSocial,
  deleteSocial,
  addPortfolio,
  deletePortfolio,
  uploadPhoto,
  deletePhoto,
  addFinancial,
  deleteFinancial,
  uploadDocument,
  deleteDocument,
  submit,
  newAttempt,
}

enum OperationStatus { idle, loading, success, failure }

/// نفس ترتيب وثيقة صاحب المشروع.
enum RegistrationStep { personal, profile, contact, accounts, optional, financial, security, photo, documents }

final class RegistrationState extends Equatable {
  const RegistrationState({
    this.action = RegistrationAction.none,
    this.status = OperationStatus.idle,
    this.failure,
    this.target,
    this.loaded = false,
    this.registration,
    this.account,
    this.socialAccounts = const [],
    this.portfolio = const [],
    this.financialAccounts = const [],
    this.documents = const [],
    this.meeting,
    this.step = RegistrationStep.personal,
  });

  static const _keep = Object();

  final RegistrationAction action;
  final OperationStatus status;
  final Failure? failure;
  final Object? target;
  final bool loaded;
  final Registration? registration;
  final User? account;
  final List<SocialAccount> socialAccounts;
  final List<PortfolioItem> portfolio;
  final List<FinancialAccount> financialAccounts;
  final List<RegistrationDocument> documents;
  final VerificationMeeting? meeting;
  final RegistrationStep step;

  bool get isLoading => status == OperationStatus.loading;

  bool isLoadingFor(RegistrationAction value, [Object? item]) =>
      isLoading && action == value && (item == null || target == item);

  bool didSucceed(RegistrationAction value) => action == value && status == OperationStatus.success;

  bool didFail(RegistrationAction value) => action == value && status == OperationStatus.failure;

  bool get hasRegistration => registration != null;

  RegistrationStep get furthestAllowed => hasRegistration ? RegistrationStep.documents : RegistrationStep.personal;

  // ---------- قيم أولية من الحساب ----------

  PersonalInfo get personalSeed {
    if (registration case final registration?) return registration.personal;
    final parts = (account?.fullName ?? '').trim().split(RegExp(r'\s+'));
    return PersonalInfo(
      firstName: parts.isEmpty ? '' : parts.first,
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      birthPlace: '',
    );
  }

  // ---------- الوثائق ----------

  RegistrationDocument? documentOf(DocumentType type, {int? financialAccountId}) => documents
      .where((d) => d.type == type && d.financialAccountId == financialAccountId)
      .firstOrNull;

  RegistrationDocument? documentForAccount(FinancialAccount account) =>
      documentOf(account.documentType, financialAccountId: account.id);

  bool get hasIdCard =>
      documentOf(DocumentType.identityFront) != null && documentOf(DocumentType.identityBack) != null;

  bool get hasIdentity => hasIdCard || documentOf(DocumentType.passport) != null;

  List<FinancialAccount> get accountsMissingDocument =>
      [for (final account in financialAccounts) if (documentForAccount(account) == null) account];

  bool get financialComplete => financialAccounts.isNotEmpty && accountsMissingDocument.isEmpty;

  RegistrationState copyWith({
    RegistrationAction? action,
    OperationStatus? status,
    Object? failure = _keep,
    Object? target = _keep,
    bool? loaded,
    Object? registration = _keep,
    Object? account = _keep,
    List<SocialAccount>? socialAccounts,
    List<PortfolioItem>? portfolio,
    List<FinancialAccount>? financialAccounts,
    List<RegistrationDocument>? documents,
    Object? meeting = _keep,
    RegistrationStep? step,
  }) =>
      RegistrationState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        target: identical(target, _keep) ? this.target : target,
        loaded: loaded ?? this.loaded,
        registration: identical(registration, _keep) ? this.registration : registration as Registration?,
        account: identical(account, _keep) ? this.account : account as User?,
        socialAccounts: socialAccounts ?? this.socialAccounts,
        portfolio: portfolio ?? this.portfolio,
        financialAccounts: financialAccounts ?? this.financialAccounts,
        documents: documents ?? this.documents,
        meeting: identical(meeting, _keep) ? this.meeting : meeting as VerificationMeeting?,
        step: step ?? this.step,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        target,
        loaded,
        registration,
        account,
        socialAccounts,
        portfolio,
        financialAccounts,
        documents,
        meeting,
        step,
      ];
}
