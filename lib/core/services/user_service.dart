import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class UserService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Get current authenticated user's profile
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.getUserInfo}',
    );
    return User.fromJson(response.data['data'] ?? response.data);
  }

  /// Get a user's public profile by username
  Future<Map<String, dynamic>> getUserProfile(String username) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userProfile(username)}',
    );
    return response.data['data'] ?? response.data;
  }

  /// Update bio
  Future<void> updateBio(String bio) async {
    await _apiClient.put(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.updateBio}',
      data: {'bio': bio},
    );
  }

  /// Update username
  Future<void> updateUsername(String username) async {
    await _apiClient.put(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.updateUsername}',
      data: {'username': username},
    );
  }

  /// Update full name
  Future<void> updateFullname(String fullName) async {
    await _apiClient.put(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.updateFullname}',
      data: {'full_name': fullName},
    );
  }

  /// Search users by query
  Future<Map<String, dynamic>> searchUsers(String query, {int page = 1}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.searchUsers}',
      queryParameters: {'query': query, 'page': page},
    );
    return response.data;
  }

  /// Get activity feed
  Future<List<Map<String, dynamic>>> getActivities() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userActivities}',
    );
    return (response.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  /// Get like history
  Future<Map<String, dynamic>> getLikeHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryLikes}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] ?? response.data;
  }

  /// Get comment history
  Future<Map<String, dynamic>> getCommentHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryComments}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] ?? response.data;
  }

  /// Get watch history
  Future<Map<String, dynamic>> getWatchHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryWatches}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] ?? response.data;
  }

  /// Get repost history
  Future<Map<String, dynamic>> getRepostHistory({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userHistoryReposts}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] ?? response.data;
  }

  /// Get saved items
  Future<Map<String, dynamic>> getSavedItems({int page = 1, int limit = 20}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userSaved}',
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] ?? response.data;
  }
}
