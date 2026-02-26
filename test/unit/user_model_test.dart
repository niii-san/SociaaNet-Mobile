import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/features/auth/data/model/auth_api_model.dart';

void main() {
  group('UserModel Unit Tests', () {
    test('should create UserModel from JSON correctly', () {
      // Arrange
      final json = {
        '_id': 'user123',
        'full_name': 'John Doe',
        'username': 'johndoe',
        'email_address': 'john@example.com',
        'avatar_url': 'avatar_key_123',
        'created_at': '2024-01-01T00:00:00Z',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, equals('user123'));
      expect(user.fullName, equals('John Doe'));
      expect(user.username, equals('johndoe'));
      expect(user.emailAddress, equals('john@example.com'));
      expect(user.avatarUrl, equals('avatar_key_123'));
      expect(user.createdAt, equals('2024-01-01T00:00:00Z'));
    });

    test('should create UserModel with null avatar_url', () {
      // Arrange
      final json = {
        '_id': 'user123',
        'full_name': 'Jane Doe',
        'username': 'janedoe',
        'email_address': 'jane@example.com',
        'created_at': '2024-01-01T00:00:00Z',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.avatarUrl, isNull);
      expect(user.fullName, equals('Jane Doe'));
    });

    test('should convert UserModel to JSON correctly', () {
      // Arrange
      final user = UserModel(
        id: 'user456',
        fullName: 'Alice Smith',
        username: 'alicesmith',
        emailAddress: 'alice@example.com',
        avatarUrl: 'avatar_key_456',
        createdAt: '2024-02-01T00:00:00Z',
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['_id'], equals('user456'));
      expect(json['full_name'], equals('Alice Smith'));
      expect(json['username'], equals('alicesmith'));
      expect(json['email_address'], equals('alice@example.com'));
      expect(json['avatar_url'], equals('avatar_key_456'));
      expect(json['created_at'], equals('2024-02-01T00:00:00Z'));
    });

    test('should handle empty strings in UserModel', () {
      // Arrange
      final json = {
        '_id': '',
        'full_name': '',
        'username': '',
        'email_address': '',
        'created_at': '',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, equals(''));
      expect(user.fullName, equals(''));
      expect(user.username, equals(''));
      expect(user.emailAddress, equals(''));
      expect(user.createdAt, equals(''));
    });

    test('should return full avatar URL with base URL prepended', () {
      // Arrange
      final user = UserModel(
        id: 'user123',
        fullName: 'John Doe',
        username: 'johndoe',
        emailAddress: 'john@example.com',
        avatarUrl: '/api/v1/files/images/avatar_key_123',
        createdAt: '2024-01-01T00:00:00Z',
      );

      // Act
      final fullUrl = user.fullAvatarUrl;

      // Assert
      expect(fullUrl, equals('https://sociaanet-backend-production.up.railway.app/api/v1/files/images/avatar_key_123'));
    });

    test('should return avatar URL as-is if already a full URL', () {
      // Arrange
      final user = UserModel(
        id: 'user123',
        fullName: 'John Doe',
        username: 'johndoe',
        emailAddress: 'john@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: '2024-01-01T00:00:00Z',
      );

      // Act
      final fullUrl = user.fullAvatarUrl;

      // Assert
      expect(fullUrl, equals('https://example.com/avatar.jpg'));
    });

    test('should return null for fullAvatarUrl when avatarUrl is null', () {
      // Arrange
      final user = UserModel(
        id: 'user123',
        fullName: 'John Doe',
        username: 'johndoe',
        emailAddress: 'john@example.com',
        avatarUrl: null,
        createdAt: '2024-01-01T00:00:00Z',
      );

      // Act
      final fullUrl = user.fullAvatarUrl;

      // Assert
      expect(fullUrl, isNull);
    });

    test('should return null for fullAvatarUrl when avatarUrl is empty', () {
      // Arrange
      final user = UserModel(
        id: 'user123',
        fullName: 'John Doe',
        username: 'johndoe',
        emailAddress: 'john@example.com',
        avatarUrl: '',
        createdAt: '2024-01-01T00:00:00Z',
      );

      // Act
      final fullUrl = user.fullAvatarUrl;

      // Assert
      expect(fullUrl, isNull);
    });

    test('should replace localhost with 10.0.2.2 for Android emulator', () {
      // Arrange
      final user = UserModel(
        id: 'user123',
        fullName: 'John Doe',
        username: 'johndoe',
        emailAddress: 'john@example.com',
        avatarUrl: 'http://localhost:8000/api/v1/files/images/avatar.jpg',
        createdAt: '2024-01-01T00:00:00Z',
      );

      // Act
      final fullUrl = user.fullAvatarUrl;

      // Assert
      expect(fullUrl, equals('http://10.0.2.2:8000/api/v1/files/images/avatar.jpg'));
    });

    test('should create UserModel with default empty strings for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, equals(''));
      expect(user.fullName, equals(''));
      expect(user.username, equals(''));
      expect(user.emailAddress, equals(''));
      expect(user.createdAt, equals(''));
      expect(user.avatarUrl, isNull);
    });
  });

  group('GetUserInfoResponseModel Unit Tests', () {
    test('should create GetUserInfoResponseModel from JSON correctly', () {
      // Arrange
      final json = {
        'status_code': 200,
        'success': true,
        'message': 'User fetched successfully',
        'data': {
          '_id': 'user789',
          'full_name': 'Bob Johnson',
          'username': 'bobjohnson',
          'email_address': 'bob@example.com',
          'avatar_url': 'avatar_key_789',
          'created_at': '2024-03-01T00:00:00Z',
        },
      };

      // Act
      final response = GetUserInfoResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.success, isTrue);
      expect(response.message, equals('User fetched successfully'));
      expect(response.user.userId, equals('user789'));
      expect(response.user.fullName, equals('Bob Johnson'));
      expect(response.user.avatarUrl, equals('avatar_key_789'));
    });

    test('should use default values when fields are missing', () {
      // Arrange
      final json = {
        'data': {
          '_id': 'user999',
          'full_name': 'Test User',
          'username': 'testuser',
          'email_address': 'test@example.com',
          'created_at': '2024-04-01T00:00:00Z',
        },
      };

      // Act
      final response = GetUserInfoResponseModel.fromJson(json);

      // Assert
      expect(response.statusCode, equals(200));
      expect(response.success, isFalse);
      expect(response.message, equals('User fetched successfully'));
      expect(response.user.userId, equals('user999'));
    });
  });
}
