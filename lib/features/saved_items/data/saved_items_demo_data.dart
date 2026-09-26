import '../domain/models/saved_item.dart';

final List<SavedItem> demoSavedItems = [
  SavedItem(
    id: '1',
    title: 'Noumidia Lezoul',
    subtitle: 'الفن والجمال • 3.1M Instagram',
    imageUrl: 'https://i.pravatar.cc/300?img=47',
    type: SavedItemType.influencer,
    savedAt: DateTime(2026, 9, 20),
  ),
  SavedItem(
    id: '2',
    title: 'Blayli',
    subtitle: 'الرياضة وكرة القدم • 4.6 ⭐',
    imageUrl: 'https://i.pravatar.cc/300?img=12',
    type: SavedItemType.influencer,
    savedAt: DateTime(2026, 9, 19),
  ),
  SavedItem(
    id: '3',
    title: 'حملة إطلاق منتج جديد',
    subtitle: 'Instagram • 50,000 دج',
    type: SavedItemType.campaign,
    savedAt: DateTime(2026, 9, 18),
  ),
  SavedItem(
    id: '4',
    title: 'مشروع تعاون مع علامة تجارية',
    subtitle: 'مشروع مفتوح للتقديم',
    type: SavedItemType.project,
    savedAt: DateTime(2026, 9, 17),
  ),
  SavedItem(
    id: '5',
    title: 'كيف تختار المؤثر المناسب لحملتك؟',
    subtitle: 'مقال • تسويق بالمؤثرين',
    type: SavedItemType.article,
    savedAt: DateTime(2026, 9, 15),
  ),
];