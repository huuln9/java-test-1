import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/model/document_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/src/widget/success_dialog.dart';
import 'package:vncitizens_common/dio.dart' as dio;
// import '../config/constant.dart' as constant;

class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  RxBool status = true.obs;
  RxBool showPassword = false.obs;
  RxBool showRepeatPassword = false.obs;
  RxBool enableRegisterButton = false.obs;

  RxString fullnameTextError = "".obs;
  RxString phoneTextError = "".obs;
  RxString emailTextError = "".obs;
  RxString passwordTextError = "".obs;
  RxString repeatPasswordTextError = "".obs;

  RxInt radioGroupValue = 1.obs;
  RxString exampleImageSrc = "${AccountAppConfig.assetsRoot}/images/cccd.jpg".obs;
  RxString documentType = "CCCD".obs;

  RxBool loading = false.obs;

  // ============ BIOID =================
  static const platform = MethodChannel("vnptit/si/biosdk");
  Map twoSideDocumentResult = {};

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    log(Hive.box(AccountAppConfig.storageBox).keys.toString());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void checkEnableRegisterButton() {
    if (passwordController.text.isNotEmpty &&
        passwordTextError.value.isEmpty &&
        fullNameController.text.isNotEmpty &&
        fullnameTextError.value.isEmpty &&
        fullNameController.text.isBlank != true &&
        phoneNumberController.text.isNotEmpty &&
        phoneTextError.value.isEmpty &&
        repeatPasswordController.text.isNotEmpty &&
        repeatPasswordTextError.value.isEmpty &&
        emailTextError.value.isEmpty
    ) {
      if (AccountAppConfig.requireEmail == true && emailController.text.isBlank == true) {
        enableRegisterButton.value = false;
      } else {
        enableRegisterButton.value = true;
      }
    } else {
      enableRegisterButton.value = false;
    }
  }

  void setPlatformMethodCallback() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "captureDone") {
        log("captureDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureError") {
        log("captureError", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureCancel") {
        log("captureCancel", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "processImageDone") {
        log("processImageDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        twoSideDocumentResult = call.arguments;
        openFaceOval();
      } else if (call.method == "processOvalFaceDone") {
        log("processOvalFaceDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        log(call.arguments.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (Platform.isAndroid) {
          confirmFaceWithDocument(
              twoSideDocumentResult, call.arguments["FAR_PATH"]);
        } else if (Platform.isIOS) {
          try {
            final oid = ObjectId();
            final tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/${oid.hexString}.jpg')
                .create();
            file.writeAsBytesSync(call.arguments["FAR_PATH"]);
            confirmFaceWithDocument(
                twoSideDocumentResult, file.path);
          } catch (error) {
            log(error.toString());
          }
        }
      } else if (call.method == "processImageException") {
        log("processImageException", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  Future<Map> openTwoSide() async {
    Map map = {};
    try {
      Map result = await platform.invokeMethod('openTwoSide', map);
      log(result.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return result;
    } catch (error) {
      log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      rethrow;
    }
  }

  Future<Map> openFaceOval() async {
    Map map = {};
    try {
      Map result = await platform.invokeMethod('openFaceAdvanceOval', map);
      log(result.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return result;
    } catch (error) {
      log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      rethrow;
    }
  }

  void onClickNextButton() {
    Get.back();
    setPlatformMethodCallback();
    openTwoSide();
    // Get.toNamed(AccountRouteConfig.documentRoute, arguments: [
    //   radioGroupValue.value,
    //   DocumentModel.fromMap(constant.TEMP_DOCUMENT_CCCD["content"]),
    //       () {
    //     setPlatformMethodCallback();
    //     openTwoSide();
    //   },
    //   null,
    //   "",
    //   Uint8List(0),
    //   Uint8List(0)
    // ]);
  }

  Future<DocumentModel> getDocumentInfoFromBioId(Map info) async {
    String cropParam = info["CROP_PARAMS"];
    final frontFileByteArr = info["BIT_MAP_FRONT"];
    final backFileByteArr = info["BIT_MAP_BACK"];
    log("CROP_PARAMS: " + cropParam, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dio.Response response = await BioIdService().getInfoDocumentFromImage(
      cropParam: cropParam,
      frontSide: frontFileByteArr,
      backSide: backFileByteArr,
      type: [1, 2].contains(radioGroupValue.value) ? "-1" : "5",
    );
    log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return DocumentModel.fromMap(response.data["content"]);
    }  else {
      throw "Get document information failed";
    }
  }

  Future<void> confirmFaceWithDocument(Map info, String facePath) async {
    loading.value = true;
    dio.Response response = await BioIdService().confirmFaceWithDocument(frontSide: info["BIT_MAP_FRONT"], faceFilePath: facePath);
    log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.data["status"] == "SUCCESS" && response.data["matching"] > 86) {
      DocumentModel documentModel = await getDocumentInfoFromBioId(info);
      loading.value = false;
      Get.toNamed(AccountRouteConfig.documentRoute, arguments: [
        radioGroupValue.value,
        documentModel,
            () {
          setPlatformMethodCallback();
          openTwoSide();
        },
        null,
        facePath,
        info["FRONT_CROP_BITMAP"],
        info["BACK_CROP_BITMAP"]
      ]);
    } else {
      loading.value = false;
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: "xac thuc khuon mat that bai".tr,
          ),
          barrierDismissible: false);
    }
  }

  void onChangeRadioButton(int value) {
    log("value: " + value.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    switch (value) {
      case 1:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cccd.jpg";
        documentType.value = "CCCD";
        break;
      case 2:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cmnd.jpg";
        documentType.value = "CMND";
        break;
      case 3:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/passport.jpg";
        documentType.value = "ho chieu".tr;
        break;
      default:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cccd.jpg";
        documentType.value = "CCCD";
        break;
    }
    log("exampleImageSrc: " + exampleImageSrc.value, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    radioGroupValue.value = value;
  }

  void setStatus(bool value) {
    status.value = value;
  }

  void setShowPassword(bool value) {
    showPassword.value = value;
  }

  void setRepeatShowPassword(bool value) {
    showRepeatPassword.value = value;
  }

  String? fullNameValidator(String? value) {
    if (value == null) {
      fullnameTextError.value = "vui long nhap ho ten".tr;
      return "vui long nhap ho ten".tr;
    } else {
      if (value.isBlank == true) {
        fullnameTextError.value = "vui long nhap ho ten".tr;
        return "vui long nhap ho ten".tr;
      }
      if (value.length > 64) {
        fullnameTextError.value = "do dai toi da 64 ky tu".tr;
      } else {
        fullnameTextError.value = "";
      }
      return value.length <= 64 ? null : "do dai toi da 64 ky tu".tr;
    }
  }

  String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      phoneTextError.value = "vui long nhap so dien thoai".tr;
      return "vui long nhap so dien thoai".tr;
    } else {
      String pattern = r'(^0[0-9]{9}$)';
      RegExp regExp = RegExp(pattern);
      phoneTextError.value = regExp.hasMatch(value) ? "" : "so dien thoai khong hop le".tr;
      return regExp.hasMatch(value) ? null : "so dien thoai khong hop le".tr;
    }
  }

  String? emailValidator(String? value) {
    if (AccountAppConfig.requireEmail == true) {
      if (value == null || value.isEmpty) {
        emailTextError.value = "vui long nhap email".tr;
        return "vui long nhap email".tr;
      } else {
        if (value.length > 120) {
          emailTextError.value = 'do dai toi da 128 ki tu'.tr;
          return 'do dai toi da 128 ki tu'.tr;
        }
        emailTextError.value = EmailValidator.validate(value) ? "" : "email khong hop le".tr;
        return EmailValidator.validate(value) ? null : "email khong hop le".tr;
      }
    } else {
      if (value != null && value.isNotEmpty) {
        if (value.length > 120) {
          emailTextError.value = 'do dai toi da 128 ki tu'.tr;
          return 'do dai toi da 128 ki tu'.tr;
        }
        emailTextError.value = EmailValidator.validate(value) ? "" : "email khong hop le".tr;
        return EmailValidator.validate(value) ? null : "email khong hop le".tr;
      }
    }
    emailTextError.value = "";
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      passwordTextError.value = "vui long nhap mat khau".tr;
      return "vui long nhap mat khau".tr;
    } else {
      if (value.length < 8) {
        passwordTextError.value = 'mat khau it nhat 8 ky tu'.tr;
        return 'mat khau it nhat 8 ky tu'.tr;
      }
      if (value.length > 128) {
        passwordTextError.value = 'do dai toi da 128 ki tu'.tr;
        return 'do dai toi da 128 ki tu'.tr;
      }
    }
    passwordTextError.value = "";
    return null;
  }

  String? repeatPasswordValidator() {
    if (repeatPasswordController.text.isEmpty) {
      print("HERHE1");
      repeatPasswordTextError.value = "";
      return null;
    }  else {
      if (repeatPasswordController.text != passwordController.text) {
        print("HERHE2");
        repeatPasswordTextError.value = "mat khau nhap khong khop".tr;
        return "mat khau nhap khong khop".tr;
      } else {
        print("HERHE3");
        repeatPasswordTextError.value = "";
        return null;
      }
    }
  }

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    String convertedPhone = "";
    if (phoneNumber[0] == "0") {
      convertedPhone = "%2B84" + phoneNumber.substring(1);
    }
    Response response = await AuthService().checkPhoneNumberExists(phoneNumber: convertedPhone);
    log("Checking phone exists", name: AccountAppConfig.packageName);
    log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<bool> checkEmailExists(String email) async {
    Response response = await AuthService().checkEmailExists(email: email);
    log("Checking email exists", name: AccountAppConfig.packageName);
    log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<void> onUnFocusPhoneNumber() async {
    if (await checkPhoneNumberExists(phoneNumberController.text)) {
      phoneTextError.value = "so dien thoai da ton tai".tr;
    }
  }

  Future<void> onUnFocusEmail() async {
    if (emailController.text.isNotEmpty && await checkEmailExists(emailController.text)) {
      emailTextError.value = "email da ton tai".tr;
    }
  }

  Future<void> register({bool? ignoreOtp, Function? callbackError}) async {
    final state = registerFormKey.currentState;
    if (state != null && state.validate()) {
      if (await checkPhoneNumberExists(phoneNumberController.text)) {
        phoneTextError.value = "so dien thoai da ton tai".tr;
        return;
      }
      if (emailController.text.isNotEmpty && await checkEmailExists(emailController.text)) {
        emailTextError.value = "email da ton tai".tr;
        return;
      }
      phoneTextError.value = "";
      emailTextError.value = "";
      String? smsConfigId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.smsConfigIdStorageKey);
      if (smsConfigId != null && smsConfigId.isNotEmpty && (ignoreOtp == null || ignoreOtp == false)) {
        Get.toNamed(AccountRouteConfig.registerOtpRoute);
      } else {
        log("REGISTERING", name: AccountAppConfig.packageName);
        Response response = await AuthService().createUserFully(
            fullname: fullNameController.text,
            phoneNumber: phoneNumberController.text,
            email: emailController.text.isNotEmpty ? emailController.text : null,
            password: passwordController.text);
        log(response.body.toString(), name: AccountAppConfig.packageName);
        await Future.delayed(const Duration(milliseconds: 100));
        if (response.statusCode == 200 && response.body["id"] != null) {
          Get.dialog(
              SuccessDialog(
                callback: () {
                  _login(response.body["id"]);
                },
                message: "dang ky tai khoan thanh cong".tr,
              ),
              barrierDismissible: false);
        } else {
          Get.dialog(
              ErrorDialog(
                callback: callbackError != null
                    ? () {
                  callbackError();
                }
                    : () {},
                message: "dang ky tai khoan that bai".tr,
              ),
              barrierDismissible: false);
        }
      }
      status.value = true;
    } else {
      status.value = false;
    }
  }

  Future<void> _login(String userId) async {
    Response responseUser = await AuthService().getUserFully(userId);
    log(responseUser.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(responseUser.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (responseUser.statusCode == 200) {
      await AuthUtil.setHiveUserInfoFromModel(UserFullyModel.fromJson(responseUser.body), username: phoneNumberController.text);
    }
    VCallUtil.registerDevice(phoneNumberController.text);
    Get.offAllNamed(AccountRouteConfig.userDetailRoute);
  }
}
