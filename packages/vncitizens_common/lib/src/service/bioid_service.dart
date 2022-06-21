import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:vncitizens_common/dio.dart';
import 'package:vncitizens_common/src/util/common_util.dart';
import '../config/app_config.dart';

class BioIdService {
  static const String _documentsExtractLivenessUri = "/s4/1.0/ocrs/documents/extract/liveness";
  static const String _confirmFaceWithDocumentUri = "/s4/1.0/ocrs/compare_liveness/faces";
  static const String _createPerson = "/s3/1.0/persons";
  static const String _prefixRegisterFace = "/s1/1.0/enrollments/";
  static const String _suffixRegisterFace = "/faces";
  static const String _checkLiveness = "/s1/1.0/liveness/check";
  static const String _prefixConfirmFaceFromFilePath = "/s1/1.0/verifications/";
  static const String _suffixConfirmFaceFromFilePath = "/faces";

  Future<String> getBioIdToken() async {
    Dio dio = Dio();
    Map<String, String> body = {
      'grant_type': 'client_credentials'
    };
    String base64Encoded = base64.encode(utf8.encode(AppConfig.bioidConsumerKey + ":" + AppConfig.bioidConsumerSecret));
    dev.log("bioidConsumerKey: " + AppConfig.bioidConsumerKey, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log("bioidConsumerScret: " + AppConfig.bioidConsumerSecret, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(base64Encoded, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dio.options.headers.addAll({
      'Authorization': 'Basic $base64Encoded',
      'Content-Type': "application/x-www-form-urlencoded"
    });
    Response response = await dio.post(AppConfig.bioidApiEndpoint + "/token", data: body);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.data["access_token"] != null) {
      return response.data["access_token"];
    } else {
      throw "Cannot get BioID token";
    }
  }

  Future<Response<dynamic>> getInfoDocumentFromImage({
    required String cropParam,
    required Uint8List frontSide,
    required Uint8List backSide,
    required String type,
    bool? liveness
  }) async {
    String token = await getBioIdToken();
    MultipartFile frontSideFile = MultipartFile.fromBytes(frontSide, filename: "front.jpg");
    MultipartFile backSideFile = MultipartFile.fromBytes(backSide, filename: "back.jpg");
    FormData formData = FormData.fromMap({
      'front_side': frontSideFile,
      'back_side': backSideFile,
      'type': type,
      'liveness': liveness ?? false
    });
    Dio dio = Dio();
    dio.options.headers.addAll({
      'Authorization': 'Bearer $token',
      'crop_params': cropParam
    });
    return await dio.post(AppConfig.bioidApiEndpoint + _documentsExtractLivenessUri, data: formData);
  }

  Future<Response<dynamic>> confirmFaceWithDocument({
    required Uint8List frontSide,
    required String faceFilePath,
    bool? isFaceCompare,
    bool? livenessFace,
    bool? faceMask
  }) async {
    Dio dio = Dio();
    String token = await getBioIdToken();
    MultipartFile frontSideFile = MultipartFile.fromBytes(frontSide, filename: "front.jpg");
    MultipartFile faceFile = await MultipartFile.fromFile(faceFilePath, filename: "back.jpg");
    FormData formData = FormData.fromMap({
      'file1': frontSideFile,
      'file2': faceFile,
    });
    dio.options.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    String isFaceCompareQuery = isFaceCompare != null ? "?isFaceCompare=" + isFaceCompare.toString() : "?isFaceCompare=false";
    String livenessFaceQuery = livenessFace != null ? "&livenessFace=" + livenessFace.toString() : "&livenessFace=false";
    String faceMaskQuery = faceMask != null ? "&faceMask=" + faceMask.toString() : "&faceMask=false";
    String url = AppConfig.bioidApiEndpoint + _confirmFaceWithDocumentUri + isFaceCompareQuery + livenessFaceQuery + faceMaskQuery;
    return await dio.post(url, data: formData);
  }

  /// [registrationStatus] default is APPROVED. Values: [APPROVED/APPROVING/REJECT/DUPLICATE].
  /// [isPending] default is false.
  /// [status] default is ACTIVE. Values: [ACTIVE/INACTIVE]
  Future<Response<dynamic>> createPerson({
    String? registrationStatus,
    required String identification,
    String? phone,
    String? email,
    bool? isPending,
    String? status,
  }) async {
    /// check registrationStatus
    List<String> registrationStatusValues = ["APPROVED","APPROVING","REJECT","DUPLICATE"];
    if (registrationStatus != null && !registrationStatusValues.contains(registrationStatus)) {
      throw "Invalid registrationStatus. Must be in: ${registrationStatusValues.toString()}";
    }
    /// check status
    List<String> statusValues = ["ACTIVE","INACTIVE"];
    if (status != null && !statusValues.contains(status)) {
      throw "Invalid status. Must be in: ${statusValues.toString()}";
    }
    Dio dio = Dio();
    String token = await getBioIdToken();
    Options options = Options(
      contentType: Headers.jsonContentType,
      headers: {'Authorization': 'Bearer $token'}
    );
    Map<String, dynamic> body = {
      "registrationStatus": registrationStatus ?? "APPROVED",
      "identification": identification,
      "phone": phone,
      "email": email,
      "isPending": isPending ?? false,
      "status": status ?? "ACTIVE"
    };
    String url = AppConfig.bioidApiEndpoint + _createPerson;
    return await dio.post(url, data: body, options: options);
  }

  Future<Response<dynamic>> registerFaceFromImage({required String personId, required String faceFilePath}) async {
    MultipartFile faceFile = await MultipartFile.fromFile(faceFilePath, filename: "face.jpg");
    FormData formData = FormData.fromMap({
      'file': faceFile,
    });
    Dio dio = Dio();
    String token = await getBioIdToken();
    Options options = Options(
        contentType: Headers.jsonContentType,
        headers: {'Authorization': 'Bearer $token'}
    );
    String url = AppConfig.bioidApiEndpoint + _prefixRegisterFace + personId + _suffixRegisterFace;
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await dio.post(url, data: formData, options: options);
  }

  Future<Response<dynamic>> checkLiveness({required String faceFilePath}) async {
    MultipartFile faceFile = await MultipartFile.fromFile(faceFilePath, filename: "face.jpg");
    FormData formData = FormData.fromMap({
      'faceImage': faceFile,
    });
    Dio dio = Dio();
    String token = await getBioIdToken();
    Options options = Options(
      contentType: Headers.jsonContentType,
      headers: {'Authorization': 'Bearer $token'}
    );
    String url = AppConfig.bioidApiEndpoint + _checkLiveness;
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await dio.post(url, data: formData, options: options);
  }

  Future<Response<dynamic>> confirmFaceFromFilePath({required String personId, required String faceFilePath}) async {
    MultipartFile faceFile = await MultipartFile.fromFile(faceFilePath, filename: "faceConfirm.jpg");
    FormData formData = FormData.fromMap({
      'file': faceFile,
    });
    Dio dio = Dio();
    String token = await getBioIdToken();
    Options options = Options(
        contentType: Headers.jsonContentType,
        headers: {'Authorization': 'Bearer $token'}
    );
    String url = AppConfig.bioidApiEndpoint + _prefixConfirmFaceFromFilePath + personId + _suffixConfirmFaceFromFilePath;
    dev.log(url, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return await dio.post(url, data: formData, options: options);
  }
}