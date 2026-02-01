import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/api/api_client.dart';
import 'package:sociaanet/core/services/hive/hive_service.dart';
import 'package:sociaanet/features/auth/data/repositories/auth_repository.dart';
import 'package:sociaanet/features/auth/presentation/state/auth_state.dart';
import 'package:sociaanet/features/auth/presentation/state/user_state.dart';

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

    return await result.fold(
      (failure) async {
        print('❌ LOGIN FAILED: ${failure.message}');
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (response) async {
        print('✅ LOGIN SUCCESS - Full Response:');
        print('   Status Code: ${response.statusCode}');
        print('   Success: ${response.success}');
        print('   Message: ${response.message}');
        print('   Session ID: ${response.data.session_id}');
        print('   Expires At: ${response.data.expires_at}');
        
        // Store session ID in Hive
        print('📝 About to save session: ${response.data.session_id}');
        await _hiveService.saveSessionId(response.data.session_id);
        print('💾 Session ID saved to Hive');
        
        // VERIFY IT WAS SAVED
        final savedSession = _hiveService.getSessionId();
        print('🔍 VERIFICATION - Reading back session: ${savedSession ?? "NULL"}');
        if (savedSession != response.data.session_id) {
          print('⚠️ WARNING: Session mismatch! Expected: ${response.data.session_id}, Got: $savedSession');
        }
        
        await _hiveService.setLoggedIn(true);
        print('💾 Login state saved to Hive');

        // Set auth token in API client
        ApiClient.instance.setAuthToken(response.data.session_id);
        print('🔑 Authorization header set: Bearer ${response.data.session_id}');

        // Fetch user information after successful login
        print('📡 Fetching user info...');
        final userInfoResult = await _repository.getUserInfo();

        return await userInfoResult.fold(
          (failure) async {
            // Failed to fetch user info after login
            print('❌ FETCH USER INFO FAILED: ${failure.message}');
            state = state.copyWith(
              status: AuthStatus.error,
              errorMessage: 'Login successful but failed to fetch user info',
            );
            return false;
          },
          (userInfoResponse) async {
            // Save user info to in-memory state
            print('✅ USER INFO FETCHED:');
            print('   User ID: ${userInfoResponse.user.id}');
            print('   Full Name: ${userInfoResponse.user.fullName}');
            print('   Username: ${userInfoResponse.user.username}');
            print('   Email: ${userInfoResponse.user.emailAddress}');
            print('   Avatar URL: ${userInfoResponse.user.avatarUrl}');
            ref.read(currentUserProvider.notifier).setUser(userInfoResponse.user);
            print('💾 User info saved to state');

            state = state.copyWith(
              status: AuthStatus.success,
              successMessage: response.message,
            );
            return true;
          },
        );
      },
    );
  }

  /// Logout - clear session
  Future<void> logout() async {
    await _hiveService.clearAuthData();
    ApiClient.instance.clearAuthToken();
    ref.read(currentUserProvider.notifier).clearUser();
    state = const AuthState();
  }

  /// Validate session on app start
  /// Returns true if session is valid and user is auto-logged in
  Future<bool> validateSessionAndLogin() async {
    try {
      print('\n🔄 VALIDATING SESSION...');
      // Check if session exists in local storage
      final sessionId = _hiveService.getSessionId();
      print('📦 Retrieved session ID from Hive: ${sessionId ?? "NULL"}');
      if (sessionId == null || sessionId.isEmpty) {
        print('❌ No session found, redirecting to login');
        return false;
      }

      state = state.copyWith(status: AuthStatus.loading);

      // Validate session with backend
      final result = await _repository.validateSession(sessionId: sessionId);

      return await result.fold(
        (failure) async {
          // Session validation failed, clear local data
          print('❌ Session validation failed: ${failure.message}');
          await _hiveService.clearAuthData();
          state = const AuthState();
          return false;
        },
        (response) async {
          print('✅ Session validation succeeded. response.isValid = ${response.isValid}');
          if (response.isValid) {
            // Session is valid, set auth token and fetch user info
            print('🔑 Setting auth token and fetching user info...');
            ApiClient.instance.setAuthToken(sessionId);
            
            // Fetch user information
            final userInfoResult = await _repository.getUserInfo();
            
            return await userInfoResult.fold(
              (failure) async {
                // Failed to fetch user info, clear session
                await _hiveService.clearAuthData();
                ApiClient.instance.clearAuthToken();
                state = const AuthState();
                return false;
              },
              (userInfoResponse) async {
                // Successfully fetched user info, save to in-memory state
                ref.read(currentUserProvider.notifier).setUser(userInfoResponse.user);
                state = state.copyWith(
                  status: AuthStatus.success,
                  successMessage: 'Auto-login successful',
                );
                return true;
              },
            );
          } else {
            // Session is invalid, clear local data
            await _hiveService.clearAuthData();
            state = const AuthState();
            return false;
          }
        },
      );
    } catch (e) {
      // Any error during validation, clear session and return false
      await _hiveService.clearAuthData();
      ApiClient.instance.clearAuthToken();
      state = const AuthState();
      return false;
    }
  }
}
