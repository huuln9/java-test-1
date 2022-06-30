import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_emergency_contact/src/model/location_call_config.dart';
import 'dart:developer' as dev;

import '../model/sos_item_model.dart';

class AppConfig {
  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_emergency_contact";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  static const String localCall = "location_call";
  static const String sosConfig = "data";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  static const String titleExpandedString = "[OPEN]";

  static const String tagCategoryIdStorageKey = "tag_category";
  static LocationCallConfig get soSConfig =>
      LocationCallConfig.fromMap(GetStorage(storageBox).read(localCall));
  static List dataSoSConfig = soSConfig.dataSos ?? [];

  static String get secertKey {
    return soSConfig.secertKey ?? '';
  }

  static String? get phoneNumber {
    return Hive.box('vncitizens_account').get("phoneNumber");
  }

  static List<SosItemModel> contacts = [
    SosItemModel(
      name: 'canh sat'.tr,
      phoneNumber: '113',
      image: '$assetsRoot/images/police-cap.png',
      dialNumber: dataSoSConfig
          .firstWhereOrNull((element) => element.phoneNumber == '113')!
          .dialNumber,
    ),
    SosItemModel(
      name: 'chua chay'.tr,
      phoneNumber: '114',
      image: '$assetsRoot/images/fire-extinguisher.png',
      dialNumber: dataSoSConfig
          .firstWhereOrNull((element) => element.phoneNumber == '114')!
          .dialNumber,
    ),
    SosItemModel(
      name: 'cap cuu'.tr,
      phoneNumber: '115',
      image: '$assetsRoot/images/ambulance.png',
      dialNumber: dataSoSConfig
          .firstWhereOrNull((element) => element.phoneNumber == '115')!
          .dialNumber,
    ),
  ];
}
