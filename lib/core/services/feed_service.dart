import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class FeedService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<FeedResponse> getHomeFeed({int page = 1, int limit = 10}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.feedHome}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return FeedResponse.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getExplore({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.feedExplore}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data;
  }

  Future<List<FeedReel>> getReelsFeed({int page = 1, int limit = 10}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.feedReels}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return (data['reels'] as List?)
            ?.map((r) => FeedReel.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];
  }

  Future<List<SuggestedUser>> getSuggestedUsers({int limit = 5}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.feedSuggestedUsers}',
      queryParameters: {'limit': limit},
    );
    return (response.data['data'] as List?)
            ?.map((u) => SuggestedUser.fromJson(u))
            .toList() ??
        [];
  }
}
