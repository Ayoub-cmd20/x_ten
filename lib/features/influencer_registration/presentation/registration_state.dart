part of 'registration_cubit.dart';

enum RegistrationAction {
  none,
  load,
  saveBasic,
  saveProfile,
  addSocial,
  deleteSocial,
  addPortfolio,
  deletePortfolio,
  uploadPhoto,
  deletePhoto,
  saveFinancial,
  uploadDocument,
  deleteDocument,
  submit,
  newAttempt,
}

enum OperationStatus { idle, loading, success, failure }

enum RegistrationStep { basicInfo, audience, accounts, photo, financial, review }

final class RegistrationState extends Equatable {
  const RegistrationState({
    this.action = RegistrationAction.none,
    this.status = OperationStatus.idle,
    this.failure,
    this.target,
    this.loaded = false,
    this.registration,
    this.pendingBasic,
    this.account,
    this.socialAccounts = const [],
    this.portfolio = const [],
    this.documents = const [],
    this.meeting,
    this.step = RegistrationStep.basicInfo,
    this.notifications = const NotificationPreferences(),
  });

  static const _keep = Object();

  final RegistrationAction action;
  final OperationStatus status;
  final Failure? failure;
  final Object? target;
  final bool loaded;
  final Registration? registration;
  final BasicInfo? pendingBasic;
  final User? account;
  final List<SocialAccount> socialAccounts;
  final List<PortfolioItem> portfolio;
  final List<RegistrationDocument> documents;
  final VerificationMeeting? meeting;
  final RegistrationStep step;
  final NotificationPreferences notifications;

  bool get isLoading => status == OperationStatus.loading;

  bool isLoadingFor(RegistrationAction value, [Object? item]) =>
      isLoading && action == value && (item == null || target == item);

  bool didSucceed(RegistrationAction value) => action == value && status == OperationStatus.success;

  bool didFail(RegistrationAction value) => action == value && status == OperationStatus.failure;

  bool get hasRegistration => registration != null;

  RegistrationStep get furthestAllowed => hasRegistration
      ? RegistrationStep.review
      : pendingBasic != null
          ? RegistrationStep.audience
          : RegistrationStep.basicInfo;

  BasicInfo get basicSeed {
    if (registration case final registration?) return registration.basic;
    if (pendingBasic case final basic?) return basic;
    final parts = (account?.fullName ?? '').trim().split(RegExp(r'\s+'));
    return BasicInfo(
      firstName: parts.isEmpty ? '' : parts.first,
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      displayName: account?.fullName ?? '',
      birthPlace: '',
      bio: '',
      skills: '',
      whatsapp: account?.phone ?? '',
    );
  }

  RegistrationDocument? documentOf(DocumentType type) => documents.where((d) => d.type == type).firstOrNull;

  List<DocumentType> missingDocuments(FinancialAccountType? type) => [
        for (final required in RegistrationCatalog.requiredDocuments(type))
          if (documentOf(required) == null) required,
      ];

  RegistrationState copyWith({
    RegistrationAction? action,
    OperationStatus? status,
    Object? failure = _keep,
    Object? target = _keep,
    bool? loaded,
    Object? registration = _keep,
    Object? pendingBasic = _keep,
    Object? account = _keep,
    List<SocialAccount>? socialAccounts,
    List<PortfolioItem>? portfolio,
    List<RegistrationDocument>? documents,
    Object? meeting = _keep,
    RegistrationStep? step,
    NotificationPreferences? notifications,
  }) =>
      RegistrationState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        target: identical(target, _keep) ? this.target : target,
        loaded: loaded ?? this.loaded,
        registration: identical(registration, _keep) ? this.registration : registration as Registration?,
        pendingBasic: identical(pendingBasic, _keep) ? this.pendingBasic : pendingBasic as BasicInfo?,
        account: identical(account, _keep) ? this.account : account as User?,
        socialAccounts: socialAccounts ?? this.socialAccounts,
        portfolio: portfolio ?? this.portfolio,
        documents: documents ?? this.documents,
        meeting: identical(meeting, _keep) ? this.meeting : meeting as VerificationMeeting?,
        step: step ?? this.step,
        notifications: notifications ?? this.notifications,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        target,
        loaded,
        registration,
        pendingBasic,
        account,
        socialAccounts,
        portfolio,
        documents,
        meeting,
        step,
        notifications,
      ];
}
