import 'dart:convert';
import 'dart:developer';

import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class StorageService extends GetConnect {
  static const String _prefix = "storage";

  static Map<String, dynamic> get minioAccess {
    final minio = AppConfig.minioMap;
    return {
      "serviceUrl": minio["serviceUrl"],
      "accessKey": minio["connect"]["accessKey"],
      "secretKey": minio["connect"]["secretKey"],
      "bucketName": minio["bucketNamePrefix"] + minio["bucket"],
    };
  }

  StorageService() {
    httpClient.baseUrl = "${AppConfig.iscsApiEndpoint}/$_prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.accessToken}";
      return request;
    });
  }

  Future<Response> saveMinioFileInfo({
    String? filename,
    String? extension,
    String? mimeType,
    required int size,
    String? imageScale,
    required String path,
    String? userId
  }) async {
    Map<String, dynamic> body = {
      'filename': filename ?? "avatar.jpg",
      'extension': extension ?? "jpg",
      'mimeType': mimeType ?? "image/jpeg",
      'userId': userId,
      'size': size,
      'path': path,
      'imageScale': imageScale
    };
    if (userId == null) {
      body.remove("userId");
    }
    log(jsonEncode(body), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await post("/file", jsonEncode(body), contentType: "application/json");
  }

  Future<Response> getFileDetail({required String id}) async {
    return await get("/file/$id");
  }
}