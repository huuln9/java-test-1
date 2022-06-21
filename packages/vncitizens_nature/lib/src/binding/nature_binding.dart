

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_nature/src/controller/map_nature_controller.dart';
import 'package:vncitizens_nature/src/controller/home_nature_controller.dart';
import 'package:vncitizens_nature/src/controller/map_nature_item_controller.dart';

class NatureBinding extends Bindings {

    @override
    void dependencies() {
      // TODO: implement dependencies
      Get.lazyPut(() => HomeNatureController());
      Get.lazyPut(() => MapNatureController());
      Get.lazyPut(() => MapNatureItemController());
  }
}