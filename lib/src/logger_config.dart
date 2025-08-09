import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Configuration class for the LoggerService
@immutable
class LoggerConfig {
  /// Creates a logger configuration with the specified settings
  const LoggerConfig({
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.directory,
    this.logDirectoryName = 'logs',
    this.logFileName = 'app.log',
    this.maxStackTraceLines = 5,
    this.enableConsoleOutput = true,
    this.enableFileOutput = !kIsWeb,
    this.minLogLevel = kDebugMode ? Level.debug : Level.info,
  });

  /// Maximum size of log file before rotation (in bytes)
  final int maxFileSize;

  /// Custom directory for log files (if null, uses documents directory)
  final Directory? directory;

  /// Name of the directory where log files are stored
  final String logDirectoryName;

  /// Name of the log file
  final String logFileName;

  /// Maximum number of stack trace lines to include in logs
  final int maxStackTraceLines;

  /// Whether to enable console output
  final bool enableConsoleOutput;

  /// Whether to enable file output
  final bool enableFileOutput;

  /// Minimum log level to output
  final Level minLogLevel;
}
