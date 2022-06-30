import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/model/hcm_tag_resource.dart';
import 'package:vncitizens_place/src/util/image_caching_util.dart';

import '../model/hcm_place.dart';
import '../model/hcm_place_marker.dart';

class PlaceController extends GetxController {
  Rx<LatLng> centerLocation = AppConfig.centerLocation.obs;
  RxBool isDefaultView = true.obs;
  int configTypeView = AppConfig.getConfigTypeView;

  /// Tag
  RxBool isTagLoading = false.obs;
  RxList<Marker> markers = <Marker>[].obs;
  RxList<String> tagIds = <String>[].obs;
  RxBool isSelectedAllTags = false.obs;
  ScrollController vTagScrollController = ScrollController();
  ScrollController hTagScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  RxBool isMoreAvailableTag = false.obs;
  RxBool isLastTagPage = false.obs;
  RxBool isSearch = false.obs;
  int _pageTag = 0;

  /// Place
  RxBool isPlaceLoading = false.obs;
  RxString id = ''.obs;
  RxString keyword = ''.obs;
  HCMPlaceResource? hcmPlaceSelected;
  int _pagePlace = 1;
  RxList<HCMPlaceResource> hcmPlaces = <HCMPlaceResource>[].obs;
  RxList<HCMTagResource> hcmTags = <HCMTagResource>[
    HCMTagResource(name: 'Y tế', id: 'c00e92e9-5f0a-4bb9-b536-c35d65c1ec74'),
    HCMTagResource(
        name: 'Trường công lập', id: 'ecc45674-4d61-4087-80a7-a18aee6c28d7'),
    HCMTagResource(
        name: 'Trường tư thục', id: 'e47b601d-2006-40d8-adc7-b2fcbdf22f7a')
  ].obs;
  RxMap<String, Uint8List> iconBytesList = <String, Uint8List>{}.obs;
  ScrollController placeScrollController = ScrollController();
  RxBool isMoreAvailablePlace = false.obs;
  RxBool isLastPlacePage = false.obs;

  /// Common
  final int _size = 15;

  @override
  void onInit() async {
    super.onInit();
    await init();
    log("INIT PLACE CONTROLLER", name: AppConfig.packageName);
  }

  @override
  void onClose() {
    super.onClose();
    vTagScrollController.dispose();
    hTagScrollController.dispose();
    placeScrollController.dispose();
  }

  Future<void> init() async {
    await _initPagination();
    // await _getTags();
    // await getPlaces();
    await getAllResource();
  }

  Future<void> _initPagination() async {
    vTagScrollController.addListener(() {
      if (vTagScrollController.position.pixels ==
          vTagScrollController.position.maxScrollExtent) {
        if (!isLastTagPage.value) {
          _pageTag++;
          // _getMoreTags();
        } else {
          log("Last page tag: " + _pageTag.toString(),
              name: AppConfig.packageName);
        }
      }
    });
    hTagScrollController.addListener(() {
      if (hTagScrollController.position.pixels ==
          hTagScrollController.position.maxScrollExtent) {
        if (!isLastTagPage.value) {
          _pageTag++;
          // _getMoreTags();
        } else {
          log("Last page tag: " + _pageTag.toString(),
              name: AppConfig.packageName);
        }
      }
    });
    placeScrollController.addListener(() {
      if (placeScrollController.position.pixels ==
              placeScrollController.position.maxScrollExtent &&
          !isMoreAvailablePlace.value) {
        if (!isLastPlacePage.value) {
          if (isSearch.value) {
            _pagePlace++;
            loadMoreSearchPlaces(searchController.text);
          } else {
            _getMorePlaces();
          }
        } else {
          log("Last page place: " + _pagePlace.toString(),
              name: AppConfig.packageName);
        }
      }
    });
  }

  Future<void> toggleView({bool? isDefault}) async {
    isDefaultView.value = isDefault ?? !isDefaultView.value;
  }

