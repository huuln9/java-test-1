import 'dart:convert';
import 'dart:developer' as dev;

import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdministrativeDocumentService extends GetConnect {
  Future<String> _getToken() async {
    String url = AppConfig.administrativeDocTokenEndpoint;
    String base64Encoded =
        base64.encode(utf8.encode(AppConfig.administrativeDocConsumerKey + ":" + AppConfig.administrativeDocConsumerSecret));
    Response response = await post(url, {
      "grant_type": "client_credentials"
    }, headers: {
      'Authorization': 'Basic $base64Encoded',
    }, contentType: "application/x-www-form-urlencoded");
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.body["access_token"] != null) {
      return response.body["access_token"];
    } else {
      throw "Cannot get Administrative Document token";
    }
  }

  Future<Response> getDocuments({String? keyword, int? page, int? size}) async {
    // String token = await _getToken();
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    Map<String, dynamic> query = {};
    query["keyword"] = keyword ?? "";
    query["page"] = page?.toString() ?? "0";
    query["size"] = size?.toString() ?? "30";
    String url = AppConfig.administrativeDocAPIEndpoint;
    Response response = await get(url, headers: headers, query: query);
    return response;
  }

  Future<Response> getDocumentById({required String id}) async {
    // String token = await _getToken();
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String url = AppConfig.administrativeDocAPIEndpoint + "/$id";
    Response response = await get(url, headers: headers);
    return response;
  }
}
