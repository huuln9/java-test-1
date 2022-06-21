import 'dart:developer' as dev;

// import 'package:path_provider/path_provider.dart';
// import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';
import '../core/route_init.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}
