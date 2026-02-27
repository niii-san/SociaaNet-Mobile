import 'package:flutter_test/flutter_test.dart';
import 'package:sociaanet/core/utils/logger.dart';

void main() {
  group('AppLogger', () {
    test('info does not throw', () {
      expect(() => AppLogger.info('test message'), returnsNormally);
    });
    test('error does not throw', () {
      expect(() => AppLogger.error('test error'), returnsNormally);
    });
    test('debug does not throw', () {
      expect(() => AppLogger.debug('debug message'), returnsNormally);
    });
    test('warning does not throw', () {
      expect(() => AppLogger.warning('warning message'), returnsNormally);
    });
    test('network does not throw', () {
      expect(() => AppLogger.network('GET', '/api/test', 200), returnsNormally);
    });
  });
}
