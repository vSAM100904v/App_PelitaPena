import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, success }

class LogEntry {
  final DateTime timestamp;
  final String message;
  final LogLevel level;
  final String instanceName;

  LogEntry(this.instanceName, this.message, this.level, [DateTime? timestamp])
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return '${timestamp.toIso8601String()} [$instanceName] ${level.toString().split('.').last.toUpperCase()}: $message';
  }
}

class Logger {
  final String instanceName;
  final List<LogEntry> _logHistory = [];
  final int maxHistory;

  Logger(this.instanceName, {this.maxHistory = 1000});

  List<LogEntry> get history => List.unmodifiable(_logHistory);

  void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final entry = LogEntry(instanceName, message, level);
      _logHistory.add(entry);

      if (_logHistory.length > maxHistory) {
        _logHistory.removeAt(0);
      }

      const int lineLength = 50;
      String line = '<=>' * lineLength;
      String header =
          "[$instanceName] ${level.toString().split('.').last.toUpperCase()}";

      String formattedMessage = '''
$header
$line
$message
$line
<END [$instanceName] ${level.toString().split('.').last.toUpperCase()}>
''';

      switch (level) {
        case LogLevel.debug:
          // ! PAKE DEBUG PRINT BUAT LOG SEMUA MUANYA
          // debugPrint('DEBUG:$formattedMessage');
          print('DEBUG:$formattedMessage');
          break;
        case LogLevel.success:
          print('SUCCESS:$formattedMessage');
          break;
        case LogLevel.info:
          print('INFO:$formattedMessage');
          break;
        case LogLevel.warning:
          print('WARNING:$formattedMessage');
          break;
        case LogLevel.error:
          print('ERROR:$formattedMessage');
          break;
      }
    }
  }

  void clearHistory() {
    _logHistory.clear();
  }
}
