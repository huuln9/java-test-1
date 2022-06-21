import 'dart:developer' as dev;

import '../config/app_config.dart';
import '../core/route_init.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}