import 'package:flutter/material.dart';

class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_setting";

  /// storage box name
  static const String storageBox = packageName;
  static const String homeStorageBox = "vncitizens_home";

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  /// storage key name
  static const String integratedEKYC = "integratedEKYC";
  static const String appInfo = "appInfo";
  static const String instructionLink = "instructionLink";
  static const String appLatestVersion = "app";

  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);
}
