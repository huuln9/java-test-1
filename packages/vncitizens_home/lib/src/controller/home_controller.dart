import 'dart:developer' as dev;
import 'dart:typed_data';

import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_home/src/config/home_app_config.dart';
import 'package:vncitizens_home/src/model/app_info_model.dart';
import 'package:vncitizens_home/src/model/group_menu_model.dart';
import 'package:vncitizens_home/src/model/menu_model.dart';
import 'package:vncitizens_home/src/util/lunar_calendar_converter.dart';
import 'package:vncitizens_home/src/util/storage_util.dart';
import 'package:vncitizens_payment/vncitizens_payment.dart';
import 'package:vncitizens_petition/vncitizens_petition.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_setting/vncitizens_setting.dart' show SettingController;

class HomeController extends GetxController {
  RxString celsiusStr = "".obs;
  RxString locationName = "".obs;
  List<GroupMenuModel> menuData = HomeAppConfig.menuData;
  RxString currentALStr = "".obs;
  RxList<String> bannerImages = <String>[].obs;
  RxBool showUpdateDialog = false.obs;
  RxBool updateRequired = false.obs;
  late bool updateDialogShowed;
  RxString uuid = "".obs;

  Uint8List? avatarBytes;

  @override
  void onInit() {
    super.onInit();
    updateDialogShowed = StorageUtil.readShowedUpdate();
    checkUserLoggedIn();
    currentALStr.value = getCurrentDateALStr();
    bannerImages.value = getBannerImages();
    checkAppInfoFromRemote();
    getWeatherCurrentLocation().then((map) {
      celsiusStr.value = map["forecast"]["current"]["main"]["temperature"]["value"].toString();
      locationName.value = map["city"]["name"];
      // celsiusStr.value = weather.temperature?.celsius?.floor().toString() as String;
      // locationName.value = weather.areaName as String;
    });
    initAvatar();
  }

  Future<void> onTapUpdate() async {
    if (!updateRequired.value) {
      Get.back();
    }
    SettingController().getAppUpdate();
  }

