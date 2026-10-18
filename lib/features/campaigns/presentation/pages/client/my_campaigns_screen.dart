import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/core/widgets/loading/skeleton_list.dart';
import 'package:x_ten/features/campaigns/presentation/ad_requests_cubit.dart';
import 'package:x_ten/features/campaigns/presentation/campaign_labels.dart';

/// List and track the advertiser's ad requests.
class MyCampaignsScreen extends StatefulWidget {
  const MyCampaignsScreen({super.key});

  @override
  State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
}

class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  static const _filters = [
    AdRequestStatus.clientReviewing,
    AdRequestStatus.draft,
    AdRequestStatus.submitted,
    AdRequestStatus.awaitingInfluencer,
    AdRequestStatus.agreed,
    AdRequestStatus.rejected,
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdRequestsCubit>().load();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 300) {
      context.read<AdRequestsCubit>().loadMore();
    }
    return false;
  }

  Future<void> _open(AdRequest request) async {
    final cubit = context.read<AdRequestsCubit>();
    await context.push('/advertiser/campaigns/details', extra: request);
    if (mounted) cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filter = context.select((AdRequestsCubit c) => c.state.filter);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'حملاتي',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),

            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _filterChip(
                    label: l10n.all,
                    selected: filter == null,
                    onTap: () =>
                        context.read<AdRequestsCubit>().selectFilter(null),
                  ),
                  for (final status in _filters)
                    _filterChip(
                      label: l10n.adStatus(status, asClient: true),
                      selected: filter == status,
                      onTap: () =>
                          context.read<AdRequestsCubit>().selectFilter(status),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: BlocBuilder<AdRequestsCubit, AdRequestsState>(
                builder: (context, state) {
                  final cubit = context.read<AdRequestsCubit>();
                  final failure = state.failure;
                  final requests = state.requests.items;

                  if (state.isLoadingFor(AdRequestsAction.list) &&
                      requests.isEmpty) {
                    return const SkeletonList();
                  }

                  if (state.didFail(AdRequestsAction.list) &&
                      failure != null) {
                    return ErrorView(
                      message: campaignFailureText(context, failure),
                      retryLabel: l10n.retry,
                      onRetry: cubit.refresh,
                    );
                  }

                  final loadingMore =
                      state.isLoadingFor(AdRequestsAction.loadMore);

                  return RefreshIndicator(
                    color: _gold,
                    onRefresh: cubit.refresh,
                    child: requests.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  l10n.adEmpty,
                                  style:
                                      const TextStyle(color: Colors.white54),
                                ),
                              ),
                            ],
                          )
                        : NotificationListener<ScrollNotification>(
                            onNotification: _onScroll,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount:
                                  requests.length + (loadingMore ? 1 : 0),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == requests.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: AppLoader(color: _gold),
                                  );
                                }
                                final request = requests[index];
                                return AdRequestCard(
                                  request: request,
                                  asClient: true,
                                  onTap: () => _open(request),
                                );
                              },
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
        selectedColor: _gold,
        backgroundColor: const Color(0xFF161616),
        side: BorderSide(
          color:
              selected ? _gold : Colors.white.withValues(alpha: 0.08),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.black : Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Ad request card shared by the advertiser and influencer lists.
class AdRequestCard extends StatelessWidget {
  final AdRequest request;
  final bool asClient;
  final VoidCallback onTap;

  const AdRequestCard({
    super.key,
    required this.request,
    required this.asClient,
    required this.onTap,
  });

  static const Color _gold = Color(0xFFE5C158);

  static Color statusColor(AdRequestStatus status) => switch (status) {
        AdRequestStatus.agreed => Colors.greenAccent,
        AdRequestStatus.rejected || AdRequestStatus.unknown => Colors.redAccent,
        AdRequestStatus.draft => Colors.white38,
        AdRequestStatus.clientReviewing => Colors.orange,
        AdRequestStatus.awaitingInfluencer => Colors.lightBlueAccent,
        _ => _gold,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brief = request.brief;
    final title = asClient
        ? request.influencerName
        : (request.client?.name ?? request.code);
    final kinds = [
      ...brief.formats.map(l10n.adFormat),
      if (brief.requiresTravel) l10n.adTravel,
    ].join(' • ');

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1B1B1B),
                Color(0xFF121212),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _gold.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title.isEmpty ? request.code : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _statusBadge(
                    l10n.adStatus(request.status, asClient: asClient),
                    statusColor(request.status),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                request.code,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.40),
                  fontSize: 12,
                ),
              ),
              if (kinds.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  kinds,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    color: _gold,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formatDzd(brief.budget),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white.withValues(alpha: 0.35),
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formatDay(brief.publishDeadline),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.40),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      brief.platforms.map(l10n.adPlatform).join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.40),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
