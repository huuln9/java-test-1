import 'dart:developer' as dev;
import 'package:flutter_app_template/src/config/app_config.dart';
import 'package:timezone/data/latest.dart' as tz;

initAppTimezone() {
  tz.initializeTimeZones();
  dev.log('initialize timezone', name: AppConfig.packageName);
}
