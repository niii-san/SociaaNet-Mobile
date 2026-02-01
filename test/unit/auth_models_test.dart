import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

void main() {
  group('SignupRequestModel Unit Tests', () {
    test('should convert SignupRequestModel to JSON correctly', () {
      // Arrange
      final model = SignupRequestModel(
        fullName: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['full_name'], equals('John Doe'));
      expect(json['email_address'], equals('john@example.com'));
      expect(json['password'], equals('password123'));
    });

    test('should handle special characters in signup data', () {
      // Arrange
      final model = SignupRequestModel(
        fullName: 'José García',
        email: 'jose.garcia@email.com',
        password: 'P@ssw0rd!',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['full_name'], equals('José García'));
      expect(json['email_address'], equals('jose.garcia@email.com'));
      expect(json['password'], equals('P@ssw0rd!'));
    });
  });

  group('LoginRequestModel Unit Tests', () {
    test('should convert LoginRequestModel to JSON correctly', () {
      // Arrange
      final model = LoginRequestModel(
        email: 'jane@example.com',
        password: 'securePassword',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['email_address'], equals('jane@example.com'));
      expect(json['password'], equals('securePassword'));
      expect(json.length, equals(2));
    });

    test('should handle empty credentials', () {
      // Arrange
      final model = LoginRequestModel(
        email: '',
        password: '',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['email_address'], equals(''));
      expect(json['password'], equals(''));
    });
  });

  group('LoginResponseModel Unit Tests', () {
    test('should create LoginResponseModel from JSON correctly', () {
      // Arrange
      final json = {
        'status_code': 200,
        'success': true,
        'message': 'Login successful',
        'data': {
          'session_id': 'session_abc123',
          'expires_at': '2024-12-31T23:59:59Z',
        },
      };

      // Act
      final response = LoginResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.success, isTrue);
      expect(response.message, equals('Login successful'));
      expect(response.data.session_id, equals('session_abc123'));
      expect(response.data.expires_at, equals('2024-12-31T23:59:59Z'));
    });

    test('should use default values for missing fields', () {
      // Arrange
      final json = {
        'data': {
          'session_id': 'session_xyz789',
          'expires_at': '2024-06-30T12:00:00Z',
        },
      };

      // Act
      final response = LoginResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.success, isFalse);
      expect(response.message, equals('Login successful'));
      expect(response.data.session_id, equals('session_xyz789'));
    });

    test('should handle null data gracefully', () {
      // Arrange
      final json = {
        'status_code': 400,
        'success': false,
        'message': 'Login failed',
      };

      // Act
      final response = LoginResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(400));
      expect(response.success, isFalse);
      expect(response.data.session_id, equals(''));
      expect(response.data.expires_at, equals(''));
    });
  });

  group('SignupResponseModel Unit Tests', () {
    test('should create SignupResponseModel from JSON correctly', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Account created successfully',
        'userId': 'user123',
      };

      // Act
      final response = SignupResponseModel.fromJson(json);

      // Assert
      expect(response.success, isTrue);
      expect(response.message, equals('Account created successfully'));
      expect(response.userId, equals('user123'));
    });

    test('should handle user_id field name variation', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Signup complete',
        'user_id': 'user456',
      };

      // Act
      final response = SignupResponseModel.fromJson(json);

      // Assert
      expect(response.userId, equals('user456'));
    });

    test('should use default values when fields are missing', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final response = SignupResponseModel.fromJson(json);

      // Assert
      expect(response.success, isTrue);
      expect(response.message, equals('Account created successfully'));
      expect(response.userId, isNull);
    });
  });

  group('ValidateSessionResponseModel Unit Tests', () {
    test('should create ValidateSessionResponseModel from JSON', () {
      // Arrange
      final json = {
        'status_code': 200,
        'success': true,
        'message': 'Session is valid',
        'data': {
          'is_valid': true,
        },
      };

      // Act
      final response = ValidateSessionResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.success, isTrue);
      expect(response.message, equals('Session is valid'));
      expect(response.isValid, isTrue);
    });

    test('should handle invalid session', () {
      // Arrange
      final json = {
        'status_code': 401,
        'success': false,
        'message': 'Session expired',
        'data': {
          'is_valid': false,
        },
      };

      // Act
      final response = ValidateSessionResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(401));
      expect(response.isValid, isFalse);
    });

    test('should use default values when data is null', () {
      // Arrange
      final json = {
        'status_code': 500,
        'message': 'Server error',
      };

      // Act
      final response = ValidateSessionResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(500));
      expect(response.success, isFalse);
      expect(response.isValid, isFalse);
    });
  });
}
