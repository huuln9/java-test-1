import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_emergency_contact/src/config/emer_contact_app_config.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_group_by_tag_model.dart';
import 'package:vncitizens_emergency_contact/src/model/sos_item_model.dart';

class ContactExcludeGroupController extends GetxController {
  RxList<SosItemModel> listSosNoTag = <SosItemModel>[].obs;
  RxList<SosItemModel> listSos = <SosItemModel>[].obs;
  RxList<SosGroupByTagModel> listSosByTag = <SosGroupByTagModel>[].obs;
  RxnString title = RxnString();
  RxnString tagId = RxnString();
  RxBool isShowSearchInput = false.obs;
  final searchController = TextEditingController();
  RxBool isInitialized = false.obs;
  RxBool isInitError = false.obs;

  @override
  void onInit() {
    super.onInit();
    log("INIT CONTROLLER", name: EmerContactAppConfig.packageName);
    init();
  }

  void reset() {
    listSosNoTag.value = [];
    listSos.value = [];
    listSosByTag.value = [];
    title.value = null;
    isShowSearchInput.value = false;
    searchController.clear();
    isInitialized.value = false;
    isInitError.value = false;
  }

  Future<void> init() async {
    reset();
    if (Get.parameters["title"] != null && Get.parameters["title"] is String) {
      title.value = Get.parameters["title"];
    }
    /// setter tagId
    if (Get.parameters["tagId"] != null && Get.parameters["tagId"] is String) {
      tagId.value = Get.parameters["tagId"];
      log(tagId.value ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    } else {
      throw "Cannot find tagId";
    }
    getListTag().then((value) async {
      // log("LIST TAG: " + value.toString(), name: EmerContactAppConfig.packageName);
      listSosByTag.addAll(value);
      // expand group
      for (var element in value) {
        if (element.description == EmerContactAppConfig.titleExpandedString) {
          onTapSosGroupTitle(element.id);
        }
      }
      isInitialized.value = true;
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
    getListSosNoTag().then((value) async {
      listSos.value = value;
      for (var index = 0; index < value.length; index++) {
        final element = value[index];
        if (element.tag == null) {
          // add sos without tag
          listSosNoTag.add(element);
          /// get image from minio asynchronous
          (() async {
            if (element.image != null && element.image!.isNotEmpty && element.imageFile == null) {
              try {
                File minioFile = await getMinioFileFromContactImage(element.image!);
                int indexFounded = listSosNoTag.indexWhere((elem) => elem.id == element.id);
                if (indexFounded != -1) {
                  listSosNoTag[indexFounded] = listSosNoTag[indexFounded].copyWith(imageFile: minioFile);
                }
              } catch (error) {
                log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              }
            }
          }).call();
        }
      }
      isInitialized.value = true;
      // log("SOS NO TAG: " + listSosNoTag.toString(), name: EmerContactAppConfig.packageName);
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

  void onTapIconSearch() {
    isShowSearchInput.value = true;
  }

  void onClickSearchDeleteIcon() {
    isShowSearchInput.value = false;
    searchController.clear();
    resetValue();
    init();
  }

  void resetValue() {
    listSosByTag.value = [];
    listSosNoTag.value = [];
    listSos.value = [];
  }

  search(String keyword) {
    log(keyword, name: EmerContactAppConfig.packageName + " Search keyword");
    FocusManager.instance.primaryFocus?.unfocus();
    if (keyword.isEmpty) {
      init();
      return;
    }
    getListSosByKeyword(keyword).then((value) async {
      resetValue();
      await Future.delayed(const Duration(milliseconds: 50));
      listSos.value = value;
      for (var index = 0; index < value.length; index++) {
        final element = value[index];
        if (element.tag != null) {
          // add unique tag
          final foundItem = listSosByTag.firstWhereOrNull((tag) => tag.id == element.tag?.id);
          if (foundItem == null) {
            if (element.tag?.description == EmerContactAppConfig.titleExpandedString) {
              final list = await getListSosByKeyword(keyword, tagId: element.tag?.id);
              listSosByTag.add(SosGroupByTagModel(
                id: element.tag?.id as String,
                name: element.tag?.name,
                description: element.tag?.description,
                contacts: list,
              ));
            } else {
              listSosByTag.add(SosGroupByTagModel(
                id: element.tag?.id as String,
                name: element.tag?.name,
                description: element.tag?.description,
              ));
            }
          }
        } else {
          // add sos without tag
          listSosNoTag.add(element);
          /// get image from minio asynchronous
          (() async {
            if (element.image != null && element.image!.isNotEmpty && element.imageFile == null) {
              try {
                File minioFile = await getMinioFileFromContactImage(element.image!);
                int indexFounded = listSosNoTag.indexWhere((elem) => elem.id == element.id);
                if (indexFounded != -1) {
                  listSosNoTag[indexFounded] = listSosNoTag[indexFounded].copyWith(imageFile: minioFile);
                }
              } catch (error) {
                log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              }
            }
          }).call();
        }
      }
      log(listSos.toString(), name: EmerContactAppConfig.packageName);
      log(listSosByTag.toString(), name: EmerContactAppConfig.packageName);
    }).catchError((error) async {
      isInitialized.value = true;
      isInitError.value = true;
    });
  }

  Future<List<SosItemModel>> getListSosByKeyword(String keyword, {String? tagId}) async {
    Response response = await VnccService().getAllContactActivated(keyword: keyword, tagId: tagId);
    if (response.statusCode == 200) {
      List<SosItemModel> list = [];
      response.body["content"].forEach((item) {
        list.add(SosItemModel.fromMap(item));
      });
      list.removeWhere((element) {
        if (element.tag != null && element.tag!.id == this.tagId.value!) {
          return true;
        }
        return false;
      });
      return list;
    } else {
      throw "GET SOS LIST ERROR";
    }
  }

  Future<List<SosItemModel>> getListSosNoTag() async {
    Response response = await VnccService().getAllContactActivated(sort: "order", spec: "page", size: 100);
    if (response.statusCode == 200) {
      List<SosItemModel> list = [];
      response.body["content"].forEach((item) {
        list.add(SosItemModel.fromMap(item));
      });
      return list;
    } else {
      throw "GET SOS LIST ERROR";
    }
  }

  Future<void> onTapSosGroupTitle(String tagId) async {
    final tagIndex = listSosByTag.indexWhere((element) => element.id == tagId);
    final contacts = listSosByTag[tagIndex].contacts;
    if (contacts != null && contacts.isNotEmpty) {
      return;
    }
    List<SosItemModel> list = await getListSosByTag(tagId, keyword: searchController.text);
    // log(list.toString(), name: EmerContactAppConfig.packageName);
    if (tagIndex != -1) {
      listSosByTag[tagIndex] = SosGroupByTagModel(
        id: listSosByTag[tagIndex].id,
        name: listSosByTag[tagIndex].name,
        description: listSosByTag[tagIndex].description,
        contacts: list,
      );
      /// get image from minio asynchronous
      (() async {
        if (listSosByTag[tagIndex].contacts != null) {
          for (var elemContact in listSosByTag[tagIndex].contacts!) {
            if (elemContact.image != null && elemContact.image!.isNotEmpty && elemContact.imageFile == null) {
              try {
                File minioFile = await getMinioFileFromContactImage(elemContact.image!);
                int indexFounded = listSosByTag[tagIndex].contacts!.indexWhere((elem) => elem.id == elemContact.id);
                if (indexFounded != -1) {
                  listSosByTag[tagIndex].contacts![indexFounded] = listSosByTag[tagIndex].contacts![indexFounded].copyWith(imageFile: minioFile);
                  listSosByTag[tagIndex] = listSosByTag[tagIndex].copyWith(description: listSosByTag[tagIndex].description);
                }
              } catch (error) {
                log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              }
            }
          }
        }
      }).call();
    }
  }

  Future<List<SosItemModel>> getListSosByTag(String tagId, {String? keyword}) async {
    Response response = await VnccService().getAllContactActivatedWithTag(tagId, sort: "order", spec: "page", size: 100, keyword: keyword);
    if (response.statusCode == 200) {
      List<SosItemModel> list = [];
      response.body["content"].forEach((item) {
        list.add(SosItemModel.fromMap(item));
      });
      return list;
    } else {
      throw "GET SOS LIST BY TAG ERROR";
    }
  }

  Future<List<SosGroupByTagModel>> getListTag() async {
    final categoryId = GetStorage(EmerContactAppConfig.storageBox).read(EmerContactAppConfig.tagCategoryIdStorageKey);
    Response response = await DirectoryService().getAllTagActivated(categoryId: categoryId, sortBy: "order");
    if (response.statusCode == 200) {
      List<SosGroupByTagModel> list = [];
      response.body["content"].forEach((item) {
        list.add(SosGroupByTagModel.fromMap(item));
      });
      list.removeWhere((element) => element.id == tagId.value!);
      return list;
    } else {
      throw "GET TAG LIST ERROR";
    }
  }

  Future<File> getMinioFileFromContactImage(String image) async {
    Response resFile = await StorageService().getFileDetail(id: image);
    if (resFile.statusCode == 200 && resFile.body["path"] != null) {
      return await MinioService().getFile(minioPath: resFile.body["path"]);
    } else {
      throw "Cannot get file info with image string: $image";
    }
  }
}
