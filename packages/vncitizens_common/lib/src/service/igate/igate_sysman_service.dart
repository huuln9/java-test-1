import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class IGateSysmanService extends GetConnect {
  static const String prefix = "sy";
  static const String collectionName = "/otp";

  IGateSysmanService() {
    httpClient.defaultContentType = 'application/json';
    httpClient.baseUrl = "${AppConfig.iGateApiEndpoint}/$prefix";
    httpClient.addAuthenticator<dynamic>((request) async {
      request.headers['Authorization'] = "Bearer ${AppConfig.iGateAccessToken}";
      return request;
    });
  }

  Future<Response> sendOTP({String? phoneNumber, String? email}) async {
    String url = collectionName;
    Map<String, dynamic> body = {"phoneNumber": phoneNumber};
    if (email != null && email.isNotEmpty) {
      body["email"] = email;
    }
    return await post(url, FormData(body), contentType: "multipart/form-data");
  }

  Future<Response> confirmOTP(
      {String? phoneNumber, String? email, required String otp}) async {
    String url = collectionName + '/--confirm';
    Map<String, dynamic> query = {};
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      query['phone-number'] = phoneNumber;
    }
    if (email != null && email.isNotEmpty) {
      query['email'] = phoneNumber;
    }
    query['otp'] = otp;
    return await get(url, query: query);
  }
}
