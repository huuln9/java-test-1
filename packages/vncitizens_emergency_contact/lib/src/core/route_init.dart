import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_emergency_contact/src/config/emer_contact_route_config.dart';
import 'package:vncitizens_emergency_contact/src/widget/contact_by_group.dart';
import 'package:vncitizens_emergency_contact/src/widget/contact_exlude_group.dart';
import 'package:vncitizens_emergency_contact/src/widget/home_sos.dart';

import '../binding/contact_all_binding.dart';
import '../config/emer_contact_app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: EmerContactAppConfig.packageName);
  GetPageCenter.add(GetPage(name: EmerContactRouteConfig.homeRoute, page: () => const HomeSos(), binding: ContactAllBinding()));
  GetPageCenter.add(GetPage(name: EmerContactRouteConfig.groupInRoute, page: () => const ContactByGroup(), binding: ContactAllBinding()));
  GetPageCenter.add(GetPage(name: EmerContactRouteConfig.groupExcludeRoute, page: () => const ContactExcludeGroup(), binding: ContactAllBinding()));
}
