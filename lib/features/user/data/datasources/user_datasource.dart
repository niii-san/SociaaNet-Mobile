import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

/// Data source for user-related API calls
class UserDataSource {
  final ApiClient _apiClient;

  UserDataSource({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  /// Upload profile avatar
  Future<GetUserInfoResponseModel> uploadAvatar(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      String mimeType = 'image/jpeg';
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      } else if (extension == 'webp') {
        mimeType = 'image/webp';
      }

      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );

      final formData = FormData.fromMap({'avatar': multipartFile});

      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadAvatar,
        formData: formData,
      );

      return GetUserInfoResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to upload avatar: ${e.message}');
    }
  }

  /// Get current user information
  Future<GetUserInfoResponseModel> getUserInfo() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getUserInfo);
      return GetUserInfoResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user info: ${e.message}');
    }
  }

  /// Get user profile by username
  Future<Map<String, dynamic>> getUserProfile(String username) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.userProfile(username)}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get user profile: ${e.message}');
    }
  }

  /// Update bio
  Future<void> updateBio(String bio) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.updateBio}',
        data: {'bio': bio},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update bio: ${e.message}');
    }
  }

  /// Update username
  Future<void> updateUsername(String username) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.updateUsername}',
        data: {'username': username},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update username: ${e.message}');
    }
  }

  /// Update full name
  Future<void> updateFullname(String fullName) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.updateFullname}',
        data: {'full_name': fullName},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update full name: ${e.message}');
    }
  }

  /// Search users
  Future<Map<String, dynamic>> searchUsers(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.searchUsers}',
        queryParameters: {'q': query, 'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to search users: ${e.message}');
    }
  }

  /// Follow a user
  Future<Map<String, dynamic>> followUser(String followeeId) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.followUser(followeeId)}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to follow user: ${e.message}');
    }
  }

  /// Unfollow a user
  Future<void> unfollowUser(String followeeId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.unfollowUser(followeeId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to unfollow user: ${e.message}');
    }
  }

  /// Get followers list
  Future<Map<String, dynamic>> getFollowers(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.userFollowers(userId)}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get followers: ${e.message}');
    }
  }

  /// Get following list
  Future<Map<String, dynamic>> getFollowing(String userId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.userFollowing(userId)}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get following: ${e.message}');
    }
  }

  /// Get user activities
  Future<Map<String, dynamic>> getActivities({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.userActivities}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get activities: ${e.message}');
    }
  }

  /// Get saved items
  Future<Map<String, dynamic>> getSavedItems({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.userSaved}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to get saved items: ${e.message}');
    }
  }
}
