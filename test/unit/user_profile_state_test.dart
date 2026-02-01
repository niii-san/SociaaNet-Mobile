import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/features/user/presentation/viewmodel/user_profile_viewmodel.dart';

void main() {
  group('UserProfileState Unit Tests', () {
    test('should create UserProfileState with initial status', () {
      // Arrange & Act
      final state = UserProfileState(status: UserProfileStatus.initial);

      // Assert
      expect(state.status, equals(UserProfileStatus.initial));
      expect(state.errorMessage, isNull);
    });

    test('should create UserProfileState with error status and message', () {
      // Arrange & Act
      final state = UserProfileState(
        status: UserProfileStatus.error,
        errorMessage: 'Network error',
      );

      // Assert
      expect(state.status, equals(UserProfileStatus.error));
      expect(state.errorMessage, equals('Network error'));
    });

    test('should copy UserProfileState with new status', () {
      // Arrange
      final originalState = UserProfileState(status: UserProfileStatus.initial);

      // Act
      final newState = originalState.copyWith(status: UserProfileStatus.loading);

      // Assert
      expect(newState.status, equals(UserProfileStatus.loading));
      expect(newState.errorMessage, isNull);
      expect(originalState.status, equals(UserProfileStatus.initial));
    });

    test('should copy UserProfileState with error message', () {
      // Arrange
      final originalState = UserProfileState(status: UserProfileStatus.loading);

      // Act
      final newState = originalState.copyWith(
        status: UserProfileStatus.error,
        errorMessage: 'Upload failed',
      );

      // Assert
      expect(newState.status, equals(UserProfileStatus.error));
      expect(newState.errorMessage, equals('Upload failed'));
    });

    test('should preserve original values when copyWith without parameters', () {
      // Arrange
      final originalState = UserProfileState(
        status: UserProfileStatus.success,
        errorMessage: 'Previous error',
      );

      // Act
      final newState = originalState.copyWith();

      // Assert
      expect(newState.status, equals(UserProfileStatus.success));
      expect(newState.errorMessage, equals('Previous error'));
    });
  });

  group('UserProfileStatus Enum Tests', () {
    test('should have all expected status values', () {
      // Assert
      expect(UserProfileStatus.values.length, equals(4));
      expect(UserProfileStatus.values, contains(UserProfileStatus.initial));
      expect(UserProfileStatus.values, contains(UserProfileStatus.loading));
      expect(UserProfileStatus.values, contains(UserProfileStatus.success));
      expect(UserProfileStatus.values, contains(UserProfileStatus.error));
    });

    test('should be able to compare status values', () {
      // Arrange
      const status1 = UserProfileStatus.loading;
      const status2 = UserProfileStatus.loading;
      const status3 = UserProfileStatus.error;

      // Assert
      expect(status1 == status2, isTrue);
      expect(status1 == status3, isFalse);
    });
  });
}
