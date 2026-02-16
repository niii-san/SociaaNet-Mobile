import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  final PageController _pageController = PageController();
  List<FeedReel> _reels = [];
  bool _isLoading = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadReels();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadReels({bool loadMore = false}) async {
    if (!loadMore) setState(() => _isLoading = true);
    try {
      final service = ref.read(feedServiceProvider);
      final reels = await service.getReelsFeed(page: _currentPage);
      if (mounted) {
        setState(() {
          if (loadMore) {
            _reels.addAll(reels);
          } else {
            _reels = reels;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_reels.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reels')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videocam_off_outlined, size: 64,
                  color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 16),
              Text('No reels yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => _loadReels(),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Reels', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        onPageChanged: (index) {
          if (index >= _reels.length - 2) {
            _currentPage++;
            _loadReels(loadMore: true);
          }
        },
        itemBuilder: (context, index) {
          final reel = _reels[index];
          return _ReelItem(
            reel: reel,
            onLike: () async {
              final service = ref.read(postServiceProvider);
              if (reel.isLiked) {
                await service.unlikeReel(reel.reelId);
              } else {
                await service.likeReel(reel.reelId);
              }
              setState(() {
                _reels[index] = reel.copyWith(
                  isLiked: !reel.isLiked,
                  likesCount: reel.isLiked
                      ? reel.likesCount - 1
                      : reel.likesCount + 1,
                );
              });
            },
          );
        },
      ),
    );
  }
}

class _ReelItem extends StatelessWidget {
  final FeedReel reel;
  final VoidCallback onLike;

  const _ReelItem({required this.reel, required this.onLike});

  @override
  Widget build(BuildContext context) {
    final author = reel.author;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background - video placeholder
        Container(
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_circle_outline, size: 64, color: Colors.white54),
                const SizedBox(height: 8),
                Text('Video Player',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5))),
              ],
            ),
          ),
        ),

        // Bottom overlay - author info & caption
        Positioned(
          bottom: 80,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: author.fullAvatarUrl != null
                        ? NetworkImage(author.fullAvatarUrl!)
                        : null,
                    child: author.fullAvatarUrl == null
                        ? Text(author.fullName.isNotEmpty ? author.fullName[0] : '?')
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    author.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (reel.caption != null && reel.caption!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  reel.caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        // Right side actions
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: [
              _ActionButton(
                icon: reel.isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${reel.likesCount}',
                color: reel.isLiked ? Colors.red : Colors.white,
                onPressed: onLike,
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.comment_outlined,
                label: '${reel.commentsCount}',
                color: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.visibility_outlined,
                label: '${reel.viewsCount}',
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: 28),
        ),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
