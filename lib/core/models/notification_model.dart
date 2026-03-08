/// Notification type enum matching API values
enum NotificationType {
  follow,
  followRequest,
  followRequestAccepted,
  likePost,
  likeReel,
  likeComment,
  commentPost,
  commentReel,
  replyComment,
  repostPost,
  repostReel,
  mention,
  general;

  static NotificationType fromString(String value) {
    switch (value) {
      case 'follow': return NotificationType.follow;
      case 'follow_request': return NotificationType.followRequest;
      case 'follow_request_accepted': return NotificationType.followRequestAccepted;
      case 'like_post': return NotificationType.likePost;
      case 'like_reel': return NotificationType.likeReel;
      case 'like_comment': return NotificationType.likeComment;
      case 'comment_post': return NotificationType.commentPost;
      case 'comment_reel': return NotificationType.commentReel;
      case 'reply_comment': return NotificationType.replyComment;
      case 'repost_post': return NotificationType.repostPost;
      case 'repost_reel': return NotificationType.repostReel;
      case 'mention': return NotificationType.mention;
      default: return NotificationType.general;
    }
  }
}

/// Sender info embedded in notifications
class NotificationSender {
  final String id;
  final String? fullName;
  final String? username;
  final String? avatarUrl;

  const NotificationSender({
    required this.id,
    this.fullName,
    this.username,
    this.avatarUrl,
  });

  String? get fullAvatarUrl {
    if (avatarUrl == null || avatarUrl!.isEmpty) return null;
    var url = avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String senderId;
  final String? senderName;
  final String? senderUsername;
  final String? senderAvatar;
  final String? postId;
  final String? reelId;
  final String? commentId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  /// Sender object for display
  NotificationSender? get sender => senderId.isNotEmpty
      ? NotificationSender(
          id: senderId,
          fullName: senderName,
          username: senderUsername,
          avatarUrl: senderAvatar,
        )
      : null;

  /// Target ID (postId, reelId, or commentId)
  String? get targetId => postId ?? reelId ?? commentId;

  /// Alias for [message]
  String? get content => message;

  AppNotification({
    required this.id,
    required this.type,
    required this.senderId,
    this.senderName,
    this.senderUsername,
    this.senderAvatar,
    this.postId,
    this.reelId,
    this.commentId,
    required this.message,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;

    return AppNotification(
      id: json['_id'] ?? json['id'] ?? '',
      type: NotificationType.fromString(json['type'] ?? 'general'),
      senderId: sender?['_id'] ?? json['sender_id'] ?? json['sender'] ?? '',
      senderName: sender?['full_name'] ?? json['sender_name'],
      senderUsername: sender?['username'] ?? json['sender_username'],
      senderAvatar: sender?['avatar_url'] ?? json['sender_avatar'],
      postId: json['post_id'] ?? json['post'],
      reelId: json['reel_id'] ?? json['reel'],
      commentId: json['comment_id'] ?? json['comment'],
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type.name,
      'sender': {
        '_id': senderId,
        'full_name': senderName,
        'username': senderUsername,
        'avatar_url': senderAvatar,
      },
      'post_id': postId,
      'reel_id': reelId,
      'comment_id': commentId,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    bool? isRead,
  }) {
    return AppNotification(
      id: id,
      type: type,
      senderId: senderId,
      senderName: senderName,
      senderUsername: senderUsername,
      senderAvatar: senderAvatar,
      postId: postId,
      reelId: reelId,
      commentId: commentId,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
