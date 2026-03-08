import 'package:dartz/dartz.dart';
import 'package:sociaanet/core/errors/failures.dart';
import 'package:sociaanet/core/models/notification_model.dart';
import 'package:sociaanet/features/notification/data/datasources/notification_datasource.dart';

class NotificationRepository {
  final NotificationRemoteDatasource _datasource;

  NotificationRepository({NotificationRemoteDatasource? datasource})
      : _datasource = datasource ?? NotificationRemoteDatasourceImpl();

  Future<Either<Failure, Map<String, dynamic>>> getNotifications({int page = 1, int limit = 30}) async {
    try {
      final result = await _datasource.getNotifications(page: page, limit: limit);
      final notifications = (result['notifications'] as List?)
              ?.map((n) => AppNotification.fromJson(n as Map<String, dynamic>))
              .toList() ??
          [];
      return Right({
        'notifications': notifications,
        'pagination': result['pagination'],
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _datasource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _datasource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _datasource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await _datasource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteAllNotifications() async {
    try {
      await _datasource.deleteAllNotifications();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
