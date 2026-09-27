class InfluencerCategoryData {
  final String id;
  final String arabicName;
  final String englishName;

  const InfluencerCategoryData({
    required this.id,
    required this.arabicName,
    required this.englishName,
  });
}

const List<InfluencerCategoryData>
influencerCategories = [
  InfluencerCategoryData(
    id: 'technology',
    arabicName: 'التكنولوجيا',
    englishName: 'Technology',
  ),
  InfluencerCategoryData(
    id: 'sports',
    arabicName: 'الرياضة',
    englishName: 'Sports',
  ),
  InfluencerCategoryData(
    id: 'football',
    arabicName: 'كرة القدم',
    englishName: 'Football',
  ),
  InfluencerCategoryData(
    id: 'cooking',
    arabicName: 'الطبخ',
    englishName: 'Cooking',
  ),
  InfluencerCategoryData(
    id: 'travel',
    arabicName: 'السفر',
    englishName: 'Travel',
  ),
  InfluencerCategoryData(
    id: 'tourism',
    arabicName: 'السياحة',
    englishName: 'Tourism',
  ),
  InfluencerCategoryData(
    id: 'fashion',
    arabicName: 'الموضة',
    englishName: 'Fashion',
  ),
  InfluencerCategoryData(
    id: 'beauty',
    arabicName: 'الجمال',
    englishName: 'Beauty',
  ),
  InfluencerCategoryData(
    id: 'health',
    arabicName: 'الصحة',
    englishName: 'Health',
  ),
  InfluencerCategoryData(
    id: 'fitness',
    arabicName: 'اللياقة البدنية',
    englishName: 'Fitness',
  ),
  InfluencerCategoryData(
    id: 'cars',
    arabicName: 'السيارات',
    englishName: 'Cars',
  ),
  InfluencerCategoryData(
    id: 'gaming',
    arabicName: 'الألعاب',
    englishName: 'Gaming',
  ),
  InfluencerCategoryData(
    id: 'education',
    arabicName: 'التعليم',
    englishName: 'Education',
  ),
  InfluencerCategoryData(
    id: 'business',
    arabicName: 'الأعمال',
    englishName: 'Business',
  ),
  InfluencerCategoryData(
    id: 'finance',
    arabicName: 'المال والأعمال',
    englishName: 'Finance',
  ),
  InfluencerCategoryData(
    id: 'marketing',
    arabicName: 'التسويق',
    englishName: 'Marketing',
  ),
  InfluencerCategoryData(
    id: 'ecommerce',
    arabicName: 'التجارة الإلكترونية',
    englishName: 'E-commerce',
  ),
  InfluencerCategoryData(
    id: 'art',
    arabicName: 'الفن',
    englishName: 'Art',
  ),
  InfluencerCategoryData(
    id: 'music',
    arabicName: 'الموسيقى',
    englishName: 'Music',
  ),
  InfluencerCategoryData(
    id: 'entertainment',
    arabicName: 'الترفيه',
    englishName: 'Entertainment',
  ),
  InfluencerCategoryData(
    id: 'family',
    arabicName: 'العائلة',
    englishName: 'Family',
  ),
  InfluencerCategoryData(
    id: 'parenting',
    arabicName: 'الأمومة والأسرة',
    englishName: 'Parenting',
  ),
  InfluencerCategoryData(
    id: 'photography',
    arabicName: 'التصوير',
    englishName: 'Photography',
  ),
  InfluencerCategoryData(
    id: 'lifestyle',
    arabicName: 'نمط الحياة',
    englishName: 'Lifestyle',
  ),
];

InfluencerCategoryData?
findInfluencerCategoryById(
    String id,
    ) {
  for (final category
  in influencerCategories) {
    if (category.id == id) {
      return category;
    }
  }

  return null;
}

InfluencerCategoryData?
findInfluencerCategoryByArabicName(
    String name,
    ) {
  for (final category
  in influencerCategories) {
    if (category.arabicName == name) {
      return category;
    }
  }

  return null;
}