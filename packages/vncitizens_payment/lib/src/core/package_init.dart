import 'dart:developer' as dev;

import 'package:vncitizens_payment/src/config/app_config.dart';
import 'package:vncitizens_payment/src/core/route_init.dart';
import 'package:vncitizens_payment/src/core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}
