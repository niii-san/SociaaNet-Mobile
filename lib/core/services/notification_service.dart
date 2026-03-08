import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 30}) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notifications}',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] ?? response.data;
    return {
      'notifications': (data['notifications'] as List?)
              ?.map((n) => AppNotification.fromJson(n))
              .toList() ??
          [],
      'pagination': data['pagination'],
    };
  }

  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationsUnreadCount}',
    );
    return response.data['data']?['count'] ?? response.data['count'] ?? 0;
  }

  Future<void> markAllAsRead() async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationsMarkRead}',
    );
  }

  Future<void> markAsRead(String notificationId) async {
    await _apiClient.post(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationRead(notificationId)}',
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationDetail(notificationId)}',
    );
  }

  Future<void> deleteAllNotifications() async {
    await _apiClient.delete(
      '${ApiEndpoints.baseUrl}${ApiEndpoints.notifications}',
    );
  }
}
