import 'package:flutter/material.dart';

import '../domain/models/advertiser_models.dart';

// ============================================================
// CATEGORIES
// ============================================================

const List<InfluencerCategory> demoInfluencerCategories = [
  InfluencerCategory(
    id: 'art',
    name: 'فن',
    icon: Icons.palette_outlined,
    influencersCount: 24,
  ),
  InfluencerCategory(
    id: 'cooking',
    name: 'طبخ',
    icon: Icons.restaurant_outlined,
    influencersCount: 31,
  ),
  InfluencerCategory(
    id: 'sports',
    name: 'رياضة',
    icon: Icons.sports_soccer_outlined,
    influencersCount: 45,
  ),
  InfluencerCategory(
    id: 'technology',
    name: 'تكنولوجيا',
    icon: Icons.devices_outlined,
    influencersCount: 38,
  ),
  InfluencerCategory(
    id: 'ecommerce',
    name: 'تجارة إلكترونية',
    icon: Icons.shopping_bag_outlined,
    influencersCount: 19,
  ),
  InfluencerCategory(
    id: 'beauty',
    name: 'جمال',
    icon: Icons.face_retouching_natural_outlined,
    influencersCount: 27,
  ),
  InfluencerCategory(
    id: 'fashion',
    name: 'موضة',
    icon: Icons.checkroom_outlined,
    influencersCount: 33,
  ),
  InfluencerCategory(
    id: 'travel',
    name: 'سفر',
    icon: Icons.flight_outlined,
    influencersCount: 21,
  ),
  InfluencerCategory(
    id: 'tourism',
    name: 'سياحة',
    icon: Icons.landscape_outlined,
    influencersCount: 16,
  ),
];

// ============================================================
// INFLUENCERS
// ============================================================

