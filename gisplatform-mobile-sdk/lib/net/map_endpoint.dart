import 'package:flutter_vnpt_map/m_config.dart';

class Endpoint {
  ///
  static String _directionUrl = MConfig().getDirectionUrl();
  static String _placeUrl = MConfig().getPlaceUrl();
  static String _basemapUrl = MConfig().getBasemapUrl();

  /// Tìm kiếm toạ độ theo địa chỉ
  static String placesLatlngByAddress() {
    return _placeUrl + '/geocoding/latlong_by_address';
  }

  /// Tìm kiếm địa chỉ theo toạ độ
  static String placesAddressByLatlng() {
    return _placeUrl + '/geocoding/address_by_latlong';
  }

  /// Tìm kiếm đối tượng trong phạm vị bán kính cho phép
  static String placesNearBySearch() {
    return _placeUrl + '/geocoding/nearby_search';
  }

  /// Tìm kiếm đối tượng trên tuyến đường
  static String placesNearByRoad() {
    return _placeUrl + '/geocoding/nearby_road';
  }

  /// Ranh giới hành chính theo tỉnh – thành phố
  static String placesPolygonProvince() {
    return _basemapUrl + '/geoboundaries/province_polygon';
  }

  /// Tìm đường
  static String directFindPath() {
    return _directionUrl + '/path';
  }

  /// Vùng phủ của 1 điểm
  static String directIsochrone() {
    return _directionUrl + '/isochrone';
  }

  /// Vùng phủ của 2 điểm
  static String directIsochrones() {
    return _directionUrl + '/isochrones';
  }

  /// Danh sách các đối tượng giữa 2 vùng phủ
  static String directLabelFromIsochrone() {
    return _directionUrl + '/isochrone/labels';
  }

  /// Các tuyến đường đến các đối tượng theo loại phương tiện, loại địa vật, vị trí..
  static String directFacitityClosest() {
    return _directionUrl + '/facility/closest';
  }
}
