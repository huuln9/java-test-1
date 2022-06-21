import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';

import '../config/account_app_config.dart';
import '../widget/error_dialog.dart';
import '../widget/success_dialog.dart';

class ResetPassNewPassController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  RxBool showNewPassword = false.obs;
  RxBool showRepeatPassword = false.obs;
  RxBool disableButton = true.obs;
  RxString newPassTextErr = "".obs;
  RxString repeatPassTextErr = "".obs;
  bool newPassValid = false;
  bool repeatPassValid = false;
  String username = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    username = Get.arguments[0];
  }


  void setShowNewPassword(bool value) {
    showNewPassword.value = value;
  }

  void setShowRepeatPassword(bool value) {
    showRepeatPassword.value = value;
  }

  void newPassValidator(String? value) {
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
      } else {
        newPassTextErr.value = "";
        newPassValid = true;
      }
    }
    if (repeatPasswordController.text.isNotEmpty) {
      repeatPassValidator();
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
    if (newPassValid && repeatPassValid) {
      disableButton.value = false;
    } else {
      disableButton.value = true;
    }
  }

  bool checkFormValidate() {
    newPassValidator(newPasswordController.text);
    repeatPassValidator();
    if (newPassValid && repeatPassValid) {
      disableButton.value = false;
      return true;
    } else {
      disableButton.value = true;
      return false;
    }
  }

  Future<void> submit() async {
    if (checkFormValidate()) {
      dev.log("SUBMIT FORM", name: AccountAppConfig.packageName);
      Response response = await AuthService().resetPassword(username: username, password: newPasswordController.text);
      dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
      dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
      if (response.statusCode == 200 && response.body["affectedRows"] > 0) {
        Get.dialog(
            SuccessDialog(
              callback: () => _login(),
              message: "cap nhat thong tin thanh cong".tr,
            ),
            barrierDismissible: false);
      } else {
        Get.dialog(
          ErrorDialog(message: "cap nhat thong tin that bai".tr, callback: () {}),
          barrierDismissible: false,
        );
      }
    }
  }

  Future<void> _login() async {
    Response response = await OidcService().getAccessTokenGrantPassword(
      username: username,
      password: newPasswordController.text,
    );
    if (response.statusCode == 200 && response.body["access_token"] != null) {
      /// set info to hive
      final token = response.body["access_token"];
      dev.log(token, name: AccountAppConfig.packageName + " TOKEN");
      await setHive(token, response.body["id_token"], response.body["refresh_token"]);

      /// register device vcall
      final tokenDecoded = JwtDecoder.decode(token);
      AuthService().getUserFully(tokenDecoded["external_user_id"]).then((value) {
        dev.log(value.body.toString(), name: AccountAppConfig.packageName + " BODY");
        String? phoneNumber =
            value.body["phoneNumber"] == null || value.body["phoneNumber"].length == 0 ? null : value.body["phoneNumber"][0]["value"];
        if (phoneNumber != null) {
          VCallUtil.registerDevice(phoneNumber);
        }
      });

      Get.offAllNamed(AccountRouteConfig.userDetailRoute);
    } else {
      dev.log("LOGIN FAILED");
    }
  }

  Future<void> setHive(String token, String idToken, String refreshToken) async {
    final tokenDecoded = JwtDecoder.decode(token);
    final hiveBox = Hive.box(AccountAppConfig.storageBox);
    await hiveBox.clear();
    await hiveBox.put("is_logon", true);
    await hiveBox.put("user_id", tokenDecoded["external_user_id"]);
    await hiveBox.put("username", tokenDecoded["preferred_username"]);
    await hiveBox.put("name", tokenDecoded["given_name"] ?? tokenDecoded["name"]);
    await hiveBox.put("access_token", token);
    await hiveBox.put("id_token", idToken);
    await hiveBox.put("refresh_token", refreshToken);
  }
}
