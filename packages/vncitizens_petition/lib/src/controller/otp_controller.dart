import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/create_controller.dart';

import '../config/app_config.dart';

class OtpController extends GetxController {
  PetitionCreateController petitionCreateController = Get.find();

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
    super.onInit();
    phoneNumber.value = getHiddenPhoneNumber();
    sendOTP();
    startTimer();
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    otpController.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    otpController.dispose();
  }

  Future<void> sendOTP() async {
    var res = await IGateSysmanService().sendOTP(
        phoneNumber: petitionCreateController.phoneController.text,
        email: petitionCreateController.emailController.text);
  }

  String getHiddenPhoneNumber() {
    String resPhone = petitionCreateController.phoneController.text;
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

  String? otpValidator(String? value) {
    if (value == null || value.length != 6 || second.value == 0) {
      return "ma xac thuc otp khong dung hoac da het han su dung".tr;
    }
    return null;
  }

  void resetForm() {
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
      dev.log("Submit form", name: AppConfig.packageName);
      timer.cancel();
      var res = await IGateSysmanService().confirmOTP(
          phoneNumber: petitionCreateController.phoneController.text,
          email: petitionCreateController.emailController.text,
          otp: otpController.text);
      if (res.statusCode == 200) {
        Get.back(result: true);
      } else {
        UIHelper.showNotificationSnackBar(
            message: 'xac thuc khong thanh cong'.tr);
      }
      disableResent.value = true;
    } else {
      disableResent.value = false;
    }
  }
}
