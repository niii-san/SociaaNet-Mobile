import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class ReelRemoteDatasource {
  Future<Map<String, dynamic>> getReelsFeed({int page, int limit});
  Future<Map<String, dynamic>> createReel({required String caption, required String videoPath, String? visibility});
  Future<Map<String, dynamic>> getReel(String reelId);
  Future<void> updateReelVisibility(String reelId, String visibility);
  Future<void> recordView(String reelId);
  Future<void> likeReel(String reelId);
  Future<void> unlikeReel(String reelId);
  Future<void> repostReel(String reelId);
  Future<void> unrepostReel(String reelId);
  Future<void> saveReel(String reelId);
  Future<void> unsaveReel(String reelId);
  Future<Map<String, dynamic>> getComments(String reelId, {int page, int limit});
  Future<Map<String, dynamic>> addComment(String reelId, String content);
}

class ReelRemoteDatasourceImpl implements ReelRemoteDatasource {
  final ApiClient _apiClient;

  ReelRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getReelsFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.feedReels}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load reels: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> createReel({
    required String caption,
    required String videoPath,
    String? visibility,
  }) async {
    try {
      final formData = FormData.fromMap({
        'caption': caption,
        if (visibility != null) 'visibility': visibility,
        'video': await MultipartFile.fromFile(videoPath),
      });
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.mediaReel}',
        data: formData,
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create reel: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getReel(String reelId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.reelDetail(reelId)}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get reel: ${e.message}');
    }
  }

  @override
  Future<void> updateReelVisibility(String reelId, String visibility) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.reelVisibility(reelId)}',
        data: {'visibility': visibility},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update visibility: ${e.message}');
    }
  }

  @override
  Future<void> recordView(String reelId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.viewReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to record view: ${e.message}');
    }
  }

  @override
  Future<void> likeReel(String reelId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likeReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to like reel: ${e.message}');
    }
  }

  @override
  Future<void> unlikeReel(String reelId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.likeReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unlike reel: ${e.message}');
    }
  }

  @override
  Future<void> repostReel(String reelId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.repostReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to repost reel: ${e.message}');
    }
  }

  @override
  Future<void> unrepostReel(String reelId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.repostReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unrepost reel: ${e.message}');
    }
  }

  @override
  Future<void> saveReel(String reelId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.saveReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to save reel: ${e.message}');
    }
  }

  @override
  Future<void> unsaveReel(String reelId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.saveReel(reelId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unsave reel: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getComments(String reelId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.reelComments(reelId)}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load comments: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> addComment(String reelId, String content) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.reelComments(reelId)}',
        data: {'content': content},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to add comment: ${e.message}');
    }
  }
}
