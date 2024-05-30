enum LogType {
  info,
  init,
  error,
}

class Logger {
  final bool debugMode;

  Logger({required this.debugMode});

  void log(String message, {LogType type = LogType.info}) {
    if (debugMode) {
      String colorCode;
      switch (type) {
        case LogType.init:
          colorCode = '\x1B[32m'; // Green
          break;
        case LogType.error:
          colorCode = '\x1B[31m'; // Red
          break;
        case LogType.info:
        default:
          colorCode = '\x1B[34m'; // Blue
          break;
      }
      String resetCode = '\x1B[0m';
      print('$colorCode$message$resetCode');
    }
  }
}