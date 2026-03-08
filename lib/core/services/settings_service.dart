import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class SettingsService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<UserSettings> getUserSettings() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.settings}',
    );
    final data = response.data['data'] ?? response.data;
    return UserSettings.fromJson(data['settings'] ?? data);
  }

  Future<void> updatePrivacySettings(Map<String, dynamic> settings) async {
    await _apiClient.patch(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsPrivacy}',
      data: settings,
    );
  }

  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    await _apiClient.patch(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsNotifications}',
      data: settings,
    );
  }

  Future<void> updateAppearanceSettings(Map<String, dynamic> settings) async {
    await _apiClient.patch(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsAppearance}',
      data: settings,
    );
  }

  Future<void> updateFeedSettings(Map<String, dynamic> settings) async {
    await _apiClient.patch(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.settingsFeed}',
      data: settings,
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.patch(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.changePassword}',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> logoutSession(String sessionId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.logout}',
      data: {'sessionId': sessionId},
    );
  }

  Future<void> logoutAllSessions() async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.logout}',
      data: {'allSessions': true},
    );
  }
}
