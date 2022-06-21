import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_qrcode/src/config/app_config.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:rxdart/rxdart.dart';

class QRCodeController extends GetxController {
  Barcode? scanResult;
  String? scanResultStr;
  QRViewController? qrViewController;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  static const qrcodeWifiChannel = MethodChannel('qrcode_wifisetting');

  @override
  void onInit() {
    super.onInit();
    log("INIT QR CODE CONTROLLER", name: AppConfig.packageName);
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

  void _exeQrCode(String? scanResultStr) {
    if (scanResultStr == null) {
      _showNullDialog();
      return;
    }

    final splitted = scanResultStr.split(':');

    if (_checkURL(scanResultStr)) {
      log('Scan type: URL', name: AppConfig.packageName);
      _showWebDialog(scanResultStr);
    } else if (_checkMessage(scanResultStr)) {
      log('Scan type: Message', name: AppConfig.packageName);
      _showMessageDialog(splitted);
    } else if (_checkPhone(scanResultStr)) {
      log('Scan type: Phone', name: AppConfig.packageName);
      _showPhoneDialog(splitted);
    } else if (_checkEmail(scanResultStr)) {
      log('Scan type: Email', name: AppConfig.packageName);
      // split result
      final splitted1 = scanResultStr.split(';');
      var splitted = [];
      for (var e in splitted1) {
        final splitted2 = e.split(':');
        splitted = splitted..addAll(splitted2);
      }
      _showEmailDialog(splitted);
    } else if (_checkWifi(scanResultStr)) {
      log('Scan type: Wifi', name: AppConfig.packageName);
      // split result
      final splitted1 = scanResultStr.split(';');
      var splitted = [];
      for (var e in splitted1) {
        final splitted2 = e.split(':');
        splitted = splitted..addAll(splitted2);
      }
      _showWifiDialog(splitted);
    } else {
      log('Scan type: Text', name: AppConfig.packageName);
      _showTextDialog(scanResultStr);
    }
  }

  bool _checkURL(scanResultStr) {
    return Uri.tryParse(scanResultStr)?.hasAbsolutePath ?? false;
  }

  bool _checkMessage(scanResultStr) {
    final splitted = scanResultStr.split(':');
    if (splitted[0].toLowerCase() == 'smsto' &&
        double.tryParse(splitted[1]) != null) {
      return true;
    }
    return false;
  }

  bool _checkPhone(scanResultStr) {
    final splitted = scanResultStr.split(':');
    if (splitted[0].toLowerCase() == 'tel' &&
        double.tryParse(splitted[1]) != null) {
      return true;
    }
    return false;
  }

  bool _checkEmail(scanResultStr) {
    // split result
    final splitted1 = scanResultStr.split(';');
    var splitted = [];
    for (var e in splitted1) {
      final splitted2 = e.split(':');
      splitted = splitted..addAll(splitted2);
    }

    // find email index
    int emailIndex = 0;
    for (var i = 0; i < splitted.length; i++) {
      if (splitted[i].toLowerCase() == 'to') {
        emailIndex = i + 1;
      }
    }

    if (splitted[0].toLowerCase() == 'matmsg' &&
        _regexEmail(splitted[emailIndex])) {
      return true;
    }
    return false;
  }

  bool _checkWifi(scanResultStr) {
    // split result
    final splitted1 = scanResultStr.split(';');
    var splitted = [];
    for (var e in splitted1) {
      final splitted2 = e.split(':');
      splitted = splitted..addAll(splitted2);
    }

    if (splitted[0].toLowerCase() == 'wifi') {
      return true;
    }
    return false;
  }

  void _showTextDialog(scanResultStr) {
    _showMyDialog(
      title: 'van ban'.tr,
      content: '$scanResultStr',
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'sao chep',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: scanResultStr));
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
  }

