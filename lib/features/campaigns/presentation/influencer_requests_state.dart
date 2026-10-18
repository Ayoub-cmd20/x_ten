part of 'influencer_requests_cubit.dart';

enum InfluencerRequestsAction { none, list, loadMore, details, reply }

enum InfluencerRequestsStatus { idle, loading, success, failure }

final class InfluencerRequestsState extends Equatable {
  const InfluencerRequestsState({
    this.action = InfluencerRequestsAction.none,
    this.status = InfluencerRequestsStatus.idle,
    this.failure,
    this.tab = InfluencerTab.requested,
    this.counts = const InfluencerTabCounts(),
    this.requests = const Paginated.empty(),
    this.page = 1,
    this.loaded = false,
    this.selected,
  });

  static const _keep = Object();

  final InfluencerRequestsAction action;
  final InfluencerRequestsStatus status;
  final Failure? failure;
  final InfluencerTab tab;
  final InfluencerTabCounts counts;
  final Paginated<AdRequest> requests;
  final int page;
  final bool loaded;
  final AdRequestBundle? selected;

  bool get isLoading => status == InfluencerRequestsStatus.loading;

  bool isLoadingFor(InfluencerRequestsAction value) => isLoading && action == value;

  bool didSucceed(InfluencerRequestsAction value) => action == value && status == InfluencerRequestsStatus.success;

  bool didFail(InfluencerRequestsAction value) => action == value && status == InfluencerRequestsStatus.failure;

  InfluencerRequestsState copyWith({
    InfluencerRequestsAction? action,
    InfluencerRequestsStatus? status,
    Object? failure = _keep,
    InfluencerTab? tab,
    InfluencerTabCounts? counts,
    Paginated<AdRequest>? requests,
    int? page,
    bool? loaded,
    Object? selected = _keep,
  }) =>
      InfluencerRequestsState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        tab: tab ?? this.tab,
        counts: counts ?? this.counts,
        requests: requests ?? this.requests,
        page: page ?? this.page,
        loaded: loaded ?? this.loaded,
        selected: identical(selected, _keep) ? this.selected : selected as AdRequestBundle?,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        tab,
        counts,
        requests.items,
        requests.next,
        page,
        loaded,
        selected,
      ];
}
