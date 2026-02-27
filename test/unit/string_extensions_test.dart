import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/utils/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize works correctly', () {
      expect('hello'.capitalize, 'Hello');
      expect(''.capitalize, '');
    });
    test('capitalizeWords works correctly', () {
      expect('hello world'.capitalizeWords, 'Hello World');
    });
    test('truncate works correctly', () {
      expect('hello world'.truncate(5), 'hello...');
      expect('hi'.truncate(5), 'hi');
    });
    test('isValidEmail returns correct result', () {
      expect('test@example.com'.isValidEmail, true);
      expect('notanemail'.isValidEmail, false);
    });
    test('initials works correctly', () {
      expect('John Doe'.initials, 'JD');
      expect('Alice'.initials, 'A');
    });
  });
}
