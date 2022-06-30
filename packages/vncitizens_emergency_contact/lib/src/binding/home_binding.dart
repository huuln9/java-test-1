import 'package:get/get.dart';
import 'package:vncitizens_emergency_contact/src/controller/home_sos_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeSosController());
  }
}
