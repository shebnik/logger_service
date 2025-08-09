# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2025-08-09

### Added
- Initial release of LoggerService
- **Modular Architecture**: Clean separation of concerns with organized `src` structure
- Comprehensive logging service with singleton pattern
- File output with automatic log rotation
- Console output with pretty printing in debug mode
- Firebase Crashlytics integration for release builds
- **BugReportService**: Complete bug reporting functionality
- **Email Integration**: Automatic email client integration for bug reports
- **System Information**: Automatic gathering of device and platform info
- **Log File Attachment**: Seamless attachment of log files to bug reports
- **Cross-Platform Support**: Bug reporting works on all platforms including web
- Configurable log levels and filtering
- Support for multiple platforms (Android, iOS, Web, Desktop)
- Custom log filters (LevelFilter, PersistentFilter, DisabledFilter)
- Automatic directory creation for log files
- Safe Firebase initialization with fallback handling
- Comprehensive test suite
- Example applications demonstrating usage
- Full documentation and README

### Features
- **LoggerService**: Singleton service for centralized logging
- **LoggerConfig**: Configurable settings for log behavior  
- **LoggerFilters**: Multiple filter types for log level control
- **LoggerOutput**: Flexible output handling (console, file, Firebase)
- **BugReportService**: Comprehensive bug reporting with log attachments
- **Clean Architecture**: Modular design with clear separation of concerns
- **Log Rotation**: Automatic file rotation when size limits exceeded
- **Platform Support**: Works on all Flutter-supported platforms
- **Email Integration**: Built-in support for email client launching
- **System Info Collection**: Automatic device and platform information gathering
- **Firebase Integration**: Optional Crashlytics logging in release mode
- **Flexible Configuration**: Customizable file sizes, directories, and log levels

### Dependencies
- `logger: ^2.6.1` - Core logging functionality
- `firebase_crashlytics: ^5.0.0` - Crash reporting integration
- `path_provider: ^2.1.5` - Platform-specific directory access
- `path: ^1.9.1` - Path manipulation utilities
- `share_plus: ^10.1.0` - Cross-platform sharing functionality
- `url_launcher: ^6.3.1` - URL and email launching capabilities
