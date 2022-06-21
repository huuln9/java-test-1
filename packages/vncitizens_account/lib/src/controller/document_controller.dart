import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_account/src/model/agency_model.dart';
import 'package:vncitizens_account/src/model/document_model.dart';
import 'package:vncitizens_account/src/model/id_model.dart';
import 'package:vncitizens_account/src/model/id_name_model.dart';
import 'package:vncitizens_account/src/model/nation_model.dart';
import 'package:vncitizens_account/src/model/place_model.dart';
import 'package:vncitizens_account/src/model/tag_model.dart';
import 'package:vncitizens_account/src/model/user_address_model.dart';
import 'package:vncitizens_account/src/model/user_document_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/src/widget/error_dialog_two.dart';
import 'package:vncitizens_account/src/widget/success_dialog.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class DocumentController extends GetxController {
  /// receive data from Get.arguments[0]
  late int documentType;
  late DocumentModel documentModel;
  Function? reScanCallback;
  UserFullyModel? userInfo;
  String? facePath;
  late Uint8List frontSide;
  late Uint8List backSide;
  String? frontSideId;
  String? backSideId;
  String? personId;
  late bool isSubmitted;
  RxBool loading = false.obs;

  // ======== form ================
  final formKey = GlobalKey<FormState>();
  final List<String> genders = ["nam".tr, "nu".tr];
  String genderSelected = "nam".tr;
  RxList<AgencyModel> issuePlaces = <AgencyModel>[].obs;
  String issuePlaceIdSelected = "";
  String? issuePlaceIdSelectedName;
  RxList<NationModel> nations = <NationModel>[].obs;

  // ========== origin locations ============
  String? originNationSelected;
  RxList<TagModel> originPlaceTypeLevels = <TagModel>[].obs;
  RxList<PlaceModel> originAddressLevels1 = <PlaceModel>[].obs;
  RxList<PlaceModel> originAddressLevels2 = <PlaceModel>[].obs;
  RxList<PlaceModel> originAddressLevels3 = <PlaceModel>[].obs;
  RxList<PlaceModel> originAddressLevels4 = <PlaceModel>[].obs;
  PlaceModel? originAddressLevels1Selected;
  PlaceModel? originAddressLevels2Selected;
  PlaceModel? originAddressLevels3Selected;
  PlaceModel? originAddressLevels4Selected;
  String? originAddressIdSelected;

  // ========= recent locations =============
  String? recentNationSelected;
  RxList<TagModel> recentPlaceTypeLevels = <TagModel>[].obs;
  RxList<PlaceModel> recentAddressLevels1 = <PlaceModel>[].obs;
  RxList<PlaceModel> recentAddressLevels2 = <PlaceModel>[].obs;
  RxList<PlaceModel> recentAddressLevels3 = <PlaceModel>[].obs;
  RxList<PlaceModel> recentAddressLevels4 = <PlaceModel>[].obs;
  PlaceModel? recentAddressLevels1Selected;
  PlaceModel? recentAddressLevels2Selected;
  PlaceModel? recentAddressLevels3Selected;
  PlaceModel? recentAddressLevels4Selected;
  String? recentAddressIdSelected;

  // ======== controllers =========
  final fullnameController = TextEditingController();
  final birthdayController = TextEditingController();
  final cardNumberController = TextEditingController();
  final issueDateController = TextEditingController();
  final issuePlaceController = TextEditingController();
  final originAddressDetailController = TextEditingController();
  final recentAddressDetailController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setVariableFromArguments();
    isSubmitted = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void setVariableFromArguments() {
    /// set document type
    if (Get.arguments[0] != null) {
      documentType = Get.arguments[0];
    } else {
      throw "No document type passed";
    }

    /// set document model
    if (Get.arguments[1] != null) {
      documentModel = Get.arguments[1];
      fullnameController.text = documentModel.name;
      genderSelected = genders.contains(documentModel.gender!.toLowerCase().tr) ? documentModel.gender!.toLowerCase().tr : genderSelected;
      cardNumberController.text = documentModel.id;
      birthdayController.text = getDateStringFormatted(documentModel.birthDay);
      issueDateController.text = getDateStringFormatted(documentModel.issueDate);

      /// get and set issue place
      getListCitizenIdentityIssuers().then((value) {
        issuePlaces.value = value;
        String? id = getIssuePlaceIdInListAgency(documentModel.issuePlace, issuePlaces);
        if (id != null) {
          issuePlaceIdSelected = id;
          try {
            issuePlaceIdSelectedName = value.firstWhereOrNull((element) => element.id == id)?.name;
          } catch (error) {
            // do nothing
          }
        }
      });

      /// get and set nation
      getAllNationActivated().then((value) {
        nations.value = value;
        String? id = getNationIdInListNation(documentModel.nationality, nations);
        if (id != null) {
          originNationSelected = id;

          /// set all address origin
          setAllOriginAddressFromDocument(nationId: id);
          recentNationSelected = id;

          /// set all address recent
          setAllRecentAddressFromDocument(nationId: id);
        } else {
          String defaultNationId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.defaultNationIdStorageKey);
          dev.log("Set default nation id: $defaultNationId", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          originNationSelected = defaultNationId;
          setAllOriginAddressFromDocument(nationId: defaultNationId);

          recentNationSelected = defaultNationId;
          setAllRecentAddressFromDocument(nationId: defaultNationId);
        }
      });
    } else {
      throw "No document model passed";
    }

    /// set rescan callback
    if (Get.arguments[2] != null) {
      reScanCallback = Get.arguments[2];
    }  else {
      throw "No rescan callback passed";
    }

    /// set user info
    if (Get.arguments[3] != null) {
      userInfo = Get.arguments[3];
    }

    /// set face path
    if (Get.arguments[4] != null) {
      facePath = Get.arguments[4];
    }

    /// set front side
    if (Get.arguments[5] != null) {
      frontSide = Get.arguments[5];
    } else {
      throw "Front side is not found";
    }

    /// set front side
    if (Get.arguments[6] != null) {
      backSide = Get.arguments[6];
    } else {
      throw "Back side is not found";
    }
  }

  // ============== validators =====================

  String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "vui long nhap ho ten".tr;
    } else {
      return value.length <= 64 ? null : "do dai toi da 64 ky tu".tr;
    }
  }

  String? genderValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "vui long chon gioi tinh".tr;
    }
    return null;
  }

  String? emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "khong bo trong truong nay".tr;
    }
    return null;
  }

  String? cardNumberValidator(String? value) {
    if (value == null || value.isEmpty || value.isBlank == true) {
      return "khong bo trong truong nay".tr;
    } else {
      String pattern = r'([0-9]+)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value) != true) {
        return "chi cho phep ky tu so".tr;
      }
      switch (documentType) {
        case 1:
          {
            /// validate citizen identity
            return value.length == 12 ? null : "chua hop le, do dai phai 12 ky tu".tr;
          }
        case 2:
          {
            /// validate identity
            return value.length == 9 ? null : "chua hop le, do dai phai 9 ky tu".tr;
          }
        case 3:
          {
            /// validate passport
            return value.length <= 64 ? null : "do dai toi da 64 ky tu".tr;
          }
        default:
          return null;
      }
    }
  }

  // ============= end validators ================

  // ============= EVENTS ========================

  void onChangeGender(String? value) {
    if (value == null || value.isEmpty) {
    } else {
      genderSelected = value;
    }
  }

  void onTapBirthday(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        birthdayController.text = convertDateTimeToString(value);
      } else {
        dev.log("Date is null", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  void onTapIssueDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ).then((value) {
      if (value != null) {
        issueDateController.text = convertDateTimeToString(value);
      } else {
        dev.log("Date is null", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  void onChangeIssuePlace(String? value) {
    if (value != null) {
      issuePlaceIdSelected = value;
    }
  }

  Future<void> onChangeOriginNation(String? nationId) async {
    if (nationId != null) {
      await resetOriginAddress();

      originNationSelected = nationId;

      /// set new place type
      List<TagModel> placeTypes = await getAllPlaceTypeByNationId(nationId);
      originPlaceTypeLevels.value = placeTypes;

      /// get list level 1
      if (placeTypes.isNotEmpty) {
        originAddressLevels1.value = await getListLocation(tagId: placeTypes[0].id, nationId: nationId);
      }
    }
  }

  Future<void> onChangeOriginLevel1(String? id) async {
    await resetOriginAddress(level: 2);
    if (id != null) {
      originAddressIdSelected = id;
      if (originNationSelected != null && originPlaceTypeLevels.length > 1) {
        originAddressLevels2.value =
        await getListLocation(tagId: originPlaceTypeLevels[1].id, nationId: originNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeOriginLevel2(String? id) async {
    await resetOriginAddress(level: 3);
    if (id != null) {
      originAddressIdSelected = id;
      if (originNationSelected != null && originPlaceTypeLevels.length > 2) {
        originAddressLevels3.value =
        await getListLocation(tagId: originPlaceTypeLevels[2].id, nationId: originNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeOriginLevel3(String? id) async {
    await resetOriginAddress(level: 4);
    if (id != null) {
      originAddressIdSelected = id;
      if (originNationSelected != null && originPlaceTypeLevels.length > 3) {
        originAddressLevels4.value =
        await getListLocation(tagId: originPlaceTypeLevels[3].id, nationId: originNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeOriginLevel4(String? id) async {
    await resetOriginAddress(level: 5);
    if (id != null) {
      originAddressIdSelected = id;
      if (originNationSelected != null && originPlaceTypeLevels.length > 4) {
        originAddressLevels4.value =
        await getListLocation(tagId: originPlaceTypeLevels[4].id, nationId: originNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeRecentNation(String? nationId) async {
    if (nationId != null) {
      await resetRecentAddress();

      recentNationSelected = nationId;

      /// set new place type
      List<TagModel> placeTypes = await getAllPlaceTypeByNationId(nationId);
      recentPlaceTypeLevels.value = placeTypes;

      /// get list level 1
      if (placeTypes.isNotEmpty) {
        recentAddressLevels1.value = await getListLocation(tagId: placeTypes[0].id, nationId: nationId);
      }
    }
  }

  Future<void> onChangeRecentLevel1(String? id) async {
    await resetRecentAddress(level: 2);
    if (id != null) {
      recentAddressIdSelected = id;
      if (recentNationSelected != null && recentPlaceTypeLevels.length > 1) {
        recentAddressLevels2.value =
        await getListLocation(tagId: recentPlaceTypeLevels[1].id, nationId: recentNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeRecentLevel2(String? id) async {
    await resetRecentAddress(level: 3);
    if (id != null) {
      recentAddressIdSelected = id;
      if (recentNationSelected != null && recentPlaceTypeLevels.length > 2) {
        recentAddressLevels3.value =
        await getListLocation(tagId: recentPlaceTypeLevels[2].id, nationId: recentNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeRecentLevel3(String? id) async {
    await resetRecentAddress(level: 4);
    if (id != null) {
      recentAddressIdSelected = id;
      if (recentNationSelected != null && recentPlaceTypeLevels.length > 3) {
        recentAddressLevels4.value =
        await getListLocation(tagId: recentPlaceTypeLevels[3].id, nationId: recentNationSelected as String, parentId: id);
      }
    }
  }

  Future<void> onChangeRecentLevel4(String? id) async {
    await resetRecentAddress(level: 5);
    if (id != null) {
      recentAddressIdSelected = id;
      if (recentNationSelected != null && recentPlaceTypeLevels.length > 4) {
        recentAddressLevels4.value =
        await getListLocation(tagId: recentPlaceTypeLevels[4].id, nationId: recentNationSelected as String, parentId: id);
      }
    }
  }

  void reScan() {
    Get.back();
    if (reScanCallback != null) {
      reScanCallback!();
    }
  }

  Future<void> submit() async {
    final formState = formKey.currentState;
    if (formState != null && formState.validate()) {
      dev.log("SUBMIT FORM", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (userInfo != null) {
        loading.value = true;
        try {
          await uploadDocumentToMinio();
          // if (userInfo!.vnptBioId == null) {
          //   await registerFaceBioID();
          // }
        } catch (error) {
          loading.value = false;
          Get.dialog(
              ErrorDialogTwo(
                onRetry: () => submit(),
                message: "loi luu hinh anh".tr,
              ),
              barrierDismissible: false);
          return;
        }
        UserFullyModel userFullyModel = UserFullyModel.fromJson(userInfo!.toJson());
        userFullyModel.fullname = fullnameController.text;
        userFullyModel.gender = genderSelected == "nam".tr ? 1 : 0;
        userFullyModel.birthday = convertDateStringToIso(birthdayController.text);
        UserDocumentModel userDocumentModel = UserDocumentModel(
            number: cardNumberController.text,
            date: convertDateStringToIso(issueDateController.text),
            agency: IdNameModel(id: issuePlaceIdSelected, name: issuePlaceIdSelectedName),
            scanImage: backSideId != null && frontSideId != null
                ? ScanImageModel(backside: IdModel(id: backSideId!), frontside: IdModel(id: frontSideId!))
                : null);
        switch (documentType) {
          case 1:
            userFullyModel.citizenIdentity = userDocumentModel;
            break;
          case 2:
            userFullyModel.identity = userDocumentModel;
            break;
          case 3:
            userFullyModel.passport = userDocumentModel;
            break;
          default:
            break;
        }
        List<UserAddressModel> tmpAddress = [];
        final addressCurrent = userInfo!.address?.firstWhereOrNull((element) => element.type == 4);
        if (addressCurrent != null) {
          tmpAddress.add(addressCurrent);
        }
        tmpAddress.addAll([
          UserAddressModel(address: recentAddressDetailController.text, placeId: recentAddressIdSelected ?? "", type: 1),
          UserAddressModel(address: originAddressDetailController.text, placeId: originAddressIdSelected ?? "", type: 3),
        ]);
        userFullyModel.address = tmpAddress;
        // if (personId != null) {
        //   if (userFullyModel.vnptBioId != null) {
        //     userFullyModel.vnptBioId = userFullyModel.vnptBioId!.copyWith(personId: personId!);
        //   } else {
        //     userFullyModel.vnptBioId = UserBioIdModel(personId: personId!);
        //   }
        // }
        dev.log(userFullyModel.toJson().toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        Response response = await AuthService().updateUserFullyByJson(id: userFullyModel.id ?? "", json: userFullyModel.toJson());
        dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (response.statusCode == 200 && response.body["affectedRows"] > 0) {
          loading.value = false;
          // if (personId != null) {
          //   AuthUtil.setPersonId(personId!);
          // }
          Get.dialog(
              SuccessDialog(
                callback: () => Get.offAllNamed(AccountRouteConfig.userDetailRoute),
                message: "cap nhat thong tin thanh cong".tr,
              ),
              barrierDismissible: false);
        } else {
          loading.value = false;
          try {
            if (response.body["code"] != null && response.body["message"] != null) {
              Get.dialog(
                  ErrorDialog(
                    callback: () {},
                    message: response.body["message"],
                  ),
                  barrierDismissible: false);
            }
          } catch (error) {
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: "cap nhat thong tin that bai".tr,
                ),
                barrierDismissible: false);
          }
        }
      }  else {
        if (isSubmitted == false) {
          loading.value = true;
          try {
            await uploadDocumentToMinio();
          } catch (error) {
            loading.value = false;
            Get.dialog(
                ErrorDialogTwo(
                  onRetry: () => submit(),
                  message: "Khong the upload hinh anh".tr,
                ),
                barrierDismissible: false);
            return;
          }
          // registerFaceBioID();
          loading.value = false;
          isSubmitted = true;
        }
        Get.toNamed(AccountRouteConfig.registerAfterDocumentRoute, arguments: [facePath, cardNumberController.text]);
      }
    }
  }

  // ============= END EVENTS ========================

  // ============== CALL APIS =====================
  Future<List<AgencyModel>> getListCitizenIdentityIssuers() async {
    String tagId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.citizenIssuerTagIdStorageKey);
    Response response = await DirectoryService().getAllIdentityIssuePlaces(tagId: tagId, spec: "unpage");
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.body["content"].length > 0) {
      List<AgencyModel> lst = [];
      for (var item in response.body["content"]) {
        lst.add(AgencyModel.fromMap(item));
      }
      return lst;
    } else {
      return [];
    }
  }

  Future<List<NationModel>> getAllNationActivated() async {
    Response response = await DirectoryService().getNations();
    dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return NationModel.fromListMap(response.body);
    } else {
      throw "Get nations failed";
    }
  }

  Future<List<TagModel>> getAllPlaceTypeByNationId(String nationId) async {
    String categoryId = GetStorage(AccountAppConfig.storageBox).read(AccountAppConfig.placeTypeCategoryIdStorageKey);
    Response response = await DirectoryService().getTags(categoryId: categoryId, nationId: nationId, sortBy: "order");
    dev.log(response.body["content"].toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return TagModel.fromListMap(response.body["content"]);
    } else {
      throw "Get tags failed";
    }
  }

  Future<List<PlaceModel>> getListLocation({required String tagId, required String nationId, String? parentId}) async {
    Response response = await LocationService().getVPlaces(tagId: tagId, nationId: nationId, parentId: parentId);
    dev.log(response.body["content"].toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return PlaceModel.fromListMap(response.body["content"]);
    } else {
      throw "Get places failed";
    }
  }

  // ============== END CALL APIS ===================

  // ================ MANUAL FUNCTIONS ===========

  // Future<void> registerFaceBioID() async {
  //   /// create person
  //   dio.Response response = await BioIdService().createPerson(identification: cardNumberController.text);
  //   dev.log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //   dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //   if (response.statusCode == 201 && response.data["id"] != null) {
  //     personId = response.data["id"].toString();
  //     /// register face with person id and image file path
  //     dio.Response response1 = await BioIdService().registerFaceFromImage(personId: response.data["id"].toString(), faceFilePath: facePath as String);
  //     dev.log(response1.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //     dev.log(response1.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //     if (response1.statusCode == 201) {
  //       dev.log("Đăng ký khuôn mặt thành công", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //     } else {
  //       dev.log("Đăng ký khuôn mặt thất bại", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
  //     }
  //   }
  // }

  Future<void> uploadDocumentToMinio() async {
    /// upload front side
    dev.log("Uploading front side", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    try {
      final oid = ObjectId();
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/${oid.hexString}1.jpg').create();
      file.writeAsBytesSync(frontSide);

      /// upload
      String? minioFrontSidePath = await MinioService().uploadWithPath(filePath: file.path);

      file.deleteSync();
      dev.log("minioFrontSidePath: " + (minioFrontSidePath ?? "NULL"), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (minioFrontSidePath != null) {
        int frontSideSize = frontSide.lengthInBytes;

        /// save info to svc-storage
        Response response = await StorageService().saveMinioFileInfo(path: minioFrontSidePath, size: frontSideSize);
        dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        dev.log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (response.statusCode == 200 && response.body["id"] != null) {
          frontSideId = response.body["id"];
        } else {
          throw "Cannot save minio file info";
        }
      } else {
        throw "Cannot upload front side to minio";
      }
    } catch (error) {
      throw "Cannot upload front side to minio";
    }

    /// upload back side
    dev.log("Uploading back side", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    try {
      /// create file from bytes
      final oid1 = ObjectId();
      final tempDir = await getTemporaryDirectory();
      File fileBackSide = await File('${tempDir.path}/${oid1.hexString}2.jpg').create();
      fileBackSide.writeAsBytesSync(backSide);

      /// upload
      String? minioBackSidePath = await MinioService().uploadWithPath(filePath: fileBackSide.path);

      fileBackSide.deleteSync();
      dev.log("minioBackSidePath: " + (minioBackSidePath ?? "NULL"), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (minioBackSidePath != null) {
        int backSideSize = backSide.lengthInBytes;

        /// save info to svc-storage
        Response resStorageBackSide = await StorageService().saveMinioFileInfo(path: minioBackSidePath, size: backSideSize);
        dev.log(resStorageBackSide.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        dev.log(resStorageBackSide.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (resStorageBackSide.statusCode == 200 && resStorageBackSide.body["id"] != null) {
          backSideId = resStorageBackSide.body["id"];
        } else {
          throw "Cannot save minio file info";
        }
      } else {
        throw "Cannot upload back side to minio";
      }
    } catch (error) {
      throw "Cannot upload back side to minio";
    }
  }

  String convertDateStringToIso(String dateString) {
    try {
      DateTime tempDate = DateFormat("dd/MM/yyyy").parse(dateString);
      dev.log(tempDate.toIso8601String(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return tempDate.toIso8601String();
    } catch (error) {
      dev.log("Invalid date string", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
    return "";
  }

  String getDateStringFormatted(String dateString) {
    try {
      DateTime tempDate = DateFormat("dd/MM/yyyy").parse(dateString);
      return convertDateTimeToString(tempDate);
    } catch (error) {
      dev.log("Invalid date string", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<String> dateStringSplit = dateString.split("/");
      if (dateStringSplit.length == 1) {
        final newDateString = "01/01/" + dateStringSplit.last;
        return newDateString;
      }
    }
    return "";
  }

  String convertDateTimeToString(DateTime dateTime) {
    dev.log(dateTime.toIso8601String(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    final outputDate = DateFormat("dd/MM/yyyy").format(dateTime);
    dev.log(outputDate, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    return outputDate;
  }

  String nonAccentVietnamese(String str) {
    const _vietnamese = 'aAeEoOuUiIdDyY';
    final _vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp(r'ì|í|ị|ỉ|ĩ'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp(r'đ'),
      RegExp(r'Đ'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
    ];

    var result = str;
    for (var i = 0; i < _vietnamese.length; ++i) {
      result = result.replaceAll(_vietnameseRegex[i], _vietnamese[i]);
    }
    return result;
  }

  String? getIssuePlaceIdInListAgency(String issuePlace, List<AgencyModel> listAgency) {
    String issuePlaceNonAccent = nonAccentVietnamese(issuePlace.replaceAll("\n", " ").toLowerCase());
    for (var item in listAgency) {
      String agencyNonAccent = nonAccentVietnamese(item.name.toLowerCase());
      if (issuePlaceNonAccent == agencyNonAccent) {
        return item.id;
      }
    }
    return null;
  }

  String? getNationIdInListNation(String nationality, List<NationModel> listNation) {
    String nationalityNonAccent = nonAccentVietnamese(nationality.replaceAll("\n", " ").toLowerCase());
    for (var item in listNation) {
      String itemNonAccent = nonAccentVietnamese(item.name.toLowerCase());
      if (nationalityNonAccent == itemNonAccent) {
        return item.id;
      }
    }
    return null;
  }

  PlaceModel? getPlaceInListPlace(String placeName, List<PlaceModel> listPlace) {
    String placeNameNonAccent = nonAccentVietnamese(placeName.replaceAll("\n", " ").toLowerCase());
    for (var item in listPlace) {
      String itemNonAccent = nonAccentVietnamese(item.name.toLowerCase());
      if (placeNameNonAccent == itemNonAccent) {
        return item;
      }
    }
    return null;
  }

  String uppercaseFirstLetter(String str) {
    String temp = str.toLowerCase();
    return temp[0].toUpperCase() + temp.substring(1);
  }

  String getCardNumberName() {
    switch (documentType) {
      case 1:
        return "so can cuoc cong dan".tr + " *";
      case 2:
        return "so chung minh nhan dan".tr + " *";
      case 3:
        return "so ho chieu".tr + " *";
      default:
        return "so can cuoc cong dan".tr + " *";
    }
  }

  Future<void> setAllOriginAddressFromDocument({required String nationId}) async {
    List<TagModel> placeTypes = await getAllPlaceTypeByNationId(nationId);
    originPlaceTypeLevels.addAll(placeTypes);
    List<String> addressDocSplit = documentModel.originLocation.replaceAll("\n", ", ").split(",");
    addressDocSplit.removeWhere((element) => element.isEmpty);
    addressDocSplit = addressDocSplit.map((e) => e.trim()).toList().reversed.toList();
    dev.log(addressDocSplit.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

    /// set list address and set selected
    if (placeTypes.isNotEmpty) {
      dev.log("GETTING AND SETTING LEVEL 1", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel1 = await getListLocation(tagId: placeTypes[0].id, nationId: nationId);
      originAddressLevels1.addAll(placesLevel1);
      if (addressDocSplit.isNotEmpty) {
        PlaceModel? level1Selected = getPlaceInListPlace(addressDocSplit[0], placesLevel1);
        if (level1Selected != null) {
          originAddressLevels1Selected = level1Selected;
          originAddressIdSelected = level1Selected.id;
        }
      }
    }
    if (placeTypes.length > 1 && originAddressLevels1Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 2", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel2 = await getListLocation(
          tagId: placeTypes[1].id, nationId: nationId, parentId: originAddressLevels1Selected?.id);
      originAddressLevels2.addAll(placesLevel2);
      if (addressDocSplit.length > 1) {
        PlaceModel? level2Selected = getPlaceInListPlace(addressDocSplit[1], placesLevel2);
        if (level2Selected != null) {
          originAddressLevels2Selected = level2Selected;
          originAddressIdSelected = level2Selected.id;
        }
      }
    }
    if (placeTypes.length > 2 && originAddressLevels2Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 3", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel3 = await getListLocation(
          tagId: placeTypes[2].id, nationId: nationId, parentId: originAddressLevels2Selected?.id);
      originAddressLevels3.addAll(placesLevel3);
      if (addressDocSplit.length > 2) {
        PlaceModel? level3Selected = getPlaceInListPlace(addressDocSplit[2], placesLevel3);
        if (level3Selected != null) {
          originAddressLevels3Selected = level3Selected;
          originAddressIdSelected = level3Selected.id;
        }
      }
    }
    if (placeTypes.length > 3 && originAddressLevels3Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 4", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel4 = await getListLocation(
          tagId: placeTypes[3].id, nationId: nationId, parentId: originAddressLevels3Selected?.id);
      originAddressLevels4.addAll(placesLevel4);
      if (addressDocSplit.length > 3) {
        PlaceModel? level4Selected = getPlaceInListPlace(addressDocSplit[3], placesLevel4);
        if (level4Selected != null) {
          originAddressLevels4Selected = level4Selected;
          originAddressIdSelected = level4Selected.id;
        }
      }
    }

    /// fill detail to input text
    if (addressDocSplit.length > placeTypes.length) {
      int number = addressDocSplit.length - placeTypes.length;
      List<String> addressDocSublist = addressDocSplit.reversed.toList().sublist(0, number);
      originAddressDetailController.text = addressDocSublist.join(", ");
    }
  }

  Future<void> setAllRecentAddressFromDocument({required String nationId}) async {
    List<TagModel> placeTypes = await getAllPlaceTypeByNationId(nationId);
    recentPlaceTypeLevels.addAll(placeTypes);
    List<String> addressDocSplit = documentModel.recentLocation.replaceAll("\n", ", ").split(",");
    addressDocSplit.removeWhere((element) => element.isEmpty);
    addressDocSplit = addressDocSplit.map((e) => e.trim()).toList().reversed.toList();
    dev.log(addressDocSplit.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));

    /// set list address and set selected
    if (placeTypes.isNotEmpty) {
      dev.log("GETTING AND SETTING LEVEL 1", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel1 = await getListLocation(tagId: placeTypes[0].id, nationId: nationId);
      recentAddressLevels1.addAll(placesLevel1);
      if (addressDocSplit.isNotEmpty) {
        PlaceModel? level1Selected = getPlaceInListPlace(addressDocSplit[0], placesLevel1);
        if (level1Selected != null) {
          recentAddressLevels1Selected = level1Selected;
          recentAddressIdSelected = level1Selected.id;
        }
      }
    }
    if (placeTypes.length > 1 && recentAddressLevels1Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 2", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel2 = await getListLocation(
          tagId: placeTypes[1].id, nationId: nationId, parentId: recentAddressLevels1Selected?.id);
      recentAddressLevels2.addAll(placesLevel2);
      if (addressDocSplit.length > 1) {
        PlaceModel? level2Selected = getPlaceInListPlace(addressDocSplit[1], placesLevel2);
        if (level2Selected != null) {
          recentAddressLevels2Selected = level2Selected;
          recentAddressIdSelected = level2Selected.id;
        }
      }
    }
    if (placeTypes.length > 2 && recentAddressLevels2Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 3", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel3 = await getListLocation(
          tagId: placeTypes[2].id, nationId: nationId, parentId: recentAddressLevels2Selected?.id);
      recentAddressLevels3.addAll(placesLevel3);
      if (addressDocSplit.length > 2) {
        PlaceModel? level3Selected = getPlaceInListPlace(addressDocSplit[2], placesLevel3);
        if (level3Selected != null) {
          recentAddressLevels3Selected = level3Selected;
          recentAddressIdSelected = level3Selected.id;
        }
      }
    }
    if (placeTypes.length > 3 && recentAddressLevels3Selected != null) {
      dev.log("GETTING AND SETTING LEVEL 4", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      List<PlaceModel> placesLevel4 = await getListLocation(
          tagId: placeTypes[3].id, nationId: nationId, parentId: recentAddressLevels3Selected?.id);
      recentAddressLevels4.addAll(placesLevel4);
      if (addressDocSplit.length > 3) {
        PlaceModel? level4Selected = getPlaceInListPlace(addressDocSplit[3], placesLevel4);
        if (level4Selected != null) {
          recentAddressLevels4Selected = level4Selected;
          recentAddressIdSelected = level4Selected.id;
        }
      }
    }

    /// fill detail to input text
    if (addressDocSplit.length > placeTypes.length) {
      int number = addressDocSplit.length - placeTypes.length;
      List<String> addressDocSublist = addressDocSplit.reversed.toList().sublist(0, number);
      recentAddressDetailController.text = addressDocSublist.join(", ");
    }
  }

  Future<void> resetOriginAddress({int? level}) async {
    List<TagModel> tempPlaceTypes = List.from(originPlaceTypeLevels);
    if (level != null) {
      switch (level) {
        case 1:
          {
            originAddressLevels1.value = [];
            originAddressLevels2.value = [];
            originAddressLevels3.value = [];
            originAddressLevels4.value = [];
            originAddressLevels1Selected = null;
            originAddressLevels2Selected = null;
            originAddressLevels3Selected = null;
            originAddressLevels4Selected = null;
            originPlaceTypeLevels.value = [];
            await Future.delayed(const Duration(milliseconds: 50));
            originPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 2:
          {
            originAddressLevels2.value = [];
            originAddressLevels3.value = [];
            originAddressLevels4.value = [];
            originAddressLevels2Selected = null;
            originAddressLevels3Selected = null;
            originAddressLevels4Selected = null;
            originPlaceTypeLevels.value = originPlaceTypeLevels.sublist(0, 1);
            await Future.delayed(const Duration(milliseconds: 50));
            originPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 3:
          {
            originAddressLevels3.value = [];
            originAddressLevels4.value = [];
            originAddressLevels3Selected = null;
            originAddressLevels4Selected = null;
            originPlaceTypeLevels.value = originPlaceTypeLevels.sublist(0, 2);
            await Future.delayed(const Duration(milliseconds: 50));
            originPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 4:
          {
            originAddressLevels4.value = [];
            originAddressLevels4Selected = null;
            originPlaceTypeLevels.value = originPlaceTypeLevels.sublist(0, 3);
            await Future.delayed(const Duration(milliseconds: 50));
            originPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        default:
          break;
      }
    } else {
      originAddressLevels1.value = [];
      originAddressLevels2.value = [];
      originAddressLevels3.value = [];
      originAddressLevels4.value = [];
      originAddressLevels1Selected = null;
      originAddressLevels2Selected = null;
      originAddressLevels3Selected = null;
      originAddressLevels4Selected = null;
      originPlaceTypeLevels.value = [];
      await Future.delayed(const Duration(milliseconds: 50));
      originPlaceTypeLevels.value = tempPlaceTypes;
    }
  }

  Future<void> resetRecentAddress({int? level}) async {
    List<TagModel> tempPlaceTypes = List.from(recentPlaceTypeLevels);
    if (level != null) {
      switch (level) {
        case 1:
          {
            recentAddressLevels1.value = [];
            recentAddressLevels2.value = [];
            recentAddressLevels3.value = [];
            recentAddressLevels4.value = [];
            recentAddressLevels1Selected = null;
            recentAddressLevels2Selected = null;
            recentAddressLevels3Selected = null;
            recentAddressLevels4Selected = null;
            recentPlaceTypeLevels.value = [];
            await Future.delayed(const Duration(milliseconds: 50));
            recentPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 2:
          {
            recentAddressLevels2.value = [];
            recentAddressLevels3.value = [];
            recentAddressLevels4.value = [];
            recentAddressLevels2Selected = null;
            recentAddressLevels3Selected = null;
            recentAddressLevels4Selected = null;
            recentPlaceTypeLevels.value = recentPlaceTypeLevels.sublist(0, 1);
            await Future.delayed(const Duration(milliseconds: 50));
            recentPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 3:
          {
            recentAddressLevels3.value = [];
            recentAddressLevels4.value = [];
            recentAddressLevels3Selected = null;
            recentAddressLevels4Selected = null;
            recentPlaceTypeLevels.value = recentPlaceTypeLevels.sublist(0, 2);
            await Future.delayed(const Duration(milliseconds: 50));
            recentPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        case 4:
          {
            recentAddressLevels4.value = [];
            recentAddressLevels4Selected = null;
            recentPlaceTypeLevels.value = recentPlaceTypeLevels.sublist(0, 3);
            await Future.delayed(const Duration(milliseconds: 50));
            recentPlaceTypeLevels.value = tempPlaceTypes;
            break;
          }
        default:
          break;
      }
    } else {
      recentAddressLevels1.value = [];
      recentAddressLevels2.value = [];
      recentAddressLevels3.value = [];
      recentAddressLevels4.value = [];
      recentAddressLevels1Selected = null;
      recentAddressLevels2Selected = null;
      recentAddressLevels3Selected = null;
      recentAddressLevels4Selected = null;
      recentPlaceTypeLevels.value = [];
      await Future.delayed(const Duration(milliseconds: 50));
      recentPlaceTypeLevels.value = tempPlaceTypes;
    }
  }

// ================ ENDS MANUAL FUNCTIONS ===========
}
