enum FreelancerDocumentType { identityFront, identityBack, ccpCheque, bankRib, cv, certificate, diploma }
extension FreelancerDocumentTypeX on FreelancerDocumentType {
  String get arabicName {
    switch (this) {
      case FreelancerDocumentType.identityFront: return 'بطاقة التعريف - الوجه الأمامي';
      case FreelancerDocumentType.identityBack: return 'بطاقة التعريف - الوجه الخلفي';
      case FreelancerDocumentType.ccpCheque: return 'Chèque CCP barré';
      case FreelancerDocumentType.bankRib: return 'RIB بنكي';
      case FreelancerDocumentType.cv: return 'السيرة الذاتية CV';
      case FreelancerDocumentType.certificate: return 'شهادة';
      case FreelancerDocumentType.diploma: return 'دبلوم';
    }
  }
}
class FreelancerDocument {
  final String id; final FreelancerDocumentType type; final String fileName; final String filePath; final bool required; final bool verified;
  const FreelancerDocument({required this.id, required this.type, required this.fileName, required this.filePath, this.required=false, this.verified=false});
}
