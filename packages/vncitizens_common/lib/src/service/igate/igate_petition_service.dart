import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class IGatePetitionService extends GetConnect {
  static const String prefix = "pe";
  static const String collectionName = "/petition";

  IGatePetitionService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iGateApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.iGateAccessToken}";
      return request;
    });
  }

  Future<Response> getList(int page, int size,
      {String? keyword,
      String? status,
      String? tagId,
      String? parentId,
      String? parentTagId,
      String? userId,
      String? exceptStatus,
      String? startDate,
      String? endDate}) async {
    Map<String, dynamic> query = {};
    if (keyword != null && keyword != '') {
      query['keyword'] = keyword;
    }
    if (status != null && status != '') {
      query['status'] = status;
    }
    if (tagId != null && tagId != '') {
      query['tag-id'] = tagId;
    }
    if (parentId != null && parentId != '') {
      query['parent-id'] = parentId;
    }
    if (parentTagId != null && parentTagId != '') {
      query['parent-tag-id'] = parentTagId;
    }
    if (userId != null && userId != '') {
      query['user-id'] = userId;
    }
    if (exceptStatus != null && exceptStatus.isNotEmpty) {
      query['except-status'] = exceptStatus.toString();
    }
    if (startDate != null && startDate != '') {
      query['start-date'] = startDate;
    }
    if (endDate != null && endDate != '') {
      query['end-date'] = endDate;
    }
    query['sort'] = 'createdDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get(collectionName + "/--by-categories-v2", query: query);
  }

  Future<Response> getDetail(String id) async {
    return await get(collectionName + "/$id");
  }

  Future<Response> create(Map<String, dynamic> body) async {
    String url = collectionName;
    log(body.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await post(url, body, contentType: "application/json");
  }

  Future<Response> getById(String id) async {
    String url = collectionName + "/" + id;
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url);
  }

  Future<Response> updateEvaluation(String id, Map<String, String> body) async {
    String url = collectionName + "/" + id + "/--evaluation";
    final formData = FormData(body);
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await put(url, formData, contentType: "multipart/form-data");
  }

  Future<Response> deletePetition(String id) async {
    String url = collectionName + "/" + id + '/--citizens-delete';
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await delete(url);
  }

  Future<Response> updatePetition(String id, Map<String, dynamic> body) async {
    String url = collectionName + "/" + id + '/--citizens-update';
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await put(url, body);
  }
}
