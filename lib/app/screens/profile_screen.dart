import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';

/// Own profile provider
final _myProfileProvider = FutureProvider<UserProfile>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) throw Exception('Not logged in');
  final service = ref.read(userServiceProvider);
  return service.getUserProfile(currentUser.username);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_myProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: $e'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.invalidate(_myProfileProvider),
              child: const Text('Retry'),
            ),
          ],
        )),
      ),
      data: (profile) => _ProfileContent(profile: profile),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final UserProfile profile;
  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text('@${profile.username}'),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => context.push('/settings'),
              ),
            ],
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
                      child: OutlinedButton(
                        onPressed: () => context.push('/edit-profile'),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.push('/activities'),
                        child: const Text('Activity'),
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
    if (posts.isEmpty) {
      return const Center(child: Text('No posts yet'));
    }
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
                  child: Center(child: Text(post.caption ?? '',
                    maxLines: 2, overflow: TextOverflow.ellipsis,
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
    if (reels.isEmpty) {
      return const Center(child: Text('No reels yet'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 2, crossAxisSpacing: 2,
        childAspectRatio: 0.6),
      itemCount: reels.length,
      itemBuilder: (context, index) {
        final reel = reels[index];
        return GestureDetector(
          onTap: () => context.push('/reels'),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.play_circle_outline)),
              Positioned(
                bottom: 4, left: 4,
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                    const SizedBox(width: 2),
                    Text('${reel.viewsCount}',
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
    if (reposts.isEmpty) {
      return const Center(child: Text('No reposts yet'));
    }
    return ListView.builder(
      itemCount: reposts.length,
      itemBuilder: (context, index) {
        final repost = reposts[index];
        return ListTile(
          leading: const Icon(Icons.repeat),
          title: Text(repost.post?.caption ?? repost.reel?.caption ?? 'Repost'),
          subtitle: Text('Reposted ${repost.repostedAt}'),
          onTap: () {
            if (repost.post != null) {
              context.push('/posts/${repost.post!.postId}');
            }
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
