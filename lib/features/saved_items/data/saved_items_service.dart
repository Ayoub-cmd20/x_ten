import 'package:flutter/foundation.dart';
import '../domain/models/saved_item.dart';
import 'saved_items_demo_data.dart';

/// Central reactive service for managing saved items (influencers, campaigns, projects, articles).
class SavedItemsService extends ValueNotifier<List<SavedItem>> {
  static final SavedItemsService instance = SavedItemsService._();

  SavedItemsService._() : super(List<SavedItem>.from(demoSavedItems));

  /// Checks if a given item is saved.
  bool isSaved(String id, SavedItemType type) {
    return value.any((item) => item.type == type && (item.id == id || item.title == id));
  }

  /// Checks if an influencer is saved by ID or name.
  bool isInfluencerSaved(String influencerIdOrName) {
    return value.any((item) =>
        item.type == SavedItemType.influencer &&
        (item.id == influencerIdOrName || item.title == influencerIdOrName));
  }

  /// Toggles saving an influencer to the saved items list.
  /// Returns `true` if the influencer is now saved, `false` if removed.
  bool toggleSaveInfluencer({
    required String id,
    required String name,
    required String category,
    required double rating,
    required int totalFollowers,
    String? imageUrl,
  }) {
    final existingIndex = value.indexWhere(
      (item) =>
          item.type == SavedItemType.influencer &&
          (item.id == id || item.title == name),
    );

    final currentList = List<SavedItem>.from(value);
    bool newlySaved;

    if (existingIndex >= 0) {
      currentList.removeAt(existingIndex);
      newlySaved = false;
    } else {
      final formattedFollowers = _formatFollowers(totalFollowers);
      final subtitle = '$category • $rating ⭐ • $formattedFollowers متابع';
      currentList.insert(
        0,
        SavedItem(
          id: id,
          title: name,
          subtitle: subtitle,
          imageUrl: imageUrl,
          type: SavedItemType.influencer,
          savedAt: DateTime.now(),
        ),
      );
      newlySaved = true;
    }

    value = currentList;
    return newlySaved;
  }

  /// Checks if a project is saved by ID or title.
  bool isProjectSaved(String projectIdOrTitle) {
    return value.any((item) =>
        item.type == SavedItemType.project &&
        (item.id == projectIdOrTitle || item.title == projectIdOrTitle));
  }

  /// Toggles saving a project to the saved items list.
  /// Returns `true` if the project is now saved, `false` if removed.
  bool toggleSaveProject({
    required String id,
    required String title,
    required String company,
    required String category,
    required String budget,
  }) {
    final existingIndex = value.indexWhere(
      (item) =>
          item.type == SavedItemType.project &&
          (item.id == id || item.title == title),
    );

    final currentList = List<SavedItem>.from(value);
    bool newlySaved;

    if (existingIndex >= 0) {
      currentList.removeAt(existingIndex);
      newlySaved = false;
    } else {
      final subtitle = '$company • $category • $budget';
      currentList.insert(
        0,
        SavedItem(
          id: id,
          title: title,
          subtitle: subtitle,
          type: SavedItemType.project,
          savedAt: DateTime.now(),
        ),
      );
      newlySaved = true;
    }

    value = currentList;
    return newlySaved;
  }

  /// Removes an item from saved items.
  void removeItem(SavedItem item) {
    final currentList = List<SavedItem>.from(value);
    currentList.removeWhere((i) => i.id == item.id && i.type == item.type);
    value = currentList;
  }

  static String _formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    }
    return '$count';
  }
}
