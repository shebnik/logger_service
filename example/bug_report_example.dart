import 'package:flutter/material.dart';
import 'package:logger_service/logger_service.dart';

/// Example demonstrating how to use the BugReportService
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger service first
  await LoggerService.initialize(
    config: LoggerConfig(
      enableFileOutput: true,
      logDirectoryName: 'app_logs',
      logFileName: 'app.log',
    ),
  );

  runApp(const BugReportApp());
}

class BugReportApp extends StatelessWidget {
  const BugReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bug Report Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BugReportPage(),
    );
  }
}

class BugReportPage extends StatefulWidget {
  const BugReportPage({super.key});

  @override
  State<BugReportPage> createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  final BugReportService _bugReportService = BugReportService();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: 'support@example.com',
  );

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateSampleLogs();
  }

  void _generateSampleLogs() {
    // Generate some sample log entries for demonstration
    LoggerService.logger.i('Application started');
    LoggerService.logger.d('Debug information for testing');
    LoggerService.logger.w('Sample warning message');
    LoggerService.logger.e('Sample error message for bug report');
    LoggerService.logger.i('User navigated to bug report page');
  }

  Future<void> _sendBugReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _bugReportService.reportBug(
        additionalInfo: _additionalInfoController.text.isNotEmpty
            ? _additionalInfoController.text
            : null,
        supportEmail: _emailController.text.isNotEmpty
            ? _emailController.text
            : null,
      );

      if (mounted) {
        _showResultDialog(result);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showResultDialog(BugReportResult result) {
    String title;
    String message;
    IconData icon;
    Color color;

    switch (result) {
      case BugReportResult.success:
        title = 'Success';
        message = 'Bug report sent successfully!';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case BugReportResult.logFileNotFound:
        title = 'Log File Not Found';
        message = 'No log file was found to attach to the bug report.';
        icon = Icons.error;
        color = Colors.orange;
        break;
      case BugReportResult.emailClientError:
        title = 'Email Client Error';
        message = 'Could not open email client. Please try again.';
        icon = Icons.error;
        color = Colors.red;
        break;
      case BugReportResult.folderOpenError:
        title = 'Folder Error';
        message = 'Could not access the log folder.';
        icon = Icons.error;
        color = Colors.red;
        break;
      case BugReportResult.unknownError:
        title = 'Unknown Error';
        message = 'An unexpected error occurred. Please try again.';
        icon = Icons.error;
        color = Colors.red;
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bug Report Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bug Report Service',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This example demonstrates how to use the BugReportService to '
              'send bug reports with log files attached.',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Support Email',
                hintText: 'Enter support email address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _additionalInfoController,
              decoration: const InputDecoration(
                labelText: 'Additional Information',
                hintText: 'Describe the bug or issue you encountered',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _sendBugReport,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bug_report),
              label: Text(_isLoading ? 'Sending...' : 'Send Bug Report'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generateSampleLogs,
              icon: const Icon(Icons.add),
              label: const Text('Generate More Sample Logs'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Generates system information'),
                    Text('2. Locates and attaches log files'),
                    Text('3. Opens share dialog with email content'),
                    Text('4. Copies support email to clipboard'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _additionalInfoController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
