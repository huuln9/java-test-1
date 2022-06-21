import 'dart:developer' as dev;
import 'package:flutter/cupertino.dart';
import 'package:vncitizens_administrative_document/src/config/route_config.dart';
import 'package:vncitizens_administrative_document/src/model/doc_item_model.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class AdminDocListController extends GetxController {
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
    getListDoc().then((value) {
      listDocs.value = value;
      if (value.isNotEmpty) {
        addScrollEvent();
      }
      isInitializing.value = false;
    });
  }


// =========== EVENTS ==========
  Future<void> onTapSearch() async {
    Get.toNamed(RouteConfig.searchRoute, arguments: [listDocs.toList(), page, maxPage]);
  }

  Future<void> onTapDocumentItem(DocItemModel model) async {
    Get.toNamed(RouteConfig.detailRoute, arguments: [model.vanBanID]);
  }

// ========== MANUAL FUNC ==========
  Future<List<DocItemModel>> getListDoc() async {
    Response response = await AdministrativeDocumentService().getDocuments(page: page, size: size);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    // dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      try {
        maxPage = response.body["totalPages"] - 1 ?? 0;
        isEndList.value = maxPage == 0;
      } catch (error) {
        // do nothing
      }
      return DocItemModel.fromListMap(response.body["content"]);
    }  else {
      throw "Cannot get list document";
    }
    // await Future.delayed(const Duration(seconds: 1));
    // maxPage = 3;
    // return DocItemModel.fromListMap(ExampleData.itemsMap);
  }

  void addScrollEvent() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && isLoadingMore.value == false && isEndList.value == false) {
        page++;
        if (maxPage != null && page > maxPage!) {
          dev.log("ENDED", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          isEndList.value = true;
          return;
        }  else {
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
