import 'dart:developer' as dev;
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class LocationService extends GetConnect {
  static const String prefix = "location";

  LocationService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iscsApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.accessToken}";
      return request;
    });
  }

  Future<Response> getPlaces(int page, int size,
      {String? keyword,
      String? tagCategoryId,
      String? tagId,
      String? parentId,
      String? parentTagId}) async {
    Map<String, dynamic> query = {};
    if (keyword != null) {
      query['keyword'] = keyword;
    }
    if (tagCategoryId != null) {
      query['tag-category-id'] = tagCategoryId;
    }
    if (tagId != null) {
      query['tag-id'] = tagId;
    }
    if (parentId != null) {
      query['parent-id'] = parentId;
    }
    if (parentTagId != null) {
      query['parent-tag-id'] = parentTagId;
    }
    query['status'] = '1';
    query['spec'] = 'page';
    query['sort'] = 'createdDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get("/place", query: query);
  }

  Future<Response> getPlaceNames(int page, int size,
      {String? keyword, String? tagCategoryId, String? tagId}) async {
    Map<String, dynamic> query = {};
    if (keyword != null) {
      query['keyword'] = keyword;
    }
    if (tagCategoryId != null) {
      query['tag-category-id'] = tagCategoryId;
    }
    if (tagId != null) {
      query['tag-id'] = tagId;
    }
    query['status'] = '1';
    query['sort'] = 'createdDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get("/place/name", query: query);
  }

  Future<Response> getVPlaces({
    String? keyword,
    String? categoryId,
    String? tagId,
    String? nationId,
    String? parentId,
    String? spec,
    int? status,
    int? page,
    int? size,
    String? sortBy,
  }) async {
    String keywordQuery = keyword != null ? "?keyword=" + keyword : "?keyword=";
    String categoryIdQuery =
        categoryId != null ? "&tag-category-id=" + categoryId : "";
    String tagIdQuery = tagId != null ? "&tag-id=" + tagId : "";
    String nationIdQuery = nationId != null ? "&nation-id=" + nationId : "";
    String parentIdQuery = parentId != null ? "&parent-id=" + parentId : "";
    String statusQuery =
        status != null ? "&status=" + status.toString() : "&status=1";
    String specQuery = spec != null ? "&spec=" + spec.toString() : "";
    String pageQuery = page != null ? "&page=" + page.toString() : "&page=0";
    String sizeQuery = size != null ? "&size=" + size.toString() : "&size=100";
    String sortByQuery = sortBy != null ? "&sort=" + sortBy : "";
    String url = "/place" +
        keywordQuery +
        categoryIdQuery +
        tagIdQuery +
        nationIdQuery +
        parentIdQuery +
        statusQuery +
        specQuery +
        pageQuery +
        sizeQuery +
        sortByQuery;
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url);
  }

  Future<Response> getPlaceById({required String id}) async {
    String url = "/place/" + id;
    dev.log(url,
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await get(url);
  }

  Future<Response> addressDecomposition(
      {required String fullAddress, int? order}) async {
    Map<String, dynamic> data = {
      'data': [
        {'fullAddress': fullAddress, 'order': order ?? 1}
      ]
    };

    return await post("/place/--address-decomposition", data);
  }
}
