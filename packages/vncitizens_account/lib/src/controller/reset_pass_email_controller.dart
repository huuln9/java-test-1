import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/account_app_config.dart';

class ResetPassEmailController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final inputController = TextEditingController();
  RxString textError = "".obs;
  RxBool disableButton = true.obs;
  late String fullname;
  List<String> emails = [];
  List<String> usernames = [];
  List<String> phoneNumbers = [];


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    inputController.dispose();
  }

  void inputValidator(String? value) {
    textError.value = "";
    if (value == null || value.isEmpty) {
      disableButton.value = true;
    }  else {
      if (checkIfEmail(value)) {
        disableButton.value = false;
      }  else {
        disableButton.value = true;
      }
    }
  }

  bool checkIfEmail(String value) {
    return EmailValidator.validate(value);
  }

  Future<bool> checkEmailExists(String email) async {
    Response response = await AuthService().checkEmailExists(email: email);
    dev.log("Checking email exists", name: AccountAppConfig.packageName);
    dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
    dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
    return response.statusCode == 200;
  }

  Future<void> phoneNumberValidator(String? value) async {
    if (value == null || value.isEmpty) {
      disableButton.value = true;
    } else {
      String pattern = r'(^0[0-9]{9}$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        String tmpPhone = "";
        if (value[0] == "0") {
          tmpPhone = "%2B84" + value.substring(1);
        }
        dev.log(tmpPhone, name: AccountAppConfig.packageName + " PHONE");
        Response response = await AuthService().checkPhoneNumberExists(phoneNumber: tmpPhone);
        dev.log("Checking phone exists", name: AccountAppConfig.packageName);
        dev.log(response.body.toString(), name: AccountAppConfig.packageName + " BODY");
        dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + " CODE");
        if (response.statusCode == 200) {
          textError.value = "";
          disableButton.value = false;
        }  else {
          textError.value = "so dien thoai khong ton tai".tr;
          disableButton.value = true;
        }
      }  else {
        textError.value = "so dien thoai khong hop le".tr;
        disableButton.value = true;
      }
    }
  }

  Future<void> submit() async {
    dev.log("SUBMIT FORM", name: AccountAppConfig.packageName);
    if (checkIfEmail(inputController.text)) {
      final emailExists = await checkEmailExists(inputController.text);
      if (emailExists) {
        textError.value = "";
        Get.toNamed(AccountRouteConfig.resetPasswordEmailOtpRoute, arguments: [inputController.text]);
      }  else {
        textError.value = "email khong ton tai".tr;
        disableButton.value = true;
      }
    }
  }
}
