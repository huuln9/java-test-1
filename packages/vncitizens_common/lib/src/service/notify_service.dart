import 'dart:developer';

import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class NotifyService extends GetConnect {
  static const String prefix = "notify";

  NotifyService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iscsApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.accessToken}";
      return request;
    });
  }

  Future<Response> getFcmByReceiver(
      String viewerId, List<String> topics, int page, int size) async {
    Map<String, dynamic> query = {};
    query['provider'] = 'vnCitizens';
    query['topic'] = topics
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '');
    query['viewer'] = viewerId;
    query['sort'] = 'sentDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get("/fcm/--by-receiver", query: query);
  }

  Future<Response> getFcmById(String id) async {
    return await get("/fcm/$id");
  }

  Future<Response> getUnreadNumber(
    String viewerId,
    List<String> topics,
  ) async {
    Map<String, dynamic> query = {};
    query['provider'] = 'vnCitizens';
    query['topic'] = topics
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '');
    query['viewer'] = viewerId;
    return await get("/fcm/--unread-count", query: query);
  }

  Future<Response> markFcmAsRead(Map<String, dynamic> body) async {
    Map<String, dynamic> query = {};
    query['provider'] = 'vnCitizens';
    return await put("/fcm/--read", body,
        contentType: 'application/json', query: query);
  }

  Future<Response> markFcmAsDelete(Map<String, dynamic> body) async {
    Map<String, dynamic> query = {};
    query['provider'] = 'vnCitizens';
    return await put("/fcm/--delete", body,
        contentType: 'application/json', query: query);
  }

  Future<Response> sendOtpMessage(
      {required String message,
      required String phoneNumber,
      required String configId}) async {
    Map<String, String> body = {
      "phoneNumber": phoneNumber,
      "content": message,
      "configId": configId
    };
    return await post("/sms/--send-batch", body,
        contentType: "application/x-www-form-urlencoded");
  }

  Future<Response> sendOtpEmail(
      {required String message,
      required String title,
      required String email,
      required String configId}) async {
    Map<String, String> body = {
      "emailAddress": email,
      "title": title,
      "content": message,
      "configId": configId
    };
    log(body.toString(), name: runtimeType.toString() + ".sendOtpEmail BODY");
    return await post("/email/--send-batch", body,
        contentType: "application/x-www-form-urlencoded");
  }
}
