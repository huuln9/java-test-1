import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class ContactByGroupController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();

  RxList<SosItemModel> listContact = <SosItemModel>[].obs;
  RxnString tagId = RxnString();
  RxnString title = RxnString();
  RxBool isInitialized = false.obs;
  RxBool isInitError = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isEndList = false.obs;
  RxBool isShowSearchInput = false.obs;

  int page = 0;
  final int size = 30;
  int maxPage = 0;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void init() {
    /// reset
    reset();

    /// setter title
    if (Get.parameters["title"] != null && Get.parameters["title"] is String) {
      title.value = Get.parameters["title"];
    }

    /// setter tagId
    if (Get.parameters["tagId"] != null && Get.parameters["tagId"] is String) {
      tagId.value = Get.parameters["tagId"];
      dev.log(tagId.value ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    } else {
      throw "Cannot find tagId";
    }

    /// get list contact
    getListContact(tagId: tagId.value).then((list) {
      listContact.value = list;
      addScrollEvent(tagId: tagId.value, keyword: searchController.text);
      isInitialized.value = true;
      isInitError.value = false;

      /// get image from minio asynchronous
      updateContactImageFile(list);
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

  void reset() {
    dev.log("Reset data to default", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    listContact.value = <SosItemModel>[];
    isInitialized.value = false;
    isInitError.value = false;
    isLoadingMore.value = false;
    isEndList.value = false;
    page = 0;
    maxPage = 0;
    isShowSearchInput.value = false;
  }

// =========== EVENTS ==========

  void onClickSearchDeleteIcon() {
    searchController.clear();
    init();
  }

  void onTapIconSearch() {
    isShowSearchInput.value = true;
  }

  Future<void> search() async {
    FocusManager.instance.primaryFocus?.unfocus();
    reset();
    isShowSearchInput.value = true;
    if (searchController.text.isEmpty) {
      init();
      return;
    }
    getListContact(keyword: searchController.text, tagId: tagId.value).then((list) {
      listContact.value = list;
      isInitialized.value = true;
      isInitError.value = false;

      /// get image from minio asynchronous
      updateContactImageFile(list);
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

// ========== MANUAL FUNC ==========
  Future<List<SosItemModel>> getListContact({String? tagId, String? keyword}) async {
    dev.log("GET DATA", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    Response response = await VnccService().getAllContactActivated(tagId: tagId, keyword: keyword, page: page, size: size, spec: "page", sort: "order");
    if (response.statusCode == 200) {
      try {
        maxPage = response.body["totalPages"] - 1 ?? 0;
        isEndList.value = maxPage == 0;
      } catch (error) {
        dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        // do nothing
      }
      return SosItemModel.fromListMap(response.body["content"]);
    } else {
      throw "Cannot get list document";
    }
  }

  void addScrollEvent({String? tagId, String? keyword}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent &&
          isLoadingMore.value == false &&
          isEndList.value == false) {
        page++;
        if (page > maxPage) {
          dev.log("ENDED", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          isEndList.value = true;
          return;
        } else {
          dev.log("LOADING MORE", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          isLoadingMore.value = true;
          getListContact(tagId: tagId, keyword: keyword).then((list) {
            listContact.addAll(list);
            isLoadingMore.value = false;
            updateContactImageFile(list);
          }).catchError((error) async {
            isEndList.value = true;
            isLoadingMore.value = false;
            Get.showSnackbar(GetSnackBar(
                message: "tai them du lieu that bai".tr,
                mainButton: TextButton(onPressed: () => Get.closeAllSnackbars(), child: Text("dong".tr.toUpperCase())),
                isDismissible: true,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 2),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 70),
                animationDuration: const Duration(milliseconds: 200)));
          });
        }
      }
    });
  }

  Future<File> getMinioFileFromContactImage(String image) async {
    Response resFile = await StorageService().getFileDetail(id: image);
    if (resFile.statusCode == 200 && resFile.body["path"] != null) {
      return await MinioService().getFile(minioPath: resFile.body["path"]);
    } else {
      throw "Cannot get file info with image string: $image";
    }
  }

  Future<void> updateContactImageFile(List<SosItemModel> list) async {
    /// get image from minio asynchronous
    for (var element in list) {
      (() async {
        if (element.image != null && element.image!.isNotEmpty && element.imageFile == null) {
          try {
            File minioFile = await getMinioFileFromContactImage(element.image!);
            int indexFounded = listContact.indexWhere((elem) => elem.id == element.id);
            if (indexFounded != -1) {
              listContact[indexFounded] = listContact[indexFounded].copyWith(imageFile: minioFile);
            }
          } catch (error) {
            dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          }
        }
      }).call();
    }
  }
}
