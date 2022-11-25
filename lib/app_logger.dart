import 'package:logger/logger.dart';

final logger = Logger(
    printer: PrefixPrinter(
  PrettyPrinter(
      methodCount: 0,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 200,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
));
