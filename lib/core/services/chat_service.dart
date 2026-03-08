import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class ChatService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<ChatConversation>> getConversations() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversations}',
    );
    return (response.data['data'] as List?)
            ?.map((c) => ChatConversation.fromJson(c))
            .toList() ??
        [];
  }

  Future<ChatConversation> getOrCreateDirectConversation(String targetUserId) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversationsDirect}',
      data: {'target_user_id': targetUserId},
    );
    return ChatConversation.fromJson(response.data['data'] ?? response.data);
  }

  Future<ChatConversation> createGroupConversation({
    required List<String> participantIds,
    required String groupName,
  }) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversationsGroup}',
      data: {'participant_ids': participantIds, 'group_name': groupName},
    );
    return ChatConversation.fromJson(response.data['data'] ?? response.data);
  }

  Future<ChatConversation> getConversation(String conversationId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversation(conversationId)}',
    );
    return ChatConversation.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> deleteConversation(String conversationId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversation(conversationId)}',
    );
  }

  Future<List<ChatMessage>> getMessages(String conversationId, {int page = 1, int limit = 50}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessages(conversationId)}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return (data['messages'] as List?)
            ?.map((m) => ChatMessage.fromJson(m))
            .toList() ??
        [];
  }

  Future<ChatMessage> sendMessage({
    required String conversationId,
    String? content,
    String messageType = 'text',
    List<String>? mediaKeys,
    String? replyTo,
  }) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessages(conversationId)}',
      data: {
        if (content != null) 'content': content,
        'message_type': messageType,
        if (mediaKeys != null) 'media_keys': mediaKeys,
        if (replyTo != null) 'reply_to': replyTo,
      },
    );
    return ChatMessage.fromJson(response.data['data'] ?? response.data);
  }

  Future<void> markAsRead(String conversationId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMarkRead(conversationId)}',
    );
  }

  Future<void> reactToMessage(String messageId, String emoji) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatReactMessage(messageId)}',
      data: {'emoji': emoji},
    );
  }

  Future<void> removeReaction(String messageId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatReactMessage(messageId)}',
    );
  }

  Future<void> deleteMessage(String messageId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatDeleteMessage(messageId)}',
    );
  }

  Future<int> getTotalUnreadCount() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatUnreadCount}',
    );
    return response.data['data']?['count'] ?? response.data['count'] ?? 0;
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatFriends}',
    );
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  Future<List<ChatConversation>> getMessageRequests() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessageRequests}',
    );
    return (response.data['data'] as List?)
            ?.map((c) => ChatConversation.fromJson(c))
            .toList() ??
        [];
  }

  Future<int> getMessageRequestsCount() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessageRequestsCount}',
    );
    return response.data['data']?['count'] ?? 0;
  }

  Future<void> acceptMessageRequest(String conversationId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatAcceptRequest(conversationId)}',
    );
  }

  Future<void> rejectMessageRequest(String conversationId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.chatRejectRequest(conversationId)}',
    );
  }
}
