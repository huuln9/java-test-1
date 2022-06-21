import 'package:get/get.dart';
import 'dart:developer' as dev;

import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/translation/en_translation.dart';
import 'package:vncitizens_notification/src/translation/vi_translation.dart';

initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(EnTranslation().keys);
  Get.appendTranslations(ViTranslation().keys);
}
