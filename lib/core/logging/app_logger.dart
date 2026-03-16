import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';

class AppLogger {
  AppLogger({String name = 'okk_qc_app'}) : _logger = Logger(name);

  final Logger _logger;
  StreamSubscription<LogRecord>? _subscription;
  IOSink? _sink;

  Future<void> initialize(File logFile) async {
    if (_sink != null) {
      return;
    }

    await logFile.parent.create(recursive: true);
    _sink = logFile.openWrite(mode: FileMode.append);

    hierarchicalLoggingEnabled = true;
    _logger.level = Level.ALL;
    _subscription = _logger.onRecord.listen((record) {
      final line =
          '${record.time.toUtc().toIso8601String()} '
          '[${record.level.name}] '
          '${record.loggerName}: ${record.message}';
      _sink?.writeln(line);
    });
  }

  void info(String message) => _logger.info(message);

  void warning(String message) => _logger.warning(message);

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    final details = [message, error, stackTrace].nonNulls.join(' ');
    _logger.severe(details);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _sink?.flush();
    await _sink?.close();
  }
}
