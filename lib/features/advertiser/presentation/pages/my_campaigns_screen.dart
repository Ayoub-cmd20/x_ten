import 'package:flutter/material.dart';

import '../../data/advertiser_demo_data.dart';
import '../../domain/models/advertiser_models.dart';

/// List and track the advertiser's campaigns.
class MyCampaignsScreen extends StatefulWidget {
  const MyCampaignsScreen({super.key});

  @override
  State<MyCampaignsScreen> createState() => _MyCampaignsScreenState();
}

class _MyCampaignsScreenState extends State<MyCampaignsScreen> {
  static const Color _gold = Color(0xFFE5C158);
  static const Color _background = Color(0xFF0A0A0A);

  CampaignStatus? _filter;

  List<Campaign> get _campaigns {
    if (_filter == null) return demoCampaigns;

    return demoCampaigns
        .where((campaign) => campaign.status == _filter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = _campaigns;

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
                    label: 'الكل',
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  _filterChip(
                    label: 'نشطة',
                    selected: _filter == CampaignStatus.active,
                    onTap: () => setState(
                      () => _filter = CampaignStatus.active,
                    ),
                  ),
                  _filterChip(
                    label: 'مسودات',
                    selected: _filter == CampaignStatus.draft,
                    onTap: () => setState(
                      () => _filter = CampaignStatus.draft,
                    ),
                  ),
                  _filterChip(
                    label: 'متوقفة',
                    selected: _filter == CampaignStatus.paused,
                    onTap: () => setState(
                      () => _filter = CampaignStatus.paused,
                    ),
                  ),
                  _filterChip(
                    label: 'منتهية',
                    selected: _filter == CampaignStatus.completed,
                    onTap: () => setState(
                      () => _filter = CampaignStatus.completed,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: campaigns.isEmpty
                  ? const Center(
                      child: Text(
                        'لا توجد حملات في هذه الحالة',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: campaigns.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _CampaignCard(
                          campaign: campaigns[index],
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

class _CampaignCard extends StatelessWidget {
  final Campaign campaign;

  const _CampaignCard({required this.campaign});

  static const Color _gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  campaign.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _statusBadge(campaign.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            campaign.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.person_outline_rounded,
                color: _gold,
                size: 17,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  campaign.influencerName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.payments_outlined,
                color: _gold,
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                '${campaign.budget.toStringAsFixed(0)} دج',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.white.withValues(alpha: 0.35),
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                '${campaign.startDate.day}/${campaign.startDate.month} '
                '- ${campaign.endDate.day}/${campaign.endDate.month}/${campaign.endDate.year}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.40),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                campaign.platform,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.40),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(CampaignStatus status) {
    final Color color;
    final String label;

    switch (status) {
      case CampaignStatus.active:
        color = Colors.greenAccent;
        label = 'نشطة';
        break;
      case CampaignStatus.draft:
        color = Colors.white38;
        label = 'مسودة';
        break;
      case CampaignStatus.paused:
        color = Colors.orange;
        label = 'متوقفة';
        break;
      case CampaignStatus.completed:
        color = Colors.blue;
        label = 'منتهية';
        break;
      case CampaignStatus.cancelled:
        color = Colors.redAccent;
        label = 'ملغاة';
        break;
    }

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
