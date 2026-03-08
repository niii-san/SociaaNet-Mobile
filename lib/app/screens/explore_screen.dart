import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<SearchUser> _searchResults = [];
  bool _isSearchLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _doSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearchLoading = true);
    try {
      final service = ref.read(userServiceProvider);
      final results = await service.searchUsersList(query);
      if (mounted) setState(() { _searchResults = results; _isSearchLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isSearchLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exploreState = ref.watch(exploreProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                ),
                onChanged: _doSearch,
              )
            : const Text('Explore'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                _searchResults = [];
              }
            },
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: _isSearching && _searchController.text.isNotEmpty
          ? _buildSearchResults(theme)
          : _buildExploreGrid(exploreState, theme),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    if (_isSearchLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No users found',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      );
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return ListTile(
          leading: UserAvatar(
            imageUrl: user.fullAvatarUrl,
            fallbackName: user.fullName,
            radius: 22,
          ),
          title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('@${user.username}'),
          onTap: () => context.push('/u/${user.username}'),
        );
      },
    );
  }

  Widget _buildExploreGrid(AsyncValue<Map<String, dynamic>> state, ThemeData theme) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(exploreProvider.notifier).loadExplore(refresh: true),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
      data: (data) {
        final posts = (data['posts'] as List<ExplorePost>?) ?? [];
        if (posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.explore_outlined, size: 64, color: theme.colorScheme.outline),
                const SizedBox(height: 16),
                Text('Nothing to explore yet', style: theme.textTheme.titleMedium),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(exploreProvider.notifier).loadExplore(refresh: true),
          child: MasonryGridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            padding: const EdgeInsets.all(2),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () => context.push('/posts/${post.postId}'),
                child: AspectRatio(
                  aspectRatio: index % 5 == 0 ? 0.8 : 1.0,
                  child: (post.mediaUrl ?? '').isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: Post.getFullMediaUrl(post.mediaUrl!),
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: theme.colorScheme.surfaceContainerHighest),
                          errorWidget: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image)),
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
