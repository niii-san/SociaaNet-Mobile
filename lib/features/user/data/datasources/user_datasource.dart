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
  /// Returns the updated user info with new avatar URL
  Future<GetUserInfoResponseModel> uploadAvatar(File imageFile) async {
    try {
      // Get file extension
      final fileName = imageFile.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      
      // Determine MIME type
      String mimeType = 'image/jpeg';
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      } else if (extension == 'webp') {
        mimeType = 'image/webp';
      }

      // Create multipart file
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );

      // Create form data
      final formData = FormData.fromMap({
        'avatar': multipartFile,
      });

      // Upload avatar
      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadAvatar,
        formData: formData,
      );

      return GetUserInfoResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to upload avatar: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error uploading avatar: $e');
    }
  }

  /// Get current user information
  Future<GetUserInfoResponseModel> getUserInfo() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getUserInfo);
      return GetUserInfoResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to get user info: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting user info: $e');
    }
  }
}
