import 'package:flutter_vnpt_map/flutter_vnpt_map.dart';
import 'package:flutter_vnpt_map/model/base_resp.dart';
import 'package:flutter_vnpt_map/model/latlng_by_address_input.dart';
import 'package:flutter_vnpt_map/net/map_endpoint.dart';
import 'package:flutter_vnpt_map/net/map_http_helper.dart';


abstract class _BaseService {
  Future<BaseResp> getRoute(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getNearbyRoad(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getNearbySearch(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getLatlngByAddress(
    String accessToken,
    LatlngByAddressInput input,
  );
  Future<BaseResp> getAddressByLatlng(
    String accessToken,
    LatLng point,
  );
  Future<BaseResp> getProvincePolygon(
    String accessToken,
    String input,
  );
  Future<BaseResp> getIsochrone(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getIsochrones(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getLabelBetweenIsochrones(
    String accessToken, {
    required Map<String, dynamic> data,
  });
  Future<BaseResp> getFacilityClosest(
    String accessToken, {
    required Map<String, dynamic> data,
  });
}

class MapRepository implements _BaseService {
  @override
  Future<BaseResp> getRoute(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.directFindPath();
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.post,
      body: data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getNearbyRoad(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.placesNearByRoad();
    return MapHttpHelper.onGetWithBody(
      endpoint,
      data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getNearbySearch(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    return MapHttpHelper.onGetWithBody(
      Endpoint.placesNearBySearch(),
      data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getAddressByLatlng(
    String accessToken,
    LatLng point,
  ) {
    String lat = 'lat=' + point.latitude.toString();
    String lng = 'lon=' + point.longitude.toString();
    String endpoint = Endpoint.placesAddressByLatlng() + '?' + lat + '&' + lng;
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.get,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getLatlngByAddress(
    String accessToken,
    LatlngByAddressInput input,
  ) {
    String q =
        !VnptMapUtils.isNullOrBlank(input.q) ? 'q=address:${input.q}' : '';
    String address = !VnptMapUtils.isNullOrBlank(input.address)
        ? '&address=' + input.address!
        : '';
    String endpoint = Endpoint.placesLatlngByAddress() + '?' + q + address;
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.get,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getProvincePolygon(
    String accessToken,
    String input,
  ) {
    String endpoint = Endpoint.placesPolygonProvince() + '?ids=' + input;
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.get,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getIsochrone(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.directIsochrone();
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.post,
      body: data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getIsochrones(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.directIsochrones();
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.post,
      body: data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getLabelBetweenIsochrones(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.directLabelFromIsochrone();
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.post,
      body: data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }

  @override
  Future<BaseResp> getFacilityClosest(
    String accessToken, {
    required Map<String, dynamic> data,
  }) {
    String endpoint = Endpoint.directFacitityClosest();
    return MapHttpHelper.invokeHttp(
      endpoint,
      RequestType.post,
      body: data,
      headers: MapHttpHelper.getDefHeaders(
        accessToken: accessToken,
      ),
    );
  }
}
