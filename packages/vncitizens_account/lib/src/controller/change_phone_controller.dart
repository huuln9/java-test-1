import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/user_detail_controller.dart';
import 'package:vncitizens_account/src/model/phone_number_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/model/username_type_model.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/vncitizens_account.dart';

import '../widget/success_dialog.dart';

class ChangePhoneController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  RxBool disableButton = true.obs;
  late String fullname;
  List<String> emails = [];
  List<String> usernames = [];
  RxString textError = "".obs;

  late UserFullyModel userInfo;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.dispose();
  }

  /// get info from user detail controller
  Future<void> getUserInfo() async {
    UserDetailController userDetailController = Get.find();
    fullname = userDetailController.fullName.value;
    emails.add(userDetailController.email.value);
    usernames = userDetailController.usernames;

    Response response = await AuthService().getUserFully(AuthUtil.userId as String);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      userInfo = UserFullyModel.fromJson(response.body);
    } else {
      dev.log("Set userInfo from userDetailController", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      userInfo = UserFullyModel.fromJson(userDetailController.userInfo);
    }
  }

  void phoneNumberValidator(String? value) {
    textError.value = "";
    if (value == null || value.isEmpty) {
      disableButton.value = true;
    } else {
      String pattern = r'(^0[0-9]{9}$)';
      RegExp regExp = RegExp(pattern);
      disableButton.value = !regExp.hasMatch(value);
    }
  }

  Future<void> submit() async {
    if (await checkPhoneNumberExists(phoneNumberController.text)) {
      textError.value = "so dien thoai da ton tai".tr;
      return;
    }
    String? smsConfigId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.smsConfigIdStorageKey);
    if (smsConfigId != null && smsConfigId.isNotEmpty) {
      dev.log("Go to phone OTP", name: AccountAppConfig.packageName);
      Get.toNamed(AccountRouteConfig.changePhoneOtpRoute);
    } else {
      dev.log("Execute change phone number", name: AccountAppConfig.packageName);
      changePhoneNumber();
    }
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

  Future<void> changePhoneNumber({Function? callbackError}) async {
    dev.log("CHANGE PHONE NUMBER", name: AccountAppConfig.packageName);
    userInfo.phoneNumber = [PhoneNumberModel(value: phoneNumberController.text)];
    userInfo.account.username = [UserNameTypeModel(value: phoneNumberController.text)];
    dev.log(userInfo.toJson().toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    Response response = await AuthService().updateUserFullyByJson(id: userInfo.id ?? "", json: userInfo.toJson());
    dev.log(response.body.toString(), name: AccountAppConfig.packageName);
    if (response.statusCode == 200 && response.body["affectedRows"] > 0) {
      Get.dialog(
          SuccessDialog(
            callback: () => Get.offAllNamed(AccountRouteConfig.userDetailRoute),
            message: "cap nhat thong tin thanh cong".tr,
          ),
          barrierDismissible: false);
    } else {
      Get.dialog(
          ErrorDialog(
            message: "cap nhat thong tin that bai".tr,
            callback: callbackError != null ? () => callbackError() : () {},
          ),
          barrierDismissible: false);
    }
  }
}
