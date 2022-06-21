import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:vncitizens_camera/src/config/camera_app_config.dart';
import 'package:vncitizens_camera/src/config/camera_route_config.dart';
import 'package:vncitizens_camera/src/model/place_group_model.dart';
import 'package:vncitizens_camera/src/model/place_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class CameraListController extends GetxController {
  final searchController = TextEditingController();
  RxBool isInitialized = false.obs;
  RxList<PlaceGroupModel> groupCameras = <PlaceGroupModel>[].obs;
  RxBool isShowSearchDeleteIcon = false.obs;
  RxBool isLoadingCamera = false.obs;
  RxBool isShowSearchInput = false.obs;
  RxBool isInitError = false.obs;
  RxBool hasConnected = Get.find<InternetController>().hasConnected;

  @override
  void onInit() {
    super.onInit();
    init();
    hasConnected.listen((bool value) {
      if (value == true) {
        init();
      }
    });
  }


  Future<void> init() async {
    isShowSearchInput.value = false;
    isInitialized.value = false;
    isInitError.value = false;
    getListGroupCamera().then((value) {
      isInitError.value = false;
      groupCameras.value = value;
      if (groupCameras.isNotEmpty) {
        onExpansionChanged(true, groupCameras.first.id);
      }
      isInitialized.value = true;
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

  // =========== EVENTS ==========

  void onTapAppBarAction() {
    List<PlaceModel> lst = [];
    for (var element in groupCameras) {
      lst.addAll(element.places);
    }
    Get.toNamed(CameraRouteConfig.mapRoute, arguments: [lst, searchController.text])?.then((value) {
      if (value != null && value is String && value.isNotEmpty && value.isBlank != true) {
        dev.log(value, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        searchController.text = value;
        onSearchComplete();
      }
    });
  }

  void onTapIconSearch() {
    isShowSearchInput.value = true;
  }

  void onChangeSearch(String? value) {
    /// check show search close icon
    isShowSearchDeleteIcon.value = value == null || value.isEmpty ? false : true;
  }

  Future<void> onSearchComplete() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (searchController.text.isEmpty) {
      isInitialized.value = false;
      getListGroupCamera().then((value) {
        isInitError.value = false;
        groupCameras.value = value;
        isInitialized.value = true;
      }).catchError((error) async {
        isInitialized.value = true;
        isInitError.value = true;
      });
      return;
    }
    /// reset data
    isInitialized.value = false;
    groupCameras.value = [];
    isInitError.value = false;
    /// search
    List<PlaceGroupModel> tmpGroupCameras = [];
    List<PlaceModel> cameras = await getListCamera(keyword: searchController.text).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
    for (var camera in cameras) {
      if (tmpGroupCameras.isEmpty) {
        tmpGroupCameras.add(PlaceGroupModel(
            id: camera.tags[0].id,
            name: camera.tags[0].name ?? "Unknown",
            places: [PlaceModel.fromMap(camera.toMap())],
        ));
      } else {
        final foundGroupIndex = tmpGroupCameras.indexWhere((element) => element.id == camera.tags[0].id);
        if (foundGroupIndex == -1) {
          tmpGroupCameras.add(PlaceGroupModel(
            id: camera.tags[0].id,
            name: camera.tags[0].name ?? "Unknown",
            places: [PlaceModel.fromMap(camera.toMap())],
          ));
        } else {
          tmpGroupCameras[foundGroupIndex].places.add(camera);
        }
      }
    }
    groupCameras.value = tmpGroupCameras;
    isInitialized.value = true;
  }

  void onClickSearchDeleteIcon() {
    searchController.clear();
    init();
  }

  void onTapCameraItem(PlaceModel model) {
    Get.toNamed(CameraRouteConfig.liveRoute, arguments: [model]);
  }

  Future<void> onExpansionChanged(bool value, String groupId) async {
    if (value != true) return;
    final groupIndex = groupCameras.indexWhere((element) => element.id == groupId);
    final cameras = groupCameras[groupIndex].places;
    if (cameras.isEmpty) {
      try {
        isLoadingCamera.value = true;
        Response response = await LocationService().getVPlaces(tagId: groupId);
        dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (response.statusCode == 200) {
          groupCameras[groupIndex] = PlaceGroupModel(
            id: groupCameras[groupIndex].id,
            name: groupCameras[groupIndex].name,
            places: PlaceModel.fromListMap(response.body["content"]),
          );
        }
        isLoadingCamera.value = false;
      } catch (error) {
        isLoadingCamera.value = false;
      }
    }
  }

// ========== MANUAL FUNC ==========

  Future<List<PlaceModel>> getListCamera({String? keyword}) async {
    Response response = await LocationService().getVPlaces(keyword: keyword, categoryId: CameraAppConfig.cameraTagCategoryId);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return PlaceModel.fromListMap(response.body["content"]);
    } else {
      throw "GET LIST CAMERA ERROR";
    }
  }

  Future<List<PlaceGroupModel>> getListGroupCamera() async {
    Response response = await DirectoryService().getAllTagActivated(categoryId: CameraAppConfig.cameraTagCategoryId, sortBy: "order");
    if (response.statusCode == 200) {
      List<PlaceGroupModel> list = [];
      response.body["content"].forEach((item) {
        list.add(PlaceGroupModel.fromMapWithoutPlace(item));
      });
      return list;
    } else {
      throw "GET TAG LIST ERROR";
    }
  }
}
