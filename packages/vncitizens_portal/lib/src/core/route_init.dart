import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_portal/src/binding/portal_binding.dart';
import 'package:vncitizens_portal/src/widget/portal.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(
    GetPage(
      name: AppConfig.router['list'] ?? '/vncitizens_portal',
      page: () => const Portal(),
      binding: PortalBinding(),
    ),
  );
  GetPageCenter.add(
    GetPage(
      name: AppConfig.router['detail'] ?? '/vncitizens_portal/detail',
      page: () => const Portal(),
      binding: PortalBinding(),
    ),
  );
}
