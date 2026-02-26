import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    test('timeAgo returns Just now for recent dates', () {
      final now = DateTime.now();
      expect(DateFormatter.timeAgo(now), 'Just now');
    });
    test('timeAgo returns minutes ago', () {
      final fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
      expect(DateFormatter.timeAgo(fiveMinAgo), '5m ago');
    });
    test('timeAgo returns hours ago', () {
      final threeHoursAgo = DateTime.now().subtract(const Duration(hours: 3));
      expect(DateFormatter.timeAgo(threeHoursAgo), '3h ago');
    });
    test('timeAgo returns days ago', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      expect(DateFormatter.timeAgo(twoDaysAgo), '2d ago');
    });
  });
}
