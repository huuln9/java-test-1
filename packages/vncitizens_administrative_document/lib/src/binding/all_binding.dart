import 'package:vncitizens_administrative_document/src/controller/admin_doc_detail_controller.dart';
import 'package:vncitizens_administrative_document/src/controller/admin_doc_list_controller.dart';
import 'package:vncitizens_administrative_document/src/controller/admin_doc_search_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AdminDocListController());
    Get.lazyPut(() => AdminDocSearchController());
    Get.lazyPut(() => AdminDocDetailController());
  }
}