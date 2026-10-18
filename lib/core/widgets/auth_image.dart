import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x_ten/core/di/injection_container.dart';
import 'package:x_ten/core/storage/token_storage.dart';
import 'package:x_ten/core/widgets/loading/shimmer_wrapper.dart';
import 'package:x_ten/core/widgets/loading/skeleton_shapes.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.cacheKey,
    this.fallback,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final String? cacheKey;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    final Widget content;
    if (imageUrl == null || imageUrl.isEmpty) {
      content = _fallback(context);
    } else {
      final token = sl<TokenStorage>().cachedAccess;
      content = CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: cacheKey,
        width: width,
        height: height,
        fit: fit,
        httpHeaders: token == null ? null : {'Authorization': 'Bearer $token'},
        placeholder: (context, url) => ShimmerWrapper(
          child: SkeletonBox(width: width, height: height ?? width ?? 48, radius: radius),
        ),
        errorWidget: (context, url, error) => _fallback(context),
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: content);
  }

  Widget _fallback(BuildContext context) =>
      fallback ??
      Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_outlined,
          color: Theme.of(context).colorScheme.outline,
        ),
      );
}
