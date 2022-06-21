import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
                widthFactor: 0.6,
                child: Image.asset(
                  "${AppConfig.assetsRoot}/error.png",
                )),
            const SizedBox(height: 26),
            Text("that bai".tr,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 26),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 26),
            ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style:
                          ElevatedButton.styleFrom(minimumSize: const Size(110, 40)),
                      child: Text(
                        "thu lai".tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        primary: Colors.white,
                        onPrimary: Colors.white,
                        minimumSize: const Size(110, 40), //////// HERE
                      ),
                      child: Text(
                        "dong".tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
