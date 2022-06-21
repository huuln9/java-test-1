import 'package:flutter/material.dart';
import 'package:vncitizens_qrcode/src/widget/qrcode_body.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class QRCode extends StatelessWidget {
  const QRCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('quet ma qr'.tr)),
      body: QRCodeBody(),
      // floatingActionButton: const MyFloatingActionButton(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }
}
