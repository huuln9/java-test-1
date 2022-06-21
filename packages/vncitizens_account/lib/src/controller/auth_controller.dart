import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';

class AuthController extends GetxController {
  bool get isLogon {
    return Hive.box(AccountAppConfig.storageBox).get('is_logon') ?? false;
  }

  String get username {
    String strAccessToken = Hive.box(AccountAppConfig.storageBox).get('access_token');
    var payload = JwtDecoder.decode(strAccessToken);
    return payload['preferred_username'] ?? "Unknown";
  }

  String get jsonAccessToken {
    String strAccessToken = Hive.box(AccountAppConfig.storageBox).get('access_token');
    var payload = JwtDecoder.decode(strAccessToken);
    dev.log('token json: $payload', name: AccountAppConfig.packageName);
    return prettyJson(payload);
  }
}
