import 'package:logger/logger.dart';

final logger = Logger(
    printer: PrefixPrinter(
  PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 200,
      colors: true,
      printEmojis: true,
      printTime: false),
));
