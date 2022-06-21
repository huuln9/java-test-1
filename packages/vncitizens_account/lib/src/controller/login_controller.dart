import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/src/widget/error_dialog_two.dart';
import 'package:vncitizens_account/src/widget/warning_dialog.dart';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_setting/vncitizens_setting.dart';

import '../config/account_app_config.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool status = true.obs;
  RxBool showPassword = false.obs;
  RxBool enableLoginButton = false.obs;
  RxBool lockLoginButton = false.obs;

  Rxn<Uint8List> avatarBytes = Rxn<Uint8List>();
  RxnString localUsername = RxnString();
  RxnString shortString = RxnString();

  RxBool loginOther = false.obs;

  RxBool loading = false.obs;
  RxInt loginFailedCount = AuthUtil.getLoginFailedCount().obs;
  RxInt loginFailedCountdown = AuthUtil.getLoginFailedCountdown().obs;
  RxBool loginFailedCountdownFinish = false.obs;
  Timer? loginCountdownTimer;

  String? routeBack;

  static const platform = MethodChannel("vnptit/si/biosdk");

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null &&
        Get.arguments[0] != null &&
        Get.arguments[0] is String) {
      routeBack = Get.arguments[0];
    } else {
      log("Do not have route back",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
    initAvatar();
    initUsername();
    log(loginFailedCount.value.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(loginFailedCountdown.value.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    checkInitLoginFailed();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
    loginCountdownTimer?.cancel();
    saveCurrentLoginFailed();
  }

  void initAvatar() {
    AuthUtil.getAvatar().then((bytes) {
      if (bytes != null) {
        log("Set avatar from local",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        avatarBytes.value = bytes;
      } else {
        String? tmpFullName = AuthUtil.fullName;
        if (tmpFullName != null) {
          shortString.value = getShortStringFromName();
        }
      }
    });
  }

  void initUsername() {
    String? tmpUsername = AuthUtil.username;
    if (tmpUsername != null) {
      localUsername.value = tmpUsername;
      emailController.text = tmpUsername;
    }
    log(AuthUtil.username ?? "null",
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  }

  void checkInitLoginFailed() {
    if (loginFailedCount.value >= AccountAppConfig.loginFailedCount1) {
      setLoginFailedByCountdown(loginFailedCountdown.value, init: true);
    }
  }

  // ============ EVENTS =============

  void onTapOtherAccount() {
    emailController.text = "";
    avatarBytes.value = null;
    shortString.value = null;
    loginOther.value = true;
  }

  Future<void> onTapFaceScan() async {
    log("On TAP face scan",
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (loginOther.value == true || localUsername.value == null) {
      saveCurrentLoginFailed();
      loginCountdownTimer?.cancel();
      Get.toNamed(AccountRouteConfig.faceUsernameRoute,
          arguments: [AccountAppConfig.appRequireLogin])?.then((value) {
        log("Handle back to login",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        checkInitLoginFailed();
      });
    } else {
      if (AuthUtil.getPersonId() == null) {
        Get.dialog(
            WarningDialog(
              message: "ban chua dang ky xac thuc bang khuon mat".tr,
            ),
            barrierDismissible: false);
        return;
      }
      bool enableFace = await SettingUtil()
          .getFaceLoginStatusByUsername(username: localUsername.value!);
      log(enableFace.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (enableFace == false) {
        Get.dialog(
            WarningDialog(
              message: "ban da tat tinh nang dang nhap bang khuon mat".tr,
            ),
            barrierDismissible: false);
        return;
      }
      setPlatformMethodCallback();
      openFaceOval();
    }
  }

  // ============ END EVENTS =========

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
        // openFaceOval();
      } else if (call.method == "processOvalFaceDone") {
        log("processOvalFaceDone",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (Platform.isAndroid) {
          confirmFace(call.arguments["FAR_PATH"]);
        } else if (Platform.isIOS) {
          final oid = ObjectId();
          final tempDir = await getTemporaryDirectory();
          File file =
              await File('${tempDir.path}/${oid.hexString}.jpg').create();
          file.writeAsBytesSync(call.arguments["FAR_PATH"]);
          confirmFace(file.path);
        }
      } else if (call.method == "processImageException") {
        log("processImageException",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  Future<void> confirmFace(String facePath) async {
    loading.value = true;
    try {
      /// check liveness face
      log("Checking liveness",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      dio.Response response =
          await BioIdService().checkLiveness(faceFilePath: facePath);
      log(response.data.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(response.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (response.statusCode == 200 &&
          (response.data["liveness"] == "true" ||
              response.data["liveness"] == true)) {
        if (AuthUtil.getPersonId() == null) {
          loading.value = false;
          Get.dialog(
              WarningDialog(
                message: "ban chua dang ky xac thuc bang khuon mat".tr,
              ),
              barrierDismissible: false);
          return;
        }

        /// confirm login using face id
        dio.Response response1 = await BioIdService().confirmFaceFromFilePath(
            personId: AuthUtil.getPersonId() as String, faceFilePath: facePath);
        log(response1.statusCode.toString(),
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        log(response1.data.toString(),
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (response1.statusCode == 200 && response1.data["matching"] > 90) {
          /// reset avatar
          if (loginOther.value) {
            await AuthUtil.deleteAvatar();
          }

          /// set hive
          Response response2 = await AuthService().getUserFullyByUsername(
              localUsername.value!.replaceAll("+84", "%2B84"));
          log(response2.statusCode.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          log(response2.body.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          if (response2.statusCode == 200) {
            UserFullyModel userFullyModel = UserFullyModel.fromJsonWithUsername(
                response2.body, localUsername.value as String);
            await AuthUtil.setHiveUserInfoFromModel(userFullyModel);
            loading.value = false;

            /// register device
            VCallUtil.registerDevice(userFullyModel.phoneNumber[0].value);
            if (routeBack != null) {
              Get.offAllNamed(routeBack!);
            } else if (AccountAppConfig.remoteInitialRoute != null) {
              Get.offAllNamed(AccountAppConfig.remoteInitialRoute!);
            } else {
              /// back to home
              Get.offAllNamed("/vncitizens_home");
            }
          } else {
            loading.value = false;
            if (response2.body["code"] != null &&
                response2.body["message"] != null) {
              Get.dialog(
                  ErrorDialog(
                      callback: () {}, message: response2.body["message"]),
                  barrierDismissible: false);
              return;
            }
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: "da xay ra loi".tr,
                ),
                barrierDismissible: false);
            return;
          }
        } else {
          loading.value = false;
          Get.dialog(
              ErrorDialogTwo(
                onRetry: () => onTapFaceScan(),
                message: "khuon mat khong khop".tr,
              ),
              barrierDismissible: false);
        }
      } else {
        loading.value = false;
        if (response.data["message"] != null) {
          Get.dialog(
              ErrorDialog(callback: () {}, message: response.data["message"],),
              barrierDismissible: false);
          return;
        }
        Get.dialog(
            ErrorDialog(callback: () {}, message: "da xay ra loi".tr,),
            barrierDismissible: false);
        return;
      }
    } catch (error) {
      loading.value = false;
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: "da xay ra loi".tr,
          ),
          barrierDismissible: false);
      return;
    }
  }

  String getShortStringFromName() {
    final fullName = AuthUtil.fullName;
    final engStr = nonAccentVietnamese(fullName ?? "");
    List<String> names = engStr.split(" ");
    String initials = "";
    if (names.length > 1) {
      for (var i = names.length - 2; i < names.length; i++) {
        initials += names[i][0];
      }
    } else {
      initials += names[0][0] + names[0][1];
    }
    return initials.toUpperCase();
  }

  String nonAccentVietnamese(String str) {
    const _vietnamese = 'aAeEoOuUiIdDyY';
    final _vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp(r'ì|í|ị|ỉ|ĩ'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp(r'đ'),
      RegExp(r'Đ'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
    ];

    var result = str;
    for (var i = 0; i < _vietnamese.length; ++i) {
      result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
    }
    return result;
  }

  void checkEnableLoginButton() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      enableLoginButton.value = true;
    } else {
      enableLoginButton.value = false;
    }
  }

  void setStatus(bool value) {
    status.value = value;
  }

  void setShowPassword(bool value) {
    showPassword.value = value;
  }

  void goToResetPassword() {
    log(CommonUtil.getCurrentClassAndFuncName(StackTrace.current),
        name: AccountAppConfig.packageName);
    saveCurrentLoginFailed();
    loginCountdownTimer?.cancel();
    String? smsConfigId = GetStorage(AccountAppConfig.storageBox)
        .read(AccountAppConfig.smsConfigIdStorageKey);
    if (smsConfigId != null && smsConfigId.isNotEmpty) {
      Get.toNamed(AccountRouteConfig.resetPasswordSmsRoute)?.then((value) {
        log("Handle back to login",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        checkInitLoginFailed();
      });
    } else {
      Get.toNamed(AccountRouteConfig.resetPasswordEmailRoute)?.then((value) {
        log("Handle back to login",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        checkInitLoginFailed();
      });
    }
  }

  void onTapRegister() {
    saveCurrentLoginFailed();
    loginCountdownTimer?.cancel();
    Get.toNamed("/vncitizens_account/register")?.then((value) {
      log("Handle back to login",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      checkInitLoginFailed();
    });
  }

  Future<void> login() async {
    final state = loginFormKey.currentState;
    if (state != null && state.validate()) {
      Response response = await OidcService().getAccessTokenGrantPassword(
        username: emailController.text,
        password: passwordController.text,
      );
      if (response.statusCode == 200 && response.body["access_token"] != null) {
        /// reset login failed count
        resetLoginFailedCount();
        final token = response.body["access_token"];
        log(token.toString(),
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

        /// reset local avatar
        if (loginOther.value) {
          log("Reset avatar",
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          await AuthUtil.deleteAvatar();
        }

        /// set info to hive
        final tokenDecoded = JwtDecoder.decode(token);
        if (tokenDecoded["external_user_id"] != null) {
          Response responseUser = await AuthService()
              .getUserFully(tokenDecoded["external_user_id"]);
          log(responseUser.statusCode.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          log(responseUser.body.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          if (responseUser.statusCode == 200) {
            await AuthUtil.setHiveUserInfoFromModel(
                UserFullyModel.fromJson(responseUser.body),
                username: emailController.text);
          }
        } else {
          Get.dialog(
              ErrorDialog(
                callback: () {},
                message: "khong tim thay ma nguoi dung".tr,
              ),
              barrierDismissible: false);
          return;
        }

        /// register device vcall
        _registerDevice(token);
        status.value = true;
        if (routeBack != null) {
          Get.offAllNamed(routeBack!);
        } else if (AccountAppConfig.remoteInitialRoute != null) {
          Get.offAllNamed(AccountAppConfig.remoteInitialRoute!);
        } else {
          Get.offAllNamed("/vncitizens_home");
        }
      } else {
        log("LOGIN FAILED");
        status.value = false;
        increaseLoginFailedCount();
      }
    }
  }

  Future<void> _registerDevice(String token) async {
    final tokenDecoded = JwtDecoder.decode(token);
    final userId = tokenDecoded["external_user_id"];
    Response response = await AuthService().getUserFully(userId);
    if (response.statusCode == 200) {
      log(response.body.toString(), name: AccountAppConfig.packageName);
      final phoneNumber = response.body["phoneNumber"] == null ||
              response.body["phoneNumber"].length == 0
          ? ""
          : response.body["phoneNumber"][0]["value"];
      VCallUtil.registerDevice(phoneNumber);
    } else {
      log("Get user info error. Body: " + response.body.toString(),
          name: AccountAppConfig.packageName);
      log("Get user info error. Code: " + response.statusCode.toString(),
          name: AccountAppConfig.packageName);
    }
  }

  Future<void> increaseLoginFailedCount() async {
    loginFailedCount.value++;
    AuthUtil.setLoginFailedCount(loginFailedCount.value);
    log(loginFailedCount.value.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (loginFailedCount.value >= AccountAppConfig.loginFailedCount2) {
      setLoginFailedByCountdown(AccountAppConfig.loginFailedMaxCountdown2);
    } else if (loginFailedCount.value >= AccountAppConfig.loginFailedCount1) {
      setLoginFailedByCountdown(AccountAppConfig.loginFailedMaxCountdown1);
    }
  }

  void setLoginFailedByCountdown(int maxCountdown, {bool? init}) {
    status.value = false;
    lockLoginButton.value = true;
    loginFailedCountdown.value = maxCountdown;
    loginCountdownTimer?.cancel();
    loginCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (loginFailedCountdown.value > 0) {
        loginFailedCountdown.value = loginFailedCountdown.value - 1;
        saveCurrentLoginFailed();
      } else {
        if (init == true) {
          status.value = true;
        }
        lockLoginButton.value = false;
        loginFailedCountdownFinish.value = true;
        loginCountdownTimer?.cancel();
        log("expired");
      }
    });
  }

  Future<void> saveCurrentLoginFailed() async {
    AuthUtil.setLoginFailedCountdown(loginFailedCountdown.value);
    AuthUtil.setLoginFailedCount(loginFailedCount.value);
  }

  Future<void> resetLoginFailedCount() async {
    loginFailedCount.value = 0;
    AuthUtil.setLoginFailedCountdown(0);
    log(loginFailedCount.value.toString(),
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  }

  void additionalNavbarFunction() {
    log("Call additional setting function",
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    saveCurrentLoginFailed();
    loginCountdownTimer?.cancel();
  }

  void navbarCallback() {
    log("Handle back to login",
        name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    checkInitLoginFailed();
  }
}
