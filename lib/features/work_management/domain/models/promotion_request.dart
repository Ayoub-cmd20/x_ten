enum PromotionRequestStatus {
  pending,
  underReview,
  accepted,
  rejected,
}

class PromotionRequest {
  final String id;
  final String title;
  final String description;
  final double budget;
  final DateTime createdAt;
  final PromotionRequestStatus status;
  final int attachmentsCount;

  const PromotionRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.budget,
    required this.createdAt,
    required this.status,
    required this.attachmentsCount,
  });
}