import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_portal/service/portal_service.dart';
import 'package:vncitizens_portal/src/config/app_config.dart';
import 'package:vncitizens_portal/src/model/category_model.dart';
import 'package:vncitizens_portal/src/model/news_model.dart';
import 'package:vncitizens_portal/src/model/resource_model.dart';

class PortalController extends GetxController {
  RxString token = ''.obs;
  RxList<ResourceModel> resources = <ResourceModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<NewsModel> listNews = <NewsModel>[].obs;
  NewsModel? news;
  RxInt page = 1.obs;
  RxBool isInitLoading = false.obs;
  // RxBool isLoadingMore = false.obs;
  RxBool isLoadingDetail = false.obs;
  RxBool searchMode = false.obs;

  PortalService portalService = PortalService();

  final scrollController = ScrollController();

  @override
  Future<void> onInit() async {
    super.onInit();

    isInitLoading.value = true;

    log("INIT PORTAL CONTROLLER", name: AppConfig.packageName);

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // isLoadingMore.value = true;
        page++;
        listNews.addAll(await portalService.getAllNewsByActive());
        // isLoadingMore.value = false;
      }
    });

    /// Get resources from remote config
    resources.value = [];
    resources.value = _getResources();

    /// Get categories by that resources
    categories.value = [];
    for (var resource in resources) {
      // Get access token for that resource
      try {
        token.value = await portalService.getToken(
          endpoint: resource.tokenEndpoint,
          username: resource.username ?? '',
          password: resource.password ?? '',
        );
        log(
            'Get token for resource ' +
                resource.tokenEndpoint +
                ' successfully: ' +
                token.value,
            name: AppConfig.packageName);
      } catch (e) {
        log('Get token for resource ' + resource.tokenEndpoint + ' failure',
            name: AppConfig.packageName);
      }

      try {
        final list =
            await portalService.getCategoryByResource(resource.apiEndpoint);
        categories.addAll(list);
      } catch (e) {
        log('Get category by resource ' + resource.apiEndpoint + ' failure',
            name: AppConfig.packageName);
      }

      // Active default categories
      for (var dfCategory in resource.defaultCategories) {
        for (var category in categories) {
          if (category.resource == resource.apiEndpoint &&
              category.id == dfCategory.id) {
            category.active = true;
          }
        }
      }
    }

    await search(false);

    isInitLoading.value = false;
  }

  List<ResourceModel> _getResources() {
    final newsResources =
        GetStorage(AppConfig.storageBox).read(AppConfig.newsResources);
    List<ResourceModel> list = [];
    for (var item in newsResources) {
      list.add(ResourceModel.fromJson(item));
    }
    return list;
  }

  Future<void> getNewsDetail(NewsModel n) async {
    news = await portalService.getNewsDetail(
        endpoint: n.resourceApi!, newsId: n.id.toString());
    news!.thumbnail = n.thumbnail;
  }

  void resourceChange(ResourceModel r) {
    r.active = !r.active;
    for (var category in categories) {
      if (category.resource == r.apiEndpoint) {
        category.active = r.active;
      }
    }
  }

  void categoryChange(CategoryModel c) {
    c.active = !c.active;
    if (!c.active) {
      for (var category in categories) {
        if (category.resource == c.resource && category.active != c.active) {
          return;
        }
      }
    }
    resources.where((r) => r.apiEndpoint == c.resource).first.active = c.active;
  }

  bool checkAllResourceIsDeactive() {
    for (var resource in resources) {
      if (resource.active) {
        return false;
      }
    }
    return true;
  }

  bool checkAllCategoryIsDeactive() {
    for (var category in categories) {
      if (category.active) {
        return false;
      }
    }
    return true;
  }

  void changeAll(bool value) {
    for (var resource in resources) {
      resource.active = value;
    }
    for (var category in categories) {
      category.active = value;
    }
  }

  Future<void> search(bool mode) async {
    isInitLoading.value = true;

    page.value = 1;
    listNews.value = [];
    listNews.value = await portalService.getAllNewsByActive();

    if (mode) {
      searchMode.value = true;
    } else {
      searchMode.value = false;
    }

    isInitLoading.value = false;
  }

  void unsearch() {
    searchMode.value = false;
    changeAll(true);
    search(false);
  }

  Future<void> toDetailPage(int i) async {
    Get.toNamed("/vncitizens_portal/detail");

    isLoadingDetail.value = true;

    await getNewsDetail(listNews[i]);

    isLoadingDetail.value = false;
  }
}
