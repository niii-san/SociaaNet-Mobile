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
    if (_isInitialized) {
      print('⚠️  Hive already initialized');
      return;
    }

    print('🔧 Initializing Hive...');
    await Hive.initFlutter();
    await Hive.openBox(HiveBoxes.auth);
    print('✅ Hive initialized successfully');
    print('   Auth box opened: ${Hive.isBoxOpen(HiveBoxes.auth)}');
    _isInitialized = true;
  }


  HiveService() {
    print('🔨 HiveService constructor called');
    print('   Box is open: ${Hive.isBoxOpen(HiveBoxes.auth)}');
    _authBox = Hive.box(HiveBoxes.auth);
    print('   Box retrieved. Length: ${_authBox.length}');
    print('   Keys in box: ${_authBox.keys.toList()}');
  }

  // ==================== Session Management ====================

  /// Save session ID
  Future<void> saveSessionId(String sessionId) async {
    print('💾 HiveService.saveSessionId() called with: $sessionId');
    await _authBox.put(AuthKeys.sessionId, sessionId);
    print('✅ Session saved. Verifying: ${_authBox.get(AuthKeys.sessionId)}');
  }

  /// Get session ID
  String? getSessionId() {
    final sessionId = _authBox.get(AuthKeys.sessionId);
    print('📦 HiveService.getSessionId() returning: ${sessionId ?? "NULL"}');
    print('   All keys in auth_box: ${_authBox.keys.toList()}');
    print('   Auth box length: ${_authBox.length}');
    return sessionId;
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
    print('🗑️  Clearing all auth data from Hive');
    await _authBox.clear();
    print('✅ Auth data cleared. Box length: ${_authBox.length}');
  }

  /// Close all boxes (call when app terminates if needed)
  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}
