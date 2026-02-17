import 'package:flutter/material.dart';

class ReelPlayer extends StatefulWidget {
  final String videoUrl;
  final String username;
  final String? caption;
  final int likes;
  final int comments;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  const ReelPlayer({super.key, required this.videoUrl, required this.username, this.caption, this.likes = 0, this.comments = 0, this.onLike, this.onComment, this.onShare});

  @override
  State<ReelPlayer> createState() => _ReelPlayerState();
}

class _ReelPlayerState extends State<ReelPlayer> {
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isPlaying = !_isPlaying),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (!_isPlaying) const Center(child: Icon(Icons.play_arrow, size: 64, color: Colors.white70)),
          Positioned(
            bottom: 80, left: 16, right: 72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${widget.username}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                if (widget.caption != null) Text(widget.caption!, style: const TextStyle(color: Colors.white), maxLines: 3),
              ],
            ),
          ),
          Positioned(
            bottom: 80, right: 12,
            child: Column(
              children: [
                IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: widget.onLike),
                Text('${widget.likes}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 16),
                IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.white), onPressed: widget.onComment),
                Text('${widget.comments}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 16),
                IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: widget.onShare),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
