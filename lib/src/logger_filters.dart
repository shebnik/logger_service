import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Filter that allows logs based on a minimum level
class LevelFilter extends LogFilter {
  /// Creates a level filter with the specified minimum level
  LevelFilter(this.minLevel);

  /// The minimum level required for a log to pass the filter
  final Level minLevel;

  @override
  bool shouldLog(LogEvent event) {
    // Disable logging on web in release mode for performance
    if (kIsWeb && kReleaseMode) return false;
    return event.level.value >= minLevel.value;
  }
}

/// Filter that allows all logs to pass through
class PersistentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

/// Filter that blocks all logs from passing through
class DisabledFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
