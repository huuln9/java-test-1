import 'dart:developer';
import 'dart:io';

import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_setting/src/config/app_config.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';

class SettingUtil {
  final _settingBox = Hive.box(AppConfig.storageBox);

  final String _enableFaceLoginKey = "enableFaceLogin";

  void getAppUpdate() async {
    Map<String, dynamic> appInfo =
        GetStorage(AppConfig.storageBox).read(AppConfig.appInfo);
    String appUpdateLink = '';
    try {
      if (Platform.isAndroid) {
        appUpdateLink = appInfo['linkCHPlay'];
      } else if (Platform.isIOS) {
        appUpdateLink = appInfo['linkAppStore'];
      }
      await launch(appUpdateLink);
      log('Launch "$appUpdateLink" successfully', name: AppConfig.packageName);
    } catch (e) {
      log('Could not launch "$appUpdateLink"', name: AppConfig.packageName);
    }
  }

  Future<void> setFaceLoginStatusToStorage(bool value) async {
    await _settingBox.put(_enableFaceLoginKey, value);
  }

  bool? getFaceLoginStatusFromStorage() {
    return _settingBox.get(_enableFaceLoginKey);
  }

  Future<bool> getFaceLoginStatusByUsername({required String username}) async {
    bool? localEnableFaceLogin = getFaceLoginStatusFromStorage();
    String? localUsername = AuthUtil.username;

    /// matching with current username
    if (localUsername != null && localUsername == username) {
      if (localEnableFaceLogin != null) {
        return localEnableFaceLogin;
      } else {
        return await _checkFaceLoginStatusFromAPI(username: username);
      }
    } else {
      /// get face login status of username
      return await _checkFaceLoginStatusFromAPI(username: username);
    }
  }

  Future<bool> _checkFaceLoginStatusFromAPI({required String username}) async {
    Response response = await AuthService().getUserFullyByUsername(username);
    log("Get user from username.",
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.body.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 &&
        response.body["vnptBioId"] != null &&
        response.body["vnptBioId"]["enableFaceLogin"] != null) {
      return response.body["vnptBioId"]["enableFaceLogin"] == 1;
    } else {
      return false;
    }
  }

  Future<bool> getFaceLoginStatus() async {
    bool enableFaceLogin = false;
    if (AuthUtil.isLoggedIn) {
      // Get face login status from hive
      bool? enableFaceLogin = getFaceLoginStatusFromStorage();
      log(
          'Get face login status from hive, value ' +
              enableFaceLogin.toString(),
          name: AppConfig.packageName);
      // Get face login status from db
      if (enableFaceLogin == null) {
        try {
          Response response =
              await AuthService().getUserFullyByUsername(AuthUtil.username!);
          if (response.statusCode == 200) {
            UserFullyModel userFullyModel = UserFullyModel.fromJsonWithUsername(
                response.body, AuthUtil.username!);
            enableFaceLogin = userFullyModel.vnptBioId!.enableFaceLogin == 1;
            log(
                'Get face login status from db successfully, value ' +
                    enableFaceLogin.toString(),
                name: AppConfig.packageName);
            return enableFaceLogin;
          }
          log(
              'getUserFullyByUsername ' +
                  response.statusCode.toString() +
                  ', set enableFaceLogin false',
              name: AppConfig.packageName);
          return false;
        } catch (e) {
          log('Get face login status from db failure, set enableFaceLogin false',
              name: AppConfig.packageName);
          return false;
        }
      }
      return enableFaceLogin;
    }
    log('User is not login yet, enableFaceLogin false',
        name: AppConfig.packageName);
    return enableFaceLogin;
  }
}
