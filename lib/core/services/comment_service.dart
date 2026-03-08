import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class CommentService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Get comments for a post or reel
  Future<Map<String, dynamic>> getComments(
    String targetId, {
    int page = 1,
    int limit = 20,
    String targetType = 'post',
  }) async {
    final endpoint = targetType == 'reel'
        ? ApiEndpoints.reelComments(targetId)
        : ApiEndpoints.postComments(targetId);
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}$endpoint',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'comments': (data['comments'] as List?)
              ?.map((c) => Comment.fromJson(c))
              .toList() ??
          [],
      'pagination': data['pagination'],
    };
  }

  /// Add a comment to a post or reel
  Future<Comment> addComment(
    String targetId,
    String content, {
    String targetType = 'post',
  }) async {
    final endpoint = targetType == 'reel'
        ? ApiEndpoints.reelComments(targetId)
        : ApiEndpoints.postComments(targetId);
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}$endpoint',
      data: {'content': content},
    );
    return Comment.fromJson(response.data['data'] ?? response.data);
  }

  /// Reply to a comment
  Future<Comment> replyToComment(String commentId, String content) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.replyComment(commentId)}',
      data: {'content': content},
    );
    return Comment.fromJson(response.data['data'] ?? response.data);
  }

  /// Get replies to a comment
  Future<Map<String, dynamic>> getReplies(
    String commentId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.commentReplies(commentId)}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'replies': (data['replies'] as List?)
              ?.map((c) => Comment.fromJson(c))
              .toList() ??
          [],
      'pagination': data['pagination'],
    };
  }

  /// Like a comment
  Future<Map<String, dynamic>> likeComment(String commentId) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.likeComment(commentId)}',
    );
    return response.data['data'] ?? response.data;
  }

  /// Unlike a comment
  Future<Map<String, dynamic>> unlikeComment(String commentId) async {
    final response = await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.likeComment(commentId)}',
    );
    return response.data['data'] ?? response.data;
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.deleteComment(commentId)}',
    );
  }
}
