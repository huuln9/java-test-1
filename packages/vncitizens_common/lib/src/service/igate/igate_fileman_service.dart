import 'dart:typed_data';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:http/http.dart' as http;

class IGateFilemanService extends GetConnect {
  static const String prefix = "fi";
  static const String collectionName = "/file";
  late final dio.Dio _dio;

  IGateFilemanService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iGateApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.iGateAccessToken}";
      return request;
    });

    final dio.BaseOptions _options = dio.BaseOptions(
        baseUrl: AppConfig.iGateApiEndpoint,
        connectTimeout: 60000,
        receiveTimeout: 60000,
        headers: {'Authorization': 'Bearer ${AppConfig.iGateAccessToken}'});
    _dio = dio.Dio(_options);
  }

  Future<dio.Response> uploadFile(
      {required List<dio.MultipartFile> files, String? accountId}) async {
    String url = '/$prefix' + collectionName + "/--multiple";
    var _data = <String, dynamic>{};

    if (accountId != null) {
      _data["account-id"] = accountId;
    }
    _data['files'] = files;
    var body = dio.FormData.fromMap(_data);
    return await _dio.post(url,
        data: body, options: dio.Options(contentType: "multipart/form-data"));
  }

  Future<http.Response> downloadFile({required String id}) async {
    String url =
        "${AppConfig.iGateApiEndpoint}/$prefix" + collectionName + "/" + id;
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${AppConfig.iGateAccessToken}'});
    return response;
  }

  Future<void> saveFile(
      {required String id,
      required String filePathLocal,
      Function(int, int)? onReceiveProgress}) async {
    String url = "/$prefix" + collectionName + "/" + id;
    await _dio.download(url, filePathLocal,
        onReceiveProgress: onReceiveProgress);
    // return response;
  }

  Future<Map<String, dynamic>> getOptionFile({required String id}) async {
    String url =
        "${AppConfig.iGateApiEndpoint}/$prefix" + collectionName + "/" + id;
    return {
      'url': url,
      'headers': {'Authorization': 'Bearer ${AppConfig.iGateAccessToken}'}
    };
  }

  Future<Response> getFileInfo({required String id}) async {
    return await get(collectionName + "/" + id + "/filename+size");
  }
}
