import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_garbage_schedule/src/controller/garbage_schedule_controller.dart';

class GarbageScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GarbageScheduleController());
  }
}
