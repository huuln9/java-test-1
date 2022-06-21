import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_home/src/binding/home_binding.dart';
import 'package:vncitizens_home/src/widget/home.dart';

import '../config/home_app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: HomeAppConfig.packageName);
  GetPageCenter.add(GetPage(name: HomeAppConfig.homeRoute, page: () => const Home(), binding: HomeBinding()));
}
