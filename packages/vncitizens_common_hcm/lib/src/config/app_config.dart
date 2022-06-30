import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart' as core;

class AppConfig {
  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_common";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  static const Color backgroundColor = Color(0xFFE5E5E5);
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  static const String tokenStorageKey = "token";
  static const String iGateTokenStorageKey = "iGateToken";
  static const String apiEndpointStorageKey = "api_endpoint";
  static const String authenticatorStorageKey = "authenticator";
  static const String minioStorageKey = "minio";
  static const String iGateConfigStorageKey = "iGateConfig";
  static const String vietbando = "vietbando";
  static const String hcmOpenData = "hcm_opendata";

  static String get accessToken {
    return core.GetStorage(storageBox).read(tokenStorageKey);
  }

  static String get vietbandoApiEndpoint {
    return core.GetStorage(storageBox).read(vietbando)["urlEndPoint"];
  }

  static String get hcmOpenDataEndPoint {
    return core.GetStorage(storageBox).read(hcmOpenData)['urlEndPoint'];
  }

  static String get vietbandoRegisterKey {
    return core.GetStorage(storageBox).read(vietbando)["RegisterKey"];
  }
}
