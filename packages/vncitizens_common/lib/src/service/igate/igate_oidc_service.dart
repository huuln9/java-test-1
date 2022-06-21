import 'package:vncitizens_common/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class IGateOidcService extends GetConnect {
  Future<Response> getAccessTokenGrantPassword(
      {String? clientId,
      required String username,
      required String password,
      String? scope}) async {
    Map<String, dynamic> body = {
      "grant_type": "password",
      "client_id": clientId ?? AppConfig.iGateOidcClientId,
      "username": username,
      "password": password,
      "scope": scope ?? AppConfig.oidcScope
    };
    return await post(AppConfig.iGateOidcTokenEndpoint, body,
        contentType: "application/x-www-form-urlencoded");
  }

  Future<Response> getAccessTokenDefault() async {
    Map<String, dynamic> body = {
      "grant_type": "client_credentials",
      "client_id": AppConfig.iGateOidcClientId,
      "client_secret": AppConfig.iGateOidcClientSecret,
      "scope": "openid"
    };
    return await post(AppConfig.iGateOidcTokenEndpoint, body,
        contentType: "application/x-www-form-urlencoded");
  }
}
