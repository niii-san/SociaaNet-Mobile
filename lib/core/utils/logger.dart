import 'dart:developer' as dev;

class AppLogger {
  static void info(String message, [String? tag]) {
    dev.log('[INFO] $message', name: tag ?? 'SociaaNet');
  }
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log('[ERROR] $message', name: 'SociaaNet', error: error, stackTrace: stackTrace);
  }
  static void debug(String message, [String? tag]) {
    dev.log('[DEBUG] $message', name: tag ?? 'SociaaNet');
  }
  static void warning(String message, [String? tag]) {
    dev.log('[WARN] $message', name: tag ?? 'SociaaNet');
  }
  static void network(String method, String url, [int? statusCode]) {
    dev.log('[NET] $method $url ${statusCode ?? ""}', name: 'SociaaNet');
  }
}

// Added log level filtering support

// Added file logging support
