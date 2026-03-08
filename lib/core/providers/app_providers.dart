import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/services/feed_service.dart';
import 'package:sociaanet/core/services/post_service.dart';
import 'package:sociaanet/core/services/comment_service.dart';
import 'package:sociaanet/core/services/follow_service.dart';
import 'package:sociaanet/core/services/user_service.dart';
import 'package:sociaanet/core/services/notification_service.dart';
import 'package:sociaanet/core/services/settings_service.dart';
import 'package:sociaanet/core/services/chat_service.dart';
import 'package:sociaanet/core/services/activity_service.dart';
import 'package:sociaanet/features/user/data/repositories/user_repository.dart';
// Re-export from user_state so the whole app can import from here
export 'package:sociaanet/features/auth/presentation/state/user_state.dart';

// ==================== Service Providers ====================
final feedServiceProvider = Provider((ref) => FeedService());
final postServiceProvider = Provider((ref) => PostService());
final commentServiceProvider = Provider((ref) => CommentService());
final followServiceProvider = Provider((ref) => FollowService());
final userServiceProvider = Provider((ref) => UserService());
final notificationServiceProvider = Provider((ref) => NotificationService());
final settingsServiceProvider = Provider((ref) => SettingsService());
final chatServiceProvider = Provider((ref) => ChatService());
final activityServiceProvider = Provider((ref) => ActivityService());
final userRepositoryProvider = Provider((ref) => UserRepository());

// ==================== Home Feed Provider ====================
class HomeFeedNotifier extends Notifier<AsyncValue<List<FeedPost>>> {
  int _page = 1;
  bool _hasMore = true;
  int? _caughtUpIndex;

  @override
  AsyncValue<List<FeedPost>> build() {
    return const AsyncValue.loading();
  }

  int? get caughtUpIndex => _caughtUpIndex;
  bool get hasMore => _hasMore;

  Future<void> loadFeed({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final service = ref.read(feedServiceProvider);
      final response = await service.getHomeFeed(page: _page, limit: 10);

      _hasMore = response.hasMore;
      _caughtUpIndex = response.caughtUpAtIndex;

      if (refresh || _page == 1) {
        state = AsyncValue.data(response.posts);
      } else {
        final currentPosts = state.value ?? [];
        state = AsyncValue.data([...currentPosts, ...response.posts]);
      }
      _page++;
    } catch (e, st) {
      if (_page == 1) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    await loadFeed();
  }

  void updatePost(String postId, FeedPost updatedPost) {
    final posts = state.value ?? [];
    final index = posts.indexWhere((p) => p.postId == postId);
    if (index != -1) {
      final newPosts = [...posts];
      newPosts[index] = updatedPost;
      state = AsyncValue.data(newPosts);
    }
  }
}

final homeFeedProvider =
    NotifierProvider<HomeFeedNotifier, AsyncValue<List<FeedPost>>>(
  HomeFeedNotifier.new,
);

// ==================== Explore Provider ====================
class ExploreNotifier extends Notifier<AsyncValue<Map<String, dynamic>>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  AsyncValue<Map<String, dynamic>> build() => const AsyncValue.loading();

  bool get hasMore => _hasMore;

