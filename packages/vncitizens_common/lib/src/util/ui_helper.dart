import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vncitizens_common/src/config/app_config.dart';

class UIHelper {
  static Future showRequiredLoginDialog({String? routeBack}) async {
    await Get.dialog(
        AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          content: SizedBox(
            width: Get.width - 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Image(
                      height: 150,
                      width: 150,
                      image: AssetImage(
                          AppConfig.assetsRoot + '/images/error.png')),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "dang nhap".tr,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text("ban can dang nhap truoc khi su dung tinh nang nay".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey))
                ],
              ),
            ),
          ),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          actionsPadding: EdgeInsets.zero,
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Color(0xFF1565C0))),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: Text(
                        "dong".tr.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Get.back();
                        if (routeBack != null) {
                          Get.toNamed("/vncitizens_account/login",
                              arguments: [routeBack]);
                        } else {
                          Get.toNamed("/vncitizens_account/login");
                        }
                      },
                      child: Text(
                        "dang nhap".tr.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )

            // TextButton(
            //     onPressed: () => Get.back(),
            //     child: Text(
            //       "dong".tr.toUpperCase(),
            //       style: const TextStyle(
            //           color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
            //     )),
            // TextButton(
            //     onPressed: () async {
            //       if (isPop != null) {
            //         await Get.toNamed("/vncitizens_account/login",
            //             arguments: [isPop]);
            //         Get.back();
            //       } else if (routeBack != null) {
            //         Get.back();
            //         Get.toNamed("/vncitizens_account/login",
            //             arguments: [routeBack]);
            //       } else {
            //         Get.back();
            //         Get.toNamed("/vncitizens_account/login");
            //       }
            //     },
            //     child: Text(
            //       "dang nhap".tr.toUpperCase(),
            //       style: const TextStyle(
            //           color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
            //     )),
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

  static showNotificationDialog(
      {required Widget title,
      required Widget content,
      required VoidCallback? onPressed}) {
    Get.dialog(
        AlertDialog(
          title: title,
          content: content,
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
                onPressed: onPressed,
                child: Text(
                  "dong y".tr.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFF0D47A1), fontWeight: FontWeight.bold),
                )),
          ],
        ),
        barrierDismissible: false);
  }

  static showBottomSheetActions({required List<Widget> children}) {
    List<Widget> childrenOrigin = [
      Container(
          alignment: FractionalOffset.topRight,
          child: InkWell(
            child: const Padding(
              padding: EdgeInsets.only(top: 8, right: 8),
              child: Icon(Icons.clear),
            ),
            onTap: () {
              Get.back();
            },
          )),
      ...children,
      const SizedBox(height: 65)
    ];

    Get.bottomSheet(
      Wrap(children: childrenOrigin),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
    );
  }
}
