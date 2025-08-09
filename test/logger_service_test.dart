import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger_service/logger_service.dart';

void main() {
  group('LoggerService', () {
    test('should not be initialized initially', () {
      expect(LoggerService.isInitialized, false);
    });

    test('should initialize with default config', () async {
      final service = await LoggerService.initialize(
        config: const LoggerConfig(
          enableFileOutput: false,
        ), // Disable file output for tests
      );

      expect(LoggerService.isInitialized, true);
      expect(service, isA<LoggerService>());
      expect(service.config, isA<LoggerConfig>());
    });

    test('should return same instance on multiple initialize calls', () async {
      final service1 = await LoggerService.initialize(
        config: const LoggerConfig(
          enableFileOutput: false,
        ), // Disable file output for tests
      );
      final service2 = await LoggerService.initialize(
        config: const LoggerConfig(
          enableFileOutput: false,
        ), // Disable file output for tests
      );

      expect(identical(service1, service2), true);
    });
  });

  group('LoggerConfig', () {
    test('should have default values', () {
      const config = LoggerConfig();

      expect(config.maxFileSize, 10 * 1024 * 1024); // 10MB
      expect(config.logDirectoryName, 'logs');
      expect(config.logFileName, 'app.log');
      expect(config.maxStackTraceLines, 5);
      expect(config.enableConsoleOutput, true);
      expect(config.enableFileOutput, !kIsWeb);
    });

    test('should allow custom configuration', () {
      const config = LoggerConfig(
        maxFileSize: 5 * 1024 * 1024,
        logDirectoryName: 'custom_logs',
        logFileName: 'custom.log',
        maxStackTraceLines: 10,
        enableConsoleOutput: false,
        enableFileOutput: true,
      );

      expect(config.maxFileSize, 5 * 1024 * 1024);
      expect(config.logDirectoryName, 'custom_logs');
      expect(config.logFileName, 'custom.log');
      expect(config.maxStackTraceLines, 10);
      expect(config.enableConsoleOutput, false);
      expect(config.enableFileOutput, true);
    });
  });

  group('LevelFilter', () {
    test('should filter logs based on minimum level', () {
      final filter = LevelFilter(Level.warning);

      expect(filter.shouldLog(LogEvent(Level.error, 'Error')), true);
      expect(filter.shouldLog(LogEvent(Level.warning, 'Warning')), true);
      expect(filter.shouldLog(LogEvent(Level.info, 'Info')), false);
      expect(filter.shouldLog(LogEvent(Level.debug, 'Debug')), false);
    });
  });

  group('PersistentFilter', () {
    test('should always allow logging', () {
      final filter = PersistentFilter();

      expect(filter.shouldLog(LogEvent(Level.error, 'Error')), true);
      expect(filter.shouldLog(LogEvent(Level.debug, 'Debug')), true);
    });
  });

  group('DisabledFilter', () {
    test('should never allow logging', () {
      final filter = DisabledFilter();

      expect(filter.shouldLog(LogEvent(Level.error, 'Error')), false);
      expect(filter.shouldLog(LogEvent(Level.debug, 'Debug')), false);
    });
  });
}
