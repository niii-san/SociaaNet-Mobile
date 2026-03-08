import 'package:sociaanet/core/models/models.dart';

export 'package:sociaanet/core/models/chat_model.dart';

/// Extended chat model utilities

class ChatConversationWithUser {
  final ChatConversation conversation;
  final ChatParticipant otherUser;

  ChatConversationWithUser({
    required this.conversation,
    required this.otherUser,
  });

  String get displayName => otherUser.fullName;
  String? get displayAvatar => otherUser.avatarUrl;
  bool get isOnline => otherUser.isOnline;
  String? get lastMessagePreview => conversation.lastMessage?.content;
  DateTime get lastActivity => conversation.updatedAt;
  int get unreadCount => conversation.unreadCount;
}
