import 'package:digo_common/digo_common.dart';
import 'package:flutter_package_template/src/config/app_config.dart';
import 'package:flutter_package_template/src/controller/examplex_controller.dart';
import 'package:flutter_package_template/src/widget/first.dart';
import 'package:flutter_package_template/src/widget/second.dart';
import 'package:flutter_package_template/src/widget/third.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);

  GetPageCenter.add(GetPage(name: '/home', page: () => First()));

  GetPageCenter.add(GetPage(
    name: '/second',
    page: () => Second(),
    binding: BindingsBuilder(() => {Get.lazyPut<ExampleXController>(() => ExampleXController())}),
  ));

  GetPageCenter.add(GetPage(
    name: '/third',
    transition: Transition.cupertino,
    page: () => Third(),
  ));
}
