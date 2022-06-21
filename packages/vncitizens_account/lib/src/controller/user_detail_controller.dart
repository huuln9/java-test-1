import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_account/src/config/account_route_config.dart';
import 'package:vncitizens_account/src/model/place_model.dart';
import 'package:vncitizens_account/src/model/user_address_model.dart';
import 'package:vncitizens_common/dio.dart' as dio;
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_account/src/model/document_model.dart';
import 'package:vncitizens_account/src/model/user_document_model.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/util/AuthUtil.dart';
import 'package:vncitizens_account/src/widget/avatar_preview.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';

import '../config/account_app_config.dart';
import '../config/constant.dart' as constant;

class UserDetailController extends GetxController {
  RxString phoneNumber = "".obs;
  RxString email = "".obs;
  RxString currentAddress = "".obs;
  RxString shortName = "".obs;
  RxString fullName = "".obs;
  List<String> usernames = [];
  List<String> phoneNumbers = [];
  UserDocumentModel? identity;
  UserDocumentModel? citizenIdentity;
  UserDocumentModel? passport;
  RxBool hasDocument = false.obs;
  Map<String, dynamic> userInfo = {};

  late GalleryController galleryController;
  Rxn<Uint8List> avatarBytes = Rxn<Uint8List>();

  RxInt radioGroupValue = 1.obs;
  RxString exampleImageSrc = "${AccountAppConfig.assetsRoot}/images/cccd.jpg".obs;
  RxString documentType = "CCCD".obs;

  static const MethodChannel platform = MethodChannel("vnptit/si/biosdk");
  Map twoSideDocumentResult = {};

  RxBool loading = false.obs;

