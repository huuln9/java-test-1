import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_qrcode/src/config/app_config.dart';
import 'package:vncitizens_qrcode/src/util/qrcode_util.dart';

class QRScanBody extends StatelessWidget {
  QRScanBody({Key? key, required this.textCtrler, required this.isShowQRScan})
      : super(key: key);

  final QRCodeUtil qrUtil = Get.put(QRCodeUtil());
  final InternetController _internetController = Get.put(InternetController());

  final TextEditingController textCtrler;
  RxBool isShowQRScan;

  @override
  Widget build(BuildContext context) {
    qrUtil.textCtrler = textCtrler;
    qrUtil.showQRScan = isShowQRScan;
    return Obx(
      () => _internetController.hasConnected.value
          ? Column(
              children: <Widget>[
                Expanded(flex: 1, child: _buildQrView(context)),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        qrUtil.qrViewController?.pauseCamera();
                        qrUtil.getQrByGallery();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('quet anh co san'.tr.toUpperCase(),
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                )
              ],
            )
          : NoInternet(onPressed: () => qrUtil.onInit()),
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
      key: qrUtil.qrKey,
      onQRViewCreated: qrUtil.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          cutOutBottomOffset: -20,
          overlayColor: Colors.white,
          borderColor: AppConfig.materialMainBlueColor,
          // borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => qrUtil.onPermissionSet(context, ctrl, p),
    );
  }
}
