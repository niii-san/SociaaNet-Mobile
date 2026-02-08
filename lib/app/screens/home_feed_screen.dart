import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/post_card.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeFeedProvider.notifier).loadFeed(refresh: true);
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedState = ref.watch(homeFeedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('SociaaNet',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          )),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => context.push('/create-post'),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: feedState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text('Failed to load feed', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.read(homeFeedProvider.notifier).loadFeed(refresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return _buildEmptyFeed(theme);
          }
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await ref.read(homeFeedProvider.notifier).loadFeed(refresh: true);
              _refreshController.refreshCompleted();
            },
            onLoading: () async {
              await ref.read(homeFeedProvider.notifier).loadFeed();
              _refreshController.loadComplete();
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: posts[index],
                  onPostUpdated: (updatedPost) {
                    // Optimistic update in provider
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyFeed(ThemeData theme) {
    final suggestedAsync = ref.watch(suggestedUsersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Icon(Icons.dynamic_feed_outlined, size: 72,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Text('Your feed is empty', style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Follow people to see their posts here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 32),

          // Suggested users
          suggestedAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (users) {
              if (users.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suggested for you',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _SuggestedUserCard(user: user);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SuggestedUserCard extends ConsumerWidget {
  final SuggestedUser user;
  const _SuggestedUserCard({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserAvatar(
            imageUrl: user.fullAvatarUrl,
            fallbackName: user.fullName,
            radius: 28,
          ),
          const SizedBox(height: 8),
          Text(user.fullName,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          Text('@${user.username}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 11),
            maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                try {
                  await ref.read(followServiceProvider).followUser(user.userId);
                } catch (_) {}
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6),
                minimumSize: Size.zero,
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text('Follow'),
            ),
          ),
        ],
      ),
    );
  }
}
