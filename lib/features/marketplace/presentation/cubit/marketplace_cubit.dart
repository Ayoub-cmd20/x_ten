import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/marketplace/domain/entities/market_influencer.dart';
import 'package:x_ten/features/marketplace/domain/usecases/get_influencer_usecase.dart';
import 'package:x_ten/features/marketplace/domain/usecases/get_influencers_usecase.dart';

export 'package:x_ten/features/marketplace/domain/entities/featured_work.dart';
export 'package:x_ten/features/marketplace/domain/entities/market_influencer.dart';

part 'marketplace_state.dart';

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit({
    required GetInfluencersUseCase getInfluencers,
    required GetInfluencerUseCase getInfluencer,
  })  : _getInfluencers = getInfluencers,
        _getInfluencer = getInfluencer,
        super(const MarketplaceState());

  static const _debounceDelay = Duration(milliseconds: 400);

  final GetInfluencersUseCase _getInfluencers;
  final GetInfluencerUseCase _getInfluencer;

  Timer? _debounce;
  int _request = 0;

  Future<void> start({String? category}) => _search(category: category, query: '');

  Future<void> refresh() => _search(category: state.category, query: state.query);

  void selectCategory(String? category) {
    if (state.loaded && category == state.category) return;
    _debounce?.cancel();
    _search(category: category, query: state.query);
  }

  void searchChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query == state.query) return;
    _debounce = Timer(_debounceDelay, () => _search(category: state.category, query: query));
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.influencers.hasMore) return;
    final request = _request;
    final page = state.page + 1;
    emit(state.copyWith(action: MarketplaceAction.loadMore, status: MarketplaceStatus.loading, failure: null));

    final result = await _getInfluencers((category: state.category, search: state.query, page: page));
    if (isClosed || request != _request) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(
          influencers: state.influencers.append(value),
          page: page,
          status: MarketplaceStatus.success,
        ));
      case Err(:final failure):
        emit(state.copyWith(status: MarketplaceStatus.failure, failure: failure));
    }
  }

  Future<void> openInfluencer(int id, {MarketInfluencer? preview}) async {
    final cached = preview ?? state.influencers.items.where((i) => i.id == id).firstOrNull;
    emit(state.copyWith(
      action: MarketplaceAction.details,
      status: MarketplaceStatus.loading,
      failure: null,
      details: cached,
    ));

    final result = await _getInfluencer(id);
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(details: value, status: MarketplaceStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: MarketplaceStatus.failure, failure: failure));
    }
  }

  Future<void> _search({required String? category, required String query}) async {
    final request = ++_request;
    emit(state.copyWith(
      action: MarketplaceAction.search,
      status: MarketplaceStatus.loading,
      failure: null,
      category: category,
      query: query,
    ));

    final result = await _getInfluencers((category: category, search: query, page: 1));
    if (isClosed || request != _request) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(influencers: value, page: 1, loaded: true, status: MarketplaceStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: MarketplaceStatus.failure, failure: failure));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
