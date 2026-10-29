import 'package:equatable/equatable.dart';

class FeaturedWork extends Equatable {
  const FeaturedWork({
    required this.title,
    this.description = '',
    this.link = '',
    this.mediaUrls = const [],
  });

  final String title;
  final String description;
  final String link;
  final List<String> mediaUrls;

  @override
  List<Object?> get props => [title, description, link, mediaUrls];
}
