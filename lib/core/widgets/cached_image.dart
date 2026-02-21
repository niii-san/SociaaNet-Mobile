import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  const CachedImage({super.key, required this.imageUrl, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(width: width, height: height, color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: width, height: height, color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }
}

// Added placeholder image support
