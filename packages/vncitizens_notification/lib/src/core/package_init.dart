import 'dart:developer' as dev;

import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/core/hive_init.dart';
import 'package:vncitizens_notification/src/core/route_init.dart';
import 'package:vncitizens_notification/src/core/translation_init.dart';

import 'fcm_init.dart';

initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initHive();
  await initAppTranslation();
  await initAppRoute();
  await initFirebase();
}
