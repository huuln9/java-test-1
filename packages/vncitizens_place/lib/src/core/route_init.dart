import 'package:digo_common/digo_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/widget/place.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(GetPage(
      name: '/vncitizens_place',
      page: () => Place(),
  ));
}
