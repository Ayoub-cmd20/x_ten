import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/campaigns/presentation/ad_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';
import 'package:x_ten/features/campaigns/presentation/widgets/ad_request_details_view.dart';

/// One ad request as seen by the advertiser, with the actions
/// allowed in its current status.
class AdRequestDetailsScreen extends StatefulWidget {
  final int requestId;
  final AdRequest? preview;

  const AdRequestDetailsScreen({
    super.key,
    required this.requestId,
    this.preview,
  });

  @override
  State<AdRequestDetailsScreen> createState() => _AdRequestDetailsScreenState();
}

class _AdRequestDetailsScreenState extends State<AdRequestDetailsScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  static const _actions = {
    AdRequestsAction.submitDraft,
    AdRequestsAction.deleteDraft,
    AdRequestsAction.reject,
    AdRequestsAction.replyModification,
  };

  @override
  void initState() {
    super.initState();
    context.read<AdRequestsCubit>().openDetails(widget.requestId, preview: widget.preview);
  }

  void _listener(BuildContext context, AdRequestsState state) {
    final failure = state.failure;
    if (!_actions.contains(state.action)) return;

    if (state.status == AdRequestsStatus.success) {
      if (state.action == AdRequestsAction.deleteDraft) {
        context.pop();
        return;
      }
      _snack(context.l10n.adUpdated);
    } else if (state.status == AdRequestsStatus.failure && failure != null) {
      _snack(campaignFailureText(context, failure));
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1B1B1B),
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
  }

  Future<void> _reject(AdRequest request) async {
    final l10n = context.l10n;
    final cubit = context.read<AdRequestsCubit>();
    final reply = await showReplySheet(
      context,
      title: l10n.adCancelRequest,
      hint: l10n.adCancelHint,
      messageRequired: true,
    );
    if (reply != null) cubit.reject(request.id, reply.message);
  }

  Future<void> _refuseModification(AdRequest request) async {
    final l10n = context.l10n;
    final cubit = context.read<AdRequestsCubit>();
    final reply = await showReplySheet(
      context,
      title: l10n.adRefuseModification,
      hint: l10n.adRefuseHint,
      messageRequired: true,
    );
    if (reply != null) cubit.replyModification(request.id, accept: false, message: reply.message);
  }

  Future<void> _acceptModification(AdRequest request) async {
    final l10n = context.l10n;
    final cubit = context.read<AdRequestsCubit>();
    final reply = await showReplySheet(
      context,
      title: l10n.adAcceptModification,
      hint: l10n.adMessageOptional,
      messageRequired: false,
    );
    if (reply != null) cubit.replyModification(request.id, accept: true, message: reply.message);
  }

  Future<void> _deleteDraft(AdRequest request) async {
    final l10n = context.l10n;
    final cubit = context.read<AdRequestsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF151515),
          content: Text(
            l10n.adDeleteDraftConfirm,
            style: const TextStyle(color: Colors.white70, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
    if (confirmed ?? false) cubit.deleteDraft(request.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<AdRequestsCubit, AdRequestsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.action != current.action,
      listener: _listener,
      builder: (context, state) {
        final bundle = state.selected;
        final failure = state.failure;
        final request = bundle?.request;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: _background,
            appBar: AppBar(
              backgroundColor: _background,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                request == null ? '' : l10n.adRequestTitle(request.code),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            body: switch ((bundle, failure)) {
              (final loaded?, _) => RefreshIndicator(
                  color: _gold,
                  onRefresh: () => context.read<AdRequestsCubit>().openDetails(widget.requestId),
                  child: AdRequestDetailsView(bundle: loaded, asClient: true),
                ),
              (null, final error?) when state.didFail(AdRequestsAction.details) => ErrorView(
                  message: campaignFailureText(context, error),
                  retryLabel: l10n.retry,
                  onRetry: () => context.read<AdRequestsCubit>().openDetails(widget.requestId),
                ),
              _ => const AppLoader(color: _gold),
            },
            bottomNavigationBar: request == null ? null : _actionsBar(state, request),
          ),
        );
      },
    );
  }

  Widget? _actionsBar(AdRequestsState state, AdRequest request) {
    final l10n = context.l10n;
    final buttons = <Widget>[
      if (request.isDraft) ...[
        DetailsActionButton(
          label: l10n.adSend,
          icon: Icons.send_rounded,
          loading: state.isLoadingFor(AdRequestsAction.submitDraft),
          onPressed: () => context.read<AdRequestsCubit>().submitDraft(request.id),
        ),
        DetailsActionButton(
          label: l10n.adDeleteDraft,
          icon: Icons.delete_outline_rounded,
          primary: false,
          danger: true,
          loading: state.isLoadingFor(AdRequestsAction.deleteDraft),
          onPressed: () => _deleteDraft(request),
        ),
      ],
      if (request.status == AdRequestStatus.clientReviewing) ...[
        DetailsActionButton(
          label: l10n.adAcceptModification,
          icon: Icons.check_rounded,
          loading: state.isLoadingFor(AdRequestsAction.replyModification),
          onPressed: () => _acceptModification(request),
        ),
        DetailsActionButton(
          label: l10n.adRefuseModification,
          icon: Icons.close_rounded,
          primary: false,
          onPressed: state.isLoading ? null : () => _refuseModification(request),
        ),
      ],
      if (request.status.isOpen)
        DetailsActionButton(
          label: l10n.adCancelRequest,
          icon: Icons.block_rounded,
          primary: false,
          danger: true,
          loading: state.isLoadingFor(AdRequestsAction.reject),
          onPressed: () => _reject(request),
        ),
    ];

    if (buttons.isEmpty) return null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, button) in buttons.indexed) ...[
              if (index > 0) const SizedBox(height: 8),
              button,
            ],
          ],
        ),
      ),
    );
  }
}
