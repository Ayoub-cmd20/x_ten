import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';
import 'package:x_ten/features/campaigns/presentation/influencer_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/widgets/ad_request_details_view.dart';

/// An ad request forwarded to the influencer, with the four possible replies.
class OpportunityDetailsScreen extends StatefulWidget {
  final int requestId;
  final AdRequest? preview;

  const OpportunityDetailsScreen({
    super.key,
    required this.requestId,
    this.preview,
  });

  @override
  State<OpportunityDetailsScreen> createState() => _OpportunityDetailsScreenState();
}

class _OpportunityDetailsScreenState extends State<OpportunityDetailsScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);

  @override
  void initState() {
    super.initState();
    context.read<InfluencerRequestsCubit>().openDetails(widget.requestId, preview: widget.preview);
  }

  void _listener(BuildContext context, InfluencerRequestsState state) {
    final failure = state.failure;
    if (state.action != InfluencerRequestsAction.reply) return;

    if (state.status == InfluencerRequestsStatus.success) {
      _snack(context.l10n.oppReplied);
    } else if (state.status == InfluencerRequestsStatus.failure && failure != null) {
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

  Future<void> _reply(AdRequest request, InfluencerReply reply) async {
    final l10n = context.l10n;
    final cubit = context.read<InfluencerRequestsCubit>();

    final (title, hint, mustWrite, budget) = switch (reply) {
      InfluencerReply.accept => (l10n.oppAccept, l10n.adMessageOptional, false, null),
      InfluencerReply.counterOffer => (l10n.oppCounter, l10n.oppCounterHint, true, l10n.oppProposedBudgetOptional),
      InfluencerReply.unclear => (l10n.oppUnclear, l10n.oppUnclearHint, false, null),
      InfluencerReply.decline => (l10n.oppDecline, l10n.oppDeclineHint, true, null),
    };

    final answer = await showReplySheet(
      context,
      title: title,
      hint: hint,
      messageRequired: mustWrite,
      budgetLabel: budget,
    );
    if (answer == null) return;

    cubit.reply(request.id, reply, message: answer.message, proposedBudget: answer.budget);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<InfluencerRequestsCubit, InfluencerRequestsState>(
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
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: background,
              elevation: 0,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'تفاصيل الفرصة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            body: switch ((bundle, failure)) {
              (final loaded?, _) => RefreshIndicator(
                  color: gold,
                  onRefresh: () => context.read<InfluencerRequestsCubit>().openDetails(widget.requestId),
                  child: AdRequestDetailsView(
                    bundle: loaded,
                    asClient: false,
                    header: _statusNote(loaded.request),
                  ),
                ),
              (null, final error?) when state.didFail(InfluencerRequestsAction.details) => ErrorView(
                  message: campaignFailureText(context, error),
                  retryLabel: l10n.retry,
                  onRetry: () => context.read<InfluencerRequestsCubit>().openDetails(widget.requestId),
                ),
              _ => const AppLoader(color: gold),
            },
            bottomNavigationBar: request?.status == AdRequestStatus.awaitingInfluencer
                ? _actions(state, request!)
                : null,
          ),
        );
      },
    );
  }

  Widget? _statusNote(AdRequest request) {
    final l10n = context.l10n;
    final text = switch (request.status) {
      AdRequestStatus.awaitingInfluencer => null,
      AdRequestStatus.agreed => l10n.oppAgreed,
      _ => l10n.oppWaiting,
    };
    if (text == null) return null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(
            request.status == AdRequestStatus.agreed ? Icons.handshake_outlined : Icons.hourglass_top_rounded,
            color: gold,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, height: 1.6)),
          ),
        ],
      ),
    );
  }

  Widget _actions(InfluencerRequestsState state, AdRequest request) {
    final l10n = context.l10n;
    final busy = state.isLoadingFor(InfluencerRequestsAction.reply);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetailsActionButton(
              label: l10n.oppAccept,
              icon: Icons.check_rounded,
              loading: busy,
              onPressed: () => _reply(request, InfluencerReply.accept),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DetailsActionButton(
                    label: l10n.oppCounter,
                    primary: false,
                    onPressed: busy ? null : () => _reply(request, InfluencerReply.counterOffer),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DetailsActionButton(
                    label: l10n.oppUnclear,
                    primary: false,
                    onPressed: busy ? null : () => _reply(request, InfluencerReply.unclear),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DetailsActionButton(
              label: l10n.oppDecline,
              primary: false,
              danger: true,
              onPressed: busy ? null : () => _reply(request, InfluencerReply.decline),
            ),
          ],
        ),
      ),
    );
  }
}
