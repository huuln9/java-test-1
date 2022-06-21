import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';
import 'package:vncitizens_notification/src/model/fcm_info_model.dart';
import 'package:vncitizens_notification/src/util/image_caching_util.dart';

import '../model/fcm_mark_update_model.dart';

class NotificationDetailController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFailedLoading = false.obs;
  Rx<FcmInfoModel> notification = FcmInfoModel().obs;

  Rxn<Uint8List> agencyIconBytes = Rxn<Uint8List>();
  RxList<Uint8List> thumbnailBytesList = RxList<Uint8List>();

  void init(String id) {
    _getFcmById(id);
    NotificationController notificationController = Get.find();
    notificationController.markFcmAsReadById(id);
  }

  void _getFcmById(String id) {
    try {
      isLoading(true);
      NotifyService().getFcmById(id).then((res) {
        FcmInfoModel fcm = FcmInfoModel.fromJson(res.body);
        notification.value = fcm;
        String agencyIconId = fcm.fromAgency!.logoId;
        if (agencyIconId.isNotEmpty) {
          () async {
            await _getIcon(agencyIconId);
          }.call();
        } else {
          ImageCachingUtil.delete(agencyIconId);
        }
        thumbnailBytesList.value = [];
        if (fcm.attachment != null) {
          for (var element in fcm.attachment!) {
            if (element.id.isNotEmpty) {
              () async {
                await _getImages(element.id);
              }.call();
            } else {
              ImageCachingUtil.delete(element.id);
            }
          }
        }
        isLoading(false);
        isFailedLoading(false);
      }, onError: (err) {
        isLoading(false);
        isFailedLoading(true);
      });
    } catch (ex) {
      isLoading(false);
      isFailedLoading(true);
    }
  }

  Future<void> _getIcon(String iconId) async {
    Uint8List? icon = await ImageCachingUtil.get(iconId);
    if (icon != null) {
      log("Load icon from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      agencyIconBytes.value = icon;
    } else {
      log("Load icon from minio",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      Response responseFile = await StorageService().getFileDetail(id: iconId);
      log(responseFile.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(responseFile.body.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
        File file =
            await MinioService().getFile(minioPath: responseFile.body["path"]);
        agencyIconBytes.value = await file.readAsBytes();
        ImageCachingUtil.set(iconId, agencyIconBytes.value as Uint8List);
      }
    }
  }

  Future<void> _getImages(String imageId) async {
    Uint8List? image = await ImageCachingUtil.get(imageId);
    if (image != null) {
      log("Load image from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      thumbnailBytesList.add(image);
    } else {
      log("Load image from minio",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      Response responseFile = await StorageService().getFileDetail(id: imageId);
      log(responseFile.statusCode.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      log(responseFile.body.toString(),
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
        File file =
            await MinioService().getFile(minioPath: responseFile.body["path"]);
        Uint8List thumbnailBytes = await file.readAsBytes();
        thumbnailBytesList.add(thumbnailBytes);
        ImageCachingUtil.set(imageId, thumbnailBytes);
      }
    }
  }

  void markFcmAsDeleteById() async {
    try {
      NotificationController notificationController = Get.find();
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data = FcmMarkUpdateModel(
          viewer: userId!, fcmId: [notificationController.id.value]);
      await NotifyService().markFcmAsDelete(data.toJson()).then((res) {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          notificationController.updateFcmAsDeleteByIndex();
          Get.snackbar('', '',
              titleText: const SizedBox(height: 0),
              messageText: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: Text('xoa thong bao thanh cong'.tr,
                    style: const TextStyle(color: Colors.white)),
              ),
              colorText: Colors.white,
              shouldIconPulse: true,
              barBlur: 20,
              isDismissible: true,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
              borderRadius: 2,
              margin: const EdgeInsets.all(16),
              mainButton: TextButton(
                  onPressed: () {
                    Get.closeCurrentSnackbar();
                  },
                  child: Text('dong'.tr.toUpperCase())));
          Get.offAllNamed('/vncitizens_notification');
        } else {
          Get.snackbar('', '',
              titleText: const SizedBox(height: 0),
              messageText: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                child: Text('xoa thong bao that bai'.tr,
                    style: const TextStyle(color: Colors.white)),
              ),
              colorText: Colors.white,
              shouldIconPulse: true,
              barBlur: 20,
              isDismissible: true,
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
              borderRadius: 2,
              margin: const EdgeInsets.all(16),
              mainButton: TextButton(
                  onPressed: () {
                    Get.closeCurrentSnackbar();
                  },
                  child: Text('dong'.tr.toUpperCase())));
          Get.back();
        }
      }, onError: (err) {
        log("Mark as delete notification is fail", name: AppConfig.packageName);
      });
    } catch (ex) {
      log("Mark as delete notification is fail", name: AppConfig.packageName);
    }
  }
}
