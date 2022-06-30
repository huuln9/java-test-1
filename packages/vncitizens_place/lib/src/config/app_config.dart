import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

class AppConfig {
  /// your package template
  static const String packageName = "vncitizens_place";

  /// storage box name
  static const String storageBox = packageName;

  static const String tagCategoryIdStorageKey = "tagCategoryId";
  static const String centerLocationStorageKey = "centerLocation";
  // static const String hcmOpenData = "hcm_opendata";
  static const String configTypeView = "config_type_view";
  static const String placeDetailViewMap = "place_detail_view_map";

  /// subscribe to topics
  static const List<String> fcmSubscribeTopics = ["notification", "weather"];

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // Add more config properties...
  // static String get tagCategoryId {
  //   return GetStorage(storageBox).read(tagCategoryIdStorageKey);
  // }

  static const Color materialMainBlueColor = Color.fromRGBO(21, 101, 192, 1);

  static bool isCurrentLocation = false;

  static LatLng get centerLocation {
    try {
      // final GetStorage _storage = GetStorage("vncitizens_home");
      // Position position = _storage.read("position");
      // if (position != null) {
      //   isCurrentLocation = true;
      //   return LatLng(position.latitude, position.longitude);
      // }
      return LatLng(
          GetStorage(storageBox).read(centerLocationStorageKey)["lat"],
          GetStorage(storageBox).read(centerLocationStorageKey)["long"]);
    } catch (err) {
      return LatLng(10.798543, 106.6931094);
    }
  }

  // static String get schoolCategoryResourceId {
  //   return GetStorage(storageBox).read(hcmOpenData)['schoolCategoryResourceId'];
  // }

  static int get getConfigTypeView {
    return GetStorage(storageBox).read(configTypeView);
  }

  static bool get getPlaceDetailViewMap {
    return GetStorage(storageBox).read(placeDetailViewMap);
  }
}
