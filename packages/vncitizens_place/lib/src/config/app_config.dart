import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

class AppConfig {
  /// your package template
  static const String packageName = "vncitizens_place";

  /// storage box name
  static const String storageBox = packageName;

  static const String tagCategoryIdStorageKey = "tagCategoryId";
  static const String centerLocationStorageKey = "centerLocation";
  static const String configViewMapStorageKey = "config_view_map";

  /// subscribe to topics
  static const List<String> fcmSubscribeTopics = ["notification", "weather"];

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  // Add more config properties...
  static String get tagCategoryId {
    return GetStorage(storageBox).read(tagCategoryIdStorageKey);
  }

  static int get configViewMap {
    return GetStorage(storageBox).read(configViewMapStorageKey);
  }

  static bool isCurrentLocation = false;

  static LatLng get centerLocation {
    try {
      final GetStorage _storage = GetStorage("vncitizens_home");
      Position position = _storage.read("position");
      isCurrentLocation = true;
      // return LatLng(position.latitude, position.longitude);
      return LatLng(
          GetStorage(storageBox).read(centerLocationStorageKey)["lat"],
          GetStorage(storageBox).read(centerLocationStorageKey)["long"]);
    } catch (err) {
      return LatLng(10.357691, 106.367009);
    }
  }
}
