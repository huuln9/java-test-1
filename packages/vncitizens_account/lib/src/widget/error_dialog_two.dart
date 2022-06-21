import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/account_app_config.dart';

class ErrorDialogTwo extends StatelessWidget {
  const ErrorDialogTwo({Key? key, this.onClose, required this.message, this.onRetry}) : super(key: key);

  final Function? onClose;
  final Function? onRetry;
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
                  "${AccountAppConfig.assetsRoot}/images/error.png",
                )),
            const SizedBox(height: 26),
            Text("that bai".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 26),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 26),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 90,
                    maxWidth: 100
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      onClose?.call();
                    },
                    child: Text(
                      "dong".tr.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                      minWidth: 90,
                      maxWidth: 100
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onRetry?.call();
                    },
                    child: Text(
                      "thu lai".tr.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
