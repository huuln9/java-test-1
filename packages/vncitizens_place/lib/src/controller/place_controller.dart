import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vncitizens_common/vncitizens_common.dart' hide LatLng;
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/model/map_maker.dart';
import 'package:vncitizens_place/src/model/place_content.dart';
import 'package:vncitizens_place/src/model/place_page.dart';
import 'package:vncitizens_place/src/model/tag_content.dart';
import 'package:vncitizens_place/src/model/tag_page.dart';
import 'package:vncitizens_place/src/model/tag_selector.dart';
import 'package:vncitizens_place/src/util/image_caching_util.dart';

class PlaceController extends GetxController {
  late LatLng centerLocation;
  RxBool isDefaultView = true.obs;

  /// Tag
  RxBool isTagLoading = false.obs;
  RxList<TagSelector> tags = <TagSelector>[].obs;
  Set<String> _tagIds = {};
  RxBool isSelectedAllTags = false.obs;
  ScrollController vTagScrollController = ScrollController();
  ScrollController hTagScrollController = ScrollController();
  RxBool isMoreAvailableTag = false.obs;
  RxBool isLastTagPage = false.obs;
  int _pageTag = 0;

  /// Place
  RxBool isPlaceLoading = false.obs;
  RxString id = ''.obs;
  RxString keyword = ''.obs;
  int _pagePlace = 0;
  RxList<PlaceSelector> places = <PlaceSelector>[].obs;
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
    await _getTags();
    await getPlaces();
  }

  Future<void> _initPagination() async {
    vTagScrollController.addListener(() {
      if (vTagScrollController.position.pixels ==
          vTagScrollController.position.maxScrollExtent) {
        if (!isLastTagPage.value) {
          _pageTag++;
          _getMoreTags();
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
          _getMoreTags();
        } else {
          log("Last page tag: " + _pageTag.toString(),
              name: AppConfig.packageName);
        }
      }
    });
    placeScrollController.addListener(() {
      if (placeScrollController.position.pixels ==
          placeScrollController.position.maxScrollExtent) {
        if (!isLastPlacePage.value) {
          _pagePlace++;
          _getMorePlaces();
        } else {
          log("Last page place: " + _pagePlace.toString(),
              name: AppConfig.packageName);
        }
      }
    });
  }

  Future<void> toggleView() async {
    isDefaultView.value = !isDefaultView.value;
  }

  Future<void> _getTags() async {
    try {
      isTagLoading(true);
      DirectoryService()
          .getTagsByCategoryId(AppConfig.tagCategoryId, _pageTag, _size)
          .then((res) {
        TagPage page = TagPage.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          TagContent element = page.content[i];
          tags.add(TagSelector(data: element, isSelected: false));
        }
        isTagLoading(false);
      }, onError: (err) {
        isTagLoading(false);
      });
    } catch (ex) {
      isTagLoading(false);
    }
  }

  Future<void> _getMoreTags() async {
    try {
      isMoreAvailableTag(true);
      DirectoryService()
          .getTagsByCategoryId(AppConfig.tagCategoryId, _pageTag, _size)
          .then((res) {
        TagPage page = TagPage.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          TagContent element = page.content[i];
          tags.add(TagSelector(data: element, isSelected: false));
        }
        tags.refresh();
        isLastTagPage(page.last);
        isMoreAvailableTag(false);
      }, onError: (err) {
        isMoreAvailableTag(false);
      });
    } catch (ex) {
      isMoreAvailableTag(false);
    }
  }

  Future<void> toggleTag(int index) async {
    tags[index].isSelected = !tags[index].isSelected;
    _pagePlace = 0;
    if (tags[index].isSelected) {
      _tagIds.add(tags[index].data.id);
      bool temp = true;
      for (TagSelector selector in tags) {
        if (!selector.isSelected) {
          temp = false;
          break;
        }
      }
      isSelectedAllTags(temp);
    } else {
      isSelectedAllTags(false);
      _tagIds.remove(tags[index].data.id);
    }
    await getPlaces(keyword: keyword.value);
    tags.refresh();
  }

  void selectAllTags() {
    for (var _tag in tags) {
      _tag.isSelected = true;
      _tagIds.add(_tag.data.id);
    }
    isSelectedAllTags(true);
    tags.refresh();
  }

  void unselectAllTags() {
    for (var _tag in tags) {
      _tag.isSelected = false;
    }
    _tagIds = {};
    isSelectedAllTags(false);
    tags.refresh();
  }

  Future<void> getPlaces({String? keyword}) async {
    try {
      isPlaceLoading(true);
      String _tagIdsStr = _tagIds
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll(' ', '');
      LocationService()
          .getPlaces(_pagePlace, _size,
              keyword: keyword,
              tagCategoryId: AppConfig.tagCategoryId,
              tagId: _tagIdsStr != '' ? _tagIdsStr : null)
          .then((res) {
        places.value = [];
        PlacePage page = PlacePage.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          PlaceContent element = page.content[i];
          if (!element.location.isEmpty()) {
            places.add(PlaceSelector(data: element, isSelected: false));
            if (element.thumbnail.isNotEmpty) {
              () async {
                await _getIcons(element.id, element.thumbnail);
              }.call();
            } else {
              ImageCachingUtil.delete(element.thumbnail);
            }
          }
        }
        places.refresh();
        isPlaceLoading(false);
      }, onError: (err) {
        isPlaceLoading(false);
      });
    } catch (ex) {
      isPlaceLoading(false);
    }
  }

  Future<void> _getMorePlaces() async {
    try {
      isMoreAvailablePlace(true);
      String _tagIdsStr = _tagIds
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll(' ', '');
      LocationService()
          .getPlaces(_pagePlace, _size,
              keyword: keyword.value,
              tagCategoryId: AppConfig.tagCategoryId,
              tagId: _tagIdsStr != '' ? _tagIdsStr : null)
          .then((res) {
        PlacePage page = PlacePage.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          PlaceContent element = page.content[i];
          if (!element.location.isEmpty()) {
            places.add(PlaceSelector(data: element, isSelected: false));
            if (element.thumbnail.isNotEmpty) {
              () async {
                await _getIcons(element.id, element.thumbnail);
              }.call();
            } else {
              ImageCachingUtil.delete(element.thumbnail);
            }
          }
        }
        isLastPlacePage(page.last);
        places.refresh();
        isMoreAvailablePlace(false);
      }, onError: (err) {
        isMoreAvailablePlace(false);
      });
    } catch (ex) {
      isMoreAvailablePlace(false);
    }
  }

  Future<void> _getIcons(String placeId, String iconId) async {
    Uint8List? icon = await ImageCachingUtil.get(iconId);
    if (icon != null) {
      log("Load icon from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      iconBytesList[placeId] = icon;
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
        iconBytesList[placeId] = iconBytes;
        ImageCachingUtil.set(iconId, iconBytes);
      }
    }
  }

  Future<void> refreshPlaces() async {
    places.value = [];
    isLastPlacePage(false);
    _pagePlace = 0;
    getPlaces();
  }

  void togglePlace(int index) {
    places[index].isSelected = !places[index].isSelected;
    if (places[index].isSelected) {
      for (var i = 0; i < places.length; i++) {
        if (index != i) {
          places[i].isSelected = false;
        }
      }
    }
    places.refresh();
  }

  Future<void> makeCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    await launch(url).catchError((onError) {
      log('An error occurred ! Could not make a call',
          name: AppConfig.packageName);
      log(onError, name: AppConfig.packageName);
    });
    log('Make a call successfully', name: AppConfig.packageName);
  }
}
