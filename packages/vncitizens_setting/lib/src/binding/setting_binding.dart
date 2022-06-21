import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_setting/src/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
