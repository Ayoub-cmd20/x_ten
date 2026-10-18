import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/loading/skeleton_list.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';
import 'package:x_ten/features/campaigns/presentation/influencer_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/pages/client/my_campaigns_screen.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({
    super.key,
  });

  @override
  State<OpportunitiesScreen> createState() =>
      _OpportunitiesScreenState();
}

class _OpportunitiesScreenState
    extends State<OpportunitiesScreen> {
  static const Color gold = Color(0xFFE5C158);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF151515);

  @override
  void initState() {
    super.initState();
    context.read<InfluencerRequestsCubit>().load();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 300) {
      context.read<InfluencerRequestsCubit>().loadMore();
    }
    return false;
  }

  Future<void> _open(AdRequest request) async {
    final cubit = context.read<InfluencerRequestsCubit>();
    await context.push('/creator/opportunity-details', extra: request);
    if (mounted) cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          title: const Text(
            'فرص التعاون',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
        ),
        body: BlocBuilder<InfluencerRequestsCubit, InfluencerRequestsState>(
          builder: (context, state) {
            final cubit = context.read<InfluencerRequestsCubit>();
            final failure = state.failure;
            final requests = state.requests.items;
            final loadingMore =
                state.isLoadingFor(InfluencerRequestsAction.loadMore);

            final Widget content;
            if (state.isLoadingFor(InfluencerRequestsAction.list) &&
                requests.isEmpty) {
              content = const SliverFillRemaining(
                child: SkeletonList(),
              );
            } else if (state.didFail(InfluencerRequestsAction.list) &&
                failure != null) {
              content = SliverFillRemaining(
                child: ErrorView(
                  message: campaignFailureText(context, failure),
                  retryLabel: l10n.retry,
                  onRetry: cubit.refresh,
                ),
              );
            } else if (requests.isEmpty) {
              content = SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Text(
                      l10n.oppEmpty,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              );
            } else {
              content = SliverList.list(
                children: [
                  for (final request in requests)
                    _OpportunityCard(
                      request: request,
                      onTap: () => _open(request),
                    ),
                  if (loadingMore)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: AppLoader(color: gold),
                    ),
                ],
              );
            }

            return RefreshIndicator(
              color: gold,
              onRefresh: cubit.refresh,
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderCard(),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 42,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: InfluencerTab.values.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final tab = InfluencerTab.values[index];
                                  final selected = state.tab == tab;
                                  final label = switch (tab) {
                                    InfluencerTab.requested =>
                                      l10n.oppTabRequested,
                                    InfluencerTab.discussing =>
                                      l10n.oppTabDiscussing,
                                  };

                                  return ChoiceChip(
                                    selected: selected,
                                    label: Text(
                                      '$label (${state.counts.of(tab)})',
                                    ),
                                    selectedColor:
                                        gold.withValues(alpha: 0.18),
                                    backgroundColor: surface,
                                    side: BorderSide(
                                      color: selected
                                          ? gold
                                          : Colors.white12,
                                    ),
                                    labelStyle: TextStyle(
                                      color: selected
                                          ? gold
                                          : Colors.white70,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    onSelected: (_) => cubit.selectTab(tab),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                      sliver: content,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF292314),
            Color(0xFF171717),
            Color(0xFF111111),
          ],
        ),
        border: Border.all(
          color: gold.withValues(alpha: 0.25),
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF242014),
            child: Icon(
              Icons.campaign_outlined,
              color: gold,
              size: 28,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اكتشف فرصاً جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'حملات وإعلانات وتعاونات مناسبة لمحتواك وجمهورك.',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final AdRequest request;
  final VoidCallback onTap;

  const _OpportunityCard({
    required this.request,
    required this.onTap,
  });

  static const gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brief = request.brief;
    final statusColor = AdRequestCard.statusColor(request.status);
    final description = brief.requiresTravel
        ? brief.presenceRequirements
        : (brief.entryMode == EntryMode.freeText ? brief.details : brief.formats.map(l10n.adFormat).join(' • '));

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.business_center_outlined,
                  color: gold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.client?.name ?? request.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.code,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.adStatus(request.status),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white60,
                height: 1.6,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final platform in brief.platforms)
                Chip(
                  label: Text(l10n.adPlatform(platform)),
                  backgroundColor: const Color(0xFF202020),
                  side: BorderSide.none,
                  labelStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: gold,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                formatDzd(brief.budget),
                style: const TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.schedule_outlined,
                color: Colors.white38,
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                formatDay(brief.publishDeadline),
                style: const TextStyle(
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text(
                'عرض تفاصيل الفرصة',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
