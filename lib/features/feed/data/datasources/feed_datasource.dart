import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class FeedRemoteDatasource {
  Future<Map<String, dynamic>> getHomeFeed({int page, int limit});
  Future<Map<String, dynamic>> getExploreFeed({int page, int limit});
  Future<Map<String, dynamic>> getReelsFeed({int page, int limit});
  Future<Map<String, dynamic>> getSuggestedUsers({int limit});
}

class FeedRemoteDatasourceImpl implements FeedRemoteDatasource {
  final ApiClient _apiClient;

  FeedRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getHomeFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.feedHome}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load feed: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getExploreFeed({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.feedExplore}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load explore: ${e.message}');
    }
  }

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
  Future<Map<String, dynamic>> getSuggestedUsers({int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.feedSuggestedUsers}',
        queryParameters: {'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load suggested users: ${e.message}');
    }
  }
}
