import 'package:get/get.dart';
import 'package:vncitizens_emergency_contact/src/controller/contact_by_group_controller.dart';
import 'package:vncitizens_emergency_contact/src/controller/contact_exclude_group_controller.dart';
import 'package:vncitizens_emergency_contact/src/controller/home_sos_controller.dart';

class ContactAllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeSosController());
    Get.lazyPut(() => ContactByGroupController());
    Get.lazyPut(() => ContactExcludeGroupController());
  }

}