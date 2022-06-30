import 'dart:developer' as dev;

import 'package:vncitizens_common/vncitizens_common.dart';
import '../config/app_config.dart';

class HCMResourceService extends GetConnect {
  HCMResourceService() {
    httpClient.defaultContentType = 'application/json';
    print(AppConfig.hcmOpenDataEndPoint.toString());
    httpClient.baseUrl = AppConfig.hcmOpenDataEndPoint;
    // httpClient.addAuthenticator<dynamic>((request) async {
    //   return request;
    // });
  }

  Future<Response> getCategoriesResources(String id) async {
    var url = "/3/action/package_show";
    return await get(url, query: {'id': id});
  }

  Future<Response> getPlacesResources(
      {required String id,
      required int limit,
      required int offset,
      String? keySearch}) async {
    var url = "/action/datastore/search.json";

    Map<String, dynamic> query = {};
    query['resource_id'] = id;
    query['limit'] = limit.toString();
    query['offset'] = offset.toString();
    if (keySearch != null) {
      query['q'] = keySearch;
    }
    return await get(url, query: query);
  }
}

class HCMLocationService extends GetConnect {
  HCMLocationService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = AppConfig.vietbandoApiEndpoint;
  }

  Future<Response> searchLocal(String keyword,
      {int? page, int? pageSize}) async {
    return await post(
        "", {"Keyword": keyword, "Page": page ?? 1, "PageSize": pageSize ?? 10},
        headers: {'RegisterKey': AppConfig.vietbandoRegisterKey});
  }
}
