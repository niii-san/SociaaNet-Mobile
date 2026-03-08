import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class PostRemoteDatasource {
  Future<Map<String, dynamic>> createPost({required String caption, required List<String> imagePaths, String? visibility});
  Future<Map<String, dynamic>> getPost(String postId);
  Future<void> updatePostVisibility(String postId, String visibility);
  Future<void> recordView(String postId);
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
  Future<void> repostPost(String postId);
  Future<void> unrepostPost(String postId);
  Future<void> savePost(String postId);
  Future<void> unsavePost(String postId);
}

class PostRemoteDatasourceImpl implements PostRemoteDatasource {
  final ApiClient _apiClient;

  PostRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> createPost({
    required String caption,
    required List<String> imagePaths,
    String? visibility,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption,
        if (visibility != null) 'visibility': visibility,
        'images': await Future.wait(
          imagePaths.map((path) => MultipartFile.fromFile(path)),
        ),
      });
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.mediaPost}',
        data: formData,
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create post: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getPost(String postId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.postDetail(postId)}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get post: ${e.message}');
    }
  }

  @override
  Future<void> updatePostVisibility(String postId, String visibility) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.postVisibility(postId)}',
        data: {'visibility': visibility},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update visibility: ${e.message}');
    }
  }

  @override
  Future<void> recordView(String postId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.viewPost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to record view: ${e.message}');
    }
  }

  @override
  Future<void> likePost(String postId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likePost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to like post: ${e.message}');
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likePost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unlike post: ${e.message}');
    }
  }

  @override
  Future<void> repostPost(String postId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.repostPost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to repost: ${e.message}');
    }
  }

  @override
  Future<void> unrepostPost(String postId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.repostPost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unrepost: ${e.message}');
    }
  }

  @override
  Future<void> savePost(String postId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.savePost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to save post: ${e.message}');
    }
  }

  @override
  Future<void> unsavePost(String postId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.savePost(postId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unsave post: ${e.message}');
    }
  }
}
