// ignore_for_file: implementation_imports, unnecessary_import

import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_setting/src/config/app_config.dart';
import 'package:vncitizens_notification/src/util/fcm_util.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/model/user_bioid_model.dart';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_setting/src/util/setting_util.dart';

class SettingController extends GetxController {
  RxBool enableFaceLogin = false.obs;
  RxBool enableNotification = false.obs;
  RxString version = '1.0.0'.obs;
  RxBool updateRequest = false.obs;

  late UserFullyModel userFullyModel;
  late UserFullyModel userInfo;
  String? personId;

  final _settingBox = Hive.box(AppConfig.storageBox);

  static const platform = MethodChannel("vnptit/si/biosdk");

  @override
  Future<void> onInit() async {
    super.onInit();

    log("INIT SETTING CONTROLLER", name: AppConfig.packageName);

    enableFaceLogin.value = await SettingUtil().getFaceLoginStatus();

    /// Set face login

    // Check user is logined
    if (AuthUtil.isLoggedIn) {
      Response response =
          await AuthService().getUserFullyByUsername(AuthUtil.username!);
      if (response.statusCode == 200) {
        userFullyModel = UserFullyModel.fromJsonWithUsername(
            response.body, AuthUtil.username!);
        // Check user is registered faceid
        if (userFullyModel.vnptBioId != null) {
        } else {
          enableFaceLogin.value = false;
        }
      }
    }

    // Set notification
    enableNotification.value =
        _settingBox.get('enableNotification', defaultValue: true);
    log('NOTIFICATION STATUS IS ENABLE: ' + enableNotification.value.toString(),
        name: AppConfig.packageName);

    // Set app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;

    updateRequest.value = _checkAppVsRemote();
  }

  void toggleFaceLoginStatus({bool? value}) {
    if (AuthUtil.isLoggedIn) {
      // Check user is registered faceid
      if (userFullyModel.vnptBioId != null) {
        enableFaceLogin.value = value ?? !enableFaceLogin.value;
        _changeFaceLoginStatus(enableFaceLogin.value);
      } else {
        setPlatformMethodCallback();
        openFaceOval();
      }
    } else {
      Get.toNamed('/vncitizens_account/login',
          arguments: ['/vncitizens_setting']);
    }
  }

  void toggleNotificationStatus({bool? value}) {
    enableNotification.value = value ?? !enableNotification.value;
    _changeNotificationStatus(enableNotification.value);
  }

  Future<void> _changeFaceLoginStatus(boolValue) async {
    // Save to hive
    _settingBox.put('enableFaceLogin', boolValue);
    // Save to db
    AuthService().updateBioId(
        id: AuthUtil.userId!,
        enableFaceLogin: boolValue ? 1 : 0,
        personId: AuthUtil.getPersonId()!);

    log(
        'FACE LOGIN STATUS CHANGED ! FACE LOGIN STATUS IS ENABLE: ' +
            enableFaceLogin.value.toString(),
        name: AppConfig.packageName);
  }

  Future<void> _changeNotificationStatus(boolValue) async {
    _settingBox.put('enableNotification', boolValue);
    log(
        'NOTIFICATION STATUS CHANGED ! NOTIFICATION STATUS IS ENABLE: ' +
            enableNotification.value.toString(),
        name: AppConfig.packageName);

    if (enableNotification.value) {
      FcmUtil.subscribe();
    } else {
      FcmUtil.unsubscribe();
    }
  }

  void watchInstruction() async {
    String instructionLink =
        GetStorage(AppConfig.storageBox).read(AppConfig.instructionLink);

    try {
      await launch(instructionLink);
      log('Launch "$instructionLink" successfully',
          name: AppConfig.packageName);
    } catch (e) {
      log('Could not launch "$instructionLink"', name: AppConfig.packageName);
    }
  }

  Future<void> shareApp() async {
    Map<String, dynamic> shareAppInfo =
        GetStorage(AppConfig.storageBox).read(AppConfig.appInfo);

    String appLink = '';
    if (Platform.isAndroid) {
      appLink = shareAppInfo['linkCHPlay'];
    } else if (Platform.isIOS) {
      appLink = shareAppInfo['linkAppStore'];
    }

    await FlutterShare.share(
      title: shareAppInfo['shareTitle'],
      chooserTitle: shareAppInfo['shareChooserTitle'],
      text: shareAppInfo['name'],
      linkUrl: appLink,
    );
  }

