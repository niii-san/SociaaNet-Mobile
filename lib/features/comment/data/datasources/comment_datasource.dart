import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class CommentRemoteDatasource {
  Future<Map<String, dynamic>> getComments(String targetId, {String targetType, int page, int limit});
  Future<Map<String, dynamic>> addComment(String targetId, String content, {String targetType});
  Future<Map<String, dynamic>> replyToComment(String commentId, String content);
  Future<Map<String, dynamic>> getReplies(String commentId, {int page, int limit});
  Future<void> likeComment(String commentId);
  Future<void> unlikeComment(String commentId);
  Future<void> deleteComment(String commentId);
}

class CommentRemoteDatasourceImpl implements CommentRemoteDatasource {
  final ApiClient _apiClient;

  CommentRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getComments(String targetId, {String targetType = 'post', int page = 1, int limit = 20}) async {
    try {
      final endpoint = targetType == 'reel'
          ? ApiEndpoints.reelComments(targetId)
          : ApiEndpoints.postComments(targetId);
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}$endpoint',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load comments: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> addComment(String targetId, String content, {String targetType = 'post'}) async {
    try {
      final endpoint = targetType == 'reel'
          ? ApiEndpoints.reelComments(targetId)
          : ApiEndpoints.postComments(targetId);
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}$endpoint',
        data: {'content': content},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to add comment: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> replyToComment(String commentId, String content) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.replyComment(commentId)}',
        data: {'content': content},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to reply to comment: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getReplies(String commentId, {int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.commentReplies(commentId)}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load replies: ${e.message}');
    }
  }

  @override
  Future<void> likeComment(String commentId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likeComment(commentId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to like comment: ${e.message}');
    }
  }

  @override
  Future<void> unlikeComment(String commentId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likeComment(commentId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unlike comment: ${e.message}');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.deleteComment(commentId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete comment: ${e.message}');
    }
  }
}
