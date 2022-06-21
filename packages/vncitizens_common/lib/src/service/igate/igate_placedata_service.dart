import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class IGatePlaceDataService extends GetConnect {
  static const String prefix = "ba";
  static const String placeCollection = "/place";

  IGatePlaceDataService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iGateApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.iGateAccessToken}";
      return request;
    });
  }

  Future<Response> getProvinces({String? keyword, String? parentTypeId}) async {
    Map<String, dynamic> query = {};
    if (keyword != null) {
      query['keyword'] = keyword;
    }

    query['nation-id'] = '5f39f4a95224cf235e134c5c';
    query['parent-type-id'] = parentTypeId ?? '5ee304423167922ac55bea01';
    // query['spec'] = 'slice';
    return await get(placeCollection + "/--search", query: query);
  }

  Future<Response> getDistricts(
      {String? keyword,
      required String provinceId,
      String? parentTypeId}) async {
    Map<String, dynamic> query = {};
    if (keyword != null) {
      query['keyword'] = keyword;
    }
    query['nation-id'] = '5f39f4a95224cf235e134c5c';
    query['parent-type-id'] = parentTypeId ?? '5ee304423167922ac55bea02';
    query['parent-id'] = provinceId;
    return await get(placeCollection + "/--search", query: query);
  }

  Future<Response> getWards(
      {String? keyword,
      required String districtId,
      String? parentTypeId}) async {
    Map<String, dynamic> query = {};
    if (keyword != null) {
      query['keyword'] = keyword;
    }
    query['nation-id'] = '5f39f4a95224cf235e134c5c';
    query['parent-type-id'] = parentTypeId ?? '5ee304423167922ac55bea03';
    query['parent-id'] = districtId;
    return await get(placeCollection + "/--search", query: query);
  }
}
