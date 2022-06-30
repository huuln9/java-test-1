import 'app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart' as vncitizens_common;
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart'
    as vncitizens_common_hcm;
import 'package:vncitizens_home/vncitizens_home.dart' as vncitizens_home;
import 'package:vncitizens_notification/vncitizens_notification.dart'
    as vncitizens_notification;
import 'package:vncitizens_account/vncitizens_account.dart'
    as vncitizens_account;
import 'package:vncitizens_qrcode/vncitizens_qrcode.dart' as vncitizens_qrcode;
import 'package:vncitizens_setting/vncitizens_setting.dart'
    as vncitizens_setting;
// import 'package:vncitizens_garbage_schedule/vncitizens_garbage_schedule.dart'
//     as vncitizens_garbage_schedule;
// import 'package:vncitizens_portal/vncitizens_portal.dart' as vncitizens_portal;
import 'package:vncitizens_petition/vncitizens_petition.dart'
    as vncitizens_petition;
import 'package:vncitizens_emergency_contact/vncitizens_emergency_contact.dart'
    as vncitizens_emergency_contact;
import 'package:vncitizens_place/vncitizens_place.dart' as vncitizens_place;
// import 'package:vncitizens_queue/vncitizens_queue.dart' as vncitizens_queue;
import 'dart:developer' as dev;

// import 'package:vncitizens_camera/vncitizens_camera.dart' as vncitizens_camera;
import 'package:vncitizens_payment/vncitizens_payment.dart'
    as vncitizens_payment;
// import 'package:vncitizens_administrative_document/vncitizens_administrative_document.dart'
//     as vncitizens_administrative_document;
import 'package:vncitizens_weather/vncitizens_weather.dart'
    as vncitizens_weather;

/// List of packages that app need to initialize
initPackages() async {
  dev.log('initialize packages', name: AppConfig.packageName);

  // Custom your package initialization
  await vncitizens_account.initPackage();
  await vncitizens_common.initPackage();
  await vncitizens_home.initPackage();
  // await vncitizens_qrcode.initPackage();
  await vncitizens_setting.initPackage();
  // await vncitizens_garbage_schedule.initPackage();
  // await vncitizens_portal.initPackage();
  await vncitizens_petition.initPackages();
  await vncitizens_emergency_contact.initPackage();
  await vncitizens_place.initPackage();
  await vncitizens_notification.initPackage();
  // await vncitizens_camera.initPackage();
  // await vncitizens_administrative_document.initPackage();
  await vncitizens_payment.initPackage();
  // await vncitizens_queue.initPackage();
  await vncitizens_common_hcm.initPackage();
  await vncitizens_qrcode.initPackage();
  await vncitizens_weather.initPackage();
}
