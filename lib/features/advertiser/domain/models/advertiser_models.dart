import 'package:flutter/material.dart';

/// A single influencer / content creator as seen by advertisers.
class Influencer {
  final String id;
  final String name;
  final String category;
  final String categoryId;
  final String imageUrl;
  final String city;
  final double rating;
  final DateTime joinDate;
  final String bio;
  final bool isAvailable;
  final bool isPlatformAmbassador;

  /// Followers per platform, e.g. {'instagram': 120000, 'tiktok': 85000}
  final Map<String, int> followers;
  final int profileViews;
  final int interestedAdvertisers;

  const Influencer({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryId,
    required this.imageUrl,
    required this.city,
    required this.rating,
    required this.joinDate,
    required this.bio,
    required this.isAvailable,
    required this.isPlatformAmbassador,
    required this.followers,
    required this.profileViews,
    required this.interestedAdvertisers,
  });

  int get totalFollowers =>
      followers.values.fold(0, (sum, count) => sum + count);
}

/// A browsing category (art, cooking, sports, ...).
class InfluencerCategory {
  final String id;
  final String name;
  final IconData icon;
  final int influencersCount;

  const InfluencerCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.influencersCount,
  });
}

enum CampaignStatus { draft, active, paused, completed, cancelled }

/// An advertising campaign created by an advertiser.
class Campaign {
  final String id;
  final String title;
  final String description;
  final String influencerName;
  final String platform;
  final String contentType;
  final double budget;
  final DateTime startDate;
  final DateTime endDate;
  final CampaignStatus status;

  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.influencerName,
    required this.platform,
    required this.contentType,
    required this.budget,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}
