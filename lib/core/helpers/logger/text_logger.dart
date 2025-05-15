import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';

mixin TextLogger<T extends StatefulWidget> on State<T> {
  final Logger logger = Logger("WidgetLogger");
  final List<LogEntry> _uiLogs = [];
  final int maxUiLogs = 200;

  List<LogEntry> get uiLogs => List.unmodifiable(_uiLogs);

  void logToUi(String message, {LogLevel level = LogLevel.info}) {
    if (!mounted) return;

    setState(() {
      _uiLogs.add(LogEntry(logger.instanceName, message, level));
      if (_uiLogs.length > maxUiLogs) {
        _uiLogs.removeAt(0);
      }
    });

    logger.log(message, level: level);
  }

  void debugLog(String message) => logger.log(message, level: LogLevel.debug);
  void infoLog(String message) => logger.log(message, level: LogLevel.info);
  void warningLog(String message) =>
      logger.log(message, level: LogLevel.warning);
  void errorLog(String message) => logger.log(message, level: LogLevel.error);
  void successLog(String message) =>
      logger.log(message, level: LogLevel.success);

  void clearUiLogs() {
    if (!mounted) return;
    setState(() => _uiLogs.clear());
  }
}
