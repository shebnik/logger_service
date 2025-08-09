import 'package:logger_service/logger_service.dart';

/// Simple example showing basic usage of LoggerService
void main() async {
  // Initialize the logger service with default configuration
  await LoggerService.initialize();

  // Basic logging examples
  LoggerService.logger.d('Debug message - detailed diagnostic information');
  LoggerService.logger.i('Info message - general information');
  LoggerService.logger.w('Warning message - something unexpected happened');
  LoggerService.logger.e('Error message - serious problem occurred');

  // Logging with additional data
  final userData = {'userId': 123, 'username': 'john_doe'};
  LoggerService.logger.i('User logged in: $userData');

  // Error logging with stack trace
  try {
    throw Exception('Sample exception for demonstration');
  } catch (error, stackTrace) {
    LoggerService.logger.e(
      'An error occurred during operation',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Custom configuration example
  await LoggerService.initialize(
    config: LoggerConfig(
      maxFileSize: 1024 * 1024, // 1MB
      logDirectoryName: 'my_app_logs',
      logFileName: 'debug.log',
      enableFileOutput: true,
      enableConsoleOutput: true,
      minLogLevel: Level.info, // Only log info and above
    ),
  );

  LoggerService.logger.i('Logger reconfigured with custom settings');
  LoggerService.logger.d(
    'This debug message will not be logged due to minLogLevel setting',
  );
}
