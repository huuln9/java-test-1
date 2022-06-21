import 'dart:developer';
import 'package:get/get.dart';
import 'package:vncitizens_common/src/config/app_config.dart';

class NotificationCounterController extends GetxController {
  RxInt num = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    log("INIT NOTIFICATION COUNTER CONTROLLER", name: AppConfig.packageName);
  }

  setNum(int number) {
    num.value = num.value + number;
  }
}
