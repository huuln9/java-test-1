import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/src/controller/dossier_controller.dart';

class DossierDetail extends GetView<DossierController> {
  const DossierDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chi tiet ho so".tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 14)),
            controller.dossier!.procedure.name != null
                ? _dossierItem(
                    title: 'ten thu tuc'.tr,
                    content: controller.dossier!.procedure.name)
                : const SizedBox.shrink(),
            controller.dossier!.code != null
                ? _dossierItem(
                    title: 'so ho so'.tr, content: controller.dossier!.code)
                : const SizedBox.shrink(),
            controller.dossier!.dossierStatus.name != null
                ? _dossierItem(
                    title: 'trang thai'.tr,
                    content: controller.dossier!.dossierStatus.name,
                    isHighlight: true)
                : const SizedBox.shrink(),
            controller.dossier!.applicant.name != null
                ? _dossierItem(
                    title: 'nguoi nop'.tr,
                    content: controller.dossier!.applicant.name)
                : const SizedBox.shrink(),
            controller.dossier!.createdDate != null
                ? _dossierItem(
                    title: 'ngay nop'.tr,
                    content: controller.convertDate(
                        date: controller.dossier!.createdDate, type: 1))
                : const SizedBox.shrink(),
            controller.dossier!.acceptedDate != null
                ? _dossierItem(
                    title: 'ngay tiep nhan'.tr,
                    content: controller.convertDate(
                        date: controller.dossier!.acceptedDate, type: 1))
                : const SizedBox.shrink(),
            controller.dossier!.appointmentDate != null
                ? _dossierItem(
                    title: 'ngay hen tra'.tr,
                    content: controller.convertDate(
                        date: controller.dossier!.appointmentDate, type: 1))
                : const SizedBox.shrink(),
            controller.dossier!.returnMethod != ''
                ? _dossierItem(
                    title: 'hinh thuc nhan ket qua'.tr,
                    content: controller.dossier!.returnMethod)
                : const SizedBox.shrink(),
            controller.dossier!.agencyAddress != ''
                ? _dossierItem(
                    title: 'dia chi nhan ket qua'.tr,
                    content: controller.dossier!.agencyAddress)
                : const SizedBox.shrink(),
            controller.dossier!.statusString != ''
                ? _dossierItem(
                    title: 'tinh trang ho so'.tr,
                    content: controller.dossier!.statusString!)
                : const SizedBox.shrink(),
          ],
        ),
      ),
      // floatingActionButton: const MyFloatingActionButton(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const MyBottomAppBar(index: 2),
    );
  }

  Widget _dossierItem({
    required String title,
    required String content,
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(color: Colors.black45),
          ),
        ),
        !isHighlight
            ? Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 4),
                child: Text(
                  content,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 4),
                child: Text(content,
                    style: TextStyle(
                        fontSize: 16,
                        color: controller.getColorByStatus(
                            controller.dossier!.dossierStatus.name),
                        fontWeight: FontWeight.bold)),
              ),
        const Divider(color: Colors.black38),
      ],
    );
  }
}
