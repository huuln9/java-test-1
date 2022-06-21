import 'package:get/get.dart';
import 'package:vncitizens_home/src/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeController());
  }

}