  void _showWebDialog(scanResultStr) {
    _showMyDialog(
      title: 'trang web'.tr,
      content: '$scanResultStr',
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'mo',
          onPressed: () {
            _launchURL(scanResultStr);
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
  }

  void _showMessageDialog(splitted) {
    String message = splitted[2];
    List<String> recipents = [splitted[1]];

    _showMyDialog(
      title: 'tin nhan'.tr,
      content: 'nhan tin cho'.trParams({'recipent': recipents[0]}),
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'dong y',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
            _sendSMS(message, recipents);
          },
        ),
      ],
    );
  }

  void _showPhoneDialog(splitted) {
    _showMyDialog(
      title: 'so dien thoai'.tr,
      content: 'goi den so'.trParams({'phone': splitted[1]}),
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'dong y',
          onPressed: () {
            _makeCall(splitted);
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
  }

  void _showEmailDialog(splitted) {
    // find email index
    int emailIndex = 0;
    for (var i = 0; i < splitted.length; i++) {
      if (splitted[i].toLowerCase() == 'to') {
        emailIndex = i + 1;
      }
    }

    _showMyDialog(
      title: 'Email',
      content: 'gui mail toi'.trParams({'email': splitted[emailIndex]}),
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'dong y',
          onPressed: () {
            _sendEmail(splitted, emailIndex);
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
  }

  void _showWifiDialog(splitted) {
    // find email index
    int ssidIndex = 0;
    for (var i = 0; i < splitted.length; i++) {
      if (splitted[i].toLowerCase() == 's') {
        ssidIndex = i + 1;
      }
    }

    _showMyDialog(
      title: 'Wifi',
      content: 'ket noi toi wifi'.trParams({'wifi': splitted[ssidIndex]}),
      actions: [
        _showMyButton(
          text: 'dong',
          onPressed: () {
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
        _showMyButton(
          text: 'dong y',
          onPressed: () {
            _connectWifi(splitted, ssidIndex);
            Get.back();
            qrViewController!.resumeCamera();
          },
        ),
      ],
    );
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

  void _launchURL(url) async {
    await launch(url, forceWebView: true).catchError((onError) {
      log('An error occurred ! Could not launch "$url"',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Launch "$url" successfully', name: AppConfig.packageName);
  }

  void _sendSMS(String message, List<String> recipents) async {
    await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      log('An error occurred ! Could not send sms',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Send SMS successfully', name: AppConfig.packageName);
  }

  Future<void> _makeCall(splitted) async {
    final url = 'tel:${splitted[1]}';
    await launch(url).catchError((onError) {
      log('An error occurred ! Could not make a call',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Make a call successfully', name: AppConfig.packageName);
  }

  Future<void> _sendEmail(splitted, emailIndex) async {
    // find subject & body index
    int subjectIndex = 0;
    int bodyIndex = 0;
    for (var i = 0; i < splitted.length; i++) {
      if (splitted[i].toLowerCase() == 'sub') {
        subjectIndex = i + 1;
      } else if (splitted[i].toLowerCase() == 'body') {
        bodyIndex = i + 1;
      }
    }
    final url =
        'mailto:${splitted[emailIndex]}?subject=${splitted[subjectIndex]}&body=${splitted[bodyIndex]}';
    await launch(url).catchError((onError) {
      log('An error occurred ! Could not send email',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Send email successfully', name: AppConfig.packageName);
  }

  Future<void> _connectWifi(splitted, ssidIndex) async {
    // find password & security index
    int passwordIndex = 0;
    int securityIndex = 0;
    for (var i = 0; i < splitted.length; i++) {
      if (splitted[i].toLowerCase() == 'p') {
        passwordIndex = i + 1;
      } else if (splitted[i].toLowerCase() == 't') {
        securityIndex = i + 1;
      }
    }

    NetworkSecurity networkSecurity;
    switch (splitted[securityIndex]) {
      case 'WPA':
        networkSecurity = NetworkSecurity.WPA;
        break;
      case 'WEP':
        networkSecurity = NetworkSecurity.WEP;
        break;
      default:
        networkSecurity = NetworkSecurity.NONE;
        break;
    }

    await WiFiForIoTPlugin.connect(
      splitted[ssidIndex],
      password: splitted[passwordIndex],
      joinOnce: true,
      security: networkSecurity,
      withInternet: true,
    ).catchError((onError) {
      log('An error occurred ! Could not scan specific wifi',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });

    try {
      await _redirectToWifiSetting();
      log('Scan specific wifi successfully'.toUpperCase(),
          name: AppConfig.packageName);
    } catch (e) {
      log('An error occurred ! Could not redirect to wifi setting',
          name: AppConfig.packageName);
      log(e.toString(), name: AppConfig.packageName);
    }
  }

  _redirectToWifiSetting() async {
    if (Platform.isAndroid) {
      final String result =
          await qrcodeWifiChannel.invokeMethod('redirectToWifiSettingAndroid');
      log(result, name: AppConfig.packageName);
    } else if (Platform.isIOS) {
      await qrcodeWifiChannel.invokeMethod('redirectToSettingIos');
    }
  }

  bool _regexEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
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

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }
}
