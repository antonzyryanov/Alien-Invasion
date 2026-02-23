import 'package:logging/logging.dart';

final Logger appLogger = Logger('AlienInvasionApp');

void configureAppLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '[${record.level.name}] ${record.time.toIso8601String()} ${record.loggerName}: ${record.message}',
    );
    if (record.error != null) {
      print('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      print(record.stackTrace);
    }
  });
}
