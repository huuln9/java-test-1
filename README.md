# flutter_app_template

Flutter App Template

## Tính năng

* Tổ chức mã nguồn tối ưu nhất
* Cấu trúc multi-packages
* Thống nhất một số nguyên tắc chung (xem bên dưới)
* Có sẳn cơ chế xử lý lỗi tập trung
* Có sẳn splash screen
* Có sẳn remote configuration (tải cấu hình qua URL)
* Cấu trúc mẫu sử dụng Getx cho State Management, Đa ngôn ngữ, Local Storage, Route và gọi RestAPI
* Hướng dẫn sử dụng Hive cho local database
* Hướng dẫn sử dụng Firebase Cloud Messaging

## Nguyên tắc chung

* Thư mục assets được đặt bên dưới thư mục lib. Tham khảo cách khai báo assets file
  tại [pubspec.yaml](pubspec.yaml).
* Việc cấu hình toàn bộ được thực hiện thông qua Dart class (thư mục config).
* Package digo_common để chứa các mã nguồn chung cho toàn bộ sản phẩm mobile
* Package vncitizens_common để chứa các mã nguồn dùng chung cho sản phẩm vncitizens (tạo tương tự
  cho các sản phẩm khác nếu cần)
* Sử dụng DetailsException để truyền thêm dữ liệu kèm theo
* Log name là tên package hoặc app. Ví dụ: `vncitizens_home`.
* Box name (container name) của GetStorage đặt theo tên của package hoặc app hiện hành, key đặt theo
  quy tắc snake_case. Ví dụ: 'menu_data'
* Mỗi package có một hàm init riêng để phục vụ cho việc thiết lập dữ liệu, cấu hình đa ngôn ngữ, ...
* Dữ liệu cấu hình (remote config) được lưu bằng GetStorage theo box là mã tham số, key là giá trị
  của `AppConfig.defaultConfigKey`. Nếu muốn custom key, hãy đặt mã tham số theo cấu
  trúc `box_name.key_name`, ví dụ `vncitizens_home.menu_config`. Giá trị của key là giá trị của tham
  số cấu hình.
* Nên sử dụng cùng một phiên bản của các dependencies giữa các packages.
* Luôn sử dụng prefix với tên package cho routes của packages, đối với app không bắt buộc prefix vì
  đã set host và scheme khi enable deeplink.
* Tên route luôn đặt theo quy tắc snake_case
* Đối với package chỉ thực hiện export các classes, functions, variables cần thiết theo quy hoạch
  của dự án. Trong hầu hết các trường hợp chỉ cần export file `package_init.dart`.
* Asset resource được khai báo trong `pubspec.yaml` dưới dạng package path (liệt kê toàn bộ assets
  sử dụng), không sử dụng đường dẫn tương đối hoặc pattern. Ví
  dụ `packages/vncitizens_home/assets/logo.png`.
* Đa ngôn ngữ sử dụng Getx, translation key đặt theo quy tắc viết thường, không dấu, cách nhau bởi
  khoảng trắng. Ví dụ: `{'ung dung': 'Ứng dụng'}`

## Hướng dẫn tạo project

Hướng dẫn tạo application project theo kiến trúc multi-packages (modular).

## Tạo application project

Tạo Flutter application:

```shell
flutter create project_folder --org=vn.vnpt.digo.appname --project-name=project_name --platform=android,ios
```

> CHÚ Ý: Không đặt giá trị của `--org` có chứa ký tự in hoa hoặc dấu gạch dưới vì sẽ bị lỗi ở một số trường hợp.
> Thông thường `project_folder` và `project_name` là giống nhau.

### Thêm một số dependencies

Tại file `pubspec.yaml` của application vừa tạo thêm các dependencies:

```yaml
digo_common:
  git: https://scm.devops.vnpt.vn/egov.pm4.digo/flutter_common.git
iscs_common:
  git: https://scm.devops.vnpt.vn/egov.pm4.digo/flutter_iscs_common.git
get: ^4.5.1
flutter_native_splash: ^1.3.2
get_storage: ^2.0.3
```

Tải dependencies:

```shell
flutter pub get
```

### Tạo thư mục assets

Tạo thư mục `assets` bên dưới thư mục `lib` và khai báo các assets cần thiết (nếu có) trong
file `pubspec.yaml`.

### Thiết lập splash screen

Tạo file `flutter_native_splash.yaml` với nội dung như dưới đây và điều chỉnh các cấu hình phù hợp:

