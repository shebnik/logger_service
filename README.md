# Logger Service

A comprehensive logging service for Flutter applications with file output, console output, Firebase Crashlytics integration, and bug reporting functionality.

## Features

- 📝 **File Logging**: Automatic log rotation and persistent storage
- 🖥️ **Console Output**: Debug-friendly console logging with pretty printing
- 🔥 **Firebase Crashlytics**: Automatic crash reporting integration
- 🐛 **Bug Report Service**: Easy bug reporting with log file attachments
- 🎛️ **Configurable**: Customizable log levels, file sizes, and output formats
- 🌐 **Web Support**: Automatically disables file logging on web platforms
- 🎯 **Level Filtering**: Filter logs by minimum level (debug, info, warning, error)
- 🔄 **Log Rotation**: Automatic log file rotation when size limits are exceeded
- 📧 **Email Integration**: Seamless email client integration for bug reports
- 📱 **Cross-Platform**: Works on Android, iOS, Web, and Desktop

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  logger_service: ^0.0.1
```

For Firebase Crashlytics integration, ensure you have Firebase configured in your project and add:

```yaml
dependencies:
  firebase_crashlytics: ^4.1.3
```

## Usage

### Basic Setup

```dart
import 'package:logger_service/logger_service.dart';

void main() async {
  // Initialize the logger service
  await LoggerService.initialize();
  
  // Use the logger
  LoggerService.logger.i('Application started');
  LoggerService.logger.d('Debug information');
  LoggerService.logger.w('Warning message');
  LoggerService.logger.e('Error occurred');
}
```

### Advanced Configuration

```dart
await LoggerService.initialize(
  config: LoggerConfig(
    maxFileSize: 5 * 1024 * 1024, // 5MB
    logDirectoryName: 'my_app_logs',
    logFileName: 'app.log',
    enableFileOutput: true,
    enableConsoleOutput: true,
    minLogLevel: Level.info,
  ),
);
```

### Available Log Levels

```dart
LoggerService.logger.d('Debug message');    // Level.debug
LoggerService.logger.i('Info message');     // Level.info
LoggerService.logger.w('Warning message');  // Level.warning
LoggerService.logger.e('Error message');    // Level.error
```

### Bug Report Service

The package includes a comprehensive bug reporting service that automatically attaches log files:

```dart
final bugReportService = BugReportService();

final result = await bugReportService.reportBug(
  additionalInfo: 'User description of the bug',
  supportEmail: 'support@yourapp.com',
);

switch (result) {
  case BugReportResult.success:
    // Bug report sent successfully
    break;
  case BugReportResult.logFileNotFound:
    // No log file found
    break;
  case BugReportResult.unknownError:
    // Handle error
    break;
}
```

The bug report service:
- 📎 Automatically attaches log files
- 📱 Gathers system information (OS, version, locale)
- 📧 Opens share dialog with email content
- 📋 Copies support email to clipboard
- 🌐 Handles web platform gracefully

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `maxFileSize` | Maximum log file size before rotation | 10MB |
| `directory` | Custom directory for log files | Documents directory |
| `logDirectoryName` | Name of the log directory | 'logs' |
| `logFileName` | Name of the log file | 'app.log' |
| `enableConsoleOutput` | Enable console logging | true |
| `enableFileOutput` | Enable file logging | true (false on web) |
| `minLogLevel` | Minimum log level to output | Level.debug (debug), Level.info (release) |

### Custom Filters

The package includes several filter types:

```dart
// Allow all logs
final persistentFilter = PersistentFilter();

// Disable all logs
final disabledFilter = DisabledFilter();

// Filter by minimum level
final levelFilter = LevelFilter(Level.warning);
```

## Library Structure

The package follows a clean architecture with all implementation details in the `src` directory:

```
lib/
├── logger_service.dart          # Main export file
└── src/
    ├── logger_service.dart      # Core logging service
    ├── logger_config.dart       # Configuration classes
    ├── logger_filters.dart      # Log filtering logic
    ├── logger_output.dart       # Output handling
    └── bug_report_service.dart  # Bug reporting functionality
```

This structure provides:
- **Clean Public API**: Only essential classes are exported
- **Modular Design**: Each component has a specific responsibility
- **Maintainability**: Easy to extend and modify individual components

## Log File Management

- Logs are automatically rotated when they exceed the configured size
- Old log files are renamed with `.old` extension
- Only one backup file is kept to prevent excessive storage usage
- Log files are stored in the application's documents directory by default

## Firebase Crashlytics Integration

When running in release mode (and not on web), all log messages are automatically sent to Firebase Crashlytics for crash reporting and analysis.

## Platform Support

- ✅ **Android**: Full support with file logging
- ✅ **iOS**: Full support with file logging  
- ✅ **Web**: Console logging only (file logging disabled)
- ✅ **Desktop**: Full support with file logging

## Additional Information

This package is built on top of the excellent [logger](https://pub.dev/packages/logger) package and provides a convenient wrapper with additional features for production Flutter applications.

For issues and feature requests, please visit the [GitHub repository](https://github.com/your-username/logger_service).
