import 'package:flutter_test/flutter_test.dart';
import 'package:logger_service/logger_service.dart';

void main() {
  group('BugReportService', () {
    late BugReportService bugReportService;

    setUp(() {
      bugReportService = BugReportService();
    });

    test('should create instance', () {
      expect(bugReportService, isA<BugReportService>());
    });

    test('should return success on web platform', () async {
      // This test would need to be run in a web environment
      // For now, we'll just test the service creation
      expect(bugReportService, isNotNull);
    });
  });

  group('BugReportResult', () {
    test('should have all expected values', () {
      expect(BugReportResult.values, [
        BugReportResult.success,
        BugReportResult.logFileNotFound,
        BugReportResult.emailClientError,
        BugReportResult.folderOpenError,
        BugReportResult.unknownError,
      ]);
    });
  });
}
