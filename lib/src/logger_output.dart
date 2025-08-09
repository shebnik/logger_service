import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'logger_config.dart';

/// Custom log output that writes to both console and file
class ConsoleAndFileOutput extends LogOutput {
  /// Creates a console and file output with the specified configuration
  ConsoleAndFileOutput(this.config);

  FirebaseCrashlytics? _crashlytics;
  final LoggerConfig config;
  File? _file;
  IOSink? _sink;

  @override
  Future<void> init() async {
    // Initialize Firebase Crashlytics safely
    try {
      _crashlytics = FirebaseCrashlytics.instance;
    } catch (e) {
      // Firebase not initialized, continue without crashlytics
      _crashlytics = null;
    }

    final directory =
        config.directory ?? await getApplicationDocumentsDirectory();
    final logDirPath = path.join(directory.path, config.logDirectoryName);
    final logFilePath = path.join(logDirPath, config.logFileName);

    await Directory(logDirPath).create(recursive: true);
    _file = File(logFilePath);

    await _rotateLogsIfNeeded();

    _sink = _file!.openWrite(mode: FileMode.writeOnlyAppend);
  }

  /// Rotates log files if they exceed the maximum size
  Future<void> _rotateLogsIfNeeded() async {
    if (!_file!.existsSync()) return;

    final size = await _file!.length();
    if (size <= config.maxFileSize) return;

    final backupPath = '${_file!.path}.old';
    final backupFile = File(backupPath);

    if (backupFile.existsSync()) {
      await backupFile.delete();
    }

    await _file!.rename(backupPath);
    _file = File(_file!.path);
  }

  @override
  void output(OutputEvent event) {
    // Output to console
    event.lines.forEach(debugPrint);

    // Output to file
    _sink?.writeAll(event.lines, '\n');
    _sink?.writeln();

    // Output to Firebase Crashlytics in release mode
    if (kReleaseMode && !kIsWeb && _crashlytics != null) {
      event.lines.forEach(_crashlytics!.log);
    }
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
    _file = null;
  }
}
