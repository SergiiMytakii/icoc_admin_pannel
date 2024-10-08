import 'package:logger/logger.dart';

Future logError(Object error, StackTrace? stackTrace) async {
  final log = Logger();

  log.e('$error', error: error, stackTrace: stackTrace);
}

Future logger(dynamic data) async {
  final log = Logger();

  log.f(data);
}
