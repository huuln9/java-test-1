import 'package:vncitizens_common/vncitizens_common.dart';

class AppConfig {
  /// your package template
  static const String packageName = "vncitizens_notification";

  /// storage box name
  static const String storageBox = packageName;

  static const String fcmTopicsStorageKey = "fcmTopics";
  static const String placeDetailResStorageKey = "placeDetailRes";
  static const String targetAndroidStorageKey = "targetAndroid";
  static const String targetIOSStorageKey = "targetIOS";

  // Add more config properties...
  static List<String> get fcmTopics {
    return GetStorage(storageBox).read(fcmTopicsStorageKey) != null
        ? List.from(GetStorage(storageBox).read(fcmTopicsStorageKey))
        : ["notification"];
  }

  static FirebaseOptions get targetAndroid {
    var platform = GetStorage(storageBox).read(targetAndroidStorageKey);
    if (platform != null) {
      return FirebaseOptions(
          apiKey:
              platform['apiKey'] ?? 'AIzaSyAKbM5YACPt_tq5buYL0T8wLYL1dG5Q06U',
          appId: platform['appId'] ??
              '1:1087247083218:android:837da16239f08cb089af0b',
          messagingSenderId: platform['messagingSenderId'] ?? '1087247083218',
          projectId: platform['projectId'] ?? 'vncitizens-1',
          storageBucket:
              platform['storageBucket'] ?? 'vncitizens-1.appspot.com');
    } else {
      return const FirebaseOptions(
          apiKey: 'AIzaSyAKbM5YACPt_tq5buYL0T8wLYL1dG5Q06U',
          appId: '1:1087247083218:android:837da16239f08cb089af0b',
          messagingSenderId: '1087247083218',
          projectId: 'vncitizens-1',
          storageBucket: 'vncitizens-1.appspot.com');
    }
  }

  static FirebaseOptions get targetIOS {
    var platform = GetStorage(storageBox).read(targetIOSStorageKey);
    if (platform != null) {
      return FirebaseOptions(
        apiKey: platform['apiKey'] ?? 'AIzaSyBpOSVTT2xkTjH1SsXV6xoVdhO070RwQmQ',
        appId:
            platform['appId'] ?? '1:1087247083218:ios:591a615b238ea0fc89af0b',
        messagingSenderId: platform['messagingSenderId'] ?? '1087247083218',
        projectId: platform['projectId'] ?? 'vncitizens-1',
        storageBucket: platform['storageBucket'] ?? 'vncitizens-1.appspot.com',
        iosClientId: platform['iosClientId'] ??
            '1087247083218-g5kd80f5ql0g1khoflrsidkil6k0c9a8.apps.googleusercontent.com',
        iosBundleId:
            platform['iosBundleId'] ?? 'vn.vnpt.digo.vncitzens.flutter.app.dev',
      );
    } else {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBpOSVTT2xkTjH1SsXV6xoVdhO070RwQmQ',
        appId: '1:1087247083218:ios:591a615b238ea0fc89af0b',
        messagingSenderId: '1087247083218',
        projectId: 'vncitizens-1',
        storageBucket: 'vncitizens-1.appspot.com',
        iosClientId:
            '1087247083218-g5kd80f5ql0g1khoflrsidkil6k0c9a8.apps.googleusercontent.com',
        iosBundleId: 'vn.vnpt.digo.vncitzens.flutter.app.dev',
      );
    }
  }
}
