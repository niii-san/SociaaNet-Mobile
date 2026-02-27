import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('creates with default milliseconds', () {
      final debouncer = Debouncer();
      expect(debouncer.milliseconds, 500);
    });
    test('creates with custom milliseconds', () {
      final debouncer = Debouncer(milliseconds: 300);
      expect(debouncer.milliseconds, 300);
    });
    test('dispose does not throw', () {
      final debouncer = Debouncer();
      expect(() => debouncer.dispose(), returnsNormally);
    });
  });
}
