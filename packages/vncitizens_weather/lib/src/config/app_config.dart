import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_weather";

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
  static const String authenticatorStorageKey = "authenticator";


  ///
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  ///
  static String get apiWeatherEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["api"];
  }
  static String get vnccApiEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["vncc"];
  }
  static String get ssoWeatherEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["sso"];
  }
  static String get iscsApiEndpoint {
    return GetStorage(storageBox).read(apiEndpoint)["iscs"];
  }
  static String get clientSecret {
    return GetStorage(storageBox).read(apiEndpoint)["client_secret"];
  }
  static String get oidcScope {
    return GetStorage(storageBox).read(authenticatorStorageKey)["scope"];
  }

  static String get oidcClientId {
    return GetStorage(storageBox).read(authenticatorStorageKey)["client_id"];
  }
  static String get accessToken {
    return GetStorage(storageBox).read(tokenStorageKey);
  }
}
