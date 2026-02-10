import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final Map<int, List<HistoryItem>> _cache = {};
  bool _isLoading = false;

  final _tabs = const ['Likes', 'Comments', 'Watched', 'Reposts', 'Saved'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTab(0);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final index = _tabController.index;
      if (!_cache.containsKey(index)) _loadTab(index);
    }
  }

  Future<void> _loadTab(int index) async {
    setState(() => _isLoading = true);
    try {
      final service = ref.read(activityServiceProvider);
      List<HistoryItem> items;
      switch (index) {
        case 0:
          items = await service.getLikeHistory();
          break;
        case 1:
          items = await service.getCommentHistory();
          break;
        case 2:
          items = await service.getWatchHistory();
          break;
        case 3:
          items = await service.getRepostHistory();
          break;
        case 4:
          items = await service.getSavedItems();
          break;
        default:
          items = [];
      }
      if (mounted) setState(() { _cache[index] = items; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _cache[index] = []; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (index) {
          if (_isLoading && !_cache.containsKey(index)) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = _cache[index] ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getTabIcon(index), size: 48,
                      color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('No ${_tabs[index].toLowerCase()} yet',
                      style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _loadTab(index),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, i) => _HistoryItemTile(item: items[i]),
            ),
          );
        }),
      ),
    );
  }

  IconData _getTabIcon(int index) {
    switch (index) {
      case 0: return Icons.favorite_border;
      case 1: return Icons.comment_outlined;
      case 2: return Icons.visibility_outlined;
      case 3: return Icons.repeat;
      case 4: return Icons.bookmark_border;
      default: return Icons.history;
    }
  }
}

class _HistoryItemTile extends StatelessWidget {
  final HistoryItem item;
  const _HistoryItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: item.mediaUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.mediaUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(width: 48, height: 48,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.image)),
              ),
            )
          : Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_getTypeIcon(item.type),
                  color: theme.colorScheme.outline),
            ),
      title: Text(
        item.caption ?? item.content ?? item.type,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.authorUsername != null
            ? '@${item.authorUsername}'
            : _formatTime(item.createdAt),
        style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline),
      ),
      trailing: Text(
        _formatTime(item.createdAt),
        style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'post': return Icons.photo;
      case 'reel': return Icons.videocam;
      case 'comment': return Icons.comment;
      default: return Icons.history;
    }
  }

  String _formatTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }
}
