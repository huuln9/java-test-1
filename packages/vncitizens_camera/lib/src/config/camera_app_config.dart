import 'package:vncitizens_common/vncitizens_common.dart';

class CameraAppConfig {
  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_camera";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  /// config storage key
  static const String configStorageKey = "config";

  static double get defaultLatitude {
    return GetStorage(storageBox).read(configStorageKey)["defaultLocation"]["latitude"];
  }

  static double get defaultLongitude {
    return GetStorage(storageBox).read(configStorageKey)["defaultLocation"]["longitude"];
  }

  static String get cameraTagCategoryId {
    return GetStorage(storageBox).read(configStorageKey)["cameraTagCategoryId"];
  }

  static bool get enableMap {
    return GetStorage(storageBox).read(configStorageKey)["enableMap"];
  }
}
