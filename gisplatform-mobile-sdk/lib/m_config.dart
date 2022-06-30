import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';

class MConfig {
  static final MConfig _instance = MConfig._internal();
  MConfig._internal();
  factory MConfig() => _instance;

  late Env _env;

  setupEnv({
    Env? env,
  }) {
    _env = env ?? Env.prod;
  }

  String _getServerUrl() {
    return _env == Env.prod
        ? 'https://maps.vnpt.vn'
        : 'https://gis-dev.vdc2.com.vn';
  }

  ///
  String getDirectionUrl() => _getServerUrl() + '/kong/api/directions/v1';

  ///
  String getPlaceUrl() => _getServerUrl() + '/kong/api/places/v1';

  ///
  String getBasemapUrl() => _getServerUrl() + '/kong/api/basemap/v1';

  ///
  String getBaseTiles() =>
      _getServerUrl() + '/tiles/mapvnpt/v1/{z}/{x}/{y}.png';

  /// Props
  static LatLng getInitLatLngPosition() => LatLng(
        10.7852113,
        106.6932453,
      );
  static const double ZOOM = 13.0;
  static const double MIN_ZOOM = 0.0;
  static const double MAX_ZOOM = 18.0;
  static const double ROTATE = 0.0;
  static const double TITLE_SIZE = 256.0;
  static bool showLog = false;
}
