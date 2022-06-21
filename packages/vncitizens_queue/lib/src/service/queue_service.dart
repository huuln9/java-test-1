import 'dart:developer';

import 'package:get/get_connect/connect.dart';
import 'package:vncitizens_common/src/config/app_config.dart'
    as app_config_common;
import 'package:vncitizens_account/src/util/AuthUtil.dart';

import '../config/app_config.dart';

class QueueService extends GetConnect {
  Future<Response> getAccessToken() async {
    Map<String, dynamic> body = {
      "grant_type": "client_credentials",
      "client_id": AppConfig.clientId,
      "client_secret": AppConfig.clientSecret,
      "scope": "openid"
    };
    return await post(AppConfig.ssoQueueEndpoint, body,
        contentType: "application/x-www-form-urlencoded");
  }

  Future<Response> getListAgency(
      {String? keyword, int? page, int? size}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${AppConfig.accessToken}'
    };

    log(AppConfig.parentId.toString());
    String keywordQuery = keyword != null ? "keyword=" + keyword : "";
    String parentIdQuery = "&parent-id=" + AppConfig.parentId.toString();
    String sizeQuery = size != null ? "&size=" + size.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "";
    return await get(
        "${AppConfig.apiQueueEndpoint}/ba/agency?" +
            keywordQuery +
            parentIdQuery +
            sizeQuery +
            pageQuery,
        headers: headers);
  }

  Future<Response> getListReception(
      {String? agencyId, String? userId, int? page, int? size}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${AppConfig.accessToken}'
    };

    String agencyIdQuery =
        agencyId != null ? "agency-id=" + agencyId.toString() : "";
    String userIdQuery = userId != null ? "&user-id=" + userId.toString() : "";
    String sizeQuery = size != null ? "&size=" + size.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "";
    log("${AppConfig.apiQueueEndpoint}/qu/counter/--screen?" +
        agencyIdQuery +
        userIdQuery +
        sizeQuery +
        pageQuery);
    return await get(
        "${AppConfig.apiQueueEndpoint}/qu/counter/--screen?" +
            agencyIdQuery +
            userIdQuery +
            sizeQuery +
            pageQuery,
        headers: headers);
  }

  Future<Response> postOrderNumber(
      {String? userId, String? officials, String? queueId}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${AppConfig.accessToken}'
    };

    return await post(
        "${AppConfig.apiQueueEndpoint}/qu/queue-data",
        {
          "queue": {"id": queueId},
          "officials": [officials],
          "userId": userId
        },
        headers: headers);
  }

  Future<Response> putCancelNumber({String? numberId}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${AppConfig.accessToken}'
    };
    String numberIdQuery = numberId != null ? numberId.toString() : "";
    String orderQuery = "order=1";
    String statusQuery = "&status=3";

    log('' + numberIdQuery);
    return await put(
        "${AppConfig.apiQueueEndpoint}/qu/queue-data/$numberIdQuery/--change-status?" +
            orderQuery +
            statusQuery,
        {},
        headers: headers);
  }

  Future<Response> getInfo() async {
    String? id = AuthUtil.userId;
    Map<String, String> headers = {
      'Authorization': 'Bearer ${app_config_common.AppConfig.accessToken}'
    };

    return await get(
        "${app_config_common.AppConfig.iscsApiEndpoint}/auth/user/$id/--fully",
        headers: headers);
  }
}
