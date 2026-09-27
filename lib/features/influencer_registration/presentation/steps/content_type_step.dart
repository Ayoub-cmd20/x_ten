import 'package:flutter/material.dart';

import '../../domain/models/content_type.dart';
import '../../domain/models/influencer_registration_draft.dart';

class ContentTypeStep extends StatefulWidget {
  final InfluencerRegistrationDraft draft;
  final VoidCallback onChanged;

  const ContentTypeStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  @override
  State<ContentTypeStep> createState() =>
      _ContentTypeStepState();
}

class _ContentTypeStepState extends State<ContentTypeStep> {
  static const Color gold = Color(0xFFE5C158);

  IconData _iconFor(ContentType type) {
    switch (type) {
      case ContentType.photos:
        return Icons.photo_outlined;

      case ContentType.videos:
        return Icons.videocam_outlined;

      case ContentType.text:
        return Icons.article_outlined;

      case ContentType.reels:
        return Icons.movie_filter_outlined;

      case ContentType.stories:
        return Icons.auto_stories_outlined;

      case ContentType.live:
        return Icons.live_tv_outlined;

      case ContentType.podcasts:
        return Icons.podcasts_outlined;

      case ContentType.reviews:
        return Icons.rate_review_outlined;

      case ContentType.tutorials:
        return Icons.school_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'نوع المحتوى الذي تقدمه',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'يمكنك اختيار أكثر من نوع محتوى.',
          style: TextStyle(
            color: Colors.white54,
          ),
        ),

        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ContentType.values.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (context, index) {
            final type = ContentType.values[index];

            final selected =
            widget.draft.contentTypes.contains(type);

            return InkWell(
              onTap: () {
                setState(() {
                  if (selected) {
                    widget.draft.contentTypes.remove(type);
                  } else {
                    widget.draft.contentTypes.add(type);
                  }
                });

                widget.onChanged();
              },
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: selected
                      ? gold.withValues(alpha: 0.11)
                      : const Color(0xFF151515),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? gold.withValues(alpha: 0.40)
                        : Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _iconFor(type),
                      color: selected ? gold : Colors.white54,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        type.arabicName,
                        style: TextStyle(
                          color: selected ? gold : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: gold,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}