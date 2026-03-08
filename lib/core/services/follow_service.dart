import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class FollowService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Follow a user (or send follow request if private)
  Future<Map<String, dynamic>> followUser(String followeeId) async {
    final response = await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.followUser(followeeId)}',
    );
    return response.data['data'] ?? response.data;
  }

  /// Unfollow a user
  Future<void> unfollowUser(String followeeId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.unfollowUser(followeeId)}',
    );
  }

  /// Cancel a pending follow request
  Future<void> cancelFollowRequest(String followeeId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.cancelFollowRequest(followeeId)}',
    );
  }

  /// Remove a follower
  Future<void> removeFollower(String followerId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.removeFollower(followerId)}',
    );
  }

  /// Get following list for a user
  Future<List<User>> getFollowing(String userId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userFollowing(userId)}',
    );
    return (response.data['data'] as List?)
            ?.map((u) => User.fromJson(u))
            .toList() ??
        [];
  }

  /// Get followers list for a user
  Future<List<User>> getFollowers(String userId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.userFollowers(userId)}',
    );
    return (response.data['data'] as List?)
            ?.map((u) => User.fromJson(u))
            .toList() ??
        [];
  }

  /// Get incoming follow requests (for private accounts)
  Future<List<User>> getFollowRequests() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.followRequests}',
    );
    return (response.data['data'] as List?)
            ?.map((u) => User.fromJson(u))
            .toList() ??
        [];
  }

  /// Get outgoing follow requests
  Future<List<User>> getFollowingRequests() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.followingRequests}',
    );
    return (response.data['data'] as List?)
            ?.map((u) => User.fromJson(u))
            .toList() ??
        [];
  }

  /// Accept a follow request
  Future<void> acceptFollowRequest(String followerId) async {
    await _apiClient.put(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.acceptFollowRequest(followerId)}',
    );
  }

  /// Reject a follow request
  Future<void> rejectFollowRequest(String followerId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.rejectFollowRequest(followerId)}',
    );
  }
}
