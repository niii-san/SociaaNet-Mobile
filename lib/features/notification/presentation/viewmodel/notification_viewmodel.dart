import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/notification_model.dart';
import 'package:sociaanet/features/notification/data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
  NotificationViewModel.new,
);

class NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

class NotificationViewModel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return const NotificationState();
  }

  NotificationRepository get _repository =>
      ref.read(notificationRepositoryProvider);

  Future<void> loadNotifications({bool refresh = false}) async {
    if (state.isLoading) return;

    final page = refresh ? 1 : state.currentPage;
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getNotifications(page: page);
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (data) {
        final newNotifications = data['notifications'] as List<AppNotification>;
        final pagination = data['pagination'] as Map<String, dynamic>?;
        final totalPages = pagination?['totalPages'] ?? 1;

        state = state.copyWith(
          notifications: refresh ? newNotifications : [...state.notifications, ...newNotifications],
          isLoading: false,
          hasMore: page < totalPages,
          currentPage: page + 1,
        );
      },
    );
  }

  Future<void> loadUnreadCount() async {
    final result = await _repository.getUnreadCount();
    result.fold(
      (_) {},
      (count) => state = state.copyWith(unreadCount: count),
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();
    result.fold(
      (_) {},
      (_) {
        state = state.copyWith(
          unreadCount: 0,
          notifications: state.notifications
              .map((n) => n.copyWith(isRead: true))
              .toList(),
        );
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _repository.markAsRead(notificationId);
    result.fold(
      (_) {},
      (_) {
        state = state.copyWith(
          unreadCount: (state.unreadCount - 1).clamp(0, state.unreadCount),
          notifications: state.notifications
              .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
              .toList(),
        );
      },
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    final result = await _repository.deleteNotification(notificationId);
    result.fold(
      (_) {},
      (_) {
        final notification = state.notifications.firstWhere((n) => n.id == notificationId);
        state = state.copyWith(
          notifications: state.notifications.where((n) => n.id != notificationId).toList(),
          unreadCount: notification.isRead ? state.unreadCount : (state.unreadCount - 1).clamp(0, state.unreadCount),
        );
      },
    );
  }

  Future<void> deleteAllNotifications() async {
    final result = await _repository.deleteAllNotifications();
    result.fold(
      (_) {},
      (_) {
        state = state.copyWith(
          notifications: [],
          unreadCount: 0,
        );
      },
    );
  }
}
