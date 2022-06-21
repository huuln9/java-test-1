import 'dart:async';
import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:vncitizens_common/src/controller/internet_controller.dart';
import 'package:vncitizens_common/src/service/notify_service.dart';
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/src/core/token_init.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_notification/vncitizens_notification.dart';

import '../controller/notification_counter_controller.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log("Init commons package", name: AppConfig.packageName);
  await initDefaultAppToken();
  await _getUnreadNumber();
  await _checkInternetConnection();
  await initAppTranslation();
  await initIGateToken();
}

Future<void> _checkInternetConnection() async {
  InternetController internetController = Get.put(InternetController());
  InternetConnectionChecker()
      .onStatusChange
      .listen((InternetConnectionStatus status) {
    switch (status) {
      case InternetConnectionStatus.connected:
        internetController.hasConnected(true);
        break;
      case InternetConnectionStatus.disconnected:
        internetController.hasConnected(false);
        break;
    }
  });
}

Future<void> _getUnreadNumber() async {
  NotificationCounterController c = Get.put(NotificationCounterController());
  String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
  // TODO: Set variable topic
  NotifyService().getUnreadNumber(userId!, FcmUtil.fcmTopics).then((res) {
    if (res.body != null) {
      c.num.value = res.body as int;
      dev.log('notification counter ' + c.num.value.toString(),
          name: AppConfig.packageName);
    }
  }, onError: (err) {
    c.num.value = 0;
  }).catchError((onError) {
    c.num.value = 0;
  });
}
