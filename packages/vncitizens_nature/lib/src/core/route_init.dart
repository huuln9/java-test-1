import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_nature/src/binding/nature_binding.dart';
import 'package:vncitizens_nature/src/widget/map_nature.dart';
import 'package:vncitizens_nature/src/widget/home_nature.dart';
import 'package:vncitizens_nature/src/widget/map_nature_item.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
    dev.log('initialize route', name: AppConfig.packageName);
    GetPageCenter.add(GetPage(name: '/vncitizens_nature', page: () => const HomeNature(), binding: NatureBinding()));
    GetPageCenter.add(GetPage(name: '/vncitizens_nature_camera', page: () => MapNature(), binding: NatureBinding()));
    GetPageCenter.add(GetPage(name: '/vncitizens_nature_item_camera', page: () => MapNatureItem(), binding: NatureBinding()));
}