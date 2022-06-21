import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/model/fcm_page_model.dart';
import 'package:vncitizens_notification/src/model/notification_selector_model.dart';
import 'package:vncitizens_notification/src/model/place_model.dart';
import 'package:vncitizens_notification/src/util/image_caching_util.dart';

import '../model/fcm_content_model.dart';
import '../model/fcm_mark_update_model.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFailedLoading = false.obs;
  RxBool isWaiting = false.obs;
  RxList<NotificationSelectorModel> notifications =
      <NotificationSelectorModel>[].obs;
  RxString id = ''.obs;
  RxInt index = 0.obs;
  int _page = 0;
  final int _size = 15;

  ScrollController scrollController = ScrollController();
  RxBool isMoreDataAvailable = false.obs;
  RxBool isLast = false.obs;

  RxBool isSelectedMode = false.obs;
  RxBool isSelectedAll = false.obs;
  RxSet<String> fcmId = <String>{}.obs;

  RxMap<String, Uint8List> iconBytesList = <String, Uint8List>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await init();
    log("INIT NOTIFICATION CONTROLLER", name: AppConfig.packageName);
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> init() async {
    await _getUnreadNumber();
    await getFcmByReceiver();
    await _initPagination();
  }

  Future<void> _getUnreadNumber() async {
    NotificationCounterController c = Get.put(NotificationCounterController());
    String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
    NotifyService()
        .getUnreadNumber(
      userId!,
      getTopics(),
    )
        .then((res) {
      if (res.body != null) {
        c.num.value = res.body as int;
        log('notification counter ' + c.num.value.toString(),
            name: AppConfig.packageName);
      }
    }, onError: (err) {
      c.num.value = 0;
    }).catchError((onError) {
      c.num.value = 0;
    });
  }

  Future<void> getFcmByReceiver() async {
    try {
      isLoading(true);
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      NotifyService().getFcmByReceiver(userId!, getTopics(), _page, _size).then(
          (res) {
        FcmPageModel page = FcmPageModel.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          FcmContentModel element = page.content[i];
          notifications
              .add(NotificationSelectorModel(data: element, isSelected: false));
          if (element.fromAgency.logoId.isNotEmpty) {
            () async {
              await _getIcons(element.id, element.fromAgency.logoId);
            }.call();
          } else {
            ImageCachingUtil.delete(element.fromAgency.logoId);
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

  Future<void> _initPagination() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isSelectedMode.value && !isLast.value) {
          _page++;
          _getMoreFcmByReceiver();
        } else {
          log("Last page notification: " + _page.toString(),
              name: AppConfig.packageName);
        }
      }
    });
  }

  Future<void> _getMoreFcmByReceiver() async {
    try {
      isMoreDataAvailable(true);
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      NotifyService()
          .getFcmByReceiver(userId!, getTopics(), _page, _size)
          .then((res) {
        FcmPageModel page = FcmPageModel.fromJson(res.body);
        for (var i = 0; i < page.numberOfElements; ++i) {
          FcmContentModel element = page.content[i];
          notifications
              .add(NotificationSelectorModel(data: element, isSelected: false));
          if (element.fromAgency.logoId.isNotEmpty) {
            () async {
              await _getIcons(element.id, element.fromAgency.logoId);
            }.call();
          } else {
            ImageCachingUtil.delete(element.fromAgency.logoId);
          }
        }
        isLast(page.last);
        isMoreDataAvailable(false);
        isFailedLoading(false);
      });
    } catch (ex) {
      isMoreDataAvailable(false);
      isFailedLoading(true);
    }
  }

  Future<void> refreshFcmList() async {
    notifications.value = [];
    isLast(false);
    _page = 0;
    await getFcmByReceiver();
  }

  void changeSelectedMode() {
    isSelectedMode(!isSelectedMode.value);
    if (isSelectedMode.value == false) {
      id = ''.obs;
      index = 0.obs;
      for (var element in notifications) {
        element.isSelected = false;
      }
    }
  }

  void selectAll() {
    for (var notification in notifications) {
      notification.isSelected = true;
      fcmId.add(notification.data.id);
    }
    isSelectedAll(true);
    notifications.refresh();
  }

  void unselectAll() {
    for (var notification in notifications) {
      notification.isSelected = false;
    }
    fcmId.value = {};
    isSelectedAll(false);
    notifications.refresh();
  }

  void toggle(int index) {
    notifications[index].isSelected = !notifications[index].isSelected;
    if (!notifications[index].isSelected) {
      isSelectedAll(false);
      fcmId.remove(notifications[index].data.id);
    } else {
      fcmId.add(notifications[index].data.id);
      bool temp = true;
      for (NotificationSelectorModel notification in notifications) {
        if (!notification.isSelected) {
          temp = false;
          break;
        }
      }
      isSelectedAll(temp);
    }
    notifications.refresh();
  }

  int getSelectedNum() {
    int _selectedNum = 0;
    for (var notification in notifications) {
      if (notification.isSelected) {
        _selectedNum++;
      }
    }
    return _selectedNum;
  }

  void _updateNotificationCounter(int counter) {
    NotificationCounterController c = Get.find();
    c.num.value -= counter;
  }

  void markFcmAsRead() async {
    try {
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data =
          FcmMarkUpdateModel(viewer: userId!, fcmId: fcmId.toList());
      await NotifyService().markFcmAsRead(data.toJson()).then((res) {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          _updateFcmAsRead();
        }
      }, onError: (err) {
        log("Update notification fail");
      });
    } catch (ex) {
      log("Update notification fail");
    }
  }

  void _updateFcmAsRead() {
    for (var element in notifications) {
      if (fcmId.contains(element.data.id) && element.data.fcmViewer.read != 1) {
        element.data.fcmViewer.read = 1;
        _updateNotificationCounter(1);
      }
    }
    fcmId.value = <String>{};
    notifications.refresh();
  }

  void markFcmAsReadAll() async {
    try {
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data =
          FcmMarkUpdateModel(viewer: userId!, markAll: true);
      await NotifyService().markFcmAsRead(data.toJson()).then((res) {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          _updateFcmAsReadAll();
        }
      }, onError: (err) {
        log("Update notification fail");
      });
    } catch (ex) {
      log("Update notification fail");
    }
  }

  void _updateFcmAsReadAll() {
    for (var element in notifications) {
      if (element.data.fcmViewer.read != 1) {
        element.data.fcmViewer.read = 1;
        _updateNotificationCounter(1);
      }
    }
    fcmId.value = {};
    notifications.refresh();
  }

  void markFcmAsReadById(String id) async {
    if (notifications[index.value].data.fcmViewer.read == 0) {
      try {
        String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
        FcmMarkUpdateModel data =
            FcmMarkUpdateModel(viewer: userId!, fcmId: [id]);
        await NotifyService().markFcmAsRead(data.toJson()).then((res) {
          AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
          log(affectedRows.toString(), name: AppConfig.packageName);
          if (affectedRows.affectedRows > 0) {
            _updateFcmAsReadByIndex();
          }
        }, onError: (err) {
          log("Mark as read notification is fail", name: AppConfig.packageName);
        });
      } catch (ex) {
        log("Mark as read notification is fail", name: AppConfig.packageName);
      }
    }
  }

  void _updateFcmAsReadByIndex() {
    notifications[index.value].data.fcmViewer.read = 1;
    _updateNotificationCounter(1);
    notifications.refresh();
  }

  void markFcmAsDelete() async {
    try {
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data =
          FcmMarkUpdateModel(viewer: userId!, fcmId: fcmId.toList());
      await NotifyService().markFcmAsDelete(data.toJson()).then((res) async {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          await _updateFcmAsDelete();
        }
      }, onError: (err) {
        log("Update notification fail");
      });
    } catch (ex) {
      log("Update notification fail");
    }
  }

  Future<void> _updateFcmAsDelete() async {
    fcmId.value = {};
    await refreshFcmList();
  }

  void markFcmAsDeleteAll() async {
    try {
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data =
          FcmMarkUpdateModel(viewer: userId!, markAll: true);
      await NotifyService().markFcmAsDelete(data.toJson()).then((res) {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          _updateFcmAsDeleteAll();
        }
      }, onError: (err) {
        log("Update notification fail");
      });
    } catch (ex) {
      log("Update notification fail");
    }
  }

  void _updateFcmAsDeleteAll() {
    for (var element in notifications) {
      if (element.data.fcmViewer.read == 0) {
        _updateNotificationCounter(1);
      }
    }
    fcmId.value = {};
    notifications.value = [];
    notifications.refresh();
  }

  void markFcmAsDeleteById() async {
    try {
      String? userId = AuthUtil.userId ?? await PlatformDeviceId.getDeviceId;
      FcmMarkUpdateModel data =
          FcmMarkUpdateModel(viewer: userId!, fcmId: [id.value]);
      await NotifyService().markFcmAsDelete(data.toJson()).then((res) {
        AffectedRowModel affectedRows = AffectedRowModel.fromJson(res.body);
        if (affectedRows.affectedRows > 0) {
          updateFcmAsDeleteByIndex();
        }
      }, onError: (err) {
        log("Mark as delete notification is fail", name: AppConfig.packageName);
      });
    } catch (ex) {
      log("Mark as delete notification is fail", name: AppConfig.packageName);
    }
  }

  void updateFcmAsDeleteByIndex() {
    if (notifications[index.value].data.fcmViewer.read == 0) {
      _updateNotificationCounter(1);
    }
    notifications.removeAt(index.value);
    notifications.refresh();
  }

  Future<void> _getIcons(String fcmId, String iconId) async {
    Uint8List? icon = await ImageCachingUtil.get(iconId);
    if (icon != null) {
      log("Load icon from local",
          name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      iconBytesList[fcmId] = icon;
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
        Uint8List iconBytes = await file.readAsBytes();
        iconBytesList[fcmId] = iconBytes;
        ImageCachingUtil.set(iconId, iconBytes);
      }
    }
  }

  bool showMarkFcmAsReadBtn() {
    bool show = false;
    for (var notification in notifications) {
      if (notification.data.fcmViewer.read == 0) {
        show = true;
      }
    }
    return show;
  }

  List<String> getTopics() {
    List<String> topics = [...AppConfig.fcmTopics];

    if (AuthUtil.userId != null && AuthUtil.userId != '') {
      topics = [...topics, AuthUtil.userId!];
    }

    if (AuthUtil.placeId != null && AuthUtil.placeId != '') {
      topics = [...topics, AuthUtil.placeId!];
    }

    try {
      if (GetStorage(AppConfig.storageBox)
              .read(AppConfig.placeDetailResStorageKey) !=
          null) {
        PlaceModel place = PlaceModel.fromJson(GetStorage(AppConfig.storageBox)
            .read(AppConfig.placeDetailResStorageKey));
        for (var item in place.ancestors) {
          topics = [...topics, item.id];
        }
      }
    } catch (exc) {}

    return topics;
  }
}
