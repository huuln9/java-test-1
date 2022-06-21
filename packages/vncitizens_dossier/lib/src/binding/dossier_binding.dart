import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/src/controller/dossier_controller.dart';

class DossierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DossierController());
  }
}
