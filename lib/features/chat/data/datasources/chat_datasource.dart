import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class ChatRemoteDatasource {
  Future<Map<String, dynamic>> getConversations({int page, int limit});
  Future<Map<String, dynamic>> getOrCreateDirectConversation(String userId);
  Future<Map<String, dynamic>> createGroupConversation({required String name, required List<String> participantIds});
  Future<Map<String, dynamic>> getConversation(String conversationId);
  Future<Map<String, dynamic>> getMessages(String conversationId, {int page, int limit});
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String content,
    String messageType,
    List<String>? mediaKeys,
    String? replyToId,
  });
  Future<void> markAsRead(String conversationId);
  Future<void> reactToMessage(String messageId, String emoji);
  Future<void> removeReaction(String messageId);
  Future<void> deleteMessage(String messageId);
  Future<void> deleteConversation(String conversationId);
  Future<int> getTotalUnreadCount();
  Future<List<Map<String, dynamic>>> getFriends();
  Future<Map<String, dynamic>> getMessageRequests();
  Future<int> getMessageRequestsCount();
  Future<void> acceptMessageRequest(String conversationId);
  Future<void> rejectMessageRequest(String conversationId);
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final ApiClient _apiClient;

  ChatRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getConversations({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversations}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load conversations: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrCreateDirectConversation(String userId) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversationsDirect}',
        data: {'participantId': userId},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create conversation: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> createGroupConversation({
    required String name,
    required List<String> participantIds,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversationsGroup}',
        data: {'name': name, 'participantIds': participantIds},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create group: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getConversation(String conversationId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversation(conversationId)}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get conversation: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getMessages(String conversationId, {int page = 1, int limit = 30}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessages(conversationId)}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load messages: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<String>? mediaKeys,
    String? replyToId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessages(conversationId)}',
        data: {
          'content': content,
          'messageType': messageType,
          if (mediaKeys != null) 'mediaKeys': mediaKeys,
          if (replyToId != null) 'replyTo': replyToId,
        },
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMarkRead(conversationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to mark as read: ${e.message}');
    }
  }

  @override
  Future<void> reactToMessage(String messageId, String emoji) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatReactMessage(messageId)}',
        data: {'emoji': emoji},
      );
    } on DioException catch (e) {
      throw Exception('Failed to react to message: ${e.message}');
    }
  }

  @override
  Future<void> removeReaction(String messageId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatReactMessage(messageId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to remove reaction: ${e.message}');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatDeleteMessage(messageId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete message: ${e.message}');
    }
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatConversation(conversationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete conversation: ${e.message}');
    }
  }

  @override
  Future<int> getTotalUnreadCount() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatUnreadCount}',
      );
      final data = response.data['data'] ?? response.data;
      return data['count'] ?? 0;
    } on DioException catch (e) {
      throw Exception('Failed to get unread count: ${e.message}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatFriends}',
      );
      final data = response.data['data'] ?? response.data;
      return (data['friends'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    } on DioException catch (e) {
      throw Exception('Failed to get friends: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getMessageRequests() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessageRequests}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get message requests: ${e.message}');
    }
  }

  @override
  Future<int> getMessageRequestsCount() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatMessageRequestsCount}',
      );
      final data = response.data['data'] ?? response.data;
      return data['count'] ?? 0;
    } on DioException catch (e) {
      throw Exception('Failed to get message requests count: ${e.message}');
    }
  }

  @override
  Future<void> acceptMessageRequest(String conversationId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatAcceptRequest(conversationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to accept message request: ${e.message}');
    }
  }

  @override
  Future<void> rejectMessageRequest(String conversationId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.chatRejectRequest(conversationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to reject message request: ${e.message}');
    }
  }
}
