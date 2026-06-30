import 'package:flutter/foundation.dart';

/// Simple wrapper for debug-only logging.
class AppLogger {
  AppLogger._();

  static void info(String message) {
    if (kDebugMode) debugPrint('[INFO] $message');
  }

  static void warning(String message) {
    if (kDebugMode) debugPrint('[WARN] $message');
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('  error: $error');
      if (stackTrace != null) debugPrint('  trace: $stackTrace');
    }
  }
}
