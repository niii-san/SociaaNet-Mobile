import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/api/api_endpoints.dart';

void main() {
  group('ApiEndpoints Unit Tests', () {
    test('should have correct base URL for Android emulator', () {
      // Arrange & Act
      final baseUrl = ApiEndpoints.baseUrl;

      // Assert
      expect(baseUrl, equals('http://10.0.2.2:8000/api/v1'));
    });

    test('should have correct endpoint paths', () {
      // Assert
      expect(ApiEndpoints.userLogin, equals('/auth/login'));
      expect(ApiEndpoints.userSignup, equals('/auth/signup'));
      expect(ApiEndpoints.validateSession, equals('/auth/validate-session'));
      expect(ApiEndpoints.getUserInfo, equals('/users/me'));
      expect(ApiEndpoints.uploadAvatar, equals('/users/me/avatar'));
    });
  });
}
