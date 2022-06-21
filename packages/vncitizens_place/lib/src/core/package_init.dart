import 'dart:developer' as dev;

import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/core/hive_init.dart';
import 'package:vncitizens_place/src/core/route_init.dart';
import 'package:vncitizens_place/src/core/translation_init.dart';

initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initHive();
  await initAppTranslation();
  await initAppRoute();
}
