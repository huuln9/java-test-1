import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/change_phone_controller.dart';

class ChangePhoneOtpController extends GetxController {
  final otpFormKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  final int maxSeconds = 120;
  RxInt second = 0.obs;
  late Timer timer;
  late String otp;
  RxBool disableResent = true.obs;
  RxString phoneNumber = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    generateOtp();
    phoneNumber.value = getHiddenPhoneNumber();
    sendOTP();
    startTimer();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    timer.cancel();
    otpController.dispose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    otpController.dispose();
  }

  Future<void> sendOTP() async {
    ChangePhoneController changePhoneController = Get.find();
    String resPhone = changePhoneController.phoneNumberController.text;
    String mes = " la ma OTP dang ky tai khoan cua ban. Vui long khong chia se cho bat ky ai.";
    String configId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.smsConfigIdStorageKey);
    Response response = await NotifyService().sendOtpMessage(message: otp + mes, phoneNumber: resPhone, configId: configId);
    dev.log(response.body.toString(), name: AccountAppConfig.packageName + "SEND OTP RESPONSE BODY");
    dev.log(response.statusCode.toString(), name: AccountAppConfig.packageName + "SEND OTP RESPONSE CODE");
  }

  String getHiddenPhoneNumber() {
    ChangePhoneController changePhoneController = Get.find();
    String resPhone = changePhoneController.phoneNumberController.text;
    return "xxxxxxx" + resPhone[7] + resPhone[8] + resPhone[9];
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
      dev.log("Submit form", name: AccountAppConfig.packageName);
      timer.cancel();
      ChangePhoneController changePhoneController = Get.find();
      changePhoneController.changePhoneNumber(callbackError: () => Get.back());
      disableResent.value = true;
    } else {
      disableResent.value = false;
    }
  }
}