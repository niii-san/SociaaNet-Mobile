import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';

class FollowRequestsScreen extends ConsumerStatefulWidget {
  const FollowRequestsScreen({super.key});

  @override
  ConsumerState<FollowRequestsScreen> createState() => _FollowRequestsScreenState();
}

class _FollowRequestsScreenState extends ConsumerState<FollowRequestsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  List<FollowRequest> _incoming = [];
  List<FollowRequest> _outgoing = [];
  bool _isLoadingIncoming = true;
  bool _isLoadingOutgoing = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    final service = ref.read(followServiceProvider);
    try {
      final incoming = await service.getFollowRequests();
      if (mounted) setState(() { _incoming = incoming; _isLoadingIncoming = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoadingIncoming = false);
    }
    try {
      final outgoing = await service.getFollowingRequests();
      if (mounted) setState(() { _outgoing = outgoing; _isLoadingOutgoing = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoadingOutgoing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Follow Requests'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Incoming'),
            Tab(text: 'Outgoing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Incoming
          _isLoadingIncoming
              ? const Center(child: CircularProgressIndicator())
              : _incoming.isEmpty
                  ? _EmptyState(
                      icon: Icons.person_add_outlined,
                      message: 'No incoming requests',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRequests,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _incoming.length,
                        itemBuilder: (context, index) {
                          final request = _incoming[index];
                          final user = request.follower;
                          return ListTile(
                            leading: UserAvatar(
                              imageUrl: user.fullAvatarUrl,
                              fallbackName: user.fullName,
                              radius: 22,
                            ),
                            title: Text(user.fullName),
                            subtitle: Text('@${user.username}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FilledButton(
                                  onPressed: () async {
                                    try {
                                      final service = ref.read(followServiceProvider);
                                      await service.acceptFollowRequest(user.userId);
                                      setState(() => _incoming.removeAt(index));
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Request accepted')));
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')));
                                      }
                                    }
                                  },
                                  child: const Text('Accept'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () async {
                                    try {
                                      final service = ref.read(followServiceProvider);
                                      await service.rejectFollowRequest(user.userId);
                                      setState(() => _incoming.removeAt(index));
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')));
                                      }
                                    }
                                  },
                                  child: const Text('Decline'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

          // Outgoing
          _isLoadingOutgoing
              ? const Center(child: CircularProgressIndicator())
              : _outgoing.isEmpty
                  ? _EmptyState(
                      icon: Icons.send_outlined,
                      message: 'No outgoing requests',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRequests,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _outgoing.length,
                        itemBuilder: (context, index) {
                          final request = _outgoing[index];
                          final user = request.following;
                          return ListTile(
                            leading: UserAvatar(
                              imageUrl: user.fullAvatarUrl,
                              fallbackName: user.fullName,
                              radius: 22,
                            ),
                            title: Text(user.fullName),
                            subtitle: Text('@${user.username}'),
                            trailing: OutlinedButton(
                              onPressed: () async {
                                try {
                                  final service = ref.read(followServiceProvider);
                                  await service.cancelFollowRequest(user.userId);
                                  setState(() => _outgoing.removeAt(index));
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                  }
                                }
                              },
                              child: const Text('Cancel'),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
