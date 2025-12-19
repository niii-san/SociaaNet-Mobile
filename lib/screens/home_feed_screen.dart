import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Home feed screen displaying stories and posts
class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SociaaNetAppBar(
        showLogo: true,
        actions: [
          NotificationIconButton(
            notificationCount: 3,
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Stories Section
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _StoryItem(
                  username: index == 0 ? 'Your Story' : 'user${index + 1}',
                  isOwn: index == 0,
                );
              },
            ),
          ),

          // Posts Feed
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _PostItem(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Story Item Widget
class _StoryItem extends StatelessWidget {
  final String username;
  final bool isOwn;

  const _StoryItem({required this.username, this.isOwn = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isOwn
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFFf093fb)],
                        ),
                  border: isOwn
                      ? Border.all(color: Colors.grey.shade300, width: 2)
                      : null,
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://i.pravatar.cc/150?img=${username.hashCode % 70}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (isOwn)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667eea),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 70,
            child: Text(
              username,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Post Item Widget
class _PostItem extends StatefulWidget {
  final int index;

  const _PostItem({required this.index});

  @override
  State<_PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<_PostItem> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=${widget.index + 10}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'username${widget.index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '2 hours ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),

        // Post Image
        Container(
          width: double.infinity,
          height: 400,
          color: Colors.grey.shade200,
          child: Image.network(
            'https://picsum.photos/400/400?random=${widget.index}',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              );
            },
          ),
        ),

        // Post Actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: isLiked ? Colors.red : Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: isSaved ? Colors.black87 : Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    isSaved = !isSaved;
                  });
                },
              ),
            ],
          ),
        ),

        // Likes Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${234 + widget.index * 10} likes',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                  text: 'username${widget.index + 1} ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: 'Beautiful day at the beach! 🌊 #sociaanet #moments',
                ),
              ],
            ),
          ),
        ),

        // View Comments
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'View all 12 comments',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}
