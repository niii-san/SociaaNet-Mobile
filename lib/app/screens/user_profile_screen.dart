import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';

/// User profile provider (family - by username)
final _userProfileProvider = FutureProvider.family<UserProfile, String>((ref, username) async {
  final service = ref.read(userServiceProvider);
  return service.getUserProfile(username);
});

class UserProfileScreen extends ConsumerWidget {
  final String username;
  const UserProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_userProfileProvider(username));

    return profileAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
      data: (profile) => _UserProfileContent(profile: profile),
    );
  }
}

class _UserProfileContent extends ConsumerStatefulWidget {
  final UserProfile profile;
  const _UserProfileContent({required this.profile});

  @override
  ConsumerState<_UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends ConsumerState<_UserProfileContent> {
  late String? _followState;

  @override
  void initState() {
    super.initState();
    _followState = widget.profile.isFollowing;
  }

  Future<void> _toggleFollow() async {
    final service = ref.read(followServiceProvider);
    try {
      if (_followState == 'following') {
        await service.unfollowUser(widget.profile.userId);
        setState(() => _followState = null);
      } else if (_followState == 'requested') {
        await service.cancelFollowRequest(widget.profile.userId);
        setState(() => _followState = null);
      } else {
        await service.followUser(widget.profile.userId);
        setState(() => _followState = widget.profile.isPrivateAccount ? 'requested' : 'following');
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = widget.profile;

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text('@${profile.username}'),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserAvatar(
                        imageUrl: profile.fullAvatarUrl,
                        fallbackName: profile.fullName,
                        radius: 40,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatColumn(count: profile.postsCount, label: 'Posts'),
                            _StatColumn(count: profile.followersCount, label: 'Followers'),
                            _StatColumn(count: profile.followingCount, label: 'Following'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(profile.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  if (profile.bio != null && profile.bio!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(profile.bio!, style: theme.textTheme.bodyMedium),
                    ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                      child: _followState == 'following'
                          ? OutlinedButton(
                              onPressed: _toggleFollow,
                              child: const Text('Following'),
                            )
                          : _followState == 'requested'
                              ? OutlinedButton(
                                  onPressed: _toggleFollow,
                                  child: const Text('Requested'),
                                )
                              : FilledButton(
                                  onPressed: _toggleFollow,
                                  child: const Text('Follow'),
                                ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          try {
                            final convo = await ref.read(chatServiceProvider)
                                .getOrCreateDirectConversation(profile.userId);
                            if (context.mounted) {
                              context.push('/chat/${convo.conversationId}');
                            }
                          } catch (_) {}
                        },
                        child: const Text('Message'),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.video_collection_outlined)),
                  Tab(icon: Icon(Icons.repeat)),
                ],
                indicatorColor: theme.colorScheme.primary,
              ),
              theme.colorScheme.surface,
            ),
            pinned: true,
          ),
        ],
        body: TabBarView(
          children: [
            _PostsGrid(posts: profile.posts),
            _ReelsGrid(reels: profile.reels),
            _RepostsGrid(reposts: profile.reposts),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final int count;
  final String label;
  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('$count', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _PostsGrid extends StatelessWidget {
  final List<Post> posts;
  const _PostsGrid({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const Center(child: Text('No posts yet'));
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () => context.push('/posts/${post.postId}'),
          child: post.mediaUrls.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: FeedPost.getFullMediaUrl(post.mediaUrls.first),
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  errorWidget: (_, __, ___) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image)),
                )
              : Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(child: Text(post.caption ?? '', maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall)),
                ),
        );
      },
    );
  }
}

class _ReelsGrid extends StatelessWidget {
  final List<Reel> reels;
  const _ReelsGrid({required this.reels});

  @override
  Widget build(BuildContext context) {
    if (reels.isEmpty) return const Center(child: Text('No reels yet'));
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2, childAspectRatio: 0.6),
      itemCount: reels.length,
      itemBuilder: (context, index) {
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Center(child: Icon(Icons.play_circle_outline)),
              Positioned(
                bottom: 4, left: 4,
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                    Text('${reels[index].viewsCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RepostsGrid extends StatelessWidget {
  final List<Repost> reposts;
  const _RepostsGrid({required this.reposts});

  @override
  Widget build(BuildContext context) {
    if (reposts.isEmpty) return const Center(child: Text('No reposts yet'));
    return ListView.builder(
      itemCount: reposts.length,
      itemBuilder: (context, index) {
        final repost = reposts[index];
        return ListTile(
          leading: const Icon(Icons.repeat),
          title: Text(repost.post?.caption ?? repost.reel?.caption ?? 'Repost'),
          onTap: () {
            if (repost.post != null) context.push('/posts/${repost.post!.postId}');
          },
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;
  _SliverTabBarDelegate(this.tabBar, this.backgroundColor);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: backgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
