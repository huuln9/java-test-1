import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AccountUtil {
  static GetSnackBar getMySnackBar({String? message}) {
    return GetSnackBar(
      message: message ?? "cap nhat du lieu that bai".tr,
      mainButton: TextButton(
        onPressed: () => Get.closeAllSnackbars(),
        child: Text("dong".tr.toUpperCase(), style: const TextStyle(color: Color(0xFF5E92F3)),),
      ),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
    );
  }
}