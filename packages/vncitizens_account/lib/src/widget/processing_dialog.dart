import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({Key? key, this.message}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
            Text(message ?? ("dang xu ly. vui long cho giay lat".tr + "..."), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
