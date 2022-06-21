import 'dart:developer' as dev;

import 'package:flutter_package_template/src/config/app_config.dart';
import 'package:flutter_package_template/src/core/route_init.dart';
import 'package:flutter_package_template/src/core/translation_init.dart';

initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}
