import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/services/hive/hive_service.dart';
import 'package:sociaanet/features/auth/data/repositories/auth_repository.dart';
import 'package:sociaanet/features/auth/presentation/state/auth_state.dart';

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider for AuthViewModel
final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);
  HiveService get _hiveService => ref.read(hiveServiceProvider);

  /// Reset state to initial
  void resetState() {
    state = const AuthState();
  }

  /// Signup with email and password
  Future<bool> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.signup(
      fullName: fullName,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (response) {
        state = state.copyWith(
          status: AuthStatus.success,
          successMessage: response.message,
        );
        return true;
      },
    );
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.login(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (response) async {
        // Store session ID in Hive
        await _hiveService.saveSessionId(response.sessionId);
        await _hiveService.setLoggedIn(true);

        state = state.copyWith(
          status: AuthStatus.success,
          successMessage: response.message,
        );
        return true;
      },
    );
  }

  /// Logout - clear session
  Future<void> logout() async {
    await _hiveService.clearAuthData();
    state = const AuthState();
  }
}
