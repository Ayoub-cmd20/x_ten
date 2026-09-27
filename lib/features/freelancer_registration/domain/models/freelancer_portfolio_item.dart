class FreelancerPortfolioItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? filePath;
  final String? externalUrl;
  final String tools;
  const FreelancerPortfolioItem({required this.id, required this.title, required this.description, required this.category, this.filePath, this.externalUrl, this.tools = ''});
}
