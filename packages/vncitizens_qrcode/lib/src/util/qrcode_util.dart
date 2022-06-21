import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vncitizens_qrcode/src/config/app_config.dart';

class QRCodeUtil extends GetxController {
  Barcode? scanResult;
  String? scanResultStr;
  QRViewController? qrViewController;

  TextEditingController? textCtrler;
  RxBool? showQRScan;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void onInit() {
    super.onInit();
    log("INIT QR CODE UTIL", name: AppConfig.packageName);
  }

  void onQRViewCreated(QRViewController ctrler) {
    qrViewController = ctrler;
    ctrler.scannedDataStream.listen((scanData) {
      scanResult = scanData;
      qrViewController!.pauseCamera();
      _exeQrCode(scanResult!.code ?? '');
    });
  }

  void getQrByGallery() {
    Stream.fromFuture(ImagePicker().pickImage(source: ImageSource.gallery))
        .flatMap((file) {
      if (file == null) throw Exception('Can not find image');
      return Stream.fromFuture(QrCodeToolsPlugin.decodeFrom(file.path));
    }).listen((scanData) {
      scanResultStr = scanData;
      _exeQrCode(scanResultStr);
    }).onError((error, stackTrace) {
      scanResultStr = '';
      log(error.toString(), name: AppConfig.packageName);
      _showNullDialog();
    });
  }

  void _exeQrCode(String? scanResultStr) {
    if (scanResultStr == null) {
      _showNullDialog();
      return;
    } else {
      final id = scanResultStr.split('|')[0];
      _fillTextResult(id);
    }
  }

  void _fillTextResult(scanResultStr) {
    textCtrler!.text = scanResultStr;
    showQRScan!.value = false;
  }

  void _showNullDialog() {
    _showMyDialog(
      title: 'thong bao'.tr,
      content: 'khong tim thay ma qr'.tr,
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
  }

  Future<void> _showMyDialog({
    String title = '',
    String content = '',
    List<Widget> actions = const [],
  }) {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(color: AppConfig.materialMainBlueColor),
          ),
          content: Text(content),
          actions: actions,
        );
      },
    );
  }

  TextButton _showMyButton({
    String text = '',
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      child: Text(
        text.tr.toUpperCase(),
        style: const TextStyle(color: AppConfig.materialMainBlueColor),
      ),
      onPressed: onPressed,
    );
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p',
        name: AppConfig.packageName);
    if (!p) {
      log('No Permission', name: AppConfig.packageName);
      _showMyDialog(
        title: 'thong bao'.tr,
        content: 'No Permission'.toUpperCase(),
        actions: [
          _showMyButton(
            text: 'dong',
            onPressed: () => Get.back(),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }
}
