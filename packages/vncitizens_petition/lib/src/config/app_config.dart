import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_petition/src/model/petition_create_remote_config.dart';
import 'package:vncitizens_petition/src/model/petition_page_content_model.dart';

class AppConfig {
  /// your package name
  static const String packageName = "vncitizens_petition";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  /// isGroupMenu storage key name
  static const String vCallStorageKey = "vcall";

  static const String centerLocationStorageKey = "centerLocation";
  static const String tagCategoryIdStorageKey = "tagCategoryId";
  static const String petitionCreateConfig = "petitionCreateConfig";
  static const String exceptStatusStorageKey = "exceptStatus";

  static Color backgroundColor = ColorUtils.fromString('#EAEAEA');
  static Color textGreyColor = ColorUtils.fromString('#737373');
  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  static LatLng get centerLocation {
    try {
      if (getPetitionCreateConfig.takePlaceAt != null &&
          getPetitionCreateConfig.takePlaceAt!.latitude != null &&
          getPetitionCreateConfig.takePlaceAt!.longtude != null) {
        return LatLng(getPetitionCreateConfig.takePlaceAt!.latitude!,
            getPetitionCreateConfig.takePlaceAt!.longtude!);
      }
      return LatLng(
          GetStorage('vncitizens_place').read(centerLocationStorageKey)["lat"],
          GetStorage('vncitizens_place')
              .read(centerLocationStorageKey)["long"]);
    } catch (err) {
      return LatLng(10.798543, 106.6931094);
    }
  }

  static String get tagCategoryId {
    return GetStorage(storageBox).read(tagCategoryIdStorageKey) ??
        "5f3a491c4e1bd312a6f00003";
  }

  static PetitionCreateRemoteConfigModel get getPetitionCreateConfig {
    return PetitionCreateRemoteConfigModel.fromJson(
        GetStorage(storageBox).read(petitionCreateConfig));
  }

  static String get exceptStatus {
    return GetStorage(storageBox).read(exceptStatusStorageKey) ?? "";
  }
}
