import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/logger/logger.dart';

class LogViewer extends StatelessWidget {
  final List<LogEntry> logs;
  final ScrollController? scrollController;
  final bool autoscroll;

  const LogViewer({
    super.key,
    required this.logs,
    this.scrollController,
    this.autoscroll = true,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (autoscroll &&
          scrollController != null &&
          scrollController!.hasClients) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        controller: scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          Color textColor;

          switch (log.level) {
            case LogLevel.debug:
              textColor = Colors.blue[200]!;
              break;
            case LogLevel.info:
              textColor = Colors.white;
              break;
            case LogLevel.warning:
              textColor = Colors.yellow[200]!;
              break;
            case LogLevel.error:
              textColor = Colors.red[200]!;
              break;
            case LogLevel.success:
              textColor = Colors.green[200]!;
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: SelectableText(
              log.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: 'Monospace',
              ),
            ),
          );
        },
      ),
    );
  }
}
