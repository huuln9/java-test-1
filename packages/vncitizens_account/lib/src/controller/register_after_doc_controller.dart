import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_account/src/controller/document_controller.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/src/widget/success_dialog.dart';
import 'package:vncitizens_account/vncitizens_account.dart';

class RegisterAfterDocumentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  RxBool showPassword = false.obs;
  RxBool showRepeatPassword = false.obs;

  RxString phoneTextError = "".obs;
  RxString emailTextError = "".obs;
  RxString passwordTextError = "".obs;
  RxString repeatPasswordTextError = "".obs;

  late String faceFilePath;
  late String cardNumber;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments[0] != null && (Get.arguments[0] is String)) {
      faceFilePath = Get.arguments[0];
    }  else {
      throw "faceFilePath is not found";
    }

    if (Get.arguments[1] != null && (Get.arguments[1] is String)) {
      cardNumber = Get.arguments[1];
    }  else {
      throw "cardNumber is not found";
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
  }

  void setShowPassword(bool value) {
    showPassword.value = value;
  }

  void setRepeatShowPassword(bool value) {
    showRepeatPassword.value = value;
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

  String? fullNameValidator(String? value) {
    if (value == null) {
      return "vui long nhap ho ten".tr;
    } else {
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
    if (repeatPasswordController.text.isNotEmpty) {
      if (repeatPasswordController.text != passwordController.text) {
        repeatPasswordTextError.value = "mat khau nhap khong khop".tr;
      } else {
        repeatPasswordTextError.value = "";
      }
    } else {
      repeatPasswordTextError.value = "";
    }
    return repeatPasswordController.text == passwordController.text ? null : "mat khau nhap khong khop".tr;
  }

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    String convertedPhone = "";
    if (phoneNumber[0] == "0") {
      convertedPhone = "%2B84" + phoneNumber.substring(1);
    }
    Response response = await AuthService().checkPhoneNumberExists(phoneNumber: convertedPhone);
    dev.log("Checking phone exists", name: AccountAppConfig.packageName);
    dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<bool> checkEmailExists(String email) async {
    Response response = await AuthService().checkEmailExists(email: email);
    dev.log("Checking email exists", name: AccountAppConfig.packageName);
    dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<void> _login(String userId) async {
    Response responseUser = await AuthService().getUserFully(userId);
    dev.log(responseUser.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(responseUser.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (responseUser.statusCode == 200) {
      await AuthUtil.setHiveUserInfoFromModel(UserFullyModel.fromJson(responseUser.body), username: phoneNumberController.text);
    }
    VCallUtil.registerDevice(phoneNumberController.text);
    Get.offAllNamed(AccountRouteConfig.userDetailRoute);
  }

  String convertDateStringToIso(String dateString) {
    try {
      DateTime tempDate = DateFormat("dd/MM/yyyy").parse(dateString);
      dev.log(tempDate.toIso8601String(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return tempDate.toIso8601String();
    } catch (error) {
      dev.log("Invalid date string", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
    return "";
  }

  Map<String, dynamic>? getDocumentObjByType(int type) {
    DocumentController documentController = Get.find();
    int docType = documentController.documentType;
    Map<String, dynamic> map = {};
    Map<String, dynamic> agency = {};
    if (documentController.frontSideId != null && documentController.backSideId != null) {
      Map<String, dynamic> scanImage = {};
      Map<String, dynamic> frontside = {};
      Map<String, dynamic> backside = {};
      frontside["id"] = documentController.frontSideId;
      backside["id"] = documentController.backSideId;
      scanImage["frontside"] = frontside;
      scanImage["backside"] = backside;
      map["scanImage"] = scanImage;
    } else {
      dev.log("Không tìm thấy frontSideId hoặc backSideId !!!", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      dev.log("frontSideID: " + (documentController.frontSideId ?? ""), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      dev.log("backSideId: " + (documentController.backSideId ?? ""), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
    switch (type) {
      case 1:
        {
          if (docType != 1) return null;
          map["number"] = documentController.cardNumberController.text;
          map["date"] = convertDateStringToIso(documentController.issueDateController.text);
          agency["id"] = documentController.issuePlaceIdSelected;
          map["agency"] = agency;
          return map;
        }
      case 2:
        {
          if (docType != 2) return null;
          map["number"] = documentController.cardNumberController.text;
          map["date"] = convertDateStringToIso(documentController.issueDateController.text);
          agency["id"] = documentController.issuePlaceIdSelected;
          map["agency"] = agency;
          return map;
        }
      case 3:
        {
          if (docType != 3) return null;
          map["number"] = documentController.cardNumberController.text;
          map["date"] = convertDateStringToIso(documentController.issueDateController.text);
          agency["id"] = documentController.issuePlaceIdSelected;
          map["agency"] = agency;
          return map;
        }
      default:
        return null;
    }
  }

  Future<void> submit({bool? ignoreOtp, Function? callbackError}) async {
    final state = formKey.currentState;
    if (state != null && state.validate()) {
      if (phoneTextError.isNotEmpty || emailTextError.isNotEmpty || passwordTextError.isNotEmpty || repeatPasswordTextError.isNotEmpty) {
        return;
      }
      if (phoneNumberValidator(phoneNumberController.text) != null) {
        return;
      }
      if (emailValidator(emailController.text) != null) {
        return;
      }
      if (passwordValidator(passwordController.text) != null) {
        return;
      }
      if (repeatPasswordValidator() != null) {
        return;
      }
      bool formValid = true;
      dev.log("Submit form", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (phoneNumberController.text.isNotEmpty && await checkPhoneNumberExists(phoneNumberController.text)) {
        phoneTextError.value = "so dien thoai da ton tai".tr;
        formValid = false;
      }
      if (emailController.text.isNotEmpty && await checkEmailExists(emailController.text)) {
        emailTextError.value = "email da ton tai".tr;
        formValid = false;
      }
      if (formValid == false) {
        return;
      }
      phoneTextError.value = "";
      emailTextError.value = "";
      String? smsConfigId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.smsConfigIdStorageKey);
      if (smsConfigId != null && smsConfigId.isNotEmpty && (ignoreOtp == null || ignoreOtp == false)) {
        Get.toNamed(AccountRouteConfig.registerAfterDocumentOtpRoute);
      } else {
        DocumentController documentController = Get.find();
        Map<String, dynamic>? citizenIdentityObj = getDocumentObjByType(1);
        Map<String, dynamic>? identityObj = getDocumentObjByType(2);
        Map<String, dynamic>? passportObj = getDocumentObjByType(3);
        dev.log("REGISTERING", name: AccountAppConfig.packageName);
        Response response = await AuthService().createUserFully(
            fullname: documentController.fullnameController.text,
            phoneNumber: phoneNumberController.text,
            email: emailController.text.isNotEmpty ? emailController.text : null,
            identity: identityObj,
            citizenIdentity: citizenIdentityObj,
            passport: passportObj,
            password: passwordController.text,
            gender: documentController.genderSelected == "nam".tr ? 1 : 0,
            birthday: convertDateStringToIso(documentController.birthdayController.text),
            address: [
              {
                "address": documentController.recentAddressDetailController.text,
                "placeId": documentController.recentAddressIdSelected,
                "type": 1
              },
              {
                "address": documentController.originAddressDetailController.text,
                "placeId": documentController.originAddressIdSelected,
                "type": 3
              }
            ],
            personId: documentController.personId
        );
        dev.log(response.body.toString(), name: AccountAppConfig.packageName);
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
          if (response.body["code"] != null &&
              response.body["message"] != null) {
            Get.dialog(
                ErrorDialog(
                    callback: () {}, message: response.body["message"]),
                barrierDismissible: false);
            return;
          }
          Get.dialog(
              ErrorDialog(
                callback: callbackError != null ? () => callbackError() : () {},
                message: "dang ky tai khoan that bai".tr,
              ),
              barrierDismissible: false);
        }
      }
    }
  }
}