  void initAvatar() {
    AuthUtil.getAvatar().then((bytes) {
      if (bytes != null) {
        dev.log("Set avatar from local", name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        avatarBytes = bytes;
        update();
      } else {
        if (checkUserLoggedIn() && AuthUtil.userId != null) {
          AuthService().getUserFully(AuthUtil.userId as String).then((response) {
            if (response.statusCode == 200 && response.body["avatarId"] != null) {
              StorageService().getFileDetail(id: response.body["avatarId"]).then((responseFile) {
                if (responseFile.statusCode == 200 && responseFile.body["path"] != null) {
                  MinioService().getFile(minioPath: responseFile.body["path"]).then((file) {
                    file.readAsBytes().then((value) {
                      avatarBytes = value;
                      AuthUtil.setAvatar(avatarBytes as Uint8List);
                      update();
                    });
                  });
                }
              });
            }
          });
        } else {
          avatarBytes = null;
          update();
        }
      }
    });
  }

  Future<void> onTapAvatar() async {
    Get.toNamed("/vncitizens_account/user_detail")?.then((value) {
      dev.log(value.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
      if (value != null) {
        initAvatar();
      }
    });
  }
  
  bool checkUserLoggedIn() {
    return AuthUtil.isLoggedIn == true;
  }

  String getShortStringFromName() {
    final fullName = AuthUtil.fullName;
    final engStr = nonAccentVietnamese(fullName ?? "");
    List<String> names = engStr.split(" ");
    String initials = "";
    if (names.length > 1) {
      for(var i = names.length - 2; i < names.length; i++){
        initials += names[i][0];
      }
    }  else {
      initials += names[0][0] + names[0][1];
    }
    return initials.toUpperCase();
  }

  String nonAccentVietnamese(String str) {
    const  _vietnamese = 'aAeEoOuUiIdDyY';
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

  setUpdateDialogShowed(bool value) {
    updateDialogShowed = value;
    StorageUtil.writeShowedUpdate(value);
  }

  List<String> getBannerImages() {
    Map<String, dynamic> banner = GetStorage(HomeAppConfig.storageBox).read(HomeAppConfig.bannerStorageKey);
    List<String> images = <String>[];
    for (var image in banner["images"]) {
      images.add(image as String);
    }
    return images;
  }

  /// Callback will be call if menu has child
  onTapMenu(MenuModel menuModel, {Function? callbackSubmenu, Function? callbackLogin}) {
    if (menuModel.requiredLogin != null && menuModel.requiredLogin == true && callbackLogin != null && !checkUserLoggedIn()) {
      callbackLogin();
      return;
    }
    if (menuModel.route != null) {
      if (PaymentRouteConstant.paymentRoutes.contains(menuModel.route)) {
        PaymentCallbackUtil.callPaymentServiceByRoute(menuModel.route!);
        return;
      }  
      if (menuModel.route == "/vncitizens_petition") {
        VCallUtil.createVCall();
        return;
      }
      Get.toNamed(menuModel.route!, parameters: { "title": menuModel.name.tr });
    } else if (menuModel.deeplink != null) {
      launch(menuModel.deeplink!);
    } else if (menuModel.inAppBrowserUrl != null) {
      launch(menuModel.inAppBrowserUrl!,
          enableJavaScript: true, forceWebView: true, forceSafariVC: true, enableDomStorage: true);
    } else if (menuModel.webUrl != null) {
      launch(menuModel.webUrl!);
    } else if (menuModel.sms != null) {
      launch("sms:" + menuModel.sms!);
    } else if (menuModel.email != null) {
      launch("mailto:" + menuModel.email!);
    } else if (menuModel.call != null) {
      launch("tel:" + menuModel.call!);
    } else if (menuModel.child != null && callbackSubmenu != null) {
      callbackSubmenu();
      return;
    } else {
      dev.log('unknown navigation of ${menuModel.name} menu', name: HomeAppConfig.packageName);
    }
  }

  getCurrentDateStr() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd/MM/yyyy").format(now);
    return getDayNameStr(now.weekday) + ", " + formattedDate;
  }

  getDayNameStr(int weekday) {
    switch (weekday) {
      case 1:
        return "T2";
      case 2:
        return "T3";
      case 3:
        return "T4";
      case 4:
        return "T5";
      case 5:
        return "T6";
      case 6:
        return "T7";
      case 7:
        return "CN";
      default:
        return "T2";
    }
  }

  String getCurrentDateALStr() {
    DateTime now = DateTime.now();
    List<int> dateVi = LunarCalendarConverter.solarToLunar(now.year, now.month, now.day);
    return dateVi[0].toString() + " " + getMonthStr(dateVi[1]) + " - AL";
  }

  getMonthStr(int month) {
    switch (month) {
      case 1:
        return "thang mot".tr;
      case 2:
        return "thang hai".tr;
      case 3:
        return "thang ba".tr;
      case 4:
        return "thang tu".tr;
      case 5:
        return "thang nam".tr;
      case 6:
        return "thang sau".tr;
      case 7:
        return "thang bay".tr;
      case 8:
        return "thang tam".tr;
      case 9:
        return "thang chin".tr;
      case 10:
        return "thang muoi".tr;
      case 11:
        return "thang muoi mot".tr;
      case 12:
        return "thang muoi hai".tr;
      default:
        return "thang mot".tr;
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permissions are denied";
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (error) {
      throw "Get current position error !!!";
    }
  }

  Future<Map<String, dynamic>> getWeatherCurrentLocation() async {
    final GetStorage _storage = GetStorage(HomeAppConfig.packageName);
    Position position = await getCurrentLocation();
    await _storage.write('position', position);
    Response response = await VnccService().getWeather(latitude: position.latitude, longitude: position.longitude);
    dev.log(response.statusCode.toString(), name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw "Get weather error";
    }
  }

  checkAppInfoFromRemote() async {
    AppInfoModel appInfoModel = getAppInfoFromRemote();
    updateRequired.value = appInfoModel.updateRequired;
    List<int> versionRemoteParts = appInfoModel.version.split(".").map(int.parse).toList();
    List<int> appVersionParts = await getAppVersion();
    for (var index = 0; index < appVersionParts.length; index++) {
      if (appVersionParts[index] < versionRemoteParts[index]) {
        showUpdateDialog.value = true;
        return;
      }
      if (appVersionParts[index] > versionRemoteParts[index]) {
        return;
      }
    }
  }

  Future<List<int>> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageVersion = packageInfo.version;
    return packageVersion.split(".").map(int.parse).toList();
  }

  AppInfoModel getAppInfoFromRemote() {
    Map<String, dynamic> appInfo = GetStorage(HomeAppConfig.storageBox).read(HomeAppConfig.appStorageKey);
    return AppInfoModel.fromMap(appInfo);
  }
}
