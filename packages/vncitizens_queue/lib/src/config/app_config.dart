import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_queue";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  /// storage key name
  static const String apiEndpoint = "api_endpoint";
  static const String tokenStorageKey = "token";

  ///
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  ///
  static String get apiQueueEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["api"];
  }

  static String get ssoQueueEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["sso"];
  }

  static String get clientId {
    return GetStorage(storageBox).read(apiEndpoint)["client_id"];
  }

  static String get clientSecret {
    return GetStorage(storageBox).read(apiEndpoint)["client_secret"];
  }

  static String get agencyId {
    return GetStorage(storageBox).read(apiEndpoint)["agency-id"];
  }

  static String get parentId {
    return GetStorage(storageBox).read(apiEndpoint)["parent-id"];
  }

  static String get accessToken {
    return GetStorage(storageBox).read(tokenStorageKey);
  }
}
