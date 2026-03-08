import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

class ActivityService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<Map<String, dynamic>> getActivities({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userActivities}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'activities': (data['activities'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }

  Future<Map<String, dynamic>> getLikeHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryLikes}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'likes': (data['likes'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }

  Future<Map<String, dynamic>> getCommentHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryComments}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'comments': (data['comments'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }

  Future<Map<String, dynamic>> getWatchHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryWatches}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'watches': (data['watches'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }

  Future<Map<String, dynamic>> getRepostHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryReposts}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'reposts': (data['reposts'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }

  Future<Map<String, dynamic>> getSavedItems({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userSaved}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'saved': (data['saved'] as List?)?.cast<Map<String, dynamic>>() ?? [],
      'pagination': data['pagination'],
    };
  }
}
