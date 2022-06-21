import 'package:get/get.dart';
import 'package:vncitizens_camera/src/translation/en_translation.dart';
import 'package:vncitizens_camera/src/translation/vi_translation.dart';

initAppTranslation() async {
  Get.appendTranslations(ViTranslation().keys);
  Get.appendTranslations(EnTranslation().keys);
}
