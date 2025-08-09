import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'logger_config.dart';
import 'logger_filters.dart';
import 'logger_output.dart';

/// Singleton service for centralized logging throughout the application
class LoggerService {
  LoggerService._();
  static LoggerService? _instance;

  /// Initialize the logger service with optional configuration
  static Future<LoggerService> initialize({
    LoggerConfig config = const LoggerConfig(),
  }) async {
    if (_instance != null) return _instance!;

    final service = LoggerService._();
    await service._initialize(config);
    _instance = service;
    return service;
  }

  /// Check if the logger service has been initialized
  static bool get isInitialized => _instance != null;

  /// Get the singleton instance of the logger service
  static LoggerService get instance {
    if (_instance == null) {
      throw StateError(
        'LoggerService is not initialized. Call LoggerService.initialize() first.',
      );
    }
    return _instance!;
  }

  late final LoggerConfig _config;

  /// Get the current configuration
  LoggerConfig get config => _config;

  Logger? _logger;

  /// Get the logger instance for logging messages
  static Logger get logger {
    if (_instance == null) {
      throw StateError(
        'LoggerService is not initialized. Call LoggerService.initialize() first.',
      );
    }
    return _instance!._logger!;
  }

  /// Initialize the logger with the provided configuration
  Future<void> _initialize(LoggerConfig config) async {
    _config = config;

    LogOutput output;

    if (config.enableFileOutput) {
      output = ConsoleAndFileOutput(config);
      await output.init();
    } else {
      output = ConsoleOutput();
    }

    _logger = Logger(
      filter: LevelFilter(config.minLogLevel),
      printer: kDebugMode
          ? PrettyPrinter(
              dateTimeFormat: _dateWithTimeAndElapsed(),
              methodCount: 6,
            )
          : SimplePrinter(printTime: true, colors: false),
      output: output,
    );
  }

  /// Create a date formatter that includes both date/time and elapsed time
  DateTimeFormatter _dateWithTimeAndElapsed() {
    return (DateTime time) =>
        '${DateTimeFormat.onlyDate(time)} '
        '${DateTimeFormat.onlyTimeAndSinceStart(time)}';
  }
}
