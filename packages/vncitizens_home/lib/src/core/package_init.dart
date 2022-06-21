import 'dart:developer' as dev;

import 'package:vncitizens_home/src/config/home_app_config.dart';
import 'package:vncitizens_home/src/core/route_init.dart';
import 'package:vncitizens_home/src/core/storage_init.dart';
import 'package:vncitizens_home/src/core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: HomeAppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
  await initSessionStorage();
}
