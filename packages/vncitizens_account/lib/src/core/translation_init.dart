import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/translation/en_translation.dart';
import 'package:vncitizens_account/src/translation/vi_translation.dart';

initAppTranslation() async {
  dev.log('initialize translation', name: AccountAppConfig.packageName);
  Get.appendTranslations(ViTranslation().keys);
  Get.appendTranslations(EnTranslation().keys);
}
