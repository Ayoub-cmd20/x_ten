import 'package:flutter/material.dart';
import 'package:x_ten/features/marketplace/domain/entities/influencer.dart';
import 'package:x_ten/features/marketplace/domain/entities/influencer_category.dart';

const List<InfluencerCategory> influencerCategories = [
  InfluencerCategory(
    id: 'art',
    name: 'الفن',
    icon: Icons.palette_outlined,
  ),
  InfluencerCategory(
    id: 'cooking',
    name: 'الطبخ',
    icon: Icons.restaurant_outlined,
  ),
  InfluencerCategory(
    id: 'sport',
    name: 'الرياضة',
    icon: Icons.sports_soccer_outlined,
  ),
  InfluencerCategory(
    id: 'technology',
    name: 'التكنولوجيا والتجارة الإلكترونية',
    icon: Icons.devices_outlined,
  ),
  InfluencerCategory(
    id: 'beauty',
    name: 'الجمال والموضة',
    icon: Icons.auto_awesome_outlined,
  ),
  InfluencerCategory(
    id: 'travel',
    name: 'السفر والسياحة',
    icon: Icons.flight_takeoff_outlined,
  ),
];

final List<Influencer> demoInfluencers = [
  Influencer(
    id: '1',
    name: 'Noumidia Lezoul',
    category: 'الفن والجمال',
    categoryId: 'art',
    imageUrl: 'https://i.pravatar.cc/300?img=47',
    facebookFollowers: 2300000,
    instagramFollowers: 3100000,
    tiktokFollowers: 1800000,
    youtubeFollowers: 2100000,
    joinDate: DateTime(2024, 4, 10),
    rating: 4.8,
    city: 'الجزائر',
    bio:
    'صانعة محتوى متخصصة في الفن والجمال والموضة وأسلوب الحياة.',
    isAvailable: true,
    isAmbassador: true,
    ambassadorCategory: 'الفن',
    ambassadorYear: 2024,
    profileViews: 154200,
    interestedAdvertisers: 827,
    featuredWorks: const [
      'حملة تجميل وطنية',
      'ترويج منتجات الموضة',
      'تعاون مع علامات تجارية',
    ],
  ),

  Influencer(
    id: '2',
    name: 'Blayli',
    category: 'الرياضة وكرة القدم',
    categoryId: 'sport',
    imageUrl: 'https://i.pravatar.cc/300?img=12',
    facebookFollowers: 2300000,
    instagramFollowers: 3100000,
    tiktokFollowers: 1800000,
    youtubeFollowers: 2100000,
    joinDate: DateTime(2023, 12, 5),
    rating: 4.6,
    city: 'وهران',
    bio:
    'مؤثر متخصص في الرياضة وكرة القدم وأسلوب الحياة.',
    isAvailable: true,
    profileViews: 120400,
    interestedAdvertisers: 620,
    featuredWorks: const [
      'حملات رياضية',
      'منتجات رياضية',
      'تغطية أحداث رياضية',
    ],
  ),

  Influencer(
    id: '3',
    name: 'Amine Tech',
    category: 'التكنولوجيا',
    categoryId: 'technology',
    imageUrl: 'https://i.pravatar.cc/300?img=11',
    facebookFollowers: 520000,
    instagramFollowers: 860000,
    tiktokFollowers: 1200000,
    youtubeFollowers: 430000,
    joinDate: DateTime(2024, 2, 15),
    rating: 4.5,
    city: 'سطيف',
    bio:
    'صانع محتوى متخصص في الهواتف والتطبيقات والتكنولوجيا.',
    isAvailable: true,
    profileViews: 87400,
    interestedAdvertisers: 415,
    featuredWorks: const [
      'مراجعة هواتف',
      'تطبيقات رقمية',
      'منتجات إلكترونية',
    ],
  ),

  Influencer(
    id: '4',
    name: 'Sara Fashion',
    category: 'الجمال والموضة',
    categoryId: 'beauty',
    imageUrl: 'https://i.pravatar.cc/300?img=44',
    facebookFollowers: 300000,
    instagramFollowers: 1400000,
    tiktokFollowers: 900000,
    youtubeFollowers: 150000,
    joinDate: DateTime(2024, 6, 12),
    rating: 4.7,
    city: 'تلمسان',
    bio:
    'صانعة محتوى متخصصة في الموضة والأزياء والجمال.',
    isAvailable: false,
    profileViews: 94300,
    interestedAdvertisers: 510,
  ),

  Influencer(
    id: '5',
    name: 'Chef Karim',
    category: 'الطبخ',
    categoryId: 'cooking',
    imageUrl: 'https://i.pravatar.cc/300?img=13',
    facebookFollowers: 670000,
    instagramFollowers: 750000,
    tiktokFollowers: 1100000,
    youtubeFollowers: 640000,
    joinDate: DateTime(2023, 8, 20),
    rating: 4.9,
    city: 'قسنطينة',
    bio:
    'محتوى متخصص في وصفات الطبخ والمطاعم والمنتجات الغذائية.',
    isAvailable: true,
    profileViews: 107000,
    interestedAdvertisers: 740,
  ),
];
