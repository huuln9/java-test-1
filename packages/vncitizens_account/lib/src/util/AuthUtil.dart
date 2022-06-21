import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/model/phone_number_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_setting/vncitizens_setting.dart';

class AuthUtil {
  static String? get fullName {
    return Hive.box(AccountAppConfig.storageBox).get("name");
  }
  static String? get userId {
    return Hive.box(AccountAppConfig.storageBox).get("user_id");
  }
  static String? get username {
    return Hive.box(AccountAppConfig.storageBox).get("username");
  }
  static String? get placeId {
    return Hive.box(AccountAppConfig.storageBox).get("placeId");
  }
  static String? get accessToken {
    return Hive.box(AccountAppConfig.storageBox).get("access_token");
  }
  static bool get isLoggedIn {
    return Hive.box(AccountAppConfig.storageBox).get("is_logon") ?? false;
  }

  static String? getPersonId() {
    return Hive.box(AccountAppConfig.storageBox).get("personId");
  }

  static Future<void> setPersonId(String id) async {
    await Hive.box(AccountAppConfig.storageBox).put("personId", id);
  }

  static Future<Uint8List?> getAvatar() async {
    return Hive.box(AccountAppConfig.storageBox).get("avatar");
  }

  static Future<void> setAvatar(Uint8List bytes) async {
    await Hive.box(AccountAppConfig.storageBox).put("avatar", bytes);
  }

  static Future<void> deleteAvatar() async {
    await Hive.box(AccountAppConfig.storageBox).delete("avatar");
  }

  static Future<void> setUsername(String username) async {
    await Hive.box(AccountAppConfig.storageBox).put("username", username );
  }

  Future<void> setHive(String token, {String? username}) async {
    final tokenDecoded = JwtDecoder.decode(token);
    final hiveBox = Hive.box(AccountAppConfig.storageBox);
    await hiveBox.put("is_logon", true);
    await hiveBox.put("user_id", tokenDecoded["external_user_id"]);
    await hiveBox.put("username", username ?? tokenDecoded["preferred_username"]);
    await hiveBox.put("name", tokenDecoded["given_name"] ?? tokenDecoded["name"]);
    await hiveBox.put("access_token", token);
  }

  static Future<void> setHiveUserInfoFromModel(UserFullyModel model, {String? username, String? accessToken}) async {
    print("Set username: " + (username ?? ""));
    final hiveBox = Hive.box(AccountAppConfig.storageBox);
    await hiveBox.put("is_logon", true);
    await hiveBox.put("user_id", model.id);
    await hiveBox.put("username", username ?? model.account.username[0].value);
    await hiveBox.put("name", model.fullname);
    await hiveBox.put("personId", model.vnptBioId?.personId);
    await hiveBox.put("email", (model.email != null && model.email!.isNotEmpty) ? model.email![0].value : null);
    await hiveBox.put("emailList", (model.email != null && model.email!.isNotEmpty) ? PhoneNumberModel.toListJson(model.email!) : null);
    await hiveBox.put("phoneNumber", (model.phoneNumber.isNotEmpty) ? model.phoneNumber[0].value : null);
    await hiveBox.put("phoneNumberList", (model.phoneNumber.isNotEmpty) ? PhoneNumberModel.toListJson(model.phoneNumber) : null);
    await hiveBox.put("birthday", model.birthday);
    await hiveBox.put("gender", model.gender);
    await hiveBox.put("placeId", (model.address != null && model.address!.isNotEmpty) ? model.address![0].placeId : null);
    await hiveBox.put("access_token", accessToken);
    await SettingUtil().setFaceLoginStatusToStorage(model.vnptBioId?.enableFaceLogin == 1);
    await setLoginFailedCount(0);
    await setLoginFailedCountdown(0);
  }

  static Future<void> removeAuth() async {
    final hiveBox = Hive.box(AccountAppConfig.storageBox);
    await hiveBox.delete("is_logon");
    await hiveBox.delete("user_id");
    await hiveBox.delete("usernameList");
    await hiveBox.delete("email");
    await hiveBox.delete("emailList");
    await hiveBox.delete("phoneNumber");
    await hiveBox.delete("phoneNumberList");
    await hiveBox.delete("birthday");
    await hiveBox.delete("gender");
    await hiveBox.delete("placeId");
    await hiveBox.delete("access_token");
    await hiveBox.delete("loginFailedCount");
    await hiveBox.delete("loginFailedCountdown");
  }

  static List<dynamic> getAllHiveKeys() {
    final hiveBox = Hive.box(AccountAppConfig.storageBox);
    return hiveBox.keys.toList();
  }

  static Future<void> setLoginFailedCount(int count) async {
    await Hive.box(AccountAppConfig.storageBox).put("loginFailedCount", count);
  }

  static int getLoginFailedCount() {
    return Hive.box(AccountAppConfig.storageBox).get("loginFailedCount") ?? 0;
  }

  static Future<void> deleteLoginFailedCount() async {
    await Hive.box(AccountAppConfig.storageBox).delete("loginFailedCount");
  }

  static Future<void> setLoginFailedCountdown(int count) async {
    await Hive.box(AccountAppConfig.storageBox).put("loginFailedCountdown", count);
  }

  static int getLoginFailedCountdown() {
    return Hive.box(AccountAppConfig.storageBox).get("loginFailedCountdown") ?? 0;
  }

  static Future<void> deleteLoginFailedCountdown() async {
    await Hive.box(AccountAppConfig.storageBox).delete("loginFailedCountdown");
  }
}