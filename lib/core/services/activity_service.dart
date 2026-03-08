import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class ActivityService {
  final ApiClient _apiClient = ApiClient.instance;

  List<HistoryItem> _parseItems(List? items) {
    if (items == null) return [];
    return items.map((e) => HistoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<HistoryItem>> getLikeHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryLikes}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return _parseItems(data['likes'] as List?);
  }

  Future<List<HistoryItem>> getCommentHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryComments}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return _parseItems(data['comments'] as List?);
  }

  Future<List<HistoryItem>> getWatchHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryWatches}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return _parseItems(data['watches'] as List?);
  }

  Future<List<HistoryItem>> getRepostHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryReposts}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return _parseItems(data['reposts'] as List?);
  }

  Future<List<HistoryItem>> getSavedItems({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userSaved}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return _parseItems(data['saved'] as List?);
  }
}
