import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_dossier/service/dossier_service.dart';
import 'package:vncitizens_dossier/src/config/app_config.dart';
import 'package:vncitizens_dossier/src/model/dossier_model.dart';

class DossierController extends GetxController {
  RxBool isShowSearchInput = false.obs;
  RxBool isShowQRScan = false.obs;
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  RxList<DossierModel> dossiers = <DossierModel>[].obs;
  RxInt page = 0.obs;

  RxBool isLoading = false.obs;
  // RxBool isLoadingMore = false.obs;
  RxBool isLast = false.obs;
  RxBool isLoadFailed = false.obs;
  RxBool isLoadingMoreFailed = false.obs;
  RxBool isLoadEmpty = false.obs;

  DossierModel? dossier;

  final scrollController = ScrollController();
  DossierService service = DossierService();

  final String endpoint =
      GetStorage(AppConfig.packageName).read(AppConfig.apiEndpoint);

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // isLoadingMore.value = true;

        page++;
        try {
          dossiers.addAll(
            await service.getDossiersByKey(
                endpoint: endpoint,
                keywork: searchController.text,
                page: page.toString()),
          );
        } catch (e) {
          isLoadingMoreFailed.value = true;
        }

        // isLoadingMore.value = false;
      }
    });
  }

  void onTapIconSearch() {
    isShowSearchInput.value = true;
    focusNode.requestFocus();
  }

  void onTapIconDeSearch() {
    isShowSearchInput.value = false;
    searchController.clear();
    dossiers.value = [];

    isLoadEmpty.value = false;
  }

  void onTapIconQRScan() {
    isShowQRScan.value = true;
    isShowQRScan.listen((p0) => isShowSearchInput.value = !p0);
    getDossierByKey();
  }

  Future<void> getDossierByKey() async {
    isLoading.value = true;
    dossiers.value = [];
    try {
      final list = await service.getDossiersByKey(
          endpoint: endpoint,
          keywork: searchController.text,
          page: page.toString());
      if (list.isEmpty) {
        isLoadEmpty.value = true;
      }

      dossiers.addAll(list);
      page++;

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      isLoadFailed.value = true;
    }
  }

  void setDetailDossier(String code) {
    for (DossierModel d in dossiers) {
      if (d.code == code) {
        dossier = d;
      }
    }
  }

  String convertDate({required String date, required int type}) {
    if (type == 1) {
      return DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(date));
    } else {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }
  }

  Color getColorByStatus(String status) {
    for (int i = 0; i < AppConfig.dossierStatus.length; i++) {
      if (status == AppConfig.dossierStatus[i]) {
        return AppConfig.statusColor[i];
      }
    }
    return AppConfig.statusColor[AppConfig.statusColor.length - 1];
  }

  Widget showToast() {
    // UIHelper.showNotificationSnackBar(message: "tai them du lieu that bai".tr);
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("tai them du lieu that bai".tr,
              style: const TextStyle(color: Colors.white)),
          GestureDetector(
            onTap: () => Get.closeCurrentSnackbar(),
            child: Text("dong".tr.toUpperCase(),
                style: const TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
      isDismissible: true,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 200),
    ));
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
