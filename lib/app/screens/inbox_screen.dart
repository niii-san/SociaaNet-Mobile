import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Provider for conversations
final _conversationsProvider = FutureProvider<List<ChatConversation>>((ref) async {
  final service = ref.read(chatServiceProvider);
  return service.getConversations();
});

/// Provider for message requests
final _messageRequestsProvider = FutureProvider<List<ChatConversation>>((ref) async {
  final service = ref.read(chatServiceProvider);
  return service.getMessageRequests();
});

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () => _showNewMessageSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Messages'),
            Tab(text: 'Requests'),
          ],
        ),
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MessagesTab(),
          _RequestsTab(),
        ],
      ),
    );
  }

  void _showNewMessageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _NewMessageSheet(),
    );
  }
}

class _MessagesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final conversationsAsync = ref.watch(_conversationsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return conversationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: theme.colorScheme.outline),
                const SizedBox(height: 16),
                Text('No messages yet', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Start a conversation!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(_conversationsProvider),
          child: ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final convo = conversations[index];
              final displayName = currentUser != null
                  ? convo.getDisplayName(currentUser.userId)
                  : convo.groupName ?? 'Chat';
              final displayAvatar = currentUser != null
                  ? convo.getDisplayAvatar(currentUser.userId)
                  : null;

              return ListTile(
                leading: UserAvatar(
                  imageUrl: displayAvatar,
                  fallbackName: displayName,
                  radius: 24,
                ),
                title: Text(displayName,
                    style: TextStyle(
                      fontWeight: convo.unreadCount > 0
                          ? FontWeight.w700
                          : FontWeight.w500,
                    )),
                subtitle: convo.lastMessage != null
                    ? Text(
                        convo.lastMessage!.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: convo.unreadCount > 0
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.outline,
                        ),
                      )
                    : null,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (convo.createdAt != null)
                      Text(
                        timeago.format(DateTime.parse(convo.createdAt!), locale: 'en_short'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline, fontSize: 11),
                      ),
                    if (convo.unreadCount > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${convo.unreadCount}',
                            style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ),
                    ],
                  ],
                ),
                onTap: () => context.push('/chat/${convo.conversationId}'),
              );
            },
          ),
        );
      },
    );
  }
}

class _RequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final requestsAsync = ref.watch(_messageRequestsProvider);

    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (requests) {
        if (requests.isEmpty) {
          return Center(
            child: Text('No message requests', style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline)),
          );
        }
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            return ListTile(
              title: Text(req.groupName ?? 'Message Request'),
              subtitle: const Text('Wants to send you a message'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: () async {
                      await ref.read(chatServiceProvider).acceptMessageRequest(req.conversationId);
                      ref.invalidate(_messageRequestsProvider);
                    },
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await ref.read(chatServiceProvider).rejectMessageRequest(req.conversationId);
                      ref.invalidate(_messageRequestsProvider);
                    },
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                    child: const Text('Reject'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _NewMessageSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NewMessageSheet> createState() => _NewMessageSheetState();
}

class _NewMessageSheetState extends ConsumerState<_NewMessageSheet> {
  List<ChatFriend> _friends = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      final service = ref.read(chatServiceProvider);
      _friends = await service.getFriends();
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Message', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _friends.isEmpty
                    ? Center(child: Text('No friends to message',
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.outline)))
                    : ListView.builder(
                        itemCount: _friends.length,
                        itemBuilder: (context, index) {
                          final friend = _friends[index];
                          return ListTile(
                            leading: UserAvatar(
                              imageUrl: friend.fullAvatarUrl,
                              fallbackName: friend.fullName,
                              radius: 22,
                            ),
                            title: Text(friend.fullName),
                            subtitle: Text('@${friend.username}'),
                            onTap: () async {
                              Navigator.pop(context);
                              try {
                                final convo = await ref.read(chatServiceProvider)
                                    .getOrCreateDirectConversation(friend.userId);
                                if (context.mounted) {
                                  context.push('/chat/${convo.conversationId}');
                                }
                              } catch (_) {}
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
