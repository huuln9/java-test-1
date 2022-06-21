import 'dart:developer' as dev;

import '../config/app_config.dart';
import '../config/package_config.dart';
import '../core/errors_handler.dart';
import '../core/translation_init.dart';
import 'package:get_storage/get_storage.dart';

import 'app_config_init.dart';
import 'timezone_init.dart';

Future initApp() async {
  dev.log("initialize application", name: AppConfig.packageName);
  await GetStorage.init();
  await initAppErrorHandler();
  await initAppTranslation();
  await initAppConfig();
  await initPackages();
  await initAppTimezone();
}