```yaml
flutter_native_splash:

  # This package generates native code to customize Flutter's default white native splash screen
  # with background color and splash image.
  # Customize the parameters below, and run the following command in the terminal:
  # flutter pub run flutter_native_splash:create
  # To restore Flutter's default white splash screen, run the following command in the terminal:
  # flutter pub run flutter_native_splash:remove

  # color or background_image is the only required parameter.  Use color to set the background
  # of your splash screen to a solid color.  Use background_image to set the background of your
  # splash screen to a png image.  This is useful for gradients. The image will be stretch to the
  # size of the app. Only one parameter can be used, color and background_image cannot both be set.
  color: "#f1f1f1"
  #background_image: "lib/assets/background.png"

  # Optional parameters are listed below.  To enable a parameter, uncomment the line by removing
  # the leading # character.

  # The image parameter allows you to specify an image used in the splash screen.  It must be a
  # png file and should be sized for 4x pixel density.
  image: lib/assets/logo/vnpt-blue.png

  # The color_dark, background_image_dark, and image_dark are parameters that set the background
  # and image when the device is in dark mode. If they are not specified, the app will use the
  # parameters from above. If the image_dark parameter is specified, color_dark or
  # background_image_dark must be specified.  color_dark and background_image_dark cannot both be
  # set.
  #color_dark: "#042a49"
  #background_image_dark: "assets/dark-background.png"
  #image_dark: assets/splash-invert.png

  # The android, ios and web parameters can be used to disable generating a splash screen on a given
  # platform.
  #android: false
  #ios: false
  #web: false

  # The position of the splash image can be set with android_gravity, ios_content_mode, and
  # web_image_mode parameters.  All default to center.
  #
  # android_gravity can be one of the following Android Gravity (see
  # https://developer.android.com/reference/android/view/Gravity): bottom, center,
  # center_horizontal, center_vertical, clip_horizontal, clip_vertical, end, fill, fill_horizontal,
  # fill_vertical, left, right, start, or top.
  #android_gravity: center
  #
  # ios_content_mode can be one of the following iOS UIView.ContentMode (see
  # https://developer.apple.com/documentation/uikit/uiview/contentmode): scaleToFill,
  # scaleAspectFit, scaleAspectFill, center, top, bottom, left, right, topLeft, topRight,
  # bottomLeft, or bottomRight.
  #ios_content_mode: center
  #
  # web_image_mode can be one of the following modes: center, contain, stretch, and cover.
  #web_image_mode: center

  # To hide the notification bar, use the fullscreen parameter.  Has no affect in web since web
  # has no notification bar.  Defaults to false.
  # NOTE: Unlike Android, iOS will not automatically show the notification bar when the app loads.
  #       To show the notification bar, add the following code to your Flutter app:
  #       WidgetsFlutterBinding.ensureInitialized();
  #       SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  #fullscreen: true

  # If you have changed the name(s) of your info.plist file(s), you can specify the filename(s)
  # with the info_plist_files parameter.  Remove only the # characters in the three lines below,
  # do not remove any spaces:
  #info_plist_files:
  #  - 'ios/Runner/Info-Debug.plist'
  #  - 'ios/Runner/Info-Release.plist'
```

Áp dụng cấu hình:

```shell
flutter pub run flutter_native_splash:create
```

> Tham khảo thêm tại https://pub.dev/packages/flutter_native_splash

### Tạo cấu hình chung

Tạo file application config  `lib/src/config/app_config.dart` và điều chỉnh các tham số cho phù hợp:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppConfig {

  //--------------------------------------------
  // REQUIRED UPDATE
  //--------------------------------------------

  /// package name
  static const String packageName = "project_name";

  /// the base url of ISCS APIs
  static const String iscsBaseUrl = "https://iscsapidev.digigov.vn";

  /// deployment id (tenant id)
  static const String deploymentId = "master";


  //--------------------------------------------
  // OPTIONAL UPDATE
  //--------------------------------------------

  /// initial route
  static const String initialRoute = '/home';

  /// config code 
  static const String configCode = packageName;

  /// default locale
  static const locale = Locale('vi');

  /// fallback locale
  static const fallbackLocale = Locale('en');

  /// storage box
  static const String storageBox = packageName;

  /// default transition
  static const Transition defaultTransition = Transition.fadeIn;

  /// config key
  static const String defaultConfigKey = 'remote_config';

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

}

```

Tạo file package config  `lib/src/config/package_config.dart` như bên dưới và điều chỉnh code thiết
lập các package cho phù hợp.

```dart
import 'app_config.dart';
import 'dart:developer' as dev;

