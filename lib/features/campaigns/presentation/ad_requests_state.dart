part of 'ad_requests_cubit.dart';

enum AdRequestsAction {
  none,
  list,
  loadMore,
  details,
  send,
  submitDraft,
  deleteDraft,
  reject,
  replyModification,
}

enum AdRequestsStatus { idle, loading, success, failure }

typedef PendingAttachment = ({AttachmentPurpose purpose, UploadFile file});

final class AdRequestsState extends Equatable {
  const AdRequestsState({
    this.action = AdRequestsAction.none,
    this.status = AdRequestsStatus.idle,
    this.failure,
    this.filter,
    this.requests = const Paginated.empty(),
    this.page = 1,
    this.loaded = false,
    this.selected,
    this.draft,
    this.uploadedPaths = const {},
  });

  static const _keep = Object();

  final AdRequestsAction action;
  final AdRequestsStatus status;
  final Failure? failure;
  final AdRequestStatus? filter;
  final Paginated<AdRequest> requests;
  final int page;
  final bool loaded;
  final AdRequestBundle? selected;
  final AdRequest? draft;
  final Set<String> uploadedPaths;

  bool get isLoading => status == AdRequestsStatus.loading;

  bool isLoadingFor(AdRequestsAction value) => isLoading && action == value;

  bool didSucceed(AdRequestsAction value) => action == value && status == AdRequestsStatus.success;

  bool didFail(AdRequestsAction value) => action == value && status == AdRequestsStatus.failure;

  AdRequestsState copyWith({
    AdRequestsAction? action,
    AdRequestsStatus? status,
    Object? failure = _keep,
    Object? filter = _keep,
    Paginated<AdRequest>? requests,
    int? page,
    bool? loaded,
    Object? selected = _keep,
    Object? draft = _keep,
    Set<String>? uploadedPaths,
  }) =>
      AdRequestsState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        filter: identical(filter, _keep) ? this.filter : filter as AdRequestStatus?,
        requests: requests ?? this.requests,
        page: page ?? this.page,
        loaded: loaded ?? this.loaded,
        selected: identical(selected, _keep) ? this.selected : selected as AdRequestBundle?,
        draft: identical(draft, _keep) ? this.draft : draft as AdRequest?,
        uploadedPaths: uploadedPaths ?? this.uploadedPaths,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        filter,
        requests.items,
        requests.next,
        page,
        loaded,
        selected,
        draft,
        uploadedPaths,
      ];
}
