import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class SettingsRemoteDatasource {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updatePrivacy(Map<String, dynamic> settings);
  Future<void> updateNotifications(Map<String, dynamic> settings);
  Future<void> updateAppearance(Map<String, dynamic> settings);
  Future<void> updateFeed(Map<String, dynamic> settings);
  Future<void> changePassword({required String currentPassword, required String newPassword});
}

class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  final ApiClient _apiClient;

  SettingsRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.settings}',
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load settings: ${e.message}');
    }
  }

  @override
  Future<void> updatePrivacy(Map<String, dynamic> settings) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsPrivacy}',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update privacy settings: ${e.message}');
    }
  }

  @override
  Future<void> updateNotifications(Map<String, dynamic> settings) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsNotifications}',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update notification settings: ${e.message}');
    }
  }

  @override
  Future<void> updateAppearance(Map<String, dynamic> settings) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsAppearance}',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update appearance settings: ${e.message}');
    }
  }

  @override
  Future<void> updateFeed(Map<String, dynamic> settings) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsFeed}',
        data: settings,
      );
    } on DioException catch (e) {
      throw Exception('Failed to update feed settings: ${e.message}');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.patch(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.changePassword}',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to change password: ${e.message}');
    }
  }
}
