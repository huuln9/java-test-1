import 'package:vncitizens_common/vncitizens_common.dart';

import '../controller/address_maps_controller.dart';
import '../controller/create_controller.dart';
import '../controller/petition_detail_controller.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetitionCreateController());
    Get.lazyPut(() => AddressMapsController());
    Get.lazyPut(() => PetitionDetailController());
  }
}
