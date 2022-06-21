import 'dart:developer' as dev;

import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';
import '../core/route_init.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);

  var tmpDir = await getTemporaryDirectory();
  dev.log('initialize Hive in directory ${tmpDir.path}',
      name: AppConfig.packageName);
  await Hive.openBox(AppConfig.storageBox, path: tmpDir.path);

  await initAppTranslation();
  await initAppRoute();
}
