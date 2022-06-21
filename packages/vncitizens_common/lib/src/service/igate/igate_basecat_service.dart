import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class IGateBasecatService extends GetConnect {
  static const String prefix = "bt";
  static const String tagCollection = "/tag";

  IGateBasecatService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iGateApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.iGateAccessToken}";
      return request;
    });
  }

//Lĩnh vực
  Future<Response> getCategories(int page, int size,
      {required String categoryId}) async {
    Map<String, dynamic> query = {};
    query['category-id'] = categoryId;
    query['status'] = '1';
    query['sort'] = 'createdDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get(tagCollection + "/--by-parent-id", query: query);
  }

//chuyên mục
  Future<Response> getTags(int page, int size,
      {required String categoryId, String? parentId}) async {
    Map<String, dynamic> query = {};
    query['category-id'] = categoryId;
    if (parentId != null) {
      query['parent-id'] = parentId;
    }
    query['status'] = '1';
    query['sort'] = 'createdDate,desc';
    query['page'] = "$page";
    query['size'] = "$size";
    return await get(tagCollection + "/--by-category-id", query: query);
  }

  // Lấy chi tiết chuyên mục hoặc nhãn
  Future<Response> getTagInfo({required String id}) async {
    return await get(tagCollection + "/" + id);
  }
}
