import 'dart:developer';

import 'package:logger/logger.dart';

import '../../helpers/extensions/int_extension.dart';

final logger = LoggingService().createLogger();

class LoggingService {
  Logger createLogger() {
    return Logger(
      filter: _LogFilter(),
      printer: _LogPrinter(),
      output: _ConsoleLogOutput(),
    );
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => true;
}

class _LogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var message = event.message;
    var error = event.error;
    var stackTrace = event.stackTrace;
    var level = event.level;

    var builder = StringBuffer();
    const spacer = '|';
    builder.write(_getTime());
    builder.write(spacer);
    builder.write(_logLevel(level));
    builder.write(spacer);
    builder.write(_getLogLocation());
    builder.write(spacer);
    builder.write(message);

    var errorString = error.toString();
    if (errorString != 'null') {
      var errorLines = errorString.split('\n');
      errorLines = errorLines.map((line) => '  $line').toList();
      builder.write('\n${errorLines.join('\n')}');
      builder.write('\n');
    }

    var stackTraceString = stackTrace.toString();
    if (stackTraceString != 'null') {
      var stackTraceLines = stackTraceString.split('\n');
      stackTraceLines =
          stackTraceLines.map((line) => '  $line').take(100).toList();
      builder.write('\n${stackTraceLines.join('\n')}');
    }
    return [builder.toString()];
  }

  String _logLevel(Level level) {
    return level.name.substring(0, 3).toUpperCase();
  }

  String _getLogLocation() {
    final stack = StackTrace.current.toString().split('\n');
    final line = stack[4];
    return line.substring(
      line.lastIndexOf('/') + 1,
      line.indexOf('.dart'),
    );
  }

  String _getTime() {
    var now = DateTime.now().toUtc();
    var h = now.hour.twoDigits();
    var min = now.minute.twoDigits();
    var sec = now.second.twoDigits();
    var ms = now.millisecond.threeDigits();
    return '$h:$min:$sec.$ms';
  }
}

class _ConsoleLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final color = _color(event.level);
    var message = color + event.lines.join('\n');
    log(message);
  }

  String _color(Level level) => switch (level) {
        Level.error => '\u001b[1;31m',
        Level.warning => '\u001b[1;33m',
        Level.info => '\u001b[1;32m',
        _ => '\u001b[0m'
      };
}
