import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_emergency_contact/src/widget/home_sos.dart';

import '../binding/home_binding.dart';
import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(GetPage(
      name: '/vncitizens_emergency_contact',
      page: () => const HomeSos(),
      binding: HomeBinding()));
}