  UserFullyModel? userFullyModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initGalleryController();
    getUserInfo();
  }

  void initGalleryController() {
    galleryController = GalleryController(
      gallerySetting: const GallerySetting(
        enableCamera: true,
        requestType: RequestType.image,
        crossAxisCount: 3,
      ),
    );
  }

  Future<void> getUserInfo() async {
    Response response = await AuthService().getUserFully(AuthUtil.userId as String);
    log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      /// convert to model
      try {
          userFullyModel = UserFullyModel.fromJson(response.body);
      } catch (error) {
        log("Cannot convert to model", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
      shortName.value = getShortStringFromName();
      phoneNumber.value =
      response.body["phoneNumber"] == null || response.body["phoneNumber"].length == 0 ? "" : response.body["phoneNumber"][0]["value"];
      email.value = response.body["email"] == null || response.body["email"].length == 0 ? "" : response.body["email"][0]["value"];
      fullName.value = response.body["fullname"] ?? "";

      /// usernames
      List<dynamic> resUsernames = response.body["account"]["username"];
      for (var element in resUsernames) {
        if (element["value"] != null) {
          usernames.add(element["value"]);
        }
      }

      /// phone numbers
      List<dynamic> resPhones = response.body["phoneNumber"] ?? [];
      for (var element in resPhones) {
        if (element["value"] != null) {
          phoneNumbers.add(element["value"]);
        }
      }

      /// identity
      if (response.body["identity"] != null && response.body["identity"]["number"] != null) {
        identity = UserDocumentModel.fromJson(response.body["identity"]);
        hasDocument.value = true;
      }

      /// citizenIdentity
      if (response.body["citizenIdentity"] != null && response.body["citizenIdentity"]["number"] != null) {
        citizenIdentity = UserDocumentModel.fromJson(response.body["citizenIdentity"]);
        hasDocument.value = true;
      }

      /// passport
      if (response.body["passport"] != null && response.body["passport"]["number"] != null) {
        passport = UserDocumentModel.fromJson(response.body["passport"]);
        hasDocument.value = true;
      }

      /// user info
      userInfo = response.body;

      /// set avatar
      if (response.body["avatarId"] != null) {
            () async {
          Uint8List? localAvatar = await AuthUtil.getAvatar();
          if (localAvatar != null) {
            log("Load avatar from local", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            avatarBytes.value = localAvatar;
          }  else {
            log("Load avatar from minio", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            Response responseFile = await StorageService().getFileDetail(id: response.body["avatarId"]);
            log(responseFile.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            log(responseFile.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
              File file = await MinioService().getFile(minioPath: responseFile.body["path"]);
              avatarBytes.value = await file.readAsBytes();
              AuthUtil.setAvatar(avatarBytes.value as Uint8List);
            }
          }
        }.call();
      } else {
        AuthUtil.deleteAvatar();
      }

      /// set current address
      try {
          if (response.body["address"] != null) {
            final curAddress = UserAddressModel.fromListJson(response.body["address"]).firstWhereOrNull((element) => element.type == 4);
            if (curAddress != null) {
              (() async {
                Response response = await LocationService().getPlaceById(id: curAddress.placeId);
                log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
                if (response.statusCode == 200) {
                  final tmpPlace = PlaceModel.fromMap(response.body);
                  currentAddress.value = (curAddress.address.isEmpty ? "" : curAddress.address + ", ") + (tmpPlace.name + ", ") + (tmpPlace.fullPlace ?? "");
                }
              }).call();
            }
          }
      } catch (error) {
        // do nothing
        log("Cannot get current address", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    } else {
      log("Get user failed", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    }
  }

  String getShortStringFromName() {
    final engStr = nonAccentVietnamese(AuthUtil.fullName ?? "");
    log(engStr, name: AccountAppConfig.packageName);
    List<String> names = engStr.split(" ");
    String initials = "";
    if (names.length > 1) {
      for (var i = names.length - 2; i < names.length; i++) {
        initials += names[i][0];
      }
    } else {
      initials += names[0][0] + names[0][1];
    }
    log(initials.toUpperCase(), name: AccountAppConfig.packageName + " SHORT");
    return initials.toUpperCase();
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

  Future<Map> openFaceOval() async {
    Map map = {};
    try {
      Map result = await platform.invokeMethod('openFaceAdvanceOval', map);
      log(result.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return result;
    } catch (error) {
      log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      rethrow;
    }
  }

  Future<Map> openTwoSide() async {
    Map map = {};
    try {
      Map result = await platform.invokeMethod('openTwoSide', map);
      log(result.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      return result;
    } catch (error) {
      log(error.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      rethrow;
    }
  }

  Future<DocumentModel> getDocumentInfoFromBioId(Map info) async {
    String cropParam = info["CROP_PARAMS"];
    final frontFileByteArr = info["BIT_MAP_FRONT"];
    final backFileByteArr = info["BIT_MAP_BACK"];
    log("CROP_PARAMS: " + cropParam, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    dio.Response response = await BioIdService().getInfoDocumentFromImage(
      cropParam: cropParam,
      frontSide: frontFileByteArr,
      backSide: backFileByteArr,
      type: [1, 2].contains(radioGroupValue.value) ? "-1" : "5",
    );
    log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return DocumentModel.fromMap(response.data["content"]);
    } else {
      throw "Get document information failed";
    }
  }

  Future<void> confirmFaceWithDocument(Map info, String facePath) async {
    loading.value = true;
    dio.Response response = await BioIdService().confirmFaceWithDocument(frontSide: info["BIT_MAP_FRONT"], faceFilePath: facePath);
    log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200 && response.data["status"] == "SUCCESS" && response.data["matching"] > 86) {
      DocumentModel documentModel = await getDocumentInfoFromBioId(info);
      loading.value = false;
      Get.toNamed(AccountRouteConfig.documentRoute, arguments: [
        radioGroupValue.value,
        documentModel,
            () {
          setPlatformMethodCallback();
          openTwoSide();
        },
        UserFullyModel.fromJson(userInfo),
        facePath,
        info["FRONT_CROP_BITMAP"],
        info["BACK_CROP_BITMAP"]
      ]);
    } else {
      loading.value = false;
      Get.dialog(
          ErrorDialog(
            callback: () {},
            message: "xac thuc khuon mat that bai".tr,
          ),
          barrierDismissible: false);
    }
  }

  void setPlatformMethodCallback() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "captureDone") {
        log("captureDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureError") {
        log("captureError", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "captureCancel") {
        log("captureCancel", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      } else if (call.method == "processImageDone") {
        log("processImageDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        twoSideDocumentResult = call.arguments;
        openFaceOval();
      } else if (call.method == "processOvalFaceDone") {
        log("processOvalFaceDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (Platform.isAndroid) {
          confirmFaceWithDocument(twoSideDocumentResult, call.arguments["FAR_PATH"]);
        } else if (Platform.isIOS) {
          try {
            final oid = ObjectId();
            final tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/${oid.hexString}.jpg').create();
            file.writeAsBytesSync(call.arguments["FAR_PATH"]);
            confirmFaceWithDocument(twoSideDocumentResult, file.path);
          } catch (error) {
            log(error.toString());
          }
        }
      } else if (call.method == "processImageException") {
        log("processImageException", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
  }

  void onChangeRadioButton(int value) {
    log("value: " + value.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    switch (value) {
      case 1:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cccd.jpg";
        documentType.value = "CCCD";
        break;
      case 2:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cmnd.jpg";
        documentType.value = "CMND";
        break;
      case 3:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/passport.jpg";
        documentType.value = "ho chieu".tr;
        break;
      default:
        exampleImageSrc.value = "${AccountAppConfig.assetsRoot}/images/cccd.jpg";
        documentType.value = "CCCD";
        break;
    }
    log("exampleImageSrc: " + exampleImageSrc.value, name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    radioGroupValue.value = value;
  }

  void onClickNextButton() {
    Get.back();
    if (AccountAppConfig.isIntegratedEKYC == true) {
      setPlatformMethodCallback();
      openTwoSide();
    } else {
      Get.toNamed(AccountRouteConfig.updateDocumentRoute, arguments: [radioGroupValue.value, UserFullyModel.fromJson(userInfo), null]);
    }
    // Get.toNamed(AccountAppConfig.documentRoute, arguments: [
    //   radioGroupValue.value,
    //   DocumentModel.fromMap(constant.TEMP_DOCUMENT_CCCD),
    //       () {
    //     setPlatformMethodCallback();
    //     openTwoSide();
    //   },
    //   UserFullyModel.fromJson(userInfo),
    //   null,
    //   Uint8List(0),
    //   Uint8List(0)
    // ]);
  }

  Future<void> onTapAvatar(BuildContext context, {bool? changeAvatar}) async {
    if (avatarBytes.value == null || changeAvatar == true) {
      List<DrishyaEntity> entities = await galleryController.pick(context).whenComplete(() => initGalleryController());
      if (entities.isNotEmpty) {
        File? tmpFile = await entities[0].entity.file;
        ImageCropper imageCropper = ImageCropper();
        File? file = await imageCropper.cropImage(
          sourcePath: tmpFile != null ? tmpFile.path : entities[0].file.path,
          cropStyle: CropStyle.circle,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              showCropGrid: false,
              cropFrameColor: Colors.transparent,
              toolbarTitle: "chon vung anh dai dien".tr,
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Colors.black,
              hideBottomControls: true
          ),
        );
        if (file != null) {
          Uint8List bytes = await file.readAsBytes();
          avatarBytes.value = bytes;
          String? minioFilePath = await MinioService().uploadWithPath(filePath: file.path);
          if (minioFilePath != null) {
            /// save file info to svc-storage
            int fileSize = await file.length();
            Response response = await StorageService().saveMinioFileInfo(userId: userInfo["id"], path: minioFilePath, size: fileSize);
            log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            log(response.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
            if (response.statusCode == 200 && response.body["id"] != null) {
              /// update avatar in svc-auth
              Response response1 = await AuthService().updateAvatar(userId: userInfo["id"], avatarId: response.body["id"]);
              log(response1.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              log(response1.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              if (response1.statusCode == 200) {
                AuthUtil.setAvatar(bytes);
                log("Save avatar to hive !!!", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
              }
            }
          } else {
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: "Khong the tai anh len".tr,
                ),
                barrierDismissible: false);
          }
        }
      }
    } else {
      Get.to(() => AvatarPreview(bytes: avatarBytes.value as Uint8List));
    }
  }

  void onTapDocument(int type) {
    Get.toNamed(AccountRouteConfig.updateDocumentRoute, arguments: [
      type,
      UserFullyModel.fromJson(userInfo),
          () {
        setPlatformMethodCallback();
        openTwoSide();
      }
    ]);
  }

  void setRadioGroupValue(int value) {
    radioGroupValue.value = value;
  }

  void logout() {
    VCallUtil.unRegisterDevice();
    if (phoneNumbers.isNotEmpty) {
      AuthUtil.setUsername(getPhoneNumberInUsernames());
    }
    AuthUtil.removeAuth().then((value) {
      if (AccountAppConfig.appRequireLogin == true) {
        Get.offAllNamed(AccountRouteConfig.loginAppRoute);
      } else {
        Get.offAllNamed("/vncitizens_home");
      }
      log(AuthUtil.getAllHiveKeys().toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    });
  }

  String getPhoneNumberInUsernames() {
    for (var username in usernames) {
      for (var phone in phoneNumbers) {
        if (phone.replaceAll("+84", "0") == username) {
          return username;
        }
        if (phone == username) {
          return phone;
        }
      }}
    return phoneNumbers[0];
  }
}
