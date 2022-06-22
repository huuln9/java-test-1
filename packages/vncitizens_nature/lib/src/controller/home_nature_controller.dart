
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_nature/src/config/app_config.dart';
import 'package:vncitizens_nature/src/const/nature_constant.dart';
import 'package:vncitizens_nature/src/model/nature_station_item_model.dart';
import 'package:vncitizens_nature/src/service/home_nature_service.dart';

class HomeNatureController extends GetxController {
    final searchController = TextEditingController();
    RxBool isInitialized = false.obs;
    RxList<NatureStationItemModel> natureStationList = <NatureStationItemModel>[].obs;
    RxList<NatureStationItemModel> natureStationSearchOrigin = <NatureStationItemModel>[].obs;
    RxBool isShowSearchDeleteIcon = false.obs;
    RxBool searchEmptyData = false.obs;

    @override
    void onInit() {
        super.onInit();
        log("INIT CONTROLLER", name: AppConfig.packageName);
        init();
    }

    Future<void> init() async {
        getListNatureStation().then((value) async {
            log("LIST TAG: " + value.toString(), name: AppConfig.packageName);
            natureStationList.addAll(value);
            natureStationSearchOrigin.addAll(value);
            isInitialized.value = true;
        });
    }

    Future<List<NatureStationItemModel>> getListNatureStation() async {
        Response response = await HomeNatureService().getAllStationNature();
        if (response.statusCode == 200) {
            List<NatureStationItemModel> list = [];
            response.body["data"].forEach((item) {
                list.add(NatureStationItemModel.fromMap(item));
            });
            return list;
        } else {
            throw "GET NATURE STATION ERROR";
        }
    }

    void onTapOutlinedAction() {
        Get.toNamed(NatureConstant.mapNatureRoute, arguments: [natureStationList]);
    }

    void onChangeSearch(String? value) {
        isShowSearchDeleteIcon.value = value == null || value.isEmpty ? false : true;
    }

    Future<void> onSearchComplete() async {
        if(searchController.text.isEmpty) {
            // natureStationList.value = natureStationSearchOrigin.value;
            searchEmptyData.value = true;
            return;
        }

        List<NatureStationItemModel> tmpStation = natureStationSearchOrigin.value.where((element)
        => element.su_address.toLowerCase().contains(searchController.text.toLowerCase())).toList();
        if (tmpStation.isNotEmpty) {
            searchEmptyData.value = false;
            natureStationList.value = tmpStation;
        } else {
            searchEmptyData.value = true;
            return;
        }

    }

    void onClickSearchDeleteIcon() {
        searchController.clear();
        isShowSearchDeleteIcon.value = false;
    }

    void onClickNatureStationItem(NatureStationItemModel natureStationItemModel) {
        Get.toNamed(NatureConstant.mapNatureItemRoute, arguments: [natureStationItemModel]);
    }
}