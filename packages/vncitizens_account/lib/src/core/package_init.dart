import 'dart:developer' as dev;

import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/core/hive_init.dart';
import 'package:vncitizens_account/src/core/route_init.dart';
import 'package:vncitizens_account/src/core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AccountAppConfig.packageName);
  await initHive();
  await initAppTranslation();
  await initAppRoute();
}
