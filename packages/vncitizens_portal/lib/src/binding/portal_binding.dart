import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_portal/src/controller/portal_controller.dart';

class PortalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PortalController());
  }
}
