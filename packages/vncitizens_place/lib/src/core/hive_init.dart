import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;

import 'package:vncitizens_place/src/config/app_config.dart';

initHive() async {
  var tmpDir = await getTemporaryDirectory();
  dev.log('initialize Hive in directory ${tmpDir.path}',
      name: AppConfig.packageName);
  await Hive.openBox(AppConfig.storageBox, path: tmpDir.path);
}
