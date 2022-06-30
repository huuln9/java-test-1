import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIHelper {
  static Future showRequiredLoginDialog(
      {String? routeBack, bool? isPop}) async {
    await Get.dialog(
        AlertDialog(
          title: Text("dang nhap".tr),
          content: Text("chuc nang can dang nhap truoc".tr),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: EdgeInsets.zero,
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "dong".tr.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
                )),
            TextButton(
                onPressed: () async {
                  if (isPop != null) {
                    await Get.toNamed("/vncitizens_account/login",
                        arguments: [isPop]);
                    Get.back();
                  } else if (routeBack != null) {
                    Get.back();
                    Get.toNamed("/vncitizens_account/login",
                        arguments: [routeBack]);
                  } else {
                    Get.back();
                    Get.toNamed("/vncitizens_account/login");
                  }
                },
                child: Text(
                  "dang nhap".tr.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
                )),
          ],
        ),
        barrierDismissible: false);
  }

  static showNotificationSnackBar({required String message}) {
    Get.snackbar('', '',
        titleText: const SizedBox(height: 0),
        messageText: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
        colorText: Colors.white,
        shouldIconPulse: true,
        barBlur: 20,
        isDismissible: true,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
        borderRadius: 2,
        margin: const EdgeInsets.all(16),
        mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
            },
            child: Text('dong'.tr.toUpperCase())));
  }
}
