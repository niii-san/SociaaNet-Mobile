class ChatConversation {
  final String id;
  final List<ChatParticipant> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime updatedAt;
  final bool isGroup;
  final String? groupName;

  /// Alias for [id]
  String get conversationId => id;

  /// Alias for [updatedAt] (conversations don't have a separate createdAt from API)
  DateTime get createdAt => updatedAt;

  ChatConversation({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    required this.updatedAt,
    this.isGroup = false,
    this.groupName,
  });

  /// Get the display name for this conversation relative to the given userId
  String getDisplayName(String currentUserId) {
    if (isGroup) return groupName ?? 'Group';
    final other = getOtherParticipant(currentUserId);
    return other?.fullName ?? 'Unknown';
  }

  /// Get the display avatar for this conversation relative to the given userId
  String? getDisplayAvatar(String currentUserId) {
    if (isGroup) return null;
    final other = getOtherParticipant(currentUserId);
    if (other?.avatarUrl == null) return null;
    var url = other!.avatarUrl!;
    if (url.contains('localhost')) url = url.replaceAll('localhost', '10.0.2.2');
    if (!url.startsWith('http')) url = 'http://10.0.2.2:8000$url';
    return url;
  }

  /// Get the other participant in a direct conversation
  ChatParticipant? getOtherParticipant(String currentUserId) {
    if (participants.isEmpty) return null;
    try {
      return participants.firstWhere((p) => p.userId != currentUserId);
    } catch (_) {
      return participants.first;
    }
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['_id'] ?? json['id'] ?? '',
      participants: (json['participants'] as List?)
              ?.map((p) => ChatParticipant.fromJson(p))
              .toList() ??
          [],
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      isGroup: json['is_group'] ?? false,
      groupName: json['group_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'updated_at': updatedAt.toIso8601String(),
      'is_group': isGroup,
      'group_name': groupName,
    };
  }
}

class ChatParticipant {
  final String userId;
  final String fullName;
  final String? username;
  final String? avatarUrl;
  final bool isOnline;

  ChatParticipant({
    required this.userId,
    required this.fullName,
    this.username,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      userId: json['_id'] ?? json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar_url'],
      isOnline: json['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'username': username,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
    };
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final String messageType;
  final List<String>? mediaUrls;
  final String? replyToId;
  final Map<String, List<String>>? reactions;
  final bool isRead;
  final bool isDeleted;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    this.messageType = 'text',
    this.mediaUrls,
    this.replyToId,
    this.reactions,
    this.isRead = false,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;

    return ChatMessage(
      id: json['_id'] ?? json['id'] ?? '',
      conversationId: json['conversation_id'] ?? json['conversation'] ?? '',
      senderId: sender?['_id'] ?? json['sender_id'] ?? json['sender'] ?? '',
      senderName: sender?['full_name'] ?? json['sender_name'],
      senderAvatar: sender?['avatar_url'] ?? json['sender_avatar'],
      content: json['content'] ?? '',
      messageType: json['message_type'] ?? json['type'] ?? 'text',
      mediaUrls: (json['media_urls'] as List?)?.cast<String>(),
      replyToId: json['reply_to'],
      reactions: (json['reactions'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as List).cast<String>()),
      ),
      isRead: json['is_read'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'content': content,
      'message_type': messageType,
      'media_urls': mediaUrls,
      'reply_to': replyToId,
      'reactions': reactions,
      'is_read': isRead,
      'is_deleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatMessage copyWith({
    String? content,
    bool? isRead,
    bool? isDeleted,
    Map<String, List<String>>? reactions,
  }) {
    return ChatMessage(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content ?? this.content,
      messageType: messageType,
      mediaUrls: mediaUrls,
      replyToId: replyToId,
      reactions: reactions ?? this.reactions,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
    );
  }
}
