enum SavedItemType {
  influencer,
  campaign,
  project,
  article,
}

class SavedItem {
  final String id;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final SavedItemType type;
  final DateTime savedAt;

  const SavedItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.savedAt,
    this.imageUrl,
  });
}