final List<Influencer> demoInfluencers = [
  Influencer(
    id: 'INF-001',
    name: 'أمين بوقرة',
    category: 'تكنولوجيا',
    categoryId: 'technology',
    imageUrl: '',
    city: 'الجزائر العاصمة',
    rating: 4.8,
    joinDate: DateTime(2025, 3, 14),
    bio:
        'مراجع تقني وصانع محتوى متخصص في الهواتف والأجهزة الذكية. أقدّم مراجعات صادقة ومفصلة بالعربية.',
    isAvailable: true,
    isPlatformAmbassador: true,
    followers: {
      'instagram': 240000,
      'tiktok': 510000,
      'youtube': 180000,
      'facebook': 95000,
    },
    profileViews: 12400,
    interestedAdvertisers: 18,
  ),
  Influencer(
    id: 'INF-002',
    name: 'سارة مرابط',
    category: 'طبخ',
    categoryId: 'cooking',
    imageUrl: '',
    city: 'وهران',
    rating: 4.9,
    joinDate: DateTime(2024, 11, 2),
    bio:
        'شيف ومدوّنة طبخ، متخصصة في المطبخ الجزائري والعالمي. وصفات سهلة وسريعة بمكونات متوفرة.',
    isAvailable: true,
    isPlatformAmbassador: false,
    followers: {
      'instagram': 380000,
      'tiktok': 620000,
      'youtube': 150000,
      'facebook': 410000,
    },
    profileViews: 23100,
    interestedAdvertisers: 34,
  ),
  Influencer(
    id: 'INF-003',
    name: 'يوسف حمادي',
    category: 'رياضة',
    categoryId: 'sports',
    imageUrl: '',
    city: 'قسنطينة',
    rating: 4.6,
    joinDate: DateTime(2025, 6, 21),
    bio:
        'مدرب لياقة بدنية ومحلل رياضي. محتوى تحفيزي وتمارين عملية لجميع المستويات.',
    isAvailable: false,
    isPlatformAmbassador: false,
    followers: {
      'instagram': 150000,
      'tiktok': 280000,
      'youtube': 95000,
    },
    profileViews: 8900,
    interestedAdvertisers: 11,
  ),
  Influencer(
    id: 'INF-004',
    name: 'لينا بوعلام',
    category: 'موضة',
    categoryId: 'fashion',
    imageUrl: '',
    city: 'الجزائر العاصمة',
    rating: 4.7,
    joinDate: DateTime(2025, 1, 8),
    bio:
        'مدونة موضة وأسلوب حياة. أشارك إطلالات يومية ونصائح تنسيق تناسب الذوق العربي العصري.',
    isAvailable: true,
    isPlatformAmbassador: true,
    followers: {
      'instagram': 420000,
      'tiktok': 350000,
      'facebook': 120000,
    },
    profileViews: 19800,
    interestedAdvertisers: 27,
  ),
  Influencer(
    id: 'INF-005',
    name: 'رياض شريف',
    category: 'سفر',
    categoryId: 'travel',
    imageUrl: '',
    city: 'عنابة',
    rating: 4.5,
    joinDate: DateTime(2025, 8, 30),
    bio:
        'رحّالة ومصور، أستكشف أجمل مناطق الجزائر والعالم وأشارك تجارب السفر الاقتصادي.',
    isAvailable: true,
    isPlatformAmbassador: false,
    followers: {
      'instagram': 98000,
      'tiktok': 145000,
      'youtube': 210000,
    },
    profileViews: 6700,
    interestedAdvertisers: 8,
  ),
  Influencer(
    id: 'INF-006',
    name: 'نسرين عيادي',
    category: 'جمال',
    categoryId: 'beauty',
    imageUrl: '',
    city: 'سطيف',
    rating: 4.9,
    joinDate: DateTime(2024, 9, 17),
    bio:
        'خبيرة تجميل وعناية بالبشرة. مراجعات منتجات صادقة وروتينات عناية مناسبة لكل أنواع البشرة.',
    isAvailable: true,
    isPlatformAmbassador: true,
    followers: {
      'instagram': 560000,
      'tiktok': 480000,
      'youtube': 130000,
    },
    profileViews: 31200,
    interestedAdvertisers: 42,
  ),
  Influencer(
    id: 'INF-007',
    name: 'كريم زروقي',
    category: 'تجارة إلكترونية',
    categoryId: 'ecommerce',
    imageUrl: '',
    city: 'البليدة',
    rating: 4.3,
    joinDate: DateTime(2026, 2, 5),
    bio:
        'رائد أعمال وخبير تجارة إلكترونية. أشارك تجارب ونصائح لإطلاق متاجر ناجحة في السوق الجزائري.',
    isAvailable: false,
    isPlatformAmbassador: false,
    followers: {
      'instagram': 75000,
      'tiktok': 120000,
      'youtube': 88000,
    },
    profileViews: 4300,
    interestedAdvertisers: 6,
  ),
  Influencer(
    id: 'INF-008',
    name: 'هالة منصوري',
    category: 'فن',
    categoryId: 'art',
    imageUrl: '',
    city: 'تلمسان',
    rating: 4.7,
    joinDate: DateTime(2025, 5, 11),
    bio:
        'فنانة تشكيلية وخطّاطة. أشارك لوحاتي ودروساً مبسطة في الرسم والخط العربي.',
    isAvailable: true,
    isPlatformAmbassador: false,
    followers: {
      'instagram': 88000,
      'tiktok': 64000,
      'facebook': 41000,
    },
    profileViews: 5100,
    interestedAdvertisers: 5,
  ),
];

// ============================================================
// CAMPAIGNS
// ============================================================

final List<Campaign> demoCampaigns = [
  Campaign(
    id: 'CMP-001',
    title: 'إطلاق هاتف جديد',
    description:
        'حملة مراجعات وفيديوهات فك التغليف لهاتفنا الجديد عبر TikTok و YouTube.',
    influencerName: 'أمين بوقرة',
    platform: 'TikTok',
    contentType: 'فيديو قصير',
    budget: 150000,
    startDate: DateTime(2026, 9, 10),
    endDate: DateTime(2026, 10, 10),
    status: CampaignStatus.active,
  ),
  Campaign(
    id: 'CMP-002',
    title: 'وصفة برعاية علامتنا',
    description:
        'دمج منتجنا الغذائي في وصفة أسبوعية مع قصص Instagram تفاعلية.',
    influencerName: 'سارة مرابط',
    platform: 'Instagram',
    contentType: 'ريلز + ستوري',
    budget: 90000,
    startDate: DateTime(2026, 9, 25),
    endDate: DateTime(2026, 10, 20),
    status: CampaignStatus.active,
  ),
  Campaign(
    id: 'CMP-003',
    title: 'حملة مجموعة العناية الجديدة',
    description: 'سلسلة مراجعات لمجموعة العناية بالبشرة الجديدة.',
    influencerName: 'نسرين عيادي',
    platform: 'Instagram',
    contentType: 'صور + فيديو',
    budget: 200000,
    startDate: DateTime(2026, 8, 1),
    endDate: DateTime(2026, 9, 1),
    status: CampaignStatus.completed,
  ),
];
