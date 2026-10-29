import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:x_ten/core/errors/failure_message.dart';
import 'package:x_ten/core/localization/category_labels.dart';
import 'package:x_ten/core/localization/localization_extension.dart';
import 'package:x_ten/core/widgets/auth_image.dart';
import 'package:x_ten/core/widgets/feedback/error_view.dart';
import 'package:x_ten/core/widgets/loading/app_loader.dart';
import 'package:x_ten/features/marketplace/presentation/cubit/marketplace_cubit.dart';
import 'package:x_ten/features/saved_items/data/saved_items_service.dart';
import 'package:x_ten/features/saved_items/domain/models/saved_item.dart';

/// Full influencer profile as seen by an advertiser,
/// with a direct call-to-action to start a campaign.
class InfluencerDetailsScreen extends StatefulWidget {
  final int influencerId;
  final MarketInfluencer? preview;

  const InfluencerDetailsScreen({
    super.key,
    required this.influencerId,
    this.preview,
  });

  @override
  State<InfluencerDetailsScreen> createState() =>
      _InfluencerDetailsScreenState();
}

class _InfluencerDetailsScreenState extends State<InfluencerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<MarketplaceCubit>()
        .openInfluencer(widget.influencerId, preview: widget.preview);
  }

  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _surface = Color(0xFF151515);
  static const Color _surface2 = Color(0xFF1B1B1B);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MarketplaceCubit>().state;
    final influencer = state.details;
    final failure = state.failure;

    if (influencer == null) {
      return Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          backgroundColor: _background,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: state.didFail(MarketplaceAction.details) && failure != null
            ? ErrorView(
                message: failure.localized(context),
                retryLabel: context.l10n.retry,
                onRetry: () => context
                    .read<MarketplaceCubit>()
                    .openInfluencer(widget.influencerId),
              )
            : const AppLoader(color: _gold),
      );
    }

    final category = context.l10n.category(influencer.category);
    final subtitle = [
      if (category.isNotEmpty) category,
      if (influencer.city.isNotEmpty) influencer.city,
    ].join(' • ');

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
            'ملف المؤثر',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            ValueListenableBuilder<List<SavedItem>>(
              valueListenable: SavedItemsService.instance,
              builder: (context, savedItems, _) {
                final isSaved = SavedItemsService.instance.isInfluencerSaved('${influencer.id}') ||
                    SavedItemsService.instance.isInfluencerSaved(influencer.name);

                return IconButton(
                  tooltip: isSaved ? 'إزالة من المحفوظات' : 'حفظ في المحفوظات',
                  icon: Icon(
                    isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    color: isSaved ? _gold : Colors.white,
                  ),
                  onPressed: () {
                    final newlySaved = SavedItemsService.instance.toggleSaveInfluencer(
                      id: '${influencer.id}',
                      name: influencer.name,
                      category: category,
                      rating: influencer.rating ?? 0,
                      totalFollowers: influencer.totalFollowers,
                      imageUrl: influencer.imageUrl,
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                newlySaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                newlySaved
                                    ? 'تم حفظ المؤثر في العناصر المحفوظة'
                                    : 'تمت إزالة المؤثر من العناصر المحفوظة',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: _gold,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(influencer, subtitle),
              const SizedBox(height: 16),
              _statsRow(influencer),
              if (influencer.bio.isNotEmpty) ...[
                const SizedBox(height: 16),
                _bioCard(influencer),
              ],
              if (influencer.followersByPlatform.isNotEmpty) ...[
                const SizedBox(height: 16),
                _platformsCard(influencer),
              ],
              if (influencer.featuredWorks.isNotEmpty) ...[
                const SizedBox(height: 16),
                _worksCard(influencer, context.l10n.featuredWorks),
              ],
              const SizedBox(height: 16),
              _metaCard(influencer),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: influencer.isAvailable
                    ? () {
                        context.push(
                          '/advertiser/campaign/new',
                          extra: influencer,
                        );
                      }
                    : null,
                icon: const Icon(Icons.campaign_rounded),
                label: Text(
                  influencer.isAvailable
                      ? 'بدء الإشهار مع هذا المؤثر'
                      : 'غير متاح حالياً',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor:
                      _gold.withValues(alpha: 0.30),
                  disabledForegroundColor: Colors.black54,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header(MarketInfluencer influencer, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            _gold.withValues(alpha: 0.12),
            _gold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _gold.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          AuthImage(
            url: influencer.imageUrl,
            width: 80,
            height: 80,
            radius: 40,
            cacheKey: 'market-influencer-${influencer.id}',
            fallback: CircleAvatar(
              radius: 40,
              backgroundColor: _gold.withValues(alpha: 0.15),
              child: Text(
                influencer.name.isNotEmpty
                    ? influencer.name.characters.first
                    : '?',
                style: const TextStyle(
                  color: _gold,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  influencer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (influencer.isAvailable
                      ? Colors.greenAccent
                      : Colors.white38)
                  .withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              influencer.isAvailable
                  ? 'متاح للإشهار'
                  : 'غير متاح حالياً',
              style: TextStyle(
                color: influencer.isAvailable
                    ? Colors.greenAccent
                    : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS
  // ============================================================

  Widget _statsRow(MarketInfluencer influencer) {
    return Row(
      children: [
        _statTile(
          icon: Icons.star_rounded,
          value: influencer.rating?.toStringAsFixed(1) ?? '—',
          label: 'التقييم',
        ),
        const SizedBox(width: 10),
        _statTile(
          icon: Icons.visibility_outlined,
          value: _formatCount(influencer.profileViews),
          label: 'مشاهدات الملف',
        ),
        const SizedBox(width: 10),
        _statTile(
          icon: Icons.business_center_outlined,
          value: '${influencer.interestedAdvertisers}',
          label: 'معلنون مهتمون',
        ),
      ],
    );
  }

  Widget _statTile({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: _gold, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BIO
  // ============================================================

  Widget _bioCard(MarketInfluencer influencer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نبذة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            influencer.bio,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.5,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLATFORMS
  // ============================================================

  Widget _platformsCard(MarketInfluencer influencer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائيات المتابعين',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...influencer.followersByPlatform.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _surface2,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      _platformIcon(entry.key),
                      color: _gold,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _platformName(entry.key),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${_formatCount(entry.value)} متابع',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURED WORKS
  // ============================================================

  Widget _worksCard(MarketInfluencer influencer, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...influencer.featuredWorks.map(
            (work) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: _surface2,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    work.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (work.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      work.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                  if (work.link.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        work.link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _gold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // META
  // ============================================================

  Widget _metaCard(MarketInfluencer influencer) {
    final joinDate = influencer.joinDate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          if (joinDate != null)
            _metaRow(
              'تاريخ الانضمام',
              '${joinDate.day}/${joinDate.month}/${joinDate.year}',
            ),
          _metaRow(
            'إجمالي المتابعين',
            _formatCount(influencer.totalFollowers),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  FaIconData _platformIcon(String platform) {
    switch (platform) {
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'tiktok':
        return FontAwesomeIcons.tiktok;
      case 'youtube':
        return FontAwesomeIcons.youtube;
      case 'facebook':
        return FontAwesomeIcons.facebookF;
      default:
        return FontAwesomeIcons.globe;
    }
  }

  String _platformName(String platform) {
    switch (platform) {
      case 'instagram':
        return 'Instagram';
      case 'tiktok':
        return 'TikTok';
      case 'youtube':
        return 'YouTube';
      case 'facebook':
        return 'Facebook';
      default:
        return platform;
    }
  }

  static String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    }
    return '$count';
  }
}
