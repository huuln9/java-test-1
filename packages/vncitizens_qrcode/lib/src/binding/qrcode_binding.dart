import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_qrcode/src/controller/qrcode_controller.dart';

class QRCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QRCodeController());
  }
}
