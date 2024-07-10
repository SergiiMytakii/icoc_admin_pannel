import 'package:logger/logger.dart';

Future logError(Object error, StackTrace? stackTrace) async {
  final log = Logger();

  log.e('$error', error: error, stackTrace: stackTrace);
}
