import 'dart:developer' as dev;

import 'package:vncitizens_emergency_contact/src/core/route_init.dart';
import 'package:vncitizens_emergency_contact/src/core/translation_init.dart';

import '../config/app_config.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}