  Future<void> toggleSearchOrClose() async {
    isSearch(!isSearch.value);
    // isSearch.refresh();
    if (!isSearch.value) {
      searchController.clear();
      await searchPlaces('');
      _pagePlace = 1;
      await refreshPlaces();
    } else {
      _pagePlace = 1;
    }
  }

  Future<void> toggleHCMTag(int index) async {
    // toggleView(isDefault: false);
    _pagePlace = 1;
    hcmTags[index].isSelected = !hcmTags[index].isSelected;
    // isSearch(false);
    if (hcmTags[index].isSelected) {
      tagIds.add(hcmTags[index].id);
      bool temp = true;
      for (HCMTagResource selector in hcmTags) {
        if (!selector.isSelected) {
          temp = false;
          break;
        }
      }
      if (isSearch.value) {
        searchPlaces(searchController.text);
      } else {
        await refreshPlaces();
      }

      isSelectedAllTags(temp);
    } else {
      isSelectedAllTags(false);
      hcmPlaces
          .removeWhere((element) => element.resourceId == hcmTags[index].id);
      getMarker();
      tagIds.remove(hcmTags[index].id);
      if (tagIds.isEmpty) {
        if (isSearch.value) {
          searchPlaces(searchController.text);
        } else {
          await getAllResource();
        }
      }
    }
    hcmTags.refresh();
  }

  //HCM places
  void selectAllTags() {
    for (var _tag in hcmTags) {
      _tag.isSelected = true;
      tagIds.add(_tag.id);
    }
    isSelectedAllTags(true);
    hcmTags.refresh();
  }

  void unselectAllTags() {
    for (var _tag in hcmTags) {
      _tag.isSelected = false;
    }
    tagIds.value = [];
    isSelectedAllTags(false);
    hcmTags.refresh();
  }

  getMarker() {
    if (configTypeView == 0) {
      markers.value = [];
      try {
        for (final place in hcmPlaces) {
          if (place.latitude != 0.0 && place.longtitude != 0.0) {
            var marker = HCMPlaceMarker(place: place);
            markers.add(marker);
          }
        }
        markers.refresh();
      } catch (_) {}
    }
  }

  Future<void> loadMoreSearchPlaces(String key) async {
    try {
      if (key.isNotEmpty) {
        isMoreAvailablePlace(true);
        List<String> ids = [];
        if (tagIds.isNotEmpty) {
          ids = tagIds;
        } else {
          for (final tag in hcmTags) {
            ids.add(tag.id);
          }
        }
        for (final id in ids) {
          int offset = 0;

          if (hcmPlaces.isNotEmpty) {
            offset = hcmPlaces.where((va) => va.resourceId == id).length;
          }
          var result = await HCMResourceService().getPlacesResources(
              id: id, limit: _size, offset: offset, keySearch: key);
          HCMPlaceResourceResponse response =
              HCMPlaceResourceResponse.fromJson(result.body['result']);
          for (var i = 0; i < response.records!.length; ++i) {
            HCMPlaceResource element = response.records![i];
            element.resourceId = id;
            if (configTypeView == 0) {
              try {
                var response = await HCMLocationService().searchLocal(
                    _getSearchLocationKey(element) + ', Hồ Chí Minh');
                if (response.body['List'].length > 0) {
                  var local = response.body['List'][0];
                  element.latitude = local['Latitude'];
                  element.longtitude = local['Longitude'];
                  if (element.address == null ||
                      element.address!.isEmpty ||
                      element.address == 'none') {
                    element.address = getAddressFromVietBanDo(local);
                  }
                }
              } catch (_) {}
            }

            hcmPlaces.add(element);
          }
        }

        getMarker();
        hcmPlaces.refresh();
        markers.refresh();
        hcmPlaces.refresh();

        isMoreAvailablePlace(false);
      } else {
        isMoreAvailablePlace(false);
        _pagePlace = 1;
        // markers.value = [];
        // hcmPlaces.value = [];
        // await refreshPlaces();

      }
    } catch (ex) {
      isMoreAvailablePlace(false);
    }
  }

