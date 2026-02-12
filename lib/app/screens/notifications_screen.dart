import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationsProvider.notifier).loadNotifications(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifState = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsProvider.notifier).markAllAsRead(),
            child: const Text('Mark all read'),
          ),
        ],
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: notifState.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(notificationsProvider.notifier).loadNotifications(refresh: true),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 72,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15)),
                  const SizedBox(height: 16),
                  Text('No notifications yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                  const SizedBox(height: 8),
                  Text("When someone interacts with you,\nyou'll see it here",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsProvider.notifier).loadNotifications(refresh: true),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _NotificationItem(notification: notifications[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.transparent
              : theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                UserAvatar(
                  imageUrl: notification.sender?.fullAvatarUrl,
                  fallbackName: notification.sender?.fullName ?? '',
                  radius: 22,
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(),
                      size: 14,
                      color: _getIconColor(theme),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: notification.sender?.fullName ?? 'Someone',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' ${_getMessage()}'),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(DateTime.parse(notification.createdAt)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6, left: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    switch (notification.type) {
      case NotificationType.follow:
      case NotificationType.followRequestAccepted:
        if (notification.sender != null) {
          context.push('/u/${notification.sender!.username}');
        }
        break;
      case NotificationType.followRequest:
        context.push('/follow-requests');
        break;
      case NotificationType.likePost:
      case NotificationType.commentPost:
      case NotificationType.replyComment:
      case NotificationType.repostPost:
        if (notification.targetId != null) {
          context.push('/posts/${notification.targetId}');
        }
        break;
      default:
        if (notification.sender != null) {
          context.push('/u/${notification.sender!.username}');
        }
    }
  }

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.follow:
      case NotificationType.followRequestAccepted:
        return Icons.person_add;
      case NotificationType.followRequest:
        return Icons.person_add_alt;
      case NotificationType.likePost:
      case NotificationType.likeReel:
      case NotificationType.likeComment:
        return Icons.favorite;
      case NotificationType.commentPost:
      case NotificationType.commentReel:
      case NotificationType.replyComment:
        return Icons.chat_bubble;
      case NotificationType.repostPost:
      case NotificationType.repostReel:
        return Icons.repeat;
      case NotificationType.mention:
        return Icons.alternate_email;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (notification.type) {
      case NotificationType.likePost:
      case NotificationType.likeReel:
      case NotificationType.likeComment:
        return Colors.red;
      case NotificationType.follow:
      case NotificationType.followRequestAccepted:
      case NotificationType.followRequest:
        return theme.colorScheme.primary;
      case NotificationType.commentPost:
      case NotificationType.commentReel:
      case NotificationType.replyComment:
        return Colors.blue;
      case NotificationType.repostPost:
      case NotificationType.repostReel:
        return Colors.green;
      default:
        return theme.colorScheme.primary;
    }
  }

  String _getMessage() {
    switch (notification.type) {
      case NotificationType.follow:
        return 'started following you';
      case NotificationType.followRequest:
        return 'requested to follow you';
      case NotificationType.followRequestAccepted:
        return 'accepted your follow request';
      case NotificationType.likePost:
        return 'liked your post';
      case NotificationType.likeReel:
        return 'liked your reel';
      case NotificationType.likeComment:
        return 'liked your comment';
      case NotificationType.commentPost:
        return 'commented on your post';
      case NotificationType.commentReel:
        return 'commented on your reel';
      case NotificationType.replyComment:
        return 'replied to your comment';
      case NotificationType.repostPost:
        return 'reposted your post';
      case NotificationType.repostReel:
        return 'reposted your reel';
      case NotificationType.mention:
        return 'mentioned you';
      default:
        return notification.content ?? 'interacted with you';
    }
  }
}
