import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_account/src/widget/error_dialog_two.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_account/src/model/user_fully_model.dart';
import 'package:vncitizens_account/src/widget/error_dialog.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/dio.dart' as dio;

class FaceUsernameController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  RxBool status = true.obs;
  RxBool enableLoginButton = false.obs;
  RxnString notifyMessage = RxnString();
  String? personId;
  RxBool loading = false.obs;
  bool initApp = false;

  static const platform = MethodChannel("vnptit/si/biosdk");

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null && Get.arguments[0] is bool) {
      initApp = Get.arguments[0];
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void checkEnableLoginButton() {
    if (emailController.text.isNotEmpty) {
      enableLoginButton.value = true;
    } else {
      enableLoginButton.value = false;
    }
  }

  void setStatus(bool value) {
    status.value = value;
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
      } else if (call.method == "processOvalFaceDone") {
        log("processOvalFaceDone", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (Platform.isAndroid) {
          confirmFace(call.arguments["FAR_PATH"]);
        } else if (Platform.isIOS) {
          final oid = ObjectId();
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/${oid.hexString}.jpg').create();
          file.writeAsBytesSync(call.arguments["FAR_PATH"]);
          confirmFace(file.path);
        }
      } else if (call.method == "processImageException") {
        log("processImageException", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      }
    });
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

  Future<void> confirmFace(String facePath) async {
    loading.value = true;
    try {
      /// check liveness face
      log("Checking liveness", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      dio.Response response = await BioIdService().checkLiveness(faceFilePath: facePath);
      log(response.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (response.statusCode == 200 && (response.data["liveness"] == "true" || response.data["liveness"] == true)) {
        if (personId == null) {
          loading.value = false;
          Get.dialog(
              ErrorDialog(callback: () {}, message: "khong tim thay FaceID".tr,),
              barrierDismissible: false);
          return;
        }
        /// confirm login using face id
        dio.Response response1 = await BioIdService().confirmFaceFromFilePath(personId: personId as String, faceFilePath: facePath);
        log(response1.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        log(response1.data.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        if (response1.statusCode == 200 && response1.data["matching"] > 90) {
          /// reset avatar
          await AuthUtil.deleteAvatar();
          /// set hive
          Response response2 = await AuthService().getUserFullyByUsername(emailController.text);
          log(response2.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          log(response2.body.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          UserFullyModel userFullyModel = UserFullyModel.fromJsonWithUsername(response2.body, emailController.text);
          if (response2.statusCode == 200) {
            await AuthUtil.setHiveUserInfoFromModel(userFullyModel);
          }  else {
            loading.value = false;
            Get.dialog(
                ErrorDialog(
                  callback: () {},
                  message: "da xay ra loi".tr,
                ),
                barrierDismissible: false);
            return;
          }
          loading.value = false;
          /// register device
          VCallUtil.registerDevice(userFullyModel.phoneNumber[0].value);
          /// back to home
          Get.offAllNamed("/vncitizens_home");
        } else {
          loading.value = false;
          Get.dialog(
              ErrorDialogTwo(
                onClose: () => FocusManager.instance.primaryFocus?.unfocus(),
                onRetry: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  submit();
                },
                message: "khuon mat khong khop".tr,
              ),
              barrierDismissible: false);
        }
      } else {
        loading.value = false;
        if (response.data["message"] != null) {
          Get.dialog(
              ErrorDialog(callback: () {}, message: response.data["message"],),
              barrierDismissible: false);
          return;
        }
        Get.dialog(
            ErrorDialog(callback: () {}, message: "da xay ra loi".tr,),
            barrierDismissible: false);
        return;
      }
    } catch (error) {
      loading.value = false;
      Get.dialog(
          ErrorDialog(callback: () {}, message: "da xay ra loi".tr,),
          barrierDismissible: false);
      return;
    }
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    Response response = await AuthService().getUserFullyByUsername(emailController.text);
    if (response.statusCode == 200) {
      if (response.body["vnptBioId"] == null) {
        status.value = false;
        notifyMessage.value = "ban chua dang ky xac thuc bang khuon mat".tr;
        return;
      } else {
        if (response.body["vnptBioId"]["enableFaceLogin"] != 1) {
          status.value = false;
          notifyMessage.value = "tai khoan cua ban da tat tinh nang dang nhap bang khuon mat".tr;
          return;
        }
        personId = response.body["vnptBioId"]["personId"].toString();
        setPlatformMethodCallback();
        openFaceOval();
      }
    } else {
      status.value = false;
      notifyMessage.value = "thong tin dang nhap chua dung!".tr;
    }
  }
}
