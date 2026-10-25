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
  socialScreenshot,
  readFinancial,
  scanAudience,
  submit,
}

enum OperationStatus { idle, loading, success, failure }

/// نفس ترتيب وثيقة صاحب المشروع.
enum RegistrationStep { personal, profile, contact, accounts, optional, financial, review }

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
    this.scannedAudience,
    this.readAccount,
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

  /// آخر نتيجة من لقطات Insights (تعمّر الاستمارة، ماشي محفوظة)
  final Audience? scannedAudience;
  final FinancialAccount? readAccount;
  final RegistrationStep step;

  bool get isLoading => status == OperationStatus.loading;

  bool isLoadingFor(RegistrationAction value, [Object? item]) =>
      isLoading && action == value && (item == null || target == item);

  bool didSucceed(RegistrationAction value) => action == value && status == OperationStatus.success;

  bool didFail(RegistrationAction value) => action == value && status == OperationStatus.failure;

  bool get hasRegistration => registration != null;

  RegistrationStep get furthestAllowed => hasRegistration ? RegistrationStep.review : RegistrationStep.personal;

  // ---------- قيم أولية من الحساب ----------

  /// الاسم واللقب يكتبهم من الوثيقة: اسم المستخدم (التسجيل الأول) ماشي هو الاسم الحقيقي
  PersonalInfo get personalSeed =>
      registration?.personal ?? const PersonalInfo(firstName: '', lastName: '', birthPlace: '');

  // ---------- الوثائق ----------

  RegistrationDocument? documentOf(DocumentType type, {int? financialAccountId}) => documents
      .where((d) => d.type == type && d.financialAccountId == financialAccountId)
      .firstOrNull;

  bool get hasIdCard => documentOf(DocumentType.identityFront) != null;

  bool get hasIdentity => hasIdCard || documentOf(DocumentType.passport) != null;

  bool get financialComplete => financialAccounts.isNotEmpty;

  RegistrationDocument? proofOf(int accountId) => documents
      .where((d) => d.financialAccountId == accountId && (d.type == DocumentType.financialProof || d.type == DocumentType.ccpCheque))
      .firstOrNull;

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
    Object? scannedAudience = _keep,
    Object? readAccount = _keep,
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
        scannedAudience: identical(scannedAudience, _keep) ? this.scannedAudience : scannedAudience as Audience?,
        readAccount: identical(readAccount, _keep) ? this.readAccount : readAccount as FinancialAccount?,
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
        scannedAudience,
        readAccount,
        step,
      ];
}
