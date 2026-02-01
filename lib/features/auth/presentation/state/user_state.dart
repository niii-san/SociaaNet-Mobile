import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

/// Notifier for managing current user state
class CurrentUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  void setUser(UserModel? user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

/// Provider for current user information (in-memory only)
/// This holds the user data for the current session and is cleared when the app restarts
final currentUserProvider = NotifierProvider<CurrentUserNotifier, UserModel?>(
  CurrentUserNotifier.new,
);

/// Helper provider to check if user is logged in
final isUserLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