//import 'package:vncitizens_home/vncitizens_home.dart' as vncitizens_home;
//import 'package:vncitizens_taikhoan_canhan/vncitizens_taikhoan_canhan.dart' as vncitizens_taikhoan_canhan;
//import 'package:flutter_package_template/vncitizens_notification.dart' as flutter_package_template;

/// List of packages that app need to initialize
initPackages() async {
  dev.log('initialize packages', name: AppConfig.packageName);

  /// Add your package initialization
  //await vncitizens_home.initPackage();
  //await flutter_package_template.initPackage();
  //await vncitizens_taikhoan_canhan.initPackage();
}
```

### Tạo cấu hình đã ngôn ngữ

Tạo file cấu hình đa ngôn ngữ cho Tiếng Việt `lib/src/translation/vi_translation.dart`:

```dart
import 'package:get/get.dart';

class ViTranslation extends Translations {

  @override
  Map<String, Map<String, String>> get keys =>
      {
        "vi": {
          "ung dung": "Ứng dụng"
        }
      };
}
```

Tạo file cấu hình đa ngôn ngữ cho Tiếng Anh `lib/src/translation/en_translation.dart`:

```dart
import 'package:get/get.dart';

class EnTranslation extends Translations {

  @override
  Map<String, Map<String, String>> get keys =>
      {
        "en": {
          "ung dung": "Application"
        }
      };
}
```

> Thêm các ngôn ngữ khác nếu cần. Lưu ý quy tắc đặt translation key (xem tại phần Nguyên tắc chung).

### Thiết lập luồng khởi động

Tạo file xử lý lỗi tập trung  `lib/src/core/errors_handler.dart`:

```dart
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

initAppErrorHandler() async {
  dev.log("initialize error handler", name: AppConfig.packageName);
}

class AppErrorHandler {
  static onError({FlutterErrorDetails? details, StackTrace? stack, Object? object}) {
    dev.log("an error has occurs", name: AppConfig.packageName);
    if (details != null) {
      dev.log("error details: " + details.toString(), name: AppConfig.packageName);
    }
    if (stack != null) {
      dev.log("error stack: " + stack.toString(), name: AppConfig.packageName);
    }
    if (object != null) {
      dev.log("error class: " + object.runtimeType.toString(), name: AppConfig.packageName);
      dev.log("error object: " + object.toString(), name: AppConfig.packageName);
    }
  }
}

```

Tạo file thiết lập đa ngôn ngữ  `lib/src/core/translation_init.dart`:

```dart
import '../config/app_config.dart';
import '../translation/en_translation.dart';
import '../translation/vi_translation.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

/// Getx translation config together in app
/// does not include from other packages
initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(EnTranslation().keys);
  Get.appendTranslations(ViTranslation().keys);
}

```

Tạo file thiết lập route  `lib/src/core/route_init.dart`:

```dart
import 'dart:developer' as dev;
import '../config/app_config.dart';

initAppRoute() {
  dev.log('initialize route', name: AppConfig.packageName);

  // Add your application route here
  //GetPageCenter.add(GetPage(name: '/setting', page: () => Setting()));
}

```

Tạo file thiết lập config  `lib/src/core/app_config_init.dart`:

```dart
import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import '../config/app_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

initAppConfig() async {
  dev.log('initialize config', name: AppConfig.packageName);
  ConfigService configService = ConfigService();
  configService.baseUrl = AppConfig.iscsBaseUrl;
  Response response = await configService.getPublicConfigurationAsKeyValue([AppConfig.configCode],
      deploymentId: AppConfig.deploymentId);

  if (response.statusCode == 200) {
    dev.log('load remote config with response body: ${response.body}', name: AppConfig.packageName);
    _storeRemoteConfig(response.body?[AppConfig.configCode]?["parameters"]);
  } else {
    throw DetailsException("Failed to load application config",
        details: {'responseCode': response.statusCode, 'responseBody': response.bodyString});
  }
}

_storeRemoteConfig(dynamic config) {
  if (config is Map) {
    config.forEach((key, value) {
      var arr = key.toString().split(".");
      var boxName = arr.first;
      var storeKey = arr.length != 2 || arr[1].isEmpty ? AppConfig.defaultConfigKey : arr[1];
      dev.log('store remote config box $boxName, key $storeKey,  value: $value',
          name: AppConfig.packageName);
      GetStorage(boxName).write(storeKey, value);
    });
  } else {
    dev.log('remote config is not stored because it is not a map or empty',
        name: AppConfig.packageName);
  }
}

```

Tạo file thiết lập ứng dụng  `lib/src/core/app_init.dart`:

```dart
import 'dart:developer' as dev;

import '../config/app_config.dart';
import '../config/package_config.dart';
import '../core/errors_handler.dart';
import '../core/translation_init.dart';
import 'package:get_storage/get_storage.dart';

