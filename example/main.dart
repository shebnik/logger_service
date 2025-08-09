import 'package:flutter/material.dart';
import 'package:logger_service/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger service with custom configuration
  await LoggerService.initialize(
    config: LoggerConfig(
      maxFileSize: 5 * 1024 * 1024, // 5MB
      logDirectoryName: 'example_logs',
      logFileName: 'example.log',
      enableFileOutput: true,
      enableConsoleOutput: true,
      minLogLevel: Level.debug,
    ),
  );

  // Log application startup
  LoggerService.logger.i('Application starting...');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logger Service Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Logger Service Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Log the counter increment with different log levels
    if (_counter % 10 == 0) {
      LoggerService.logger.w('Counter reached milestone: $_counter');
    } else if (_counter % 5 == 0) {
      LoggerService.logger.i('Counter is at $_counter');
    } else {
      LoggerService.logger.d('Counter incremented to $_counter');
    }

    // Simulate an error every 20 increments
    if (_counter % 20 == 0) {
      LoggerService.logger.e('Simulated error at counter: $_counter');
    }
  }

  @override
  void initState() {
    super.initState();
    LoggerService.logger.i('MyHomePage initialized');
  }

  @override
  void dispose() {
    LoggerService.logger.i('MyHomePage disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.logger.d('Building MyHomePage widget');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LoggerService.logger.i(
                  'Log levels demonstration button pressed',
                );
                _showLogLevelsDemo();
              },
              child: const Text('Demonstrate Log Levels'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                LoggerService.logger.i('Error simulation button pressed');
                _simulateError();
              },
              child: const Text('Simulate Error'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLogLevelsDemo() {
    LoggerService.logger.d(
      'This is a DEBUG message - typically used for detailed diagnostic information',
    );
    LoggerService.logger.i(
      'This is an INFO message - used for general information about program execution',
    );
    LoggerService.logger.w(
      'This is a WARNING message - indicates something unexpected happened',
    );
    LoggerService.logger.e(
      'This is an ERROR message - indicates a serious problem occurred',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Log levels demonstrated! Check console and log files.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _simulateError() {
    try {
      // Simulate an error
      throw Exception('This is a simulated error for demonstration purposes');
    } catch (error, stackTrace) {
      LoggerService.logger.e(
        'Caught an error: $error',
        error: error,
        stackTrace: stackTrace,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error simulated and logged! Check console and log files.',
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