  void getAppUpdate() async {
    SettingUtil().getAppUpdate();
  }

  bool _checkAppVsRemote() {
    Map<String, dynamic> appInfo =
        GetStorage(AppConfig.homeStorageBox).read(AppConfig.appLatestVersion);
    String remoteAppVersion = appInfo['version'];
    List<int> remoteAppVersionParts =
        remoteAppVersion.split(".").map(int.parse).toList();

    List<int> appVersionParts =
        version.value.split(".").map(int.parse).toList();

    for (var i = 0; i < appVersionParts.length; i++) {
      if (appVersionParts[i] < remoteAppVersionParts[i]) {
        return true;
      }
    }
    return false;
  }

  Future<Map> openFaceOval() async {
    Map map = {};
    try {
      Map result = await platform.invokeMethod('openFaceAdvanceOval', map);
      log(result.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return result;
    } catch (error) {
      log(error.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      rethrow;
    }
  }

  void setPlatformMethodCallback() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "captureDone") {
        log("captureDone",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureError") {
        log("captureError",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureCancel") {
        log("captureCancel",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "processImageDone") {
        log("processImageDone",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "processOvalFaceDone") {
        log("processOvalFaceDone",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        // call.arguments["FAR_PATH"] tham số này trả về đường dẫn của ảnh xa khuôn mặt khi quét Oval
        // Tiến hành đăng ký khuôn mặt
        if (Platform.isAndroid) {
          registerFaceBioID(call.arguments["FAR_PATH"]);
        } else if (Platform.isIOS) {
          try {
            final oid = ObjectId();
            final tempDir = await getTemporaryDirectory();
            File file =
                await File('${tempDir.path}/${oid.hexString}.jpg').create();
            file.writeAsBytesSync(call.arguments["FAR_PATH"]);
            registerFaceBioID(file.path);
          } catch (error) {
            log(error.toString());
          }
        }
      } else if (call.method == "processImageException") {
        log("processImageException",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  Future<void> registerFaceBioID(String facePath) async {
    /// create person

    // Change +84 -> 0
    // String phoneNumber = userFullyModel.phoneNumber[0].value;
    // if (phoneNumber.substring(0, 3) == '+84') {
    //   phoneNumber = '0' + phoneNumber.substring(3);
    // }

    dio.Response response =
        await BioIdService().createPerson(identification: userFullyModel.id!);
    log(response.data.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.statusCode.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 201 && response.data["id"] != null) {
      personId = response.data["id"].toString();

      /// register face with person id and image file path
      dio.Response response1 = await BioIdService().registerFaceFromImage(
          personId: response.data["id"].toString(), faceFilePath: facePath);
      log(response1.data.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(response1.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (response1.statusCode == 201) {
        log("Đăng ký khuôn mặt thành công",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

        /// Update vnptBioid
        // Get user info fully
        Response response = await AuthService().getUserFully(AuthUtil.userId!);
        if (response.statusCode == 200) {
          userInfo = UserFullyModel.fromJson(response.body);
          // Update vnptBioId
          if (personId != null) {
            userInfo.vnptBioId = UserBioIdModel(personId: personId!);
          }
          Response response1 = await AuthService().updateUserFullyByJson(
              id: userFullyModel.id ?? "", json: userInfo.toJson());
          log(response1.body.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          log(response1.statusCode.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          if (response1.statusCode == 200 &&
              response1.body["affectedRows"] > 0) {
            log("Update vnptBioid done",
                name:
                    CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            if (personId != null) {
              AuthUtil.setPersonId(personId!);
            }
          } else {
            log("Update vnptBioid failure",
                name:
                    CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          }
        } else {
          log("Update vnptBioid -> getUserFully failure",
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        }

        /// toggle switch
        enableFaceLogin.value = true;
        _changeFaceLoginStatus(enableFaceLogin.value);
      } else {
        log("Đăng ký khuôn mặt thất bại",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
