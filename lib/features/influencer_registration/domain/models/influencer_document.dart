enum InfluencerDocumentType {
  identityFront,
  identityBack,
  bankRib,
  ccpCheque,
  other,
}

extension InfluencerDocumentTypeExtension
on InfluencerDocumentType {
  String get arabicName {
    switch (this) {
      case InfluencerDocumentType
          .identityFront:
        return 'بطاقة التعريف - الوجه الأمامي';

      case InfluencerDocumentType
          .identityBack:
        return 'بطاقة التعريف - الوجه الخلفي';

      case InfluencerDocumentType.bankRib:
        return 'RIB بنكي';

      case InfluencerDocumentType.ccpCheque:
        return 'Chèque CCP';

      case InfluencerDocumentType.other:
        return 'وثيقة أخرى';
    }
  }
}

class InfluencerDocument {
  final String id;

  final InfluencerDocumentType type;

  final String fileName;
  final String filePath;

  final bool uploaded;
  final bool verified;

  const InfluencerDocument({
    required this.id,
    required this.type,
    required this.fileName,
    required this.filePath,
    this.uploaded = true,
    this.verified = false,
  });

  InfluencerDocument copyWith({
    String? id,
    InfluencerDocumentType? type,
    String? fileName,
    String? filePath,
    bool? uploaded,
    bool? verified,
  }) {
    return InfluencerDocument(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName:
      fileName ?? this.fileName,
      filePath:
      filePath ?? this.filePath,
      uploaded:
      uploaded ?? this.uploaded,
      verified:
      verified ?? this.verified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'fileName': fileName,
      'filePath': filePath,
      'uploaded': uploaded,
      'verified': verified,
    };
  }

  factory InfluencerDocument.fromMap(
      Map<String, dynamic> map,
      ) {
    return InfluencerDocument(
      id: map['id'] ?? '',
      type:
      InfluencerDocumentType.values
          .firstWhere(
            (e) => e.name == map['type'],
        orElse: () =>
        InfluencerDocumentType.other,
      ),
      fileName:
      map['fileName'] ?? '',
      filePath:
      map['filePath'] ?? '',
      uploaded:
      map['uploaded'] ?? false,
      verified:
      map['verified'] ?? false,
    );
  }
}