import 'app_config_init.dart';

Future initApp() async {
  dev.log("initialize application", name: AppConfig.packageName);
  await GetStorage.init();
  await initAppErrorHandler();
  await initAppTranslation();
  await initAppConfig();
  await initPackages();
}

```

Tạo wigdet gốc cho ứng dụng `lib/src/widget/app.dart`:

```dart
import 'package:digo_common/digo_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';

class DigoApp extends StatelessWidget {
  const DigoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: AppConfig.initialRoute,
        defaultTransition: AppConfig.defaultTransition,
        locale: AppConfig.locale,
        fallbackLocale: AppConfig.fallbackLocale,
        getPages: GetPageCenter.pages,
        translationsKeys: Get.translations);
  }
}
```

Ghi đè lại file `lib/main.dart` với nội dung:

```dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'src/core/app_init.dart';
import 'src/core/errors_handler.dart';
import 'src/widget/app.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initApp();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      AppErrorHandler.onError(details: details);
      exit(1);
    };
    runApp(const DigoApp());
  }, (Object error, StackTrace stack) {
    AppErrorHandler.onError(object: error, stack: stack);
    exit(1);
  });
}
```

### Thiết lập FCM (tùy chọn)

> Việc thiết lập FCM chỉ thực hiện duy nhất ở application, không thực hiện ở package.
> Thiết lập FCM là không bắt buộc, tùy thuộc vào nhu cầu phát triển của ứng dụng.

Tại file `pubspec.yaml` của application thêm dependencies:

```yaml
firebase_core: ^1.10.6
firebase_messaging: ^11.2.4
```

Tải dependencies:

```shell
flutter pub get
```

Cài đặt Firebase CLI bằng npm (nếu đã cài rồi thì bỏ qua):

```shell
npm install -g firebase-tools
```

> Tham khảo chi tiết hướng dẫn tại https://firebase.google.com/docs/cli

Thiết lập FlutterFire (nếu đã thiết lập rồi thì bỏ qua):

```shell
dart pub global activate flutterfire_cli
```

Generate cấu hình cho FCM:

```shell
# Thực thi bên dưới thư mục gốc của application và cung cấp các thông tin phù hợp theo yêu cầu của lệnh
flutterfire configure --out=lib/src/config
```

> Nếu lệnh thực thi thành công sẽ tự động sinh ra file `lib/src/config/firebase_options.dart`

Bổ sung thêm tham số cấu hình các topic subscribe vào file `lib/src/config/app_config.dart`

```dart
class AppConfig {

  //--------------------------------------------
  // REQUIRED UPDATE
  //--------------------------------------------

  /// FCM: subscribe to topics
  static const List<String> fcmSubscribeTopics = ["topic1", "topic2"];

}

```

Tạo file thiết lập FCM `lib/src/core/firebase_init.dart`:

```dart
import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../config/app_config.dart';
import '../config/firebase_options.dart';

/// handler message in foreground
_onMessage(RemoteMessage message) {
  // Add your code here...
}

/// handler message in background or terminated
_onBackgroundMessage(RemoteMessage message) {
  // Add your code here...
}

