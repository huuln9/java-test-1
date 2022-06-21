import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/model/tag_page_content_model.dart';
import 'package:vncitizens_petition/src/model/tag_page_model.dart';

import '../config/app_config.dart';

class PetitionFilterListController extends GetxController {
  Rx<TagPageContentModel> defaultTag =
      TagPageContentModel(id: '', name: 'tat ca'.tr).obs;
  final statusList = [
    TagPageContentModel(id: '', name: 'tat ca'.tr),
    TagPageContentModel(id: '1', name: 'cho tiep nhan'.tr),
    TagPageContentModel(id: '2', name: 'dang xu ly'.tr),
    TagPageContentModel(id: '3', name: 'hoan thanh'.tr),
    TagPageContentModel(id: '4', name: 'tu choi xu ly'.tr)
  ];

  RxBool isLoading = false.obs;
  RxList<TagPageContentModel> categories =
      <TagPageContentModel>[TagPageContentModel(id: '', name: 'tat ca'.tr)].obs;
  RxList<TagPageContentModel> tags =
      <TagPageContentModel>[TagPageContentModel(id: '', name: 'tat ca'.tr)].obs;
  RxString restorationId = 'VN_CITIZENS_DEFAULT'.obs;
  final TextEditingController keywordController = TextEditingController();
  Rx<TagPageContentModel> statusSelector =
      TagPageContentModel(id: '', name: 'tat ca'.tr).obs;
  Rx<TagPageContentModel> categorySelector =
      TagPageContentModel(id: '', name: 'tat ca'.tr).obs;
  Rx<TagPageContentModel> tagSelector =
      TagPageContentModel(id: '', name: 'tat ca'.tr).obs;
  RxString startDate = ''.obs;
  RxString endDate = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _init();
  }

  Future<void> _init() async {
    await _initCategories();
  }

  Future<void> _initCategories() async {
    try {
      isLoading(true);
      IGateBasecatService()
          .getCategories(0, 50, categoryId: AppConfig.tagCategoryId)
          .then((res) {
        categories.value = [defaultTag.value];
        tags.value = [defaultTag.value];
        try {
          TagPageModel page = TagPageModel.fromJson(res.body);
          for (var i = 0; i < page.numberOfElements; ++i) {
            TagPageContentModel element = page.content[i];
            categories.add(element);
          }
        } catch (ex) {}
        categories.refresh();
        isLoading(false);
      }, onError: (err) {
        isLoading(false);
      });
    } catch (ex) {
      isLoading(false);
    }
  }

  Future<void> getTags() async {
    try {
      if (categorySelector.value.id != '') {
        isLoading(true);
        IGateBasecatService()
            .getTags(0, 50,
                categoryId: AppConfig.tagCategoryId,
                parentId: categorySelector.value.id)
            .then((res) {
          tags.value = [defaultTag.value];
          try {
            TagPageModel page = TagPageModel.fromJson(res.body);
            for (var i = 0; i < page.numberOfElements; ++i) {
              TagPageContentModel element = page.content[i];
              tags.add(element);
            }
          } catch (ex) {}
          tags.refresh();
          isLoading(false);
        }, onError: (err) {
          isLoading(false);
        });
      } else {
        tagSelector = TagPageContentModel(id: '', name: 'tat ca'.tr).obs;
        tags.value = [TagPageContentModel(id: '', name: 'tat ca'.tr)];
      }
    } catch (ex) {
      isLoading(false);
    }
  }

  bool checkDateTimeRange() {
    return startDate.value != '' && endDate.value != '';
  }

  Future<void> resetFilterValue() async {
    keywordController.clear();
    statusSelector.value = TagPageContentModel(id: '', name: 'tat ca'.tr);
    categorySelector.value = TagPageContentModel(id: '', name: 'tat ca'.tr);
    tagSelector.value = TagPageContentModel(id: '', name: 'tat ca'.tr);
    tags.value = [TagPageContentModel(id: '', name: 'tat ca'.tr)];
    startDate.value = '';
    endDate.value = '';
    restorationId.value = 'VN_CITIZENS_RESET';
    tags.refresh();
  }
}
