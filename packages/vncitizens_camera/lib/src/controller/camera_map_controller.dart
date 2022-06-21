import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_camera/src/config/camera_app_config.dart';
import 'package:vncitizens_camera/src/config/camera_route_config.dart';
import 'package:vncitizens_camera/src/model/place_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;

class CameraMapController extends GetxController {
  final searchController = TextEditingController();
  final mapController = MapController();
  final popupController = PopupController();
  RxBool isShowSearchDeleteIcon = false.obs;
  final double defaultZoom = 13;
  RxList<PlaceModel> cameraModels = <PlaceModel>[].obs;
  RxBool isShowSearchInput = false.obs;
  RxBool isInitialized = false.obs;
  RxBool isSearching = false.obs;
  RxBool isInitError = false.obs;
  RxBool hasConnected = Get.find<InternetController>().hasConnected;

  @override
  void onInit() {
    super.onInit();
    /// check list camera passed
    if (Get.arguments != null && Get.arguments[0] != null && Get.arguments[0] is List<PlaceModel>) {
      cameraModels.value = Get.arguments[0];
      /// move camera to location
      if (cameraModels.isNotEmpty) {
          isInitialized.value = true;
          mapController.onReady.then((value) {
            initMap();
          });
      } else {
        dev.log("Pass empty camera", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        init();
      }
    } else {
      dev.log("No camera model is passed", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      init();
    }

    /// check keyword passed
    if (Get.arguments != null && Get.arguments[1] != null && Get.arguments[1] is String) {
      searchController.text = Get.arguments[1];
    }

    isShowSearchInput.value = false;

    hasConnected.listen((bool value) {
      if (value == true) {
        init();
      }
    });
  }


  Future<void> init() async {
    isInitialized.value = false;
    isInitError.value = false;
    isShowSearchInput.value = false;
    getListCamera(keyword: "").then((value) {
      isInitialized.value = true;
      isInitError.value = false;
      cameraModels.value = value;
      initMap();
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

  // =========== EVENTS ==========

  void onChangeSearch(String? value) {
    isShowSearchDeleteIcon.value = value == null || value.isEmpty ? false : true;
  }

  void onTapIconSearch() {
    isShowSearchInput.value = true;
  }

  Future<void> onSearchComplete() async {
    FocusManager.instance.primaryFocus!.unfocus();
    popupController.hideAllPopups();
    /// reset data
    isInitError.value = false;
    isSearching.value = true;
    /// search
    cameraModels.value = await getListCamera(keyword: searchController.text).catchError((error) async {
      isSearching.value = false;
      isInitError.value = true;
    });
    if (cameraModels.isEmpty) {
      isSearching.value = false;
      initMap();
      Get.showSnackbar(GetSnackBar(
        messageText: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("khong tim thay camera phu hop".tr, style: const TextStyle(color: Colors.white)),
            GestureDetector(
              onTap: () => Get.closeCurrentSnackbar(),
              child: Text("dong".tr.toUpperCase(), style: const TextStyle(color: Colors.blueAccent)),
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
    }  else {
      isSearching.value = false;
      if (cameraModels.first.location.coordinates[1] == null || cameraModels.first.location.coordinates[0] == null) {
        LatLng defaultLocation = LatLng(CameraAppConfig.defaultLatitude, CameraAppConfig.defaultLongitude);
        mapController.move(defaultLocation, defaultZoom);
      } else {
        LatLng firstLocation = LatLng(cameraModels.first.location.coordinates[1]!, cameraModels.first.location.coordinates[0]!);
        mapController.move(firstLocation, defaultZoom);
      }
    }
  }

  void onClickSearchDeleteIcon() {
    isShowSearchInput.value = false;
    searchController.clear();
    isShowSearchDeleteIcon.value = false;
    /// search
    isSearching.value = true;
    getListCamera(keyword: "").then((value) {
      cameraModels.value = value;
      isInitError.value = false;
      isSearching.value = false;
      initMap();
    }).catchError((error) async {
      isSearching.value = false;
      isInitError.value = true;
    });
  }

  void onTapLocationPopup(PlaceModel camera) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.toNamed(CameraRouteConfig.liveRoute, arguments: [camera]);
  }

// ========== MANUAL FUNC ==========
  void initMap() {
    try {
      LatLng defaultLocation = LatLng(CameraAppConfig.defaultLatitude, CameraAppConfig.defaultLongitude);
      mapController.move(defaultLocation, defaultZoom);
    } catch (error) {
      dev.log("CANNOT FIND DEFAULT LOCATION", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
  }

  Future<List<PlaceModel>> getListCamera({String? keyword}) async {
    Response response = await LocationService().getVPlaces(keyword: keyword, categoryId: CameraAppConfig.cameraTagCategoryId, spec: "page");
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return PlaceModel.fromListMap(response.body["content"]);
    } else {
      throw "GET LIST CAMERA ERROR";
    }
  }

}
