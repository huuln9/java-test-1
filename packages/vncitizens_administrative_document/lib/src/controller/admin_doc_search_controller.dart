import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:vncitizens_administrative_document/src/config/route_config.dart';
import 'package:vncitizens_administrative_document/src/model/doc_item_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdminDocSearchController extends GetxController {
  final searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RxList<DocItemModel> listDocs = <DocItemModel>[].obs;
  RxBool isInitializing = true.obs;
  RxBool isEndList = false.obs;
  RxBool isLoadingMore = false.obs;

  int page = 0;
  int? maxPage;
  final int size = 30;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments[0] != null &&
        Get.arguments[0] is List<DocItemModel> &&
        Get.arguments[1] != null &&
        Get.arguments[1] is int &&
        Get.arguments[2] != null &&
        Get.arguments[2] is int) {
      listDocs.value = Get.arguments[0];
      page = Get.arguments[1];
      maxPage = Get.arguments[2];
      if (Get.arguments[0].isNotEmpty) {
        addScrollEvent();
      }
      isInitializing.value = false;
    } else {
      getListDoc().then((value) {
        listDocs.value = value;
        if (value.isNotEmpty) {
          addScrollEvent();
        }
        isInitializing.value = false;
      });
    }
  }


// =========== EVENTS ==========
  Future<void> search() async {
    FocusManager.instance.primaryFocus?.unfocus();
    isInitializing.value = true;
    page = 0;
    maxPage = 0;
    listDocs.value = await getListDoc(keyword: searchController.text);
    isInitializing.value = false;
  }

  Future<void> onTapClearSearch() async {
    searchController.clear();
    search();
  }

  Future<void> onTapDocumentItem(DocItemModel model) async {
    Get.toNamed(RouteConfig.detailRoute, arguments: [model.vanBanID]);
  }

// ========== MANUAL FUNC ==========
  Future<List<DocItemModel>> getListDoc({String? keyword}) async {
    Response response = await AdministrativeDocumentService().getDocuments(keyword: keyword, page: page, size: size);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      try {
        maxPage = response.body["totalPages"] - 1 ?? 0;
      } catch (error) {
        // do nothing
      }
      return DocItemModel.fromListMap(response.body["content"]);
    } else {
      throw "Cannot get list document";
    }
  }

  void addScrollEvent() {
    if (scrollController.positions.isEmpty) {
      isEndList.value = true;
    }
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && isLoadingMore.value == false) {
        page++;
        if (maxPage != null && page > maxPage!) {
          dev.log("ENDED", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          isEndList.value = true;
          return;
        } else {
          dev.log("LOADING MORE", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          isLoadingMore.value = true;
          getListDoc().then((value) {
            listDocs.addAll(value);
            isLoadingMore.value = false;
          });
        }
      }
    });
  }
}
