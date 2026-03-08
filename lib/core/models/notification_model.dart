class AppNotification {
  final String id;
  final String type;
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
      type: json['type'] ?? 'general',
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
      'type': type,
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
