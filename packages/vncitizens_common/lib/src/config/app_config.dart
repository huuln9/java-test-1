import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppConfig {
  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "vncitizens_common";

  /// storage box name
  static const String storageBox = packageName;

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  static const Color backgroundColor = Color(0xFFE5E5E5);

  // ------------------------------------
  // PACKAGE PRIVACY
  // ------------------------------------

  static const String tokenStorageKey = "token";
  static const String iGateTokenStorageKey = "iGateToken";
  static const String apiEndpointStorageKey = "api_endpoint";
  static const String authenticatorStorageKey = "authenticator";
  static const String minioStorageKey = "minio";
  static const String iGateConfigStorageKey = "iGateConfig";

  static String get accessToken {
    return GetStorage(storageBox).read(tokenStorageKey);
  }

  static String get oidcScope {
    return GetStorage(storageBox).read(authenticatorStorageKey)["scope"];
  }

  static String get oidcClientId {
    return GetStorage(storageBox).read(authenticatorStorageKey)["client_id"];
  }

  static String get oidcTokenEndpoint {
    return GetStorage(storageBox)
        .read(authenticatorStorageKey)["oidcTokenEndpoint"];
  }

  static String get iscsApiEndpoint {
    return GetStorage(storageBox).read(apiEndpointStorageKey)["iscs"];
  }

  static String get vnccApiEndpoint {
    return GetStorage(storageBox).read(apiEndpointStorageKey)["vncc"];
  }

  static String get iGateApiEndpoint {
    return GetStorage(storageBox).read(iGateConfigStorageKey)["apiDomain"] ??
        "https://apitest.vnptigate.vn";
  }

  static String get bioidApiEndpoint {
    return GetStorage(storageBox).read(apiEndpointStorageKey)["bioid"];
  }

  static String get bioidConsumerKey {
    return GetStorage(storageBox).read(authenticatorStorageKey)["bioid"]
        ["consumerKey"];
  }

  static String get bioidConsumerSecret {
    return GetStorage(storageBox).read(authenticatorStorageKey)["bioid"]
        ["consumerSecret"];
  }

  static Map<String, dynamic> get minioMap {
    return GetStorage(storageBox).read(minioStorageKey);
  }

  static String get administrativeDocAPIEndpoint {
    return GetStorage(storageBox)
        .read(apiEndpointStorageKey)["administrativeDocument"]["apiEndpoint"];
  }

  static String get administrativeDocTokenEndpoint {
    return GetStorage(storageBox)
        .read(apiEndpointStorageKey)["administrativeDocument"]["tokenEndpoint"];
  }

  static String get administrativeDocConsumerKey {
    return GetStorage(storageBox)
        .read(authenticatorStorageKey)["administrativeDocument"]["consumerKey"];
  }

  static String get administrativeDocConsumerSecret {
    return GetStorage(storageBox)
            .read(authenticatorStorageKey)["administrativeDocument"]
        ["consumerSecret"];
  }

  static String get iGateOidcTokenEndpoint {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['oidc']
        ?['tokenEndpoint'];
  }

  static String get iGateOidcClientId {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['oidc']
            ?["clientId"] ??
        "vn-citizens-mobile-v2";
  }

  static String get iGateOidcClientSecret {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['oidc']
            ?["clientSecret"] ??
        "a3dd033e-e6af-49dd-ac84-246f1883c943";
  }

  static String get iGateNationId {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['constant']
            ?["nationId"] ??
        "5f39f4a95224cf235e134c5c";
  }

  static String get iGateProvincePlaceTypeId {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['constant']
            ?["provincePlaceTypeId"] ??
        "5ee304423167922ac55bea01";
  }

  static String get iGateDistrictPlaceTypeId {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['constant']
            ?["districtPlaceTypeId"] ??
        "5ee304423167922ac55bea02";
  }

  static String get iGateWardPlaceTypeId {
    return GetStorage(storageBox).read(iGateConfigStorageKey)['constant']
            ?["wardPlaceTypeId"] ??
        "5ee304423167922ac55bea03";
  }

  static String get iGateAccessToken {
    return GetStorage(storageBox).read(iGateTokenStorageKey);
  }

  static String get clientCredentialClientSecret {
    return GetStorage(storageBox).read(authenticatorStorageKey)["clientCredential"]["clientSecret"];
  }

  static String? get clientCredentialClientId {
    return GetStorage(storageBox).read(authenticatorStorageKey)["clientCredential"]["clientId"];
  }
}
