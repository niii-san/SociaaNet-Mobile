import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/features/auth/presentation/state/user_state.dart';
import 'package:sociaanet/features/user/data/repositories/user_repository.dart';

/// State for user profile operations
enum UserProfileStatus {
  initial,
  loading,
  success,
  error,
}

class UserProfileState {
  final UserProfileStatus status;
  final String? errorMessage;

  UserProfileState({
    required this.status,
    this.errorMessage,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    String? errorMessage,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier for user profile operations
class UserProfileNotifier extends Notifier<UserProfileState> {
  final UserRepository _repository = UserRepository();

  @override
  UserProfileState build() {
    return UserProfileState(status: UserProfileStatus.initial);
  }

  /// Upload profile avatar
  Future<void> uploadAvatar(File imageFile) async {
    state = state.copyWith(status: UserProfileStatus.loading);

    try {
      final updatedUser = await _repository.uploadAvatar(imageFile);
      
      // Update the current user in the global state
      ref.read(currentUserProvider.notifier).setUser(updatedUser);
      
      state = state.copyWith(status: UserProfileStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: UserProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch user information
  Future<void> fetchUserInfo() async {
    state = state.copyWith(status: UserProfileStatus.loading);

    try {
      final user = await _repository.getUserInfo();
      
      // Update the current user in the global state
      ref.read(currentUserProvider.notifier).setUser(user);
      
      state = state.copyWith(status: UserProfileStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: UserProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Reset state
  void resetState() {
    state = UserProfileState(status: UserProfileStatus.initial);
  }
}

/// Provider for user profile operations
final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(
  UserProfileNotifier.new,
);
