import 'package:get_storage/get_storage.dart';

class AppConfig {

  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_nature";

  // ------------------------------------
  // OPTIONAL UPDATE
  // ------------------------------------

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  /// storage box name
  static const String storageBox = packageName;

  /// config storage key
  static const String configStorageKey = "config";

  static double get defaultLatitude {
    return GetStorage(storageBox).read(configStorageKey)["defaultLocation"]["latitude"];
  }

  static double get defaultLongitude {
    return GetStorage(storageBox).read(configStorageKey)["defaultLocation"]["longitude"];
  }

// add more property

}