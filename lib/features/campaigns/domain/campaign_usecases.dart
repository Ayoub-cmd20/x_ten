import 'package:x_ten/core/errors/failures.dart';
import 'package:x_ten/core/pagination/paginated.dart';
import 'package:x_ten/core/usecase/usecase.dart';
import 'package:x_ten/core/utils/file_rules.dart';
import 'package:x_ten/core/utils/result.dart';
import 'package:x_ten/features/campaigns/domain/campaign_entities.dart';
import 'package:x_ten/features/campaigns/domain/campaign_repository.dart';

typedef AdRequestsParams = ({AdRequestStatus? status, int page});
typedef SaveDraftParams = ({int? draftId, int influencerProfileId, AdBrief brief, int readyContentCount});
typedef AttachmentParams = ({int requestId, AttachmentPurpose purpose, UploadFile file});
typedef ReasonParams = ({int id, String reason});
typedef ModificationReplyParams = ({int id, bool accept, String message});
typedef InfluencerRequestsParams = ({InfluencerTab tab, int page});
typedef InfluencerReplyParams = ({int id, InfluencerReply reply, String message, double? proposedBudget});

enum InfluencerReply { accept, counterOffer, unclear, decline }

const _required = 'required';

Result<T> _invalid<T>(Map<String, dynamic> details) => Err(ValidationFailure(details: details));

String _text(String value) => value.trim();

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

AdBrief _normalized(AdBrief brief) {
  final travel = brief.requiresTravel;
  final template = !travel && brief.entryMode == EntryMode.template;
  final freeText = !travel && brief.entryMode == EntryMode.freeText;
  return AdBrief(
    requiresTravel: travel,
    travelAddress: travel ? _text(brief.travelAddress) : '',
    presenceRequirements: travel ? _text(brief.presenceRequirements) : '',
    entryMode: travel ? null : brief.entryMode,
    mediaType: template ? brief.mediaType : null,
    contentSource: template ? brief.contentSource : null,
    sampleRequired: template ? brief.sampleRequired : null,
    details: freeText ? _text(brief.details) : '',
    needsPlatformServices: brief.needsPlatformServices,
    formats: brief.formats,
    platforms: brief.platforms,
    budget: brief.budget,
    publishDeadline: brief.publishDeadline,
  );
}

Map<String, dynamic> _briefErrors(AdBrief brief, int readyContentCount) {
  final deadline = brief.publishDeadline;
  final budget = brief.budget;
  final deadlineError = switch (deadline) {
    null => _required,
    final DateTime date when !date.isAfter(_today()) => 'future',
    _ => null,
  };
  return {
    if (brief.formats.isEmpty) 'formats': _required,
    if (brief.platforms.isEmpty) 'platforms': _required,
    if (budget == null || budget <= 0) 'budgetAmount': _required,
    'publishDeadline': ?deadlineError,
    if (brief.requiresTravel) ...{
      if (brief.travelAddress.isEmpty) 'travelAddress': _required,
      if (brief.presenceRequirements.isEmpty) 'presenceRequirements': _required,
    } else ...{
      if (brief.entryMode == null) 'entryMode': _required,
      if (brief.entryMode == EntryMode.template) ...{
        if (brief.mediaType == null) 'mediaType': _required,
        if (brief.contentSource == null) 'contentSource': _required,
        if (brief.sampleRequired == null) 'sampleRequired': _required,
        if (brief.needsReadyContent && readyContentCount == 0)
          'attachments': {
            'missing': [AttachmentPurpose.readyContent.name],
          },
      },
      if (brief.entryMode == EntryMode.freeText && brief.details.isEmpty) 'details': _required,
    },
  };
}

class GetAdRequestsUseCase implements UseCase<Paginated<AdRequest>, AdRequestsParams> {
  const GetAdRequestsUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<Paginated<AdRequest>>> call(AdRequestsParams params) =>
      _repository.list(status: params.status, page: params.page);
}

class GetAdRequestUseCase implements UseCase<AdRequestBundle, int> {
  const GetAdRequestUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<AdRequestBundle>> call(int id) => _repository.details(id);
}

class SaveAdDraftUseCase implements UseCase<AdRequest, SaveDraftParams> {
  const SaveAdDraftUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<AdRequest>> call(SaveDraftParams params) async {
    final brief = _normalized(params.brief);
    final errors = _briefErrors(brief, params.readyContentCount);
    if (errors.isNotEmpty) return _invalid(errors);

    return switch (params.draftId) {
      final id? => _repository.update(id, brief),
      null => _repository.create(params.influencerProfileId, brief),
    };
  }
}

class UploadAdAttachmentUseCase implements UseCase<AdAttachment, AttachmentParams> {
  const UploadAdAttachmentUseCase(this._repository);

