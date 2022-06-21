import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/config/app_config.dart';
import 'package:vncitizens_petition/src/controller/petition_filter_list_controller.dart';
import 'package:vncitizens_petition/src/model/petition_page_content_model.dart';
import 'package:vncitizens_petition/src/model/petition_page_model.dart';
import 'package:vncitizens_petition/src/util/image_caching_util.dart';
import 'package:vncitizens_petition/src/widget/pages/detail/petition_detail.dart';

class PetitionPersonalListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFailedLoading = false.obs;

  RxList<PetitionPageContentModel> petitions = <PetitionPageContentModel>[].obs;
  RxMap<String, Uint8List> thumbnailBytesList = <String, Uint8List>{}.obs;
  ScrollController scrollController = ScrollController();
  RxBool isLastPage = false.obs;
  RxBool isMoreAvailablePlace = false.obs;

  int _page = 0;
  final int _size = 15;

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> init() async {
    await _initPagination();
    await _initPetitions();
    _getRouterParameters();
  }

  _getRouterParameters() {
    try {
      final id = Get.parameters['id_detail'];
      final rating = Get.parameters['rating'];
      if (id != null) {
        Get.to(PetitionDetail(
          id: id,
          reporterRating: rating != null ? int.parse(rating) : null,
        ));
      }
    } catch (_) {}
  }

  Future<void> _initPagination() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLastPage.value) {
          _page++;
          _getMorePetitions();
        } else {
          log("Last page place: " + _page.toString(),
              name: AppConfig.packageName);
        }
      }
    });
  }

  Future<void> _initPetitions() async {
    try {
      isLoading(true);
      IGatePetitionService()
          .getList(_page, _size, userId: AuthUtil.userId)
          .then((res) {
        petitions.value = [];
        PetitionPageModel page = PetitionPageModel.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          PetitionPageContentModel element = page.content[i];
          petitions.add(element);
          if (element.thumbnailId.isNotEmpty) {
            () async {
              await _getThumbnails(element);
            }.call();
          } else {
            ImageCachingUtil.delete(element.thumbnailId);
          }
        }
        petitions.refresh();
        isLoading(false);
        isFailedLoading(false);
      }, onError: (err) {
        isLoading(false);
        isFailedLoading(true);
      });
    } catch (ex) {
      isLoading(false);
      isFailedLoading(true);
    }
  }

  Future<void> _getMorePetitions() async {
    try {
      isMoreAvailablePlace(true);
      PetitionFilterListController filterController = Get.find();
      IGatePetitionService()
          .getList(_page, _size,
              userId: AuthUtil.userId,
              keyword: filterController.keywordController.text,
              status: filterController.statusSelector.value.id,
              parentTagId: filterController.categorySelector.value.id,
              tagId: filterController.tagSelector.value.id,
              startDate: filterController.startDate.value,
              endDate: filterController.endDate.value)
          .then((res) {
        PetitionPageModel page = PetitionPageModel.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          PetitionPageContentModel element = page.content[i];
          petitions.add(element);
          if (element.thumbnailId.isNotEmpty) {
            () async {
              await _getThumbnails(element);
            }.call();
          } else {
            ImageCachingUtil.delete(element.thumbnailId);
          }
        }
        isLastPage(page.last);
        petitions.refresh();
        isMoreAvailablePlace(false);
        isFailedLoading(false);
      }, onError: (err) {
        isMoreAvailablePlace(false);
        isFailedLoading(true);
      });
    } catch (ex) {
      isMoreAvailablePlace(false);
      isFailedLoading(true);
    }
  }

  Future<void> searchPetitions() async {
    try {
      isLoading(true);
      PetitionFilterListController filterController = Get.find();
      IGatePetitionService()
          .getList(_page, _size,
              userId: AuthUtil.userId,
              keyword: filterController.keywordController.text,
              status: filterController.statusSelector.value.id,
              parentTagId: filterController.categorySelector.value.id,
              tagId: filterController.tagSelector.value.id,
              startDate: filterController.startDate.value,
              endDate: filterController.endDate.value)
          .then((res) {
        petitions.value = [];
        PetitionPageModel page = PetitionPageModel.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          PetitionPageContentModel element = page.content[i];
          petitions.add(element);
          if (element.thumbnailId.isNotEmpty) {
            () async {
              await _getThumbnails(element);
            }.call();
          } else {
            ImageCachingUtil.delete(element.thumbnailId);
          }
        }
        petitions.refresh();
        isLoading(false);
        isFailedLoading(false);
      }, onError: (err) {
        isLoading(false);
        isFailedLoading(true);
      });
    } catch (ex) {
      isLoading(false);
      isFailedLoading(true);
    }
  }

  Future<void> refreshPetitions() async {
    isLastPage(false);
    _page = 0;
    _initPetitions();
  }

  Future<void> _getThumbnails(PetitionPageContentModel petition) async {
    final id = petition.id;
    final thumbnailId = petition.thumbnailId;

    Uint8List? thumbnail = await ImageCachingUtil.get(thumbnailId);
    if (thumbnail != null) {
      log("Load thumbnail $thumbnailId from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      thumbnailBytesList[id] = thumbnail;
    } else {
      log("Load thumbnail $thumbnailId from server",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      final res = await IGateFilemanService().downloadFile(id: thumbnailId);
      if (res.statusCode == 200) {
        Uint8List iconBytes = res.bodyBytes;
        thumbnailBytesList[id] = iconBytes;
        ImageCachingUtil.set(thumbnailId, iconBytes);
      } else {
        log("Thumbnail $thumbnailId not found",
            name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    }
  }
}
