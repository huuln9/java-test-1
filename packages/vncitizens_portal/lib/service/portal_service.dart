import 'dart:convert';
import 'dart:developer';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common/http.dart' as http;
import 'package:vncitizens_portal/src/config/app_config.dart';
import 'package:vncitizens_portal/src/controller/portal_controller.dart';
import 'package:vncitizens_portal/src/model/category_model.dart';
import 'package:vncitizens_portal/src/model/news_model.dart';

class PortalService extends GetConnect {
  Future<String> getToken({
    required String endpoint,
    required String username,
    required String password,
  }) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    Map<String, String> headers = {'Authorization': basicAuth};
    Map<String, String> body = {"grant_type": "client_credentials"};

    Response resp = await post(endpoint, body,
        headers: headers, contentType: 'application/x-www-form-urlencoded');
    if (resp.statusCode == 200) {
      return resp.body['access_token'];
    }
    throw Exception(resp.body);
  }

  Future<List<CategoryModel>> getCategoryByResource(String endpoint) async {
    PortalController controller = Get.find();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${controller.token}'
    };
    http.Response resp = await http
        .get(Uri.parse("$endpoint/DanhSachChuyenMuc"), headers: headers);
    if (resp.statusCode == 200) {
      final jsList = jsonDecode(resp.body);
      List<CategoryModel> list = CategoryModel.fromArray(jsList, endpoint);
      return list;
    }
    throw Exception(resp.body);
  }

  Future<List<NewsModel>> _getNewsByCategory(
      {required String endpoint, required String categoryId}) async {
    PortalController controller = Get.find();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${controller.token}'
    };
    String keyQuery =
        '&p=' + controller.page.toString() + '&s=' + AppConfig.size;
    http.Response resp = await http.get(
        Uri.parse(
            "$endpoint/DanhSachBaiViet?idchuyenmuc=" + categoryId + keyQuery),
        headers: headers);
    if (resp.statusCode == 200) {
      final jsList = jsonDecode(resp.body)['content'];
      List<NewsModel> list = NewsModel.fromArray(jsList, endpoint);
      return list;
    }
    throw Exception(resp.body);
  }

  Future<List<NewsModel>> getAllNewsByActive() async {
    PortalController controller = Get.find();
    List<NewsModel> listNews = [];
    for (var resource in controller.resources) {
      if (resource.active) {
        // Get access token for that resource
        try {
          controller.token.value = await getToken(
            endpoint: resource.tokenEndpoint,
            username: resource.username ?? '',
            password: resource.password ?? '',
          );
          log('Get token successfully: ' + controller.token.value,
              name: AppConfig.packageName);
        } catch (e) {
          log('portal_service:81: ' + e.toString(),
              name: AppConfig.packageName);
        }

        // Get news by categories of that resource
        for (var category in controller.categories) {
          if (category.resource == resource.apiEndpoint && category.active) {
            try {
              List<NewsModel> list = await _getNewsByCategory(
                  endpoint: resource.apiEndpoint,
                  categoryId: category.id.toString());
              // Sort by date
              list.sort(((b, a) => DateFormat('dd/MM/yyyy')
                  .parse(a.createDate)
                  .compareTo(DateFormat('dd/MM/yyyy').parse(b.createDate))));
              listNews.addAll(list);
              log(
                  'Get news by category ' +
                      category.id.toString() +
                      ' ' +
                      resource.apiEndpoint +
                      ' successfully',
                  name: AppConfig.packageName);
            } catch (e) {
              log(
                  'Get news by category ' +
                      category.id.toString() +
                      ' ' +
                      resource.apiEndpoint +
                      ' failure, detail: ' +
                      e.toString(),
                  name: AppConfig.packageName);
            }
          }
        }
      }
    }
    return listNews;
  }

  Future<NewsModel> getNewsDetail(
      {required String endpoint, required String newsId}) async {
    PortalController controller = Get.find();
    Map<String, String> headers = {
      'Authorization': 'Bearer ${controller.token}'
    };
    http.Response resp = await http.get(
        Uri.parse("$endpoint/ChiTietBaiViet?idtintuc=" + newsId),
        headers: headers);
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      NewsModel news = NewsModel.fromJson(json);
      return news;
    }
    throw Exception(resp.body);
  }
}
