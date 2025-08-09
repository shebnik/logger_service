import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logger_service.dart';

/// Result of the bug report operation
enum BugReportResult {
  success,
  logFileNotFound,
  emailClientError,
  folderOpenError,
  unknownError,
}

class BugReportService {
  static const String _bugReportSubject = 'Bug Report';

  Future<BugReportResult> reportBug({
    String? additionalInfo,
    String? supportEmail,
  }) async {
    if (kIsWeb) {
      if (supportEmail != null) {
        final uri = Uri.parse('mailto:$supportEmail');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      }
      return BugReportResult.success;
    }
    final logger = LoggerService.logger;

    try {
      final logFilePath = await _getLogFilePath();

      logger.i(
        'Bug report requested, '
        'logFilePath: $logFilePath, '
        'additionalInfo $additionalInfo, '
        'platform ${Platform.operatingSystem}',
      );

      final logFile = File(logFilePath);
      if (!logFile.existsSync()) {
        logger.e('Log file not found, path: $logFilePath');
        return BugReportResult.logFileNotFound;
      }

      final systemInfo = await _getSystemInfo();

      final emailBody = _constructEmailBody(
        systemInfo: systemInfo,
        supportEmail: supportEmail,
        additionalInfo: additionalInfo,
      );

      if (supportEmail != null) {
        await Clipboard.setData(ClipboardData(text: supportEmail));
        // Notification commented out as it requires additional dependencies
        // await NotificationsService.instance.show(
        //   title: 'Bug Report',
        //   body: 'Please email attached file to $supportEmail',
        // );
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(logFilePath)],
          subject: _bugReportSubject,
          text: emailBody,
        ),
      );

      return BugReportResult.success;
    } catch (e, stackTrace) {
      logger.e('Error sending bug report', error: e, stackTrace: stackTrace);
      return BugReportResult.unknownError;
    }
  }

  /// Gets the full path to the log file
  Future<String> _getLogFilePath() async {
    final config = LoggerService.instance.config;
    final docsDir = await getApplicationDocumentsDirectory();
    return path.join(docsDir.path, config.logDirectoryName, config.logFileName);
  }

  /// Gathers system information for the bug report
  Future<Map<String, String>> _getSystemInfo() async {
    return {
      'Platform': Platform.operatingSystem,
      'Version': Platform.operatingSystemVersion,
      'Locale': Platform.localeName,
      'Dart Version': Platform.version,
    };
  }

  /// Constructs the email body with all necessary information
  String _constructEmailBody({
    required Map<String, String> systemInfo,
    String? supportEmail,
    String? additionalInfo,
  }) {
    final buffer = StringBuffer();
    if (supportEmail != null) {
      buffer.writeln('$supportEmail\n\n');
    }
    buffer
      ..writeln('Bug Report Details:')
      ..writeln('-------------------')
      ..writeln('\nSystem Information:');
    systemInfo.forEach((key, value) {
      buffer.writeln('$key: $value');
    });

    if (additionalInfo != null && additionalInfo.isNotEmpty) {
      buffer
        ..writeln('\nAdditional Information:')
        ..writeln(additionalInfo);
    }
    return buffer.toString();
  }
}
