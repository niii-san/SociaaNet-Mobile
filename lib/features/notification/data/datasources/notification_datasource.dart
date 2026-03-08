import 'package:dio/dio.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

abstract class NotificationRemoteDatasource {
  Future<Map<String, dynamic>> getNotifications({int page, int limit});
  Future<int> getUnreadCount();
  Future<void> markAllAsRead();
  Future<void> markAsRead(String notificationId);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications();
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final ApiClient _apiClient;

  NotificationRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 30}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notifications}',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      throw Exception('Failed to load notifications: ${e.message}');
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationsUnreadCount}',
      );
      final data = response.data['data'] ?? response.data;
      return data['count'] ?? 0;
    } on DioException catch (e) {
      throw Exception('Failed to get unread count: ${e.message}');
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationsMarkRead}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to mark all as read: ${e.message}');
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationRead(notificationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to mark as read: ${e.message}');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notificationDetail(notificationId)}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete notification: ${e.message}');
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    try {
      await _apiClient.delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.notifications}',
      );
    } on DioException catch (e) {
      throw Exception('Failed to delete all notifications: ${e.message}');
    }
  }
}
