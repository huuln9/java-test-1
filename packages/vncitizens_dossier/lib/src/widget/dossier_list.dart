import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/src/config/app_config.dart';
import 'package:vncitizens_dossier/src/controller/dossier_controller.dart';

class DossierList extends GetView<DossierController> {
  const DossierList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const DataLoading(message: "Đang tải dữ liệu")
          : controller.dossiers.isNotEmpty
              ? _listDossier()
              : controller.isLoadFailed.value
                  ? DataFailedLoading(
                      onPressed: () => controller.getDossierByKey())
                  : controller.isLoadEmpty.value
                      ? const EmptyData()
                      : Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              'vui long nhap'.tr,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
    );
  }

  Widget _listDossier() {
    return Obx(
      () => ListView.builder(
        controller: controller.scrollController,
        itemCount: controller.isLast.value
            ? controller.dossiers.length
            : controller.dossiers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          String date = '';
          try {
            date = controller.dossiers[index].createdDate != ''
                ? controller.convertDate(
                    date: controller.dossiers[index].createdDate, type: 0)
                : '';
          } catch (e) {
            log('dossier_list:47');
          }

          return index >= controller.dossiers.length
              ? const Center(child: CircularProgressIndicator())
              : controller.isLoadingMoreFailed.value
                  ? controller.showToast()
                  : _dossier(
                      code: controller.dossiers[index].code,
                      status: controller.dossiers[index].dossierStatus.name,
                      procedure: controller.dossiers[index].procedure.name,
                      createDate: date,
                    );
        },
      ),
    );
  }

  Widget _dossier({
    required String code,
    required String status,
    required String procedure,
    String? agency,
    required String createDate,
  }) {
    return GestureDetector(
      onTap: () {
        controller.setDetailDossier(code);
        Get.toNamed('/vncitizens_dossier/detail');
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 3.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    code,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    status.length > AppConfig.statusMaxLength
                        ? status.substring(0, AppConfig.statusMaxLength) + '...'
                        : status,
                    style:
                        TextStyle(color: controller.getColorByStatus(status)),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              Text(
                procedure,
                maxLines: 2,
                style: const TextStyle(fontSize: 16),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              agency != null
                  ? Row(
                      children: [
                        Text('co quan thuc hien'.tr + ': ',
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 12)),
                        Text(agency,
                            style: const TextStyle(
                                color: Colors.black45, fontSize: 12)),
                      ],
                    )
                  : const SizedBox.shrink(),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              Row(
                children: [
                  Text(
                    'ngay nop'.tr + ': ',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(createDate,
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