  _getSearchLocationKey(HCMPlaceResource element) {
    if (element.address != null &&
        element.address!.isNotEmpty &&
        element.address != 'none') {
      return element.address;
    }
    return element.name ?? '';
  }

  getAddressFromVietBanDo(dynamic data) {
    var address = '';
    if (data['Number'] != null && data['Number'].toString().isNotEmpty) {
      address += data['Number'];
    }
    if (data['Street'] != null && data['Street'].toString().isNotEmpty) {
      address += ' ' + data['Street'];
    }
    if (data['Ward'] != null && data['Ward'].toString().isNotEmpty) {
      address += ', ' + data['Ward'];
    }

    if (data['District'] != null && data['District'].toString().isNotEmpty) {
      address += ', ' + data['District'];
    }
    if (data['Province'] != null && data['Province'].toString().isNotEmpty) {
      address += ' ' + data['Province'];
    }
    return address;
  }

  Future<void> searchPlaces(String key) async {
    if (key.isNotEmpty) {
      try {
        _pagePlace = 1;
        markers.value = [];
        hcmPlaces.value = [];
        isPlaceLoading(true);
        List<String> ids = [];
        if (tagIds.isNotEmpty) {
          ids = tagIds;
        } else {
          for (final tag in hcmTags) {
            ids.add(tag.id);
          }
        }
        for (var tag in ids) {
          var result = await HCMResourceService().getPlacesResources(
              id: tag, limit: _size, offset: 0, keySearch: key);
          HCMPlaceResourceResponse response =
              HCMPlaceResourceResponse.fromJson(result.body['result']);
          for (var i = 0; i < response.records!.length; ++i) {
            HCMPlaceResource element = response.records![i];
            element.resourceId = tag;
            if (configTypeView == 0) {
              try {
                var response = await HCMLocationService().searchLocal(
                    _getSearchLocationKey(element) + ', Hồ Chí Minh');
                if (response.body['List'].length > 0) {
                  var local = response.body['List'][0];
                  element.latitude = local['Latitude'];
                  element.longtitude = local['Longitude'];
                  if (element.address == null ||
                      element.address!.isEmpty ||
                      element.address == 'none') {
                    element.address = getAddressFromVietBanDo(local);
                  }
                }
              } catch (_) {}
            }

            hcmPlaces.add(element);
          }
        }

        try {
          getMarker();
          hcmPlaces.refresh();
          isPlaceLoading(false);
        } catch (_) {
          isPlaceLoading(false);
        }
      } catch (ex) {
        isPlaceLoading(false);
      }
    } else {
      // _pagePlace = 1;
      // markers.value = [];
      // hcmPlaces.value = [];
      // await refreshPlaces();
    }
  }

  Future<void> getPlaces({String? id, bool? isLoading}) async {
    try {
      var resourceId = id;
      if (resourceId == null && hcmTags.isNotEmpty) {
        resourceId = hcmTags[0].id;
      }
      final res = await HCMResourceService()
          .getPlacesResources(id: resourceId ?? '', limit: _size, offset: 0);
      HCMPlaceResourceResponse response =
          HCMPlaceResourceResponse.fromJson(res.body['result']);
      for (var i = 0; i < response.records!.length; ++i) {
        HCMPlaceResource element = response.records![i];
        element.resourceId = resourceId ?? '';
        if (configTypeView == 0) {
          try {
            var response = await HCMLocationService()
                .searchLocal(_getSearchLocationKey(element) + ', Hồ Chí Minh');
            if (response.body['List'].length > 0) {
              var local = response.body['List'][0];
              element.latitude = local['Latitude'];
              element.longtitude = local['Longitude'];
              if (element.address == null ||
                  element.address!.isEmpty ||
                  element.address == 'none') {
                element.address = getAddressFromVietBanDo(local);
              }
            }
          } catch (_) {}
        }

        hcmPlaces.add(element);
      }
      hcmPlaces.refresh();
      getMarker();
    } catch (ex) {}
  }

