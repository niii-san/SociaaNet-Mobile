import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/error/failures.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/features/chat/data/datasources/chat_datasource.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatConversation>>> getConversations({int page, int limit});
  Future<Either<Failure, ChatConversation>> getOrCreateDirectConversation(String userId);
  Future<Either<Failure, ChatConversation>> createGroupConversation({required String name, required List<String> participantIds});
  Future<Either<Failure, ChatConversation>> getConversation(String conversationId);
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId, {int page, int limit});
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String conversationId,
    required String content,
    String messageType,
    List<String>? mediaKeys,
    String? replyToId,
  });
  Future<Either<Failure, void>> markAsRead(String conversationId);
  Future<Either<Failure, void>> reactToMessage(String messageId, String emoji);
  Future<Either<Failure, void>> removeReaction(String messageId);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  Future<Either<Failure, void>> deleteConversation(String conversationId);
  Future<Either<Failure, int>> getTotalUnreadCount();
  Future<Either<Failure, List<Map<String, dynamic>>>> getFriends();
  Future<Either<Failure, Map<String, dynamic>>> getMessageRequests();
  Future<Either<Failure, int>> getMessageRequestsCount();
  Future<Either<Failure, void>> acceptMessageRequest(String conversationId);
  Future<Either<Failure, void>> rejectMessageRequest(String conversationId);
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource _remoteDatasource;

  ChatRepositoryImpl({ChatRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? ChatRemoteDatasourceImpl();

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations({int page = 1, int limit = 20}) async {
    try {
      final data = await _remoteDatasource.getConversations(page: page, limit: limit);
      final convList = data['conversations'] ?? data['items'] ?? [];
      final conversations = (convList as List).map((json) => ChatConversation.fromJson(json)).toList();
      return Right(conversations);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, ChatConversation>> getOrCreateDirectConversation(String userId) async {
    try {
      final data = await _remoteDatasource.getOrCreateDirectConversation(userId);
      return Right(ChatConversation.fromJson(data));
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, ChatConversation>> createGroupConversation({required String name, required List<String> participantIds}) async {
    try {
      final data = await _remoteDatasource.createGroupConversation(name: name, participantIds: participantIds);
      return Right(ChatConversation.fromJson(data));
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, ChatConversation>> getConversation(String conversationId) async {
    try {
      final data = await _remoteDatasource.getConversation(conversationId);
      return Right(ChatConversation.fromJson(data));
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId, {int page = 1, int limit = 30}) async {
    try {
      final data = await _remoteDatasource.getMessages(conversationId, page: page, limit: limit);
      final msgList = data['messages'] ?? data['items'] ?? [];
      final messages = (msgList as List).map((json) => ChatMessage.fromJson(json)).toList();
      return Right(messages);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<String>? mediaKeys,
    String? replyToId,
  }) async {
    try {
      final data = await _remoteDatasource.sendMessage(
        conversationId: conversationId,
        content: content,
        messageType: messageType,
        mediaKeys: mediaKeys,
        replyToId: replyToId,
      );
      return Right(ChatMessage.fromJson(data));
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      await _remoteDatasource.markAsRead(conversationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> reactToMessage(String messageId, String emoji) async {
    try {
      await _remoteDatasource.reactToMessage(messageId, emoji);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> removeReaction(String messageId) async {
    try {
      await _remoteDatasource.removeReaction(messageId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _remoteDatasource.deleteMessage(messageId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String conversationId) async {
    try {
      await _remoteDatasource.deleteConversation(conversationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalUnreadCount() async {
    try {
      final count = await _remoteDatasource.getTotalUnreadCount();
      return Right(count);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getFriends() async {
    try {
      final friends = await _remoteDatasource.getFriends();
      return Right(friends);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getMessageRequests() async {
    try {
      final data = await _remoteDatasource.getMessageRequests();
      return Right(data);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, int>> getMessageRequestsCount() async {
    try {
      final count = await _remoteDatasource.getMessageRequestsCount();
      return Right(count);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> acceptMessageRequest(String conversationId) async {
    try {
      await _remoteDatasource.acceptMessageRequest(conversationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> rejectMessageRequest(String conversationId) async {
    try {
      await _remoteDatasource.rejectMessageRequest(conversationId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ApiFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
