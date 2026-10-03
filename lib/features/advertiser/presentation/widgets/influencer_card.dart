import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/models/advertiser_models.dart';

/// Compact influencer card used in discovery lists.
class InfluencerCard extends StatelessWidget {
  final Influencer influencer;
  final VoidCallback onTap;

  const InfluencerCard({
    super.key,
    required this.influencer,
    required this.onTap,
  });

  static const Color _gold = Color(0xFFE5C158);

  @override
  Widget build(BuildContext context) {
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
                  // Avatar
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: _gold.withValues(alpha: 0.12),
                    child: Text(
                      influencer.name.isNotEmpty
                          ? influencer.name.characters.first
                          : '?',
                      style: const TextStyle(
                        color: _gold,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                influencer.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (influencer.isPlatformAmbassador) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                color: _gold,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${influencer.category} • ${influencer.city}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.50),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _availabilityBadge(),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _stat(
                    icon: Icons.star_rounded,
                    value: influencer.rating.toStringAsFixed(1),
                  ),
                  const SizedBox(width: 16),
                  _stat(
                    icon: Icons.people_alt_outlined,
                    value: _formatCount(influencer.totalFollowers),
                  ),
                  const SizedBox(width: 16),
                  ...influencer.followers.keys.take(3).map(
                    (platform) => Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: 10),
                      child: FaIcon(
                        _platformIcon(platform),
                        color: Colors.white38,
                        size: 15,
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

  Widget _availabilityBadge() {
    final available = influencer.isAvailable;
    final color = available ? Colors.greenAccent : Colors.white38;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? 'متاح' : 'مشغول',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _stat({
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: _gold, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  IconData _platformIcon(String platform) {
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
        return Icons.public_rounded;
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
