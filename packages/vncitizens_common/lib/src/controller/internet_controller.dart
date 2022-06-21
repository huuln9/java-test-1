import 'dart:developer';
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class InternetController extends GetxController {
  RxBool hasConnected = false.obs;

  @override
  void onInit() async {
    super.onInit();
    log("INIT INTERNET CONTROLLER", name: AppConfig.packageName);
  }
}
