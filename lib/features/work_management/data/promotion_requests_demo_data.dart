import '../domain/models/promotion_request.dart';

final List<PromotionRequest> demoPromotionRequests = [
  PromotionRequest(
    id: 'REQ-001',
    title: 'حملة للترويج لمنتج جديد',
    description:
    'أريد إطلاق حملة ترويجية لمنتج جديد مع مؤثرين في مجال التكنولوجيا.',
    budget: 50000,
    createdAt: DateTime(2026, 9, 26),
    status: PromotionRequestStatus.pending,
    attachmentsCount: 2,
  ),
  PromotionRequest(
    id: 'REQ-002',
    title: 'إشهار لمنتج رياضي',
    description:
    'أبحث عن مؤثرين في مجال الرياضة وكرة القدم للترويج لمنتج جديد.',
    budget: 80000,
    createdAt: DateTime(2026, 9, 20),
    status: PromotionRequestStatus.underReview,
    attachmentsCount: 1,
  ),
  PromotionRequest(
    id: 'REQ-003',
    title: 'حملة إشهارية لمتجر إلكتروني',
    description:
    'حملة ترويجية تستهدف الشباب عبر Instagram و TikTok.',
    budget: 120000,
    createdAt: DateTime(2026, 9, 14),
    status: PromotionRequestStatus.accepted,
    attachmentsCount: 3,
  ),
];