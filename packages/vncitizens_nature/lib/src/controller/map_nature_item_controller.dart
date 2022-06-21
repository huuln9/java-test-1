import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:vncitizens_nature/src/config/app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_nature/src/model/nature_station_item_model.dart';
import 'package:vncitizens_nature/src/model/attribute_nature_station_model.dart';
import 'package:vncitizens_nature/src/service/home_nature_service.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

import '../service/map_nature_service.dart';

class MapNatureItemController extends GetxController {
  final mapController = MapController();
  final double defaultZoom = 13;
  late BuildContext dialogLoadingContext;
  late BuildContext bottomSheetDetailContext;
  RxBool isInitializedDetail = false.obs;
  RxList<NatureStationItemModel> natureStationItemModel = <NatureStationItemModel>[].obs;
  RxList<AttributeNatureStationModel> attributeNatureStationModel = <AttributeNatureStationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null && Get.arguments[0] != null && Get.arguments[0] is NatureStationItemModel) {
      natureStationItemModel.add(Get.arguments[0]);
      if(natureStationItemModel.isNotEmpty) {
        mapController.onReady.then((value) => initMap());
      } else {
        dev.log("Empty data", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        getListNatureStation().then((value) {
          natureStationItemModel.value = value;
          initMap();
        });
      }
    } else {
      dev.log("Empty arguments", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      getListNatureStation().then((value) {
        natureStationItemModel.value = value;
        initMap();
      });
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    if (Get.arguments != null && Get.arguments[0] != null && Get.arguments[0] is NatureStationItemModel) {
      showDetailStationNature(Get.arguments[0]);
    }
  }

  @override
  void onClose() {
    super.onClose();
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
      throw "GET LIST NATURE STATION ERROR";
    }
  }

  void initMap() {
    try {
      latLng.LatLng defaultLocation = latLng.LatLng(natureStationItemModel.first.su_location_lat, natureStationItemModel.first.su_location_lng);
      mapController.move(defaultLocation, defaultZoom);
    } catch (error) {
      dev.log("CANNOT FIND DEFAULT LOCATION", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      latLng.LatLng defaultLocation = latLng.LatLng(AppConfig.defaultLatitude, AppConfig.defaultLongitude);
      mapController.move(defaultLocation, defaultZoom);
    }
  }

  void showDetailStationNature(NatureStationItemModel natureStationItemModel) {
    attributeNatureStationModel.clear();
    getDetailStationNature(natureStationItemModel).then((value) async {
      attributeNatureStationModel.addAll(value);
      isInitializedDetail.value = true;
      Navigator.pop(dialogLoadingContext);
      buildModalBottomSheet(natureStationItemModel);
    });
    buildLoadingDialog();
  }

  void buildModalBottomSheet(NatureStationItemModel natureStationItemModel) {
    DateTime now = new DateTime.now();
    String currentHour = now.hour.toString() + ":" + now.minute.toString();
    String currentDay = now.day.toString() + "/" + now.month.toString() + "/" + now.year.toString();
    showModalBottomSheet(
        context: Get.context!,
        builder: (context) {
          bottomSheetDetailContext = context;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Text(natureStationItemModel.su_name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      margin: const EdgeInsets.only(top: 15, left: 10, bottom: 5),
                    ),
                    const Spacer(),
                    Container(
                        margin: const EdgeInsets.only(top: 15, right: 10, bottom: 5),
                        child: IconButton(onPressed: () => closeModalBottomSheet(), icon: const Icon(Icons.close)))
                  ],
                ),
                Container(
                  child: Text(natureStationItemModel.su_address, style: const TextStyle(fontSize: 14, color: Color.fromRGBO(126, 132, 135, 1))),
                  margin: const EdgeInsets.only(left: 10, top: 5, bottom: 15),
                  alignment: Alignment.centerLeft,
                ),
                Table(
                  border: TableBorder.all(width: 1, color: const Color.fromRGBO(233, 231, 231, 1)),
                  children: attributeNatureStationModel.map((item){
                    return TableRow(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color.fromRGBO(21, 101, 192, 1),
                            alignment: Alignment.centerLeft,
                            child: Text(item.datatype_name, style: const TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerRight,
                            child: Text(item.data_val.toString(), style: const TextStyle(fontSize: 14)),
                          ),
                        ]);
                  }).toList(),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => reloadModalBottomSheet(natureStationItemModel),
                          icon: Image.asset("${AppConfig.assetsRoot}/images/reload_nature_station.png",
                              width: 22)),
                      Text("Cập nhật lúc " + currentHour + ", ngày " + currentDay, style: const TextStyle(fontSize: 14, color: Color.fromRGBO(126, 132, 135, 1)))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<List<AttributeNatureStationModel>> getDetailStationNature(NatureStationItemModel natureStationItemModel) async {
    Response response = await MapNatureService().getDetailStationNature(natureStationItemModel.id);
    if (response.statusCode == 200) {
      List<AttributeNatureStationModel> list = [];
      response.body["data"]["list_details"].forEach((item) {
        list.add(AttributeNatureStationModel.fromMap(item));
      });
      return list;
    } else {
      throw "GET DETAIL NATURE STATION ERROR";
    }
  }

  void buildLoadingDialog(){
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogLoadingContext = context;
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(20.0)),
            child: Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        child: Text("loadingdata".tr, style: const TextStyle(fontSize: 18)),
                        margin: const EdgeInsets.all(20),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const LinearProgressIndicator(
                          backgroundColor: Color.fromRGBO(21, 101, 192, 0.2),
                          color: Color.fromRGBO(21, 101, 192, 1),
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void closeModalBottomSheet() {
    Navigator.pop(bottomSheetDetailContext);
  }

  void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  void reloadModalBottomSheet(NatureStationItemModel natureStationItemModel) {
    attributeNatureStationModel.clear();
    getDetailStationNature(natureStationItemModel).then((value) async {
      attributeNatureStationModel.addAll(value);
      isInitializedDetail.value = true;
      Navigator.pop(dialogLoadingContext);
    });
    buildLoadingDialog();
  }
}