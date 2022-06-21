import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_home/vncitizens_home.dart' show HomeAppConfig;
import 'package:vncitizens_account/vncitizens_account.dart' show AccountRouteConfig, AuthUtil;

class AppConfig {
  // ------------------------------------
  // REQUIRED
  // ------------------------------------

  /// default locale
  static const locale = Locale('vi');

  /// fallback locale
  static const fallbackLocale = Locale('en');

  /// the base url of ISCS APIs
  static const String iscsBaseUrl = "https://iscsapidev.digigov.vn";

  /// config code
  static const String configCode = "vncitizens-dev";

  /// deployment id (tenant id)
  static const String deploymentId = "master";

  /// package name
  static const String packageName = "flutter_vncitizens";

  /// storage box
  static const String storageBox = packageName;

  /// default transition
  static const Transition defaultTransition = Transition.fadeIn;

  /// require login
  static bool get requireLogin {
    return GetStorage(storageBox).read("requireLogin") ?? false;
  }

  static String? get remoteInitialRoute {
    return GetStorage(storageBox).read("initialRoute");
  }

  /// initial route
  static String get initialRoute {
    if (requireLogin && AuthUtil.isLoggedIn == false) {
      return AccountRouteConfig.loginAppRoute;
    }
    if (remoteInitialRoute != null) {
      return remoteInitialRoute!;
    }
    return HomeAppConfig.homeRoute;
  }

  /// config key
  static const String defaultConfigKey = 'remote_config';

  // ------------------------------------
  // OPTIONAL
  // ------------------------------------

  /// FCM: subscribe to topics
  static const List<String> fcmSubscribeTopics = ["topic1", "topic2"];

  // ------------------------------------
  // PRIVACY
  // ------------------------------------

  // add more your config here
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);
}
