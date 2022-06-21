import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/src/controller/dossier_controller.dart';
import 'package:vncitizens_dossier/src/widget/dossier_list.dart';
import 'package:vncitizens_dossier/vncitizens_dossier.dart';
export 'package:vncitizens_qrcode/src/widget/qrscan_body.dart';

class Dossier extends GetView<DossierController> {
  const Dossier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => controller.isShowSearchInput.value
              ? _buildSearchInput(context)
              : Text("tra cuu ho so".tr),
        ),
        actions: [
          Obx(() => !controller.isShowSearchInput.value &&
                  !controller.isShowQRScan.value
              ? IconButton(
                  onPressed: () => controller.onTapIconQRScan(),
                  icon: const Icon(Icons.qr_code))
              : const SizedBox.shrink()),
          Obx(
            () => !controller.isShowQRScan.value
                ? controller.isShowSearchInput.value
                    ? IconButton(
                        onPressed: () => controller.onTapIconDeSearch(),
                        icon: const Icon(Icons.close))
                    : IconButton(
                        onPressed: () => controller.onTapIconSearch(),
                        icon: const Icon(Icons.search))
                : const SizedBox.shrink(),
          ),
          Obx(() => controller.isShowSearchInput.value &&
                  !controller.isShowQRScan.value
              ? IconButton(
                  onPressed: () => controller.onTapIconQRScan(),
                  icon: const Icon(Icons.qr_code))
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(
        () => controller.isShowQRScan.value
            ? QRScanBody(
                textCtrler: controller.searchController,
                isShowQRScan: controller.isShowQRScan)
            : const DossierList(),
      ),
      // floatingActionButton: const MyFloatingActionButton(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextFormField(
        controller: controller.searchController,
        focusNode: controller.focusNode,
        onEditingComplete: () {
          controller.getDossierByKey();
          FocusScope.of(context).unfocus();
        },
        cursorColor: Colors.white,
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        decoration: InputDecoration(
            filled: true,
            hintStyle: const TextStyle(color: Colors.white70),
            fillColor: Theme.of(context).appBarTheme.backgroundColor,
            border: InputBorder.none),
      ),
    );
  }
}
