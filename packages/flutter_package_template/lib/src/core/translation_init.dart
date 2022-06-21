import 'package:flutter_package_template/flutter_package_template.dart';
import 'package:flutter_package_template/src/config/app_config.dart';
import 'package:flutter_package_template/src/translation/vi_translation.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(EnTranslation().keys);
  Get.appendTranslations(ViTranslation().keys);
}