import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {
  final String imageUrl;
  final String username;
  final bool hasStory;
  final bool isViewed;
  final VoidCallback? onTap;
  const StoryAvatar({super.key, required this.imageUrl, required this.username, this.hasStory = false, this.isViewed = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasStory && !isViewed
                  ? const LinearGradient(colors: [Colors.purple, Colors.orange, Colors.red])
                  : null,
              border: hasStory && isViewed ? Border.all(color: Colors.grey.shade300, width: 2) : null,
            ),
            child: CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
          ),
          const SizedBox(height: 4),
          SizedBox(width: 70, child: Text(username, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
