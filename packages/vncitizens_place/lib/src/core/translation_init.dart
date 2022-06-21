import 'package:vncitizens_place/src/translation/en_translation.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/translation/vi_translation.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(EnTranslation().keys);
  Get.appendTranslations(ViTranslation().keys);
}