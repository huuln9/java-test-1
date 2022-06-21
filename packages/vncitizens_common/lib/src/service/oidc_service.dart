
import 'dart:developer';

import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';

class OidcService extends GetConnect {
  Future<Response> getAccessTokenGrantPassword({
    String? clientId,
    required String username,
    required String password,
    String? scope
  }) async {
    Map<String, dynamic> body = {
      "grant_type": "password",
      "client_id": clientId ?? AppConfig.oidcClientId,
      "username": username,
      "password": password,
      "scope": scope ?? AppConfig.oidcScope
    };
    return await post(AppConfig.oidcTokenEndpoint, body, contentType: "application/x-www-form-urlencoded");
  }

  Future<Response> getAccessTokenDefault() async {
    try {
      Map<String, dynamic> body = {
        "grant_type": "client_credentials",
        "client_id": AppConfig.clientCredentialClientId ?? "vncitizens-mobile-public",
        "client_secret": AppConfig.clientCredentialClientSecret,
        "scope": "openid"
      };
      return await post(AppConfig.oidcTokenEndpoint, body, contentType: "application/x-www-form-urlencoded");
    } catch (error) {
      throw "Get default token failed";
    }
  }
}