import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';

class ResetPassSmsOtpController extends GetxController {
  final otpFormKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final int maxSeconds = 120;
  RxInt second = 0.obs;
  late Timer timer;
  late String otp;
  RxBool disableResent = true.obs;
  RxString phoneNumber = "".obs;
  String rawPhoneNumber = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    generateOtp();
    rawPhoneNumber = Get.arguments[0];
    phoneNumber.value = getHiddenPhoneNumber();
    sendOTP();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dev.log("dispose was called", name: AccountAppConfig.packageName + " ResetPassSmsOtpController");
    timer.cancel();
    otpController.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    dev.log("onClose was called", name: runtimeType.toString());
    timer.cancel();
    otpController.dispose();
  }

  Future<void> sendOTP() async {
    if (rawPhoneNumber.isNotEmpty) {
      String mes = " la ma OTP dang ky tai khoan cua ban. Vui long khong chia se cho bat ky ai.";
      String configId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.smsConfigIdStorageKey);
      Response response =
      await NotifyService().sendOtpMessage(message: otp + mes, phoneNumber: rawPhoneNumber, configId: configId);
      dev.log(response.body.toString(), name: AccountAppConfig.packageName + "SEND OTP RESPONSE BODY");
      dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + "SEND OTP RESPONSE CODE");
    }  else {
      dev.log("Phone number is empty -> Cannot send OTP", name: AccountAppConfig.packageName);
    }
  }

  String getHiddenPhoneNumber() {
    if (rawPhoneNumber.isNotEmpty) {
      return "xxxxxxx" + rawPhoneNumber[7] + rawPhoneNumber[8] + rawPhoneNumber[9];
    }
    return "";
  }

  void startTimer() {
    second.value = maxSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second > 0) {
        second.value--;
      } else {
        disableResent.value = false;
        timer.cancel();
        dev.log("OTP expired");
      }
    });
  }

  void generateOtp() {
    final rnd = Random();
    dynamic next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    otp = next.toInt().toString();
    dev.log("OTP: " + next.toInt().toString(), name: AccountAppConfig.packageName);
  }

  String? otpValidator(String? value) {
    if (value == null || value.length != 6 || value != otp || second.value == 0) {
      return "ma xac thuc otp khong dung hoac da het han su dung".tr;
    }
    return null;
  }

  void resetForm() {
    generateOtp();
    timer.cancel();
    startTimer();
    sendOTP();
    disableResent.value = true;
    final state = otpFormKey.currentState;
    if (state != null) {
      state.reset();
    }
  }

  Future<void> submit() async {
    final state = otpFormKey.currentState;
    if (state != null && state.validate()) {
      dev.log("Submit form", name: runtimeType.toString());
      timer.cancel();
      disableResent.value = true;
      Get.toNamed(AccountRouteConfig.resetPasswordNewPassRoute, arguments: [rawPhoneNumber]);
    } else {
      disableResent.value = false;
    }
  }
}