  Future<void> loadExplore({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final service = ref.read(feedServiceProvider);
      final data = await service.getExplore(page: _page, limit: 20);
      _hasMore = data['has_more'] ?? false;

      if (refresh || _page == 1) {
        state = AsyncValue.data(data);
      } else {
        final current = state.value ?? {};
        final currentPosts =
            (current['posts'] as List<ExplorePost>?) ?? [];
        final currentReels =
            (current['reels'] as List<ExploreReel>?) ?? [];
        state = AsyncValue.data({
          'posts': [...currentPosts, ...data['posts']],
          'reels': [...currentReels, ...data['reels']],
          'has_more': _hasMore,
        });
      }
      _page++;
    } catch (e, st) {
      if (_page == 1) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

final exploreProvider =
    NotifierProvider<ExploreNotifier, AsyncValue<Map<String, dynamic>>>(
  ExploreNotifier.new,
);

// ==================== Suggested Users Provider ====================
final suggestedUsersProvider =
    FutureProvider<List<SuggestedUser>>((ref) async {
  final service = ref.read(feedServiceProvider);
  return service.getSuggestedUsers(limit: 10);
});

// ==================== Notifications Provider ====================
class NotificationsNotifier extends Notifier<AsyncValue<List<AppNotification>>> {
  int _page = 1;
  bool _hasMore = true;
  int _unreadCount = 0;

  @override
  AsyncValue<List<AppNotification>> build() => const AsyncValue.loading();

  int get unreadCount => _unreadCount;
  bool get hasMore => _hasMore;

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    try {
      final service = ref.read(notificationServiceProvider);
      final data = await service.getNotifications(page: _page, limit: 20);
      final notifList = data['notifications'] ?? data['items'] ?? [];
      final notifications = (notifList as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();
      _unreadCount = data['unread_count'] ?? await service.getUnreadCount();

      if (refresh || _page == 1) {
        state = AsyncValue.data(notifications);
      } else {
        final current = state.value ?? [];
        state = AsyncValue.data([...current, ...notifications]);
      }
      _hasMore = notifications.length >= 20;
      _page++;
    } catch (e, st) {
      if (_page == 1) state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final service = ref.read(notificationServiceProvider);
      await service.markAllAsRead();
      _unreadCount = 0;
      final notifications =
          state.value?.map((n) => n.copyWith(isRead: true)).toList() ?? [];
      state = AsyncValue.data(notifications);
    } catch (_) {}
  }

  void addNotification(AppNotification notification) {
    final current = state.value ?? [];
    state = AsyncValue.data([notification, ...current]);
    _unreadCount++;
  }

  void setUnreadCount(int count) {
    _unreadCount = count;
  }
}

final notificationsProvider = NotifierProvider<NotificationsNotifier,
    AsyncValue<List<AppNotification>>>(NotificationsNotifier.new);

// ==================== Settings Provider ====================
class SettingsNotifier extends Notifier<AsyncValue<UserSettings>> {
  @override
  AsyncValue<UserSettings> build() => const AsyncValue.loading();

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(settingsServiceProvider);
      final settings = await service.getUserSettings();
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePrivacy(Map<String, dynamic> settings) async {
    try {
      final service = ref.read(settingsServiceProvider);
      await service.updatePrivacySettings(settings);
      await loadSettings();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateNotifications(Map<String, dynamic> settings) async {
    try {
      final service = ref.read(settingsServiceProvider);
      await service.updateNotificationSettings(settings);
      await loadSettings();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateAppearance(Map<String, dynamic> settings) async {
    try {
      final service = ref.read(settingsServiceProvider);
      await service.updateAppearanceSettings(settings);
      await loadSettings();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateFeed(Map<String, dynamic> settings) async {
    try {
      final service = ref.read(settingsServiceProvider);
      await service.updateFeedSettings(settings);
      await loadSettings();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateSecurity(Map<String, dynamic> settings) async {
    try {
      final service = ref.read(settingsServiceProvider);
      await service.updateSecuritySettings(settings);
      await loadSettings();
    } catch (_) {
      rethrow;
    }
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>(
  SettingsNotifier.new,
);

// ==================== Follow State Provider ====================
class FollowStateNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void addRequest(String userId) {
    state = {...state, userId};
  }

  void removeRequest(String userId) {
    state = state.where((id) => id != userId).toSet();
  }

  bool hasRequest(String userId) => state.contains(userId);
}

final outgoingFollowRequestsProvider =
    NotifierProvider<FollowStateNotifier, Set<String>>(
  FollowStateNotifier.new,
);

// ==================== Chat Unread Count Provider ====================
class ChatUnreadNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setCount(int count) => state = count;
  void increment() => state++;
  void decrement() {
    if (state > 0) state--;
  }
}

final chatUnreadProvider = NotifierProvider<ChatUnreadNotifier, int>(
  ChatUnreadNotifier.new,
);

// ==================== Online Users Provider ====================
class OnlineUsersNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void addUser(String userId) => state = {...state, userId};
  void removeUser(String userId) =>
      state = state.where((id) => id != userId).toSet();
  bool isOnline(String userId) => state.contains(userId);
}

final onlineUsersProvider =
    NotifierProvider<OnlineUsersNotifier, Set<String>>(
  OnlineUsersNotifier.new,
);
