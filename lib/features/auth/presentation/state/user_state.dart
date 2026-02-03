import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/user_model.dart';

/// Notifier for managing current user state
class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void setUser(User? user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  void updateUser({
    String? fullName,
    String? username,
    String? bio,
    String? avatarUrl,
  }) {
    if (state != null) {
      state = state!.copyWith(
        fullName: fullName,
        username: username,
        avatarUrl: avatarUrl,
      );
    }
  }
}

/// Provider for current user information (in-memory only)
/// This holds the user data for the current session and is cleared when the app restarts
final currentUserProvider = NotifierProvider<CurrentUserNotifier, User?>(
  CurrentUserNotifier.new,
);

/// Helper provider to check if user is logged in
final isUserLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

