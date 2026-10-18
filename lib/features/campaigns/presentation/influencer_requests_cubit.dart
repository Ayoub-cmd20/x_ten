import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/features/campaigns/domain/campaign_usecases.dart';

export 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
export 'package:x_ten/features/campaigns/domain/campaign_usecases.dart' show InfluencerReply;

part 'influencer_requests_state.dart';

class InfluencerRequestsCubit extends Cubit<InfluencerRequestsState> {
  InfluencerRequestsCubit({
    required GetInfluencerTabsUseCase getTabs,
    required GetInfluencerRequestsUseCase getRequests,
    required GetInfluencerRequestUseCase getRequest,
    required ReplyToRequestUseCase reply,
  })  : _getTabs = getTabs,
        _getRequests = getRequests,
        _getRequest = getRequest,
        _reply = reply,
        super(const InfluencerRequestsState());

  final GetInfluencerTabsUseCase _getTabs;
  final GetInfluencerRequestsUseCase _getRequests;
  final GetInfluencerRequestUseCase _getRequest;
  final ReplyToRequestUseCase _reply;

  int _request = 0;

  Future<void> load({InfluencerTab? tab}) async {
    final request = ++_request;
    final selectedTab = tab ?? state.tab;
    emit(state.copyWith(
      action: InfluencerRequestsAction.list,
      status: InfluencerRequestsStatus.loading,
      failure: null,
      tab: selectedTab,
    ));

    final counts = await _getTabs(const NoParams());
    final result = await _getRequests((tab: selectedTab, page: 1));
    if (isClosed || request != _request) return;

    final nextCounts = switch (counts) {
      Ok(:final value) => value,
      Err() => state.counts,
    };

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(
          counts: nextCounts,
          requests: value,
          page: 1,
          loaded: true,
          status: InfluencerRequestsStatus.success,
        ));
      case Err(:final failure):
        emit(state.copyWith(counts: nextCounts, status: InfluencerRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> refresh() => load();

  void selectTab(InfluencerTab tab) {
    if (state.loaded && tab == state.tab) return;
    load(tab: tab);
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.requests.hasMore) return;
    final request = _request;
    final page = state.page + 1;
    emit(state.copyWith(
      action: InfluencerRequestsAction.loadMore,
      status: InfluencerRequestsStatus.loading,
      failure: null,
    ));

    final result = await _getRequests((tab: state.tab, page: page));
    if (isClosed || request != _request) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(
          requests: state.requests.append(value),
          page: page,
          status: InfluencerRequestsStatus.success,
        ));
      case Err(:final failure):
        emit(state.copyWith(status: InfluencerRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> openDetails(int id, {AdRequest? preview}) async {
    final cached = preview ?? state.requests.items.where((r) => r.id == id).firstOrNull;
    emit(state.copyWith(
      action: InfluencerRequestsAction.details,
      status: InfluencerRequestsStatus.loading,
      failure: null,
      selected: cached == null ? null : AdRequestBundle(request: cached),
    ));

    final result = await _getRequest(id);
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(selected: value, status: InfluencerRequestsStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: InfluencerRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> reply(int id, InfluencerReply reply, {String message = '', double? proposedBudget}) async {
    if (state.isLoading) return;
    emit(state.copyWith(
      action: InfluencerRequestsAction.reply,
      status: InfluencerRequestsStatus.loading,
      failure: null,
    ));

    final result = await _reply((id: id, reply: reply, message: message, proposedBudget: proposedBudget));
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        final refreshed = await _getRequest(id);
        if (isClosed) return;
        final bundle = switch (refreshed) {
          Ok(value: final fresh) => fresh,
          Err() => AdRequestBundle(request: value, events: state.selected?.events ?? const []),
        };
        emit(state.copyWith(selected: bundle, status: InfluencerRequestsStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: InfluencerRequestsStatus.failure, failure: failure));
    }
  }
}