initFirebase() async {
  dev.log('initialize firebase, current platform: ${DefaultFirebaseOptions.currentPlatform}',
      name: AppConfig.packageName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// handler message in background or terminated
  Future<void> _firebaseBackgroundMessagePreHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    _onBackgroundMessage(message);
  }

  /// request permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  dev.log('user granted permission: ${settings.authorizationStatus}', name: AppConfig.packageName);

  /// foreground
  FirebaseMessaging.onMessage.listen(_onMessage);

  /// background and terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessagePreHandler);

  /// subscribe to topic
  for (var topic in AppConfig.fcmSubscribeTopics) {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
```

Thêm code xử lý cho phù hợp vào 2 hàm `_onMessage` (foreground) và `_onBackgroundMessage` (background hoặc terminated).

### Cập nhật tài liệu

Cập nhật README.md:

* Tên application cùng mô tả ngắn
* Các tính năng
* Các hướng dẫn liên quan

## Tạo package project trong application project

Hướng dẫn thực hiện tạo package bên trong application với tên package minh họa là `package_name`.

### Tạo package

```bash
flutter create packages/package_name --template=package --platform=android,ios
```

Package với tên `package_name` được tạo ra bên dưới thư mục `packages`.

> Các hướng dẫn tiếp theo bên dưới, thư mục gốc mặc định được hiểu là `packages/package_name`.

### Thêm một số dependencies

Tại file `pubspec.yaml` của package vừa tạo thêm các dependencies:

```yaml
get: ^4.5.1
digo_common:
  git: https://scm.devops.vnpt.vn/egov.pm4.digo/flutter_common.git
```

Tải dependencies:

```shell
flutter pub get
```

### Tạo thư mục assets

Tạo thư mục `assets` bên dưới thư mục `lib` của package vừa tạo và thêm các file cần thiết (nếu có).

### Tạo cấu hình chung

Tạo file application config  `lib/src/config/app_config.dart` và điều chỉnh các tham số cho phù hợp:

```dart
import 'package:get_storage/get_storage.dart';
import 'dart:developer' as dev;

class AppConfig {

  // ------------------------------------
  // REQUIRED UPDATE
  // ------------------------------------

  /// your package name
  static const String packageName = "package_name";

  // ------------------------------------
  // OPTIONAL UPDATE
  // ------------------------------------

  /// the assets root folder
  static const String assetsRoot = "packages/$packageName/assets";

  /// storage box name
  static const String storageBox = packageName;

  // add more property

}
```

### Tạo cấu hình đã ngôn ngữ

Tạo file cấu hình đa ngôn ngữ cho Tiếng Việt `lib/src/translation/vi_translation.dart`:

```dart
import 'package:get/get.dart';

class ViTranslation extends Translations {

  @override
  Map<String, Map<String, String>> get keys =>
      {
        "vi": {
          "xin chao": "Xin chào!"
        }
      };
}
```

Tạo file cấu hình đa ngôn ngữ cho Tiếng Anh `lib/src/translation/en_translation.dart`:

```dart
import 'package:get/get.dart';

class EnTranslation extends Translations {

  @override
  Map<String, Map<String, String>> get keys =>
      {
        "en": {
          "xin chao": "Hello!"
        }
      };
}
```

> Thêm các ngôn ngữ khác nếu cần. Lưu ý quy tắc đặt translation key (xem tại phần Nguyên tắc chung).

### Thiết lập luồng khởi động

Tạo file thiết lập đa ngôn ngữ `lib/src/core/translation_init.dart`:

```dart
import 'dart:developer' as dev;

import 'package:get/get.dart';

import '../config/app_config.dart';
import '../translation/en_translation.dart';
import '../translation/vi_translation.dart';

initAppTranslation() async {
  dev.log('initialize translation', name: AppConfig.packageName);
  Get.appendTranslations(ViTranslation().keys);
  Get.appendTranslations(EnTranslation().keys);
}

```

Tạo file thiết lập route `lib/src/core/route_init.dart`:

```dart
import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  // GetPageCenter.add(GetPage(name: '/vncitizens_home', page: () => const Home()));
}
```

Tạo file thiết lập package `lib/src/core/package_init.dart`:

```dart
import 'dart:developer' as dev;

import '../config/app_config.dart';
import '../core/route_init.dart';
import '../core/translation_init.dart';

/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);
  await initAppTranslation();
  await initAppRoute();
}

```

### Cập nhật tài liệu

Cập nhật README.md:

* Tên application cùng mô tả ngắn
* Các hướng dẫn liên quan

Cập nhật CHANGELOG.md:

* Cập nhật verion cùng các tính năng (append mới, không xóa version cũ)

## Thiết lập Hive (tùy chọn)

Việc thiết lập Hive để sử dụng trong application hoặc package là không bắt buộc, hầu hết các sản
phẩm hiện tại chưa cần thiết lập Hive trong application mà sử dụng nhiều ở package.

Tại file `pubspec.yaml` của application hoặc package thêm dependencies:

```yaml
hive: ^2.0.5
path_provider: ^2.0.8
```

> Package `path_provider` phục vụ cho việc lấy đường dẫn thư mục lưu dữ liệu của Hive.

Tải dependencies:

```shell
flutter pub get
```

Cuối cùng, bổ sung đoạn code bên dưới để thiết lập Hive vào hàm `initPackage` (nên thêm vào trên
cùng của hàm) trong file `lib/src/core/package_init.dart`:

```dart
/// init data, translation, routes and more
initPackage() async {
  dev.log('initialize package', name: AppConfig.packageName);

  // BEGIN: Code for initializing Hive
  var tmpDir = await getTemporaryDirectory();
  dev.log('initialize Hive in directory ${tmpDir.path}', name: AppConfig.packageName);
  await Hive.openBox(AppConfig.storageBox, path: tmpDir.path);
  // END: Code for initializing Hive

  await initAppTranslation();
  await initAppRoute();
}
```

> Tham khảo thêm tại https://pub.dev/packages/hive.