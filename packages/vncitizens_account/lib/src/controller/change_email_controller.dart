import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/user_detail_controller.dart';
import 'package:vncitizens_account/src/model/phone_number_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/vncitizens_account.dart';

import '../widget/success_dialog.dart';

class ChangeEmailController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  RxBool disableButton = true.obs;
  late String fullname;
  List<String> usernames = [];
  List<String> phoneNumbers = [];
  RxString textError = "".obs;
  late UserFullyModel userInfo;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserInfo();
  }

  /// get info from user detail controller
  Future<void> getUserInfo() async {
    UserDetailController userDetailController = Get.find();
    fullname = userDetailController.fullName.value;
    usernames = userDetailController.usernames;
    phoneNumbers = userDetailController.phoneNumbers;

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

  bool checkIfPhoneNumber(String value) {
    String pattern = r'(^0[0-9]{9}$)';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      textError.value = "";
      disableButton.value = true;
    } else {
      if (value.length > 120) {
        disableButton.value = true;
        textError.value = 'do dai toi da 128 ki tu'.tr;
      }
      textError.value = EmailValidator.validate(value) ? "" : "email khong hop le".tr;
      disableButton.value = !EmailValidator.validate(value);
    }
  }

  Future<bool> checkEmailExists(String email) async {
    Response response = await AuthService().checkEmailExists(email: email);
    dev.log("Checking email exists", name: AccountAppConfig.packageName);
    dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<void> submit() async {
    dev.log("Execute change phone number", name: AccountAppConfig.packageName);
    if (emailController.text.isNotEmpty && await checkEmailExists(emailController.text)) {
      textError.value = "email da ton tai".tr;
      return;
    }
    changeEmail();
  }

  Future<void> changeEmail() async {
    dev.log("CHANGE PHONE NUMBER", name: AccountAppConfig.packageName);
    userInfo.email = [PhoneNumberModel(value: emailController.text)];
    dev.log(userInfo.toJson().toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    Response response = await AuthService().updateUserFullyByJson(id: userInfo.id ?? "", json: userInfo.toJson());
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.body["affectedRows"] > 0) {
      Get.dialog(
          SuccessDialog(
            callback: () => Get.offAllNamed(AccountRouteConfig.userDetailRoute),
            message: "cap nhat thong tin thanh cong".tr,
          ),
          barrierDismissible: false);
    } else {
      try {
        List<int> backendStatusCodes = [10015];
        if (backendStatusCodes.contains(response.body["code"])) {
          Get.dialog(
              ErrorDialog(message: response.body["message"], callback: () {}),
              barrierDismissible: false);
        } else {
          Get.dialog(
              ErrorDialog(message: "cap nhat thong tin that bai".tr, callback: () {}),
              barrierDismissible: false);
        }
      } catch (error) {
        Get.dialog(
            ErrorDialog(message: "cap nhat thong tin that bai".tr, callback: () {}),
            barrierDismissible: false);
        return;
      }
    }
  }
}
