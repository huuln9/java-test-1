import 'package:get/get.dart';
import 'package:vncitizens_queue/src/controller/queue_controller.dart';

class QueueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QueueController());
  }
}
