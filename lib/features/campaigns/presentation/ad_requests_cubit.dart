import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/features/campaigns/domain/campaign_usecases.dart';

export 'package:x_ten/features/campaigns/domain/campaign_entities.dart';

part 'ad_requests_state.dart';

class AdRequestsCubit extends Cubit<AdRequestsState> {
  AdRequestsCubit({
    required GetAdRequestsUseCase getRequests,
    required GetAdRequestUseCase getRequest,
    required SaveAdDraftUseCase saveDraft,
    required UploadAdAttachmentUseCase uploadAttachment,
    required SubmitAdRequestUseCase submit,
    required DeleteAdDraftUseCase deleteDraft,
    required RejectAdRequestUseCase reject,
    required ReplyToModificationUseCase replyModification,
  })  : _getRequests = getRequests,
        _getRequest = getRequest,
        _saveDraft = saveDraft,
        _uploadAttachment = uploadAttachment,
        _submit = submit,
        _deleteDraft = deleteDraft,
        _reject = reject,
        _replyModification = replyModification,
        super(const AdRequestsState());

  final GetAdRequestsUseCase _getRequests;
  final GetAdRequestUseCase _getRequest;
  final SaveAdDraftUseCase _saveDraft;
  final UploadAdAttachmentUseCase _uploadAttachment;
  final SubmitAdRequestUseCase _submit;
  final DeleteAdDraftUseCase _deleteDraft;
  final RejectAdRequestUseCase _reject;
  final ReplyToModificationUseCase _replyModification;

  int _request = 0;

  Future<void> load({AdRequestStatus? filter}) async {
    final request = ++_request;
    emit(state.copyWith(
      action: AdRequestsAction.list,
      status: AdRequestsStatus.loading,
      failure: null,
      filter: filter,
    ));

    final result = await _getRequests((status: filter, page: 1));
    if (isClosed || request != _request) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(requests: value, page: 1, loaded: true, status: AdRequestsStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: AdRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> refresh() => load(filter: state.filter);

  void selectFilter(AdRequestStatus? filter) {
    if (state.loaded && filter == state.filter) return;
    load(filter: filter);
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.requests.hasMore) return;
    final request = _request;
    final page = state.page + 1;
    emit(state.copyWith(action: AdRequestsAction.loadMore, status: AdRequestsStatus.loading, failure: null));

    final result = await _getRequests((status: state.filter, page: page));
    if (isClosed || request != _request) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(requests: state.requests.append(value), page: page, status: AdRequestsStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: AdRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> openDetails(int id, {AdRequest? preview}) async {
    final cached = preview ?? state.requests.items.where((r) => r.id == id).firstOrNull;
    emit(state.copyWith(
      action: AdRequestsAction.details,
      status: AdRequestsStatus.loading,
      failure: null,
      selected: cached == null ? null : AdRequestBundle(request: cached),
    ));

    final result = await _getRequest(id);
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        emit(state.copyWith(selected: value, status: AdRequestsStatus.success));
      case Err(:final failure):
        emit(state.copyWith(status: AdRequestsStatus.failure, failure: failure));
    }
  }

  Future<void> send({
    required int influencerProfileId,
    required AdBrief brief,
    required List<PendingAttachment> files,
  }) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: AdRequestsAction.send, status: AdRequestsStatus.loading, failure: null));

    final pending = [for (final f in files) if (!state.uploadedPaths.contains(f.file.path)) f];
    final uploadedReady = state.draft?.attachmentsFor(AttachmentPurpose.readyContent).length ?? 0;
    final pendingReady = pending.where((f) => f.purpose == AttachmentPurpose.readyContent).length;

    final saved = await _saveDraft((
      draftId: state.draft?.id,
      influencerProfileId: influencerProfileId,
      brief: brief,
      readyContentCount: uploadedReady + pendingReady,
    ));
    if (isClosed) return;
    final AdRequest draft;
    switch (saved) {
      case Ok(:final value):
        draft = value;
        emit(state.copyWith(draft: value));
      case Err(:final failure):
        return _fail(AdRequestsAction.send, failure);
    }

    for (final item in pending) {
      final uploaded = await _uploadAttachment((requestId: draft.id, purpose: item.purpose, file: item.file));
      if (isClosed) return;
      switch (uploaded) {
        case Ok():
          emit(state.copyWith(uploadedPaths: {...state.uploadedPaths, item.file.path}));
        case Err(:final failure):
          return _fail(AdRequestsAction.send, failure);
      }
    }

    final submitted = await _submit(draft.id);
    if (isClosed) return;
    switch (submitted) {
      case Ok(:final value):
        emit(state.copyWith(draft: value, status: AdRequestsStatus.success));
      case Err(:final failure):
        _fail(AdRequestsAction.send, failure);
    }
  }

  Future<void> submitDraft(int id) => _act(AdRequestsAction.submitDraft, id, () => _submit(id));

  Future<void> reject(int id, String reason) =>
      _act(AdRequestsAction.reject, id, () => _reject((id: id, reason: reason)));

  Future<void> replyModification(int id, {required bool accept, String message = ''}) => _act(
        AdRequestsAction.replyModification,
        id,
        () => _replyModification((id: id, accept: accept, message: message)),
      );

  Future<void> deleteDraft(int id) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: AdRequestsAction.deleteDraft, status: AdRequestsStatus.loading, failure: null));

    final result = await _deleteDraft(id);
    if (isClosed) return;

    switch (result) {
      case Ok():
        emit(state.copyWith(
          requests: _without(id),
          selected: null,
          status: AdRequestsStatus.success,
        ));
      case Err(:final failure):
        _fail(AdRequestsAction.deleteDraft, failure);
    }
  }

  Future<void> _act(AdRequestsAction action, int id, Future<Result<AdRequest>> Function() request) async {
    if (state.isLoading) return;
    emit(state.copyWith(action: action, status: AdRequestsStatus.loading, failure: null));

    final result = await request();
    if (isClosed) return;

    switch (result) {
      case Ok(:final value):
        final refreshed = await _getRequest(id);
        if (isClosed) return;
        final bundle = switch (refreshed) {
          Ok(value: final fresh) => fresh,
          Err() => AdRequestBundle(request: value, events: state.selected?.events ?? const []),
        };
        emit(state.copyWith(
          selected: bundle,
          requests: _replaced(bundle.request),
          status: AdRequestsStatus.success,
        ));
      case Err(:final failure):
        _fail(action, failure);
    }
  }

  void _fail(AdRequestsAction action, Failure failure) =>
      emit(state.copyWith(action: action, status: AdRequestsStatus.failure, failure: failure));

  Paginated<AdRequest> _replaced(AdRequest request) => Paginated(
        count: state.requests.count,
        next: state.requests.next,
        items: [for (final r in state.requests.items) r.id == request.id ? request : r],
      );

  Paginated<AdRequest> _without(int id) => Paginated(
        count: state.requests.count - 1,
        next: state.requests.next,
        items: [for (final r in state.requests.items) if (r.id != id) r],
      );
}
