import 'dart:async';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/src/config/app_config.dart';
import 'package:vncitizens_dossier/src/controller/dossier_controller.dart';
import 'package:vncitizens_dossier/src/model/dossier_model.dart';

class DossierService extends GetConnect {
  Future<List<DossierModel>> getDossiersByKey({
    required String endpoint,
    required String keywork,
    required String page,
  }) async {
    Response resp = await get(endpoint +
        '/dossier/--public?keyword=' +
        keywork +
        '&page=' +
        page +
        '&size=' +
        AppConfig.size);
    if (resp.statusCode == 200) {
      List<DossierModel> news = DossierModel.fromArray(resp.body['content']);

      DossierController controller = Get.find();
      controller.isLast.value = resp.body['last'];

      return news;
    }
    throw Exception(resp.body);
  }
}
