import 'dart:developer' as dev;

import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class DirectoryService extends GetConnect {
  static const String prefix = "directory";

  DirectoryService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iscsApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.accessToken}";
      return request;
    });
  }

  Future<Response> getAllTagActivated(
      {String? keyword,
        String? categoryId,
        String? parentId,
        String? nationId,
        String? deploymentId,
        String? sortBy,
        int? size,
        int? page,
        String? spec
      }) async {
    String keywordQuery = keyword != null ? "&keyword=" + keyword : "";
    String categoryIdQuery = categoryId != null ? "&category-id=" + categoryId : "";
    String parentIdQuery = parentId != null ? "&parent-id=" + parentId : "";
    String nationIdQuery = nationId != null ? "&nation-id=" + nationId : "";
    String deploymentIdQuery = deploymentId != null ? "&deployment-id=" + deploymentId : "";
    String sortByQuery = sortBy != null ? "&sort=" + sortBy : "";
    String specQuery = spec != null ? "&spec=" + spec.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "&page=0";
    String sizeQuery = size != null ? "&size=" + size.toString() : "&size=100";
    return await get(
        "/tag?status=1$keywordQuery$categoryIdQuery$parentIdQuery$nationIdQuery$deploymentIdQuery$sortByQuery$specQuery$pageQuery$sizeQuery");
  }

  Future<Response> getTagsByCategoryId(
      String categoryId, int page, int size) async {
    Map<String, dynamic> query = {};
    query['category-id'] = categoryId;
    query['status'] = '1';
    query['sort'] = 'order,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get("/tag/--by-category-id", query: query);
  }

  Future<Response> getAllIdentityIssuePlaces(
      {required String tagId, int? page, int? size, int? status, String? spec}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String pageQuery = page != null ? "&page=" + page.toString() : "&page=0";
    String sizeQuery = size != null ? "&size=" + size.toString() : "&size=100";
    String statusQuery = status != null ? "&status=" + status.toString() : "&status=1";
    String specQuery = spec != null ? "&spec=" + spec.toString() : "";
    String url =
        "/agency/name?tag-id=$tagId$pageQuery$sizeQuery$statusQuery$specQuery";
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url, headers: headers);
  }

  /// [keyword] default value is empty
  /// [status] default value is 1
  /// [spec] default value is empty
  /// [page] default value is 0
  /// [size] default value is 100
  Future<Response> getNations({
    String? keyword,
    String? spec,
    int? status,
    int? page,
    int? size,
    String? deploymentId,
  }) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String keywordQuery = keyword != null ? "?keyword=" + keyword : "?keyword=";
    String statusQuery = status != null ? "&status=" + status.toString() : "&status=1";
    String specQuery = spec != null ? "&spec=" + spec.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "&page=0";
    String sizeQuery = size != null ? "&size=" + size.toString() : "&size=100";
    String url =
        "/nation" + keywordQuery + statusQuery + pageQuery + sizeQuery + specQuery;
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url, headers: headers);
  }

  /// [status] default value is 1
  /// [page] default value is 0
  /// [size] default value is 100
  Future<Response> getTags({
    String? keyword,
    String? categoryId,
    String? nationId,
    String? parentId,
    String? spec,
    int? status,
    int? page,
    int? size,
    String? sortBy,
  }) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    String keywordQuery = keyword != null ? "?keyword=" + keyword : "?keyword=";
    String categoryIdQuery = categoryId != null ? "&category-id=" + categoryId : "";
    String nationIdQuery = nationId != null ? "&nation-id=" + nationId : "";
    String parentIdQuery = parentId != null ? "&parent-id=" + parentId : "";
    String statusQuery = status != null ? "&status=" + status.toString() : "&status=1";
    String specQuery = spec != null ? "&spec=" + spec.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "&page=0";
    String sizeQuery = size != null ? "&size=" + size.toString() : "&size=100";
    String sortByQuery = sortBy != null ? "&sort=" + sortBy : "";
    String url = "/tag" +
        keywordQuery +
        categoryIdQuery +
        nationIdQuery +
        parentIdQuery +
        specQuery +
        statusQuery +
        pageQuery +
        sizeQuery +
        sortByQuery;
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url, headers: headers);
  }
}
