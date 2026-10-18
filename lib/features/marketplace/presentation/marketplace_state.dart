part of 'marketplace_cubit.dart';

enum MarketplaceAction { none, search, loadMore, details }

enum MarketplaceStatus { idle, loading, success, failure }

final class MarketplaceState extends Equatable {
  const MarketplaceState({
    this.action = MarketplaceAction.none,
    this.status = MarketplaceStatus.idle,
    this.failure,
    this.category,
    this.query = '',
    this.influencers = const Paginated.empty(),
    this.page = 1,
    this.loaded = false,
    this.details,
  });

  static const _keep = Object();

  final MarketplaceAction action;
  final MarketplaceStatus status;
  final Failure? failure;
  final String? category;
  final String query;
  final Paginated<MarketInfluencer> influencers;
  final int page;
  final bool loaded;
  final MarketInfluencer? details;

  bool get isLoading => status == MarketplaceStatus.loading;

  bool isLoadingFor(MarketplaceAction value) => isLoading && action == value;

  bool didFail(MarketplaceAction value) => action == value && status == MarketplaceStatus.failure;

  MarketplaceState copyWith({
    MarketplaceAction? action,
    MarketplaceStatus? status,
    Object? failure = _keep,
    Object? category = _keep,
    String? query,
    Paginated<MarketInfluencer>? influencers,
    int? page,
    bool? loaded,
    Object? details = _keep,
  }) =>
      MarketplaceState(
        action: action ?? this.action,
        status: status ?? this.status,
        failure: identical(failure, _keep) ? this.failure : failure as Failure?,
        category: identical(category, _keep) ? this.category : category as String?,
        query: query ?? this.query,
        influencers: influencers ?? this.influencers,
        page: page ?? this.page,
        loaded: loaded ?? this.loaded,
        details: identical(details, _keep) ? this.details : details as MarketInfluencer?,
      );

  @override
  List<Object?> get props => [
        action,
        status,
        failure,
        category,
        query,
        influencers.items,
        influencers.next,
        page,
        loaded,
        details,
      ];
}
