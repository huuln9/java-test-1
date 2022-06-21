import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/widget/pages/index/notification_list.dart';

initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(GetPage(
    name: '/vncitizens_notification',
    page: () => const NotificationList(),
  ));
}
