class InfluencerCategorySelection {
  final List<String> primary;
  final List<String> secondary;

  const InfluencerCategorySelection({
    this.primary = const [],
    this.secondary = const [],
  });

  bool get canAddPrimary =>
      primary.length < 3;

  bool get canAddSecondary =>
      secondary.length < 3;

  bool get isValid =>
      primary.isNotEmpty &&
          primary.length <= 3 &&
          secondary.length <= 3;

  InfluencerCategorySelection copyWith({
    List<String>? primary,
    List<String>? secondary,
  }) {
    return InfluencerCategorySelection(
      primary: primary ?? this.primary,
      secondary:
      secondary ?? this.secondary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'primary': primary,
      'secondary': secondary,
    };
  }

  factory InfluencerCategorySelection.fromMap(
      Map<String, dynamic> map,
      ) {
    return InfluencerCategorySelection(
      primary:
      List<String>.from(
        map['primary'] ?? [],
      ),
      secondary:
      List<String>.from(
        map['secondary'] ?? [],
      ),
    );
  }
}