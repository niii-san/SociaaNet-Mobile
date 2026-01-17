import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Keys for Hive boxes
class HiveBoxes {
  HiveBoxes._();
  static const String auth = 'auth_box';
}

/// Keys for auth box
class AuthKeys {
  AuthKeys._();
  static const String sessionId = 'session_id';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';
}

/// Provider for HiveService
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

/// Service class for managing Hive local storage
class HiveService {
  static bool _isInitialized = false;
  late Box<dynamic> _authBox;

  /// Initialize Hive - call this in main() before runApp()
  static Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();
    await Hive.openBox(HiveBoxes.auth);
    _isInitialized = true;
  }

  HiveService() {
    _authBox = Hive.box(HiveBoxes.auth);
  }

  // ==================== Session Management ====================

  /// Save session ID
  Future<void> saveSessionId(String sessionId) async {
    await _authBox.put(AuthKeys.sessionId, sessionId);
  }

  /// Get session ID
  String? getSessionId() {
    return _authBox.get(AuthKeys.sessionId);
  }

  /// Check if session exists
  bool hasSession() {
    return _authBox.containsKey(AuthKeys.sessionId) &&
        _authBox.get(AuthKeys.sessionId) != null;
  }

  /// Delete session ID
  Future<void> deleteSessionId() async {
    await _authBox.delete(AuthKeys.sessionId);
  }

  // ==================== User ID Management ====================

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _authBox.put(AuthKeys.userId, userId);
  }

  /// Get user ID
  String? getUserId() {
    return _authBox.get(AuthKeys.userId);
  }

  /// Delete user ID
  Future<void> deleteUserId() async {
    await _authBox.delete(AuthKeys.userId);
  }

  // ==================== Login State ====================

  /// Set logged in state
  Future<void> setLoggedIn(bool value) async {
    await _authBox.put(AuthKeys.isLoggedIn, value);
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _authBox.get(AuthKeys.isLoggedIn, defaultValue: false) ?? false;
  }

  // ==================== Clear All Auth Data ====================

  /// Clear all auth data (for logout)
  Future<void> clearAuthData() async {
    await _authBox.clear();
  }

  /// Close all boxes (call when app terminates if needed)
  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}
