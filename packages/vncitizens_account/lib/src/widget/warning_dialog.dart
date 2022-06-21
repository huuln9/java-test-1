import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/account_app_config.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog({Key? key, this.callback, required this.message}) : super(key: key);

  final Function? callback;
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
                  "${AccountAppConfig.assetsRoot}/images/warning.png",
                )),
            const SizedBox(height: 26),
            Text("thong bao".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 26),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 26),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 120
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  if (callback != null) {
                    callback!();
                  }
                },
                child: Text(
                  "dong".tr.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
