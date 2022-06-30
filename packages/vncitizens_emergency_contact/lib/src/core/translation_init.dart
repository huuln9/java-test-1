import 'dart:developer' as dev;

import 'package:get/get.dart';

import '../config/app_config.dart';
import '../translation/en_translation.dart';
import '../translation/vi_translation.dart';

initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(ViTranslation().keys);
  Get.appendTranslations(EnTranslation().keys);
}
