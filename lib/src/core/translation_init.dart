import '../config/app_config.dart';
import '../translation/en_translation.dart';
import '../translation/vi_translation.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

/// Getx translation config together in app
/// does not include from other packages
initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(EnTranslation().keys);
  Get.appendTranslations(ViTranslation().keys);
}
