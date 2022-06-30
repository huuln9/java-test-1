import 'dart:developer' as dev;

import '../config/app_config.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log("Init commons hcm package", name: AppConfig.packageName);
  await initAppTranslation();
}
