import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () => { Get.toNamed("/vncitizens_qrcode") }, child: const Icon(Icons.qr_code_scanner));
  }
}
