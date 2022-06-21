import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/src/service/igate/igate_oidc_service.dart';
import 'package:vncitizens_common/src/service/oidc_service.dart';

Future<void> initDefaultAppToken() async {
  Response response = await OidcService().getAccessTokenDefault();
  log(response.statusCode.toString(), name: AppConfig.packageName);
  if (response.statusCode == 200 && response.body["access_token"] != null) {
    await GetStorage(AppConfig.storageBox)
        .write(AppConfig.tokenStorageKey, response.body["access_token"]);
    log("Init token successfully!!!");
  } else {
    log("Get default token failed");
    log(response.statusCode.toString(), name: AppConfig.packageName);
    log(response.body.toString(), name: AppConfig.packageName);
  }
}

Future<void> initIGateToken() async {
  Response response = await IGateOidcService().getAccessTokenDefault();
  log(response.statusCode.toString(), name: AppConfig.packageName);
  if (response.statusCode == 200 && response.body["access_token"] != null) {
    await GetStorage(AppConfig.storageBox)
        .write(AppConfig.iGateTokenStorageKey, response.body["access_token"]);
    log("Init iGate token successfully!!!");
  } else {
    log("Get iGate token failed");
    log(response.statusCode.toString(), name: AppConfig.packageName);
    log(response.body.toString(), name: AppConfig.packageName);
  }
}
