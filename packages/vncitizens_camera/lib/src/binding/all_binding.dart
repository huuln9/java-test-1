import 'package:vncitizens_camera/src/controller/camera_list_controller.dart';
import 'package:vncitizens_camera/src/controller/camera_live_controller.dart';
import 'package:vncitizens_camera/src/controller/camera_map_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => CameraListController());
    Get.lazyPut(() => CameraMapController());
    Get.lazyPut(() => CameraLiveController());
    Get.lazyPut(() => InternetController());
  }
}