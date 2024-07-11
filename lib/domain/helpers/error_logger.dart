import 'package:logger/logger.dart';

Future logError(Object error, StackTrace? stackTrace) async {
  final log = Logger();

  log.e('$error', error: error, stackTrace: stackTrace);
}

Future log(dynamic data) async {
  final log = Logger();

  log.d(data);
}
