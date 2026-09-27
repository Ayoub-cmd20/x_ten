class AudienceProfile {
  final Map<String, double> ageDistribution;

  final double malePercentage;
  final double femalePercentage;

  final Map<String, double> locations;

  final List<String> interests;

  const AudienceProfile({
    this.ageDistribution = const {
      '13-17': 0,
      '18-24': 0,
      '25-34': 0,
      '35-44': 0,
      '45+': 0,
    },
    this.malePercentage = 50,
    this.femalePercentage = 50,
    this.locations = const {},
    this.interests = const [],
  });

  AudienceProfile copyWith({
    Map<String, double>? ageDistribution,
    double? malePercentage,
    double? femalePercentage,
    Map<String, double>? locations,
    List<String>? interests,
  }) {
    return AudienceProfile(
      ageDistribution:
      ageDistribution ?? this.ageDistribution,
      malePercentage:
      malePercentage ?? this.malePercentage,
      femalePercentage:
      femalePercentage ?? this.femalePercentage,
      locations: locations ?? this.locations,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ageDistribution': ageDistribution,
      'malePercentage': malePercentage,
      'femalePercentage': femalePercentage,
      'locations': locations,
      'interests': interests,
    };
  }

  factory AudienceProfile.fromMap(
      Map<String, dynamic> map,
      ) {
    return AudienceProfile(
      ageDistribution:
      Map<String, double>.from(
        map['ageDistribution'] ?? {},
      ),
      malePercentage:
      (map['malePercentage'] ?? 50).toDouble(),
      femalePercentage:
      (map['femalePercentage'] ?? 50).toDouble(),
      locations:
      Map<String, double>.from(
        map['locations'] ?? {},
      ),
      interests:
      List<String>.from(
        map['interests'] ?? [],
      ),
    );
  }
}