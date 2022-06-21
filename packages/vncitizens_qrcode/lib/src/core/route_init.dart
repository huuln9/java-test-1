import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:vncitizens_qrcode/src/binding/qrcode_binding.dart';
import 'package:vncitizens_qrcode/src/widget/qrcode.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(
    GetPage(
      name: '/vncitizens_qrcode',
      page: () => const QRCode(),
      binding: QRCodeBinding(),
    ),
  );
}
