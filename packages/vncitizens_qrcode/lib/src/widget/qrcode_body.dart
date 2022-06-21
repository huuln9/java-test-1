import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_qrcode/src/config/app_config.dart';
import 'package:vncitizens_qrcode/src/controller/qrcode_controller.dart';

class QRCodeBody extends GetView<QRCodeController> {
  QRCodeBody({Key? key}) : super(key: key);

  final InternetController _internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _internetController.hasConnected.value
          ? Column(
              children: <Widget>[
                Expanded(flex: 1, child: _buildQrView(context)),
                Expanded(
                    child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(18)),
                    SizedBox(
                        width: 220,
                        child: Text(
                            'di chuyen camera den vung chua ma qr de quet'.tr,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 18))),
                    const Padding(padding: EdgeInsets.all(18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            controller.qrViewController?.pauseCamera();
                            controller.getQrByGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('quet anh co san'.tr.toUpperCase(),
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            )
          : NoInternet(onPressed: () => controller.onInit()),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: controller.qrKey,
      onQRViewCreated: controller.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          cutOutBottomOffset: -20,
          overlayColor: Colors.white,
          borderColor: AppConfig.materialMainBlueColor,
          // borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) =>
          controller.onPermissionSet(context, ctrl, p),
    );
  }
}