  final AdRequestRepository _repository;

  static const _video = {'mp4', 'mov'};

  static const brief = FileRules(extensions: {'jpg', 'jpeg', 'png', 'webp', 'pdf'}, maxBytes: 10 * 1024 * 1024);

  static const media = FileRules(extensions: {'jpg', 'jpeg', 'png', 'webp', 'mp4', 'mov'}, maxBytes: 100 * 1024 * 1024);

  static const _image = FileRules(extensions: {'jpg', 'jpeg', 'png', 'webp'}, maxBytes: 10 * 1024 * 1024);

  static FileRules rulesFor(AttachmentPurpose purpose) => switch (purpose) {
        AttachmentPurpose.brief => brief,
        AttachmentPurpose.readyContent => media,
      };

  @override
  Future<Result<AdAttachment>> call(AttachmentParams params) async {
    final file = params.file;
    final extension = file.name.split('.').last.toLowerCase();
    final rules = params.purpose == AttachmentPurpose.readyContent && !_video.contains(extension)
        ? _image
        : rulesFor(params.purpose);

    switch (rules.check(fileName: file.name, sizeInBytes: file.size)) {
      case FileCheck.badExtension:
        return _invalid({'file': 'badExtension'});
      case FileCheck.tooLarge:
        return _invalid({'file': 'tooLarge'});
      case FileCheck.ok:
        return _repository.uploadAttachment(params.requestId, params.purpose, file);
    }
  }
}

class DeleteAdAttachmentUseCase implements UseCase<void, int> {
  const DeleteAdAttachmentUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<void>> call(int attachmentId) => _repository.deleteAttachment(attachmentId);
}

class SubmitAdRequestUseCase implements UseCase<AdRequest, int> {
  const SubmitAdRequestUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<AdRequest>> call(int id) => _repository.submit(id);
}

class DeleteAdDraftUseCase implements UseCase<void, int> {
  const DeleteAdDraftUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<void>> call(int id) => _repository.delete(id);
}

class RejectAdRequestUseCase implements UseCase<AdRequest, ReasonParams> {
  const RejectAdRequestUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<AdRequest>> call(ReasonParams params) async {
    final reason = _text(params.reason);
    if (reason.isEmpty) return _invalid({'reason': _required});
    return _repository.reject(params.id, reason);
  }
}

class ReplyToModificationUseCase implements UseCase<AdRequest, ModificationReplyParams> {
  const ReplyToModificationUseCase(this._repository);

  final AdRequestRepository _repository;

  @override
  Future<Result<AdRequest>> call(ModificationReplyParams params) async {
    final message = _text(params.message);
    if (params.accept) return _repository.acceptModification(params.id, message);
    if (message.isEmpty) return _invalid({'message': _required});
    return _repository.refuseModification(params.id, message);
  }
}

class GetInfluencerTabsUseCase implements UseCase<InfluencerTabCounts, NoParams> {
  const GetInfluencerTabsUseCase(this._repository);

  final InfluencerRequestRepository _repository;

  @override
  Future<Result<InfluencerTabCounts>> call(NoParams params) => _repository.tabs();
}

class GetInfluencerRequestsUseCase implements UseCase<Paginated<AdRequest>, InfluencerRequestsParams> {
  const GetInfluencerRequestsUseCase(this._repository);

  final InfluencerRequestRepository _repository;

  @override
  Future<Result<Paginated<AdRequest>>> call(InfluencerRequestsParams params) =>
      _repository.list(tab: params.tab, page: params.page);
}

class GetInfluencerRequestUseCase implements UseCase<AdRequestBundle, int> {
  const GetInfluencerRequestUseCase(this._repository);

  final InfluencerRequestRepository _repository;

  @override
  Future<Result<AdRequestBundle>> call(int id) => _repository.details(id);
}

class ReplyToRequestUseCase implements UseCase<AdRequest, InfluencerReplyParams> {
  const ReplyToRequestUseCase(this._repository);

  final InfluencerRequestRepository _repository;

  @override
  Future<Result<AdRequest>> call(InfluencerReplyParams params) async {
    final message = _text(params.message);
    final budget = params.proposedBudget;
    switch (params.reply) {
      case InfluencerReply.accept:
        return _repository.accept(params.id, message);
      case InfluencerReply.unclear:
        return _repository.markUnclear(params.id, message);
      case InfluencerReply.counterOffer:
        if (message.isEmpty) return _invalid({'message': _required});
        if (budget != null && budget <= 0) return _invalid({'proposedBudget': _required});
        return _repository.counterOffer(params.id, message, budget);
      case InfluencerReply.decline:
        if (message.isEmpty) return _invalid({'reason': _required});
        return _repository.decline(params.id, message);
    }
  }
}
