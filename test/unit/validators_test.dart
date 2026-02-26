import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), 'Email is required');
        expect(Validators.validateEmail(null), 'Email is required');
      });
      test('returns error for invalid email', () {
        expect(Validators.validateEmail('notanemail'), 'Enter a valid email');
        expect(Validators.validateEmail('missing@'), 'Enter a valid email');
      });
      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co'), isNull);
      });
    });
    group('validatePassword', () {
      test('returns error for empty password', () {
        expect(Validators.validatePassword(''), 'Password is required');
      });
      test('returns error for short password', () {
        expect(Validators.validatePassword('abc'), 'Password must be at least 8 characters');
      });
      test('returns null for valid password', () {
        expect(Validators.validatePassword('password123'), isNull);
      });
    });
    group('validateUsername', () {
      test('returns error for empty username', () {
        expect(Validators.validateUsername(''), 'Username is required');
      });
      test('returns error for short username', () {
        expect(Validators.validateUsername('ab'), 'Username must be at least 3 characters');
      });
      test('returns null for valid username', () {
        expect(Validators.validateUsername('john_doe'), isNull);
      });
    });
  });
}
