import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/model/id_name_model.dart';
import 'package:vncitizens_account/src/model/place_model.dart';
import 'package:vncitizens_account/src/model/tag_model.dart';
import 'package:vncitizens_account/src/model/user_address_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/util/account_util.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/src/widget/processing_dialog.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'dart:developer' as dev;

class AccountUpdateAddressController extends GetxController {
  String? addressIdSelected;
  RxList<TagModel> placeTypeLevels = <TagModel>[].obs;
  late String nationSelected;
  RxList<PlaceModel> addressLevels1 = <PlaceModel>[].obs;
  RxList<PlaceModel> addressLevels2 = <PlaceModel>[].obs;
  RxList<PlaceModel> addressLevels3 = <PlaceModel>[].obs;
  RxList<PlaceModel> addressLevels4 = <PlaceModel>[].obs;
  PlaceModel? addressLevels1Selected;
  PlaceModel? addressLevels2Selected;
  PlaceModel? addressLevels3Selected;
  PlaceModel? addressLevels4Selected;
  RxBool enableSubmit = false.obs;
  UserFullyModel? userInfo;

  final formKey = GlobalKey<FormState>();
  final detailController = TextEditingController();

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
    /// set nation
    final String? configNation = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.defaultNationIdStorageKey);
    if (configNation == null) {
      Get.dialog(ErrorDialog(callback: () => Get.back(), message: "khong tim thay quoc gia".tr), barrierDismissible: false);
      return;
    } else {
      nationSelected = configNation;
    }
    
    /// set user info
    try {
      if (Get.arguments != null && Get.arguments[0] != null && Get.arguments[0] is UserFullyModel) {
        userInfo = Get.arguments[0];
        dev.log(userInfo?.toJson().toString() ?? "NULL", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else {
        dev.log("Argument is empty", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    } catch (error) {
      dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }

    /// init address data
    (() async {
      /// set new place type
      placeTypeLevels.value = await getAllPlaceTypeByNationId(nationSelected);

      /// get list level 1
      if (placeTypeLevels.isNotEmpty) {
        addressLevels1.value = await getListLocation(tagId: placeTypeLevels[0].id, nationId: nationSelected);
      }

      /// find current address and set data
      if (userInfo?.address != null) {
        final tmpCurAddress = userInfo!.address?.firstWhereOrNull((element) => element.type == 4);
        if (tmpCurAddress != null) {
          detailController.text = tmpCurAddress.address;
          LocationService().getPlaceById(id: tmpCurAddress.placeId).then((response) async {
            final tmpPlace = PlaceModel.fromMap(response.body);
            final List<IdNameModel> addressAncestors = tmpPlace.ancestors?.reversed.toList() ?? [];
            dev.log(addressAncestors.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            if (addressAncestors.isNotEmpty) {
              /// set level 1
              if (addressLevels1.isNotEmpty) {
                addressLevels1Selected = addressLevels1.firstWhereOrNull((element) => element.id == addressAncestors[0].id);
                if (addressLevels1Selected != null) {
                  await onChangeAddressLevel1(addressLevels1Selected!.id);
                }
              }
              /// set level 2
              if (addressAncestors.length > 1) {
                addressLevels2Selected = addressLevels2.firstWhereOrNull((element) => element.id == addressAncestors[1].id);
                if (addressLevels2Selected != null) {
                  await onChangeAddressLevel2(addressLevels2Selected!.id);
                }
              } else {
                addressLevels2Selected = addressLevels2.firstWhereOrNull((element) => element.id == tmpPlace.id);
                if (addressLevels2Selected != null) {
                  await onChangeAddressLevel2(addressLevels2Selected!.id);
                }
              }
              /// set level 3
              if (addressAncestors.length > 2) {
                addressLevels3Selected = addressLevels3.firstWhereOrNull((element) => element.id == addressAncestors[2].id);
                if (addressLevels3Selected != null) {
                  await onChangeAddressLevel3(addressLevels3Selected!.id);
                }
              } else {
                addressLevels3Selected = addressLevels3.firstWhereOrNull((element) => element.id == tmpPlace.id);
                if (addressLevels3Selected != null) {
                  await onChangeAddressLevel3(addressLevels3Selected!.id);
                }
              }
              /// set level 4
              if (addressAncestors.length > 3) {
                addressLevels4Selected = addressLevels4.firstWhereOrNull((element) => element.id == addressAncestors[3].id);
                if (addressLevels4Selected != null) {
                  await onChangeAddressLevel4(addressLevels4Selected!.id);
                }
              } else {
                addressLevels4Selected = addressLevels4.firstWhereOrNull((element) => element.id == tmpPlace.id);
                if (addressLevels4Selected != null) {
                  await onChangeAddressLevel4(addressLevels4Selected!.id);
                }
              }
            } else {
              /// set level 1
              if (addressLevels1.isNotEmpty) {
                addressLevels1Selected = addressLevels1.firstWhereOrNull((element) => element.id == tmpPlace.id);
                if (addressLevels1Selected != null) {
                  onChangeAddressLevel1(addressLevels1Selected!.id);
                }
              }
            }
          });
        }
      }
    }).call();
  }

  void reset() {
    addressIdSelected = null;
    placeTypeLevels.clear();
    addressLevels1.clear();
    addressLevels2.clear();
    addressLevels3.clear();
    addressLevels4.clear();
    addressLevels1Selected = null;
    addressLevels2Selected = null;
    addressLevels3Selected = null;
    addressLevels4Selected = null;
    detailController.clear();
    enableSubmit.value = false;
  }

  // =========== EVENTS ==========

  Future<void> onChangeAddressLevel1(String? id) async {
    await resetAddress(level: 2);
    if (id != null) {
      addressIdSelected = id;
      addressLevels1Selected = addressLevels1.firstWhereOrNull((element) => element.id == id);
      checkEnableSubmit();
      if (placeTypeLevels.length > 1) {
        addressLevels2.value = await getListLocation(tagId: placeTypeLevels[1].id, nationId: nationSelected, parentId: id);
      }
    } else {
      checkEnableSubmit();
    }
  }

  Future<void> onChangeAddressLevel2(String? id) async {
    await resetAddress(level: 3);
    if (id != null) {
      addressIdSelected = id;
      addressLevels2Selected = addressLevels2.firstWhereOrNull((element) => element.id == id);
      checkEnableSubmit();
      if (placeTypeLevels.length > 2) {
        addressLevels3.value = await getListLocation(tagId: placeTypeLevels[2].id, nationId: nationSelected, parentId: id);
      }
    } else {
      checkEnableSubmit();
    }
  }

  Future<void> onChangeAddressLevel3(String? id) async {
    await resetAddress(level: 4);
    if (id != null) {
      addressIdSelected = id;
      addressLevels3Selected = addressLevels3.firstWhereOrNull((element) => element.id == id);
      checkEnableSubmit();
      if (placeTypeLevels.length > 3) {
        addressLevels4.value = await getListLocation(tagId: placeTypeLevels[3].id, nationId: nationSelected, parentId: id);
      }
    } else {
      checkEnableSubmit();
    }
  }

  Future<void> onChangeAddressLevel4(String? id) async {
    await resetAddress(level: 5);
    if (id != null) {
      addressIdSelected = id;
      addressLevels4Selected = addressLevels4.firstWhereOrNull((element) => element.id == id);
      checkEnableSubmit();
      if (placeTypeLevels.length > 4) {
        addressLevels4.value = await getListLocation(tagId: placeTypeLevels[4].id, nationId: nationSelected, parentId: id);
      }
    } else {
      checkEnableSubmit();
    }
  }

  void onChangeAddressDetail() {
    checkEnableSubmit();
  }

  Future<void> submit() async {
    /// return if invalid
    if (enableSubmit.value != true) {
      dev.log("Form invalid", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return;
    }
    /// submit
    FocusManager.instance.primaryFocus?.unfocus();
    Get.dialog(const ProcessingDialog(), barrierDismissible: false);
    try {
      final tmpAddress = userInfo!.address ?? [];
      tmpAddress.removeWhere((element) => element.type == 4);
      tmpAddress.add(UserAddressModel(address: detailController.text, placeId: addressIdSelected!, type: 4));
      AuthService().updateAddress(id: userInfo!.id!, address: tmpAddress).then((value) {
        /// close dialog
        Get.back();
        /// back to user detail
        Get.back(result: true);
      }).catchError((error) {
        dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        Get.back();
        Get.showSnackbar(AccountUtil.getMySnackBar());
      });
    } catch (error) {
      dev.log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      Get.back();
      Get.showSnackbar(AccountUtil.getMySnackBar());
    }
  }

  // ========== MANUAL FUNC ==========

  bool checkEnableSubmit() {
    bool check = false;
    switch (placeTypeLevels.length) {
      case 0:
        check = checkValidAddressDetail();
        break;
      case 1:
        check = addressLevels1Selected != null && checkValidAddressDetail();
        break;
      case 2:
        check = addressLevels1Selected != null && addressLevels2Selected != null && checkValidAddressDetail();
        break;
      case 3:
        check = addressLevels1Selected != null &&
            addressLevels2Selected != null &&
            addressLevels3Selected != null &&
            checkValidAddressDetail();
        break;
      case 4:
        check = addressLevels1Selected != null &&
            addressLevels2Selected != null &&
            addressLevels3Selected != null &&
            addressLevels4Selected != null &&
            checkValidAddressDetail();
        break;
      default:
        check = false;
    }
    enableSubmit.value = check;
    return check;
  }

  bool checkValidAddressDetail() {
    return detailController.text.isNotEmpty && detailController.text.isBlank != true;
  }

  Future<List<TagModel>> getAllPlaceTypeByNationId(String nationId) async {
    String categoryId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.placeTypeCategoryIdStorageKey);
    Response response = await DirectoryService().getTags(categoryId: categoryId, nationId: nationId, sortBy: "order");
    // dev.log(response.body["content"].toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return TagModel.fromListMap(response.body["content"]);
    } else {
      throw "Get tags failed";
    }
  }

  Future<List<PlaceModel>> getListLocation({required String tagId, required String nationId, String? parentId}) async {
    Response response = await LocationService().getVPlaces(tagId: tagId, nationId: nationId, parentId: parentId);
    // dev.log(response.body["content"].toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return PlaceModel.fromListMap(response.body["content"]);
    } else {
      throw "Get places failed";
    }
  }

  Future<void> resetAddress({int? level}) async {
    List<TagModel> tempPlaceTypes = List.from(placeTypeLevels);
    if (level != null) {
      switch (level) {
        case 1:
          {
            addressLevels1.value = [];
            addressLevels2.value = [];
            addressLevels3.value = [];
            addressLevels4.value = [];
            addressLevels1Selected = null;
            addressLevels2Selected = null;
            addressLevels3Selected = null;
            addressLevels4Selected = null;
            placeTypeLevels.value = [];
            await Future.delayed(const Duration(milliseconds: 50));
            placeTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 2:
          {
            addressLevels2.value = [];
            addressLevels3.value = [];
            addressLevels4.value = [];
            addressLevels2Selected = null;
            addressLevels3Selected = null;
            addressLevels4Selected = null;
            placeTypeLevels.value = placeTypeLevels.sublist(0, 1);
            await Future.delayed(const Duration(milliseconds: 50));
            placeTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 3:
          {
            addressLevels3.value = [];
            addressLevels4.value = [];
            addressLevels3Selected = null;
            addressLevels4Selected = null;
            placeTypeLevels.value = placeTypeLevels.sublist(0, 2);
            await Future.delayed(const Duration(milliseconds: 50));
            placeTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 4:
          {
            addressLevels4.value = [];
            addressLevels4Selected = null;
            placeTypeLevels.value = placeTypeLevels.sublist(0, 3);
            await Future.delayed(const Duration(milliseconds: 50));
            placeTypeLevels.value = tempPlaceTypes;
            break;
          }
        default:
          break;
      }
    } else {
      addressLevels1.value = [];
      addressLevels2.value = [];
      addressLevels3.value = [];
      addressLevels4.value = [];
      addressLevels1Selected = null;
      addressLevels2Selected = null;
      addressLevels3Selected = null;
      addressLevels4Selected = null;
      placeTypeLevels.value = [];
      await Future.delayed(const Duration(milliseconds: 50));
      placeTypeLevels.value = tempPlaceTypes;
    }
  }
}
