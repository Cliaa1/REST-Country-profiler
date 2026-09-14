import 'package:logging/logging.dart';

void configureSystemTelemetry() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[${record.level.name}] ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Exception Detail: ${record.error}');
    }
  });
}
