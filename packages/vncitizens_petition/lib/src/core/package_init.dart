import 'dart:developer';

import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/core/hive_init.dart';
import 'package:vncitizens_petition/src/core/route_init.dart';
import 'package:vncitizens_petition/src/core/translation_init.dart';

Future<void> initPackages() async {
  log("Init package vncitizens_petition", name: AppConfig.packageName);
  await initHive();
  await initAppTranslation();
  await initAppRoute();
}