  Future<void> _getMorePlaces() async {
    try {
      isMoreAvailablePlace(true);
      List<String> ids = [];
      if (tagIds.isNotEmpty) {
        ids = tagIds;
      } else {
        for (final tag in hcmTags) {
          ids.add(tag.id);
        }
      }
      for (final id in ids) {
        int offset = 0;

        if (hcmPlaces.isNotEmpty) {
          offset = hcmPlaces.where((va) => va.resourceId == id).length;
        }
        var res = await HCMResourceService()
            .getPlacesResources(id: id, limit: _size, offset: offset);

        HCMPlaceResourceResponse response =
            HCMPlaceResourceResponse.fromJson(res.body['result']);

        for (var i = 0; i < response.records!.length; ++i) {
          HCMPlaceResource element = response.records![i];
          element.resourceId = id;
          if (configTypeView == 0) {
            try {
              var response = await HCMLocationService().searchLocal(
                  _getSearchLocationKey(element) + ', Hồ Chí Minh');
              if (response.body['List'].length > 0) {
                var local = response.body['List'][0];
                element.latitude = local['Latitude'];
                element.longtitude = local['Longitude'];
                if (element.address == null ||
                    element.address!.isEmpty ||
                    element.address == 'none') {
                  element.address = getAddressFromVietBanDo(local);
                }
                var marker = HCMPlaceMarker(place: element);
                markers.add(marker);
              }
            } catch (_) {}
          }

          hcmPlaces.add(element);
        }
        markers.refresh();
        hcmPlaces.refresh();

        isMoreAvailablePlace(false);
      }
    } catch (ex) {
      isMoreAvailablePlace(false);
    }
  }

  Future<void> _getIcons(String fcmId, String iconId) async {
    Uint8List? icon = await ImageCachingUtil.get(iconId);
    if (icon != null) {
      log("Load icon from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      iconBytesList[fcmId] = icon;
    } else {
      log("Load icon from minio",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      Response responseFile = await StorageService().getFileDetail(id: iconId);
      log(responseFile.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(responseFile.body.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
        File file =
            await MinioService().getFile(minioPath: responseFile.body["path"]);
        Uint8List iconBytes = await file.readAsBytes();
        iconBytesList[fcmId] = iconBytes;
      }
    }
  }

  Future<void> refreshPlaces() async {
    try {
      if (!isSearch.value) {
        hcmPlaces.value = [];
        markers.value = [];
        isLastPlacePage(false);
        _pagePlace = 1;
        if (tagIds.isNotEmpty) {
          isPlaceLoading(true);
          for (final id in tagIds) {
            await getPlaces(id: id, isLoading: false);
          }
          isPlaceLoading(false);
        } else {
          await getAllResource();
        }
      }
    } catch (ex) {
      isPlaceLoading(false);
    }
  }

  getAllResource() async {
    try {
      isPlaceLoading(true);
      // HCMResourceService()
      //     .getCategoriesResources(AppConfig.schoolCategoryResourceId)
      //     .then((res) {
      //   print("getCategoriesResource");
      //   var maintainer = res.body['result'];
      //   if (maintainer.length > 0) {
      //     List<dynamic> resources = maintainer[0]['resources'];
      //     for (final item in resources
      //         .where((element) => element['description'].contains('DiaChi'))) {
      //       hcmTags.add(HCMTagResource.fromJson(item));
      //     }
      //   }
      //   hcmTags.refresh();
      //   isTagLoading(false);
      // }, onError: (err) {
      //   isTagLoading(false);
      // });
      for (final tag in hcmTags) {
        await getPlaces(id: tag.id, isLoading: false);
      }
      isPlaceLoading(false);
    } catch (ex) {
      isPlaceLoading(false);
    }
  }
}
