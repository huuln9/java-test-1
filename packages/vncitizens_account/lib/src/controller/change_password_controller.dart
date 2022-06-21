import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/controller/user_detail_controller.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';
import 'package:vncitizens_account/src/widget/success_dialog.dart';

import '../config/account_app_config.dart';
import '../widget/error_dialog.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  RxBool showNewPassword = false.obs;
  RxBool showRepeatPassword = false.obs;
  RxBool disableButton = true.obs;
  late String fullname;
  List<String> usernames = [];
  List<String> phoneNumbers = [];
  RxString oldPassTextErr = "".obs;
  RxString newPassTextErr = "".obs;
  RxString repeatPassTextErr = "".obs;
  bool oldPassValid = false;
  bool newPassValid = false;
  bool repeatPassValid = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
  }

  /// get info from user detail controller
  Future<void> getUserInfo() async {
    UserDetailController userDetailController = Get.find();
    fullname = userDetailController.fullName.value;
    usernames = userDetailController.usernames;
    phoneNumbers = userDetailController.phoneNumbers;
    dev.log(phoneNumbers.toString(), name: AccountAppConfig.packageName + " Emails");
    dev.log(fullname, name: AccountAppConfig.packageName + " FullName");
    dev.log(usernames.toString(), name: AccountAppConfig.packageName + " Usernames");
  }

  void setShowNewPassword(bool value) {
    showNewPassword.value = value;
  }

  void setShowRepeatPassword(bool value) {
    showRepeatPassword.value = value;
  }

  void oldPassValidator(String? value) {
    if (value == null || value.isEmpty) {
      oldPassValid = false;
      oldPassTextErr.value = "vui long nhap mat khau".tr;
    } else {
      oldPassTextErr.value = "";
      oldPassValid = true;
    }
  }

  void newPassValidator(String? value) {
    if (repeatPasswordController.text.isNotEmpty) {
      repeatPassValidator();
    }
    if (value == null || value.isEmpty) {
      newPassTextErr.value = "vui long nhap mat khau".tr;
      newPassValid = false;
    } else {
      if (value.length < 8) {
        newPassTextErr.value = 'mat khau it nhat 8 ky tu'.tr;
        newPassValid = false;
      } else if (value.length > 120) {
        newPassTextErr.value = 'do dai toi da 128 ki tu'.tr;
        newPassValid = false;
      } else if (value == oldPasswordController.text) {
        newPassTextErr.value = 'mat khau moi phai khac mat khau cu'.tr;
        newPassValid = false;
      } else {
        newPassTextErr.value = "";
        newPassValid = true;
      }
    }
  }

  void repeatPassValidator() {
    if (repeatPasswordController.text.isEmpty) {
      repeatPassTextErr.value = "";
    } else {
      repeatPassTextErr.value = repeatPasswordController.text == newPasswordController.text ? "" : "mat khau khong khop!".tr;
    }
    repeatPassValid = repeatPasswordController.text == newPasswordController.text;
  }

  void checkDisableButton() {
    if (oldPassValid && newPassValid && repeatPassValid) {
      disableButton.value = false;
    } else {
      disableButton.value = true;
    }
  }

  Future<void> confirmPassword() async {
    Response responseConfirmPass =
        await AuthService().confirmPassword(username: AuthUtil.username ?? "", password: oldPasswordController.text);
    dev.log(responseConfirmPass.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(responseConfirmPass.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (responseConfirmPass.statusCode != 200) {
      oldPassTextErr.value = "mat khau hien tai chua dung".tr;
      disableButton.value = true;
    }
  }

  Future<void> submit() async {
    dev.log("SUBMIT FORM", name: AccountAppConfig.packageName);
    Response responseConfirmPass =
        await AuthService().confirmPassword(username: AuthUtil.username ?? "", password: oldPasswordController.text);
    dev.log(responseConfirmPass.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(responseConfirmPass.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (responseConfirmPass.statusCode == 200) {
      dev.log("CHANGING PASS", name: AccountAppConfig.packageName);
      Response response = await AuthService().resetPassword(username: AuthUtil.username ?? "", password: newPasswordController.text);
      dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
      dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
      if (response.statusCode == 200 && response.body["affectedRows"] > 0) {
        Get.dialog(
            SuccessDialog(
              callback: () => Get.offAllNamed(AccountRouteConfig.userDetailRoute),
              message: "cap nhat thong tin thanh cong".tr,
            ),
            barrierDismissible: false);
      } else {
        Get.dialog(
          ErrorDialog(message: "cap nhat thong tin that bai".tr, callback: () {}),
          barrierDismissible: false,
        );
      }
    } else {
      oldPassTextErr.value = "mat khau hien tai chua dung".tr;
      disableButton.value = true;
    }
  }
}
