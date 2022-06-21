import 'dart:developer' as dev;
import 'dart:developer';

import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/config/firebase_options.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';
import 'package:vncitizens_notification/src/model/place_model.dart';
import 'package:vncitizens_notification/vncitizens_notification.dart';

final notificationCounterController = Get.put(NotificationCounterController());
final notificationController = Get.put(NotificationController());
final localNotificationPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
  'vncitizens_channel',
  'vnCitizens Channel Notifications',
  description: 'This channel is vnCitizens Notifications',
  importance: Importance.high,
);

initFirebase() async {
  if (!FcmUtil.isUnsubscribed()) {
    dev.log(
        'initialize firebase, current platform: ${DefaultFirebaseOptions.currentPlatform}',
        name: AppConfig.packageName);
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    /// subscribe to default topic
    for (var topic in AppConfig.fcmTopics) {
      log("subscribe to for topic: " + topic);
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    }

    /// subscribe to personal topic
    String personalTopic = AuthUtil.userId ?? "";
    if (personalTopic != "") {
      log("subscribe to for personal topic: " + AuthUtil.userId!);
      await FirebaseMessaging.instance.subscribeToTopic(personalTopic);
    }

    /// subscribe to for area topic
    if (AuthUtil.placeId != null) {
      await FirebaseMessaging.instance.subscribeToTopic(AuthUtil.placeId!);
      log("subscribe to for area topic: " + AuthUtil.placeId!);
      LocationService()
          .getPlaceById(id: AuthUtil.placeId!)
          .then((response) async {
        if (response.statusCode == 200) {
          dev.log(response.body.toString(),
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
          PlaceModel place = PlaceModel.fromJson(response.body);
          GetStorage(AppConfig.storageBox)
              .write(AppConfig.placeDetailResStorageKey, response.body);
          for (var item in place.ancestors) {
            await FirebaseMessaging.instance.subscribeToTopic(item.id);
            log("subscribe to for area topic: " + item.id);
          }
        } else {
          dev.log("Get place failed",
              name: CommonUtil.getCurrentClassAndFuncName(StackTrace.current));
        }
      });
    }
    _initLocalNotification();

    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    FirebaseMessaging.instance.requestPermission();

    // handle background message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // foreground
    FirebaseMessaging.onMessage.listen(_onMessage);
  }
}

/// handler message in foreground
Future _initLocalNotification() async {
  const android = AndroidInitializationSettings('app_icon');
  const iOS = IOSInitializationSettings();
  const settings = InitializationSettings(android: android, iOS: iOS);
  await localNotificationPlugin.initialize(settings,
      onSelectNotification: (payload) async {
    notificationCounterController.setNum(1);
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // notificationCounterController.setNum(1);
  notificationController.refreshFcmList();
  // notificationController.getFcmByReceiver();
}

/// handler message in foreground
_onMessage(RemoteMessage message) {
  notificationCounterController.setNum(1);
  notificationController.refreshFcmList();

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    localNotificationPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                androidChannel.id, androidChannel.name,
                channelDescription: androidChannel.description,
                importance: Importance.max,
                icon: 'app_icon'),
            iOS: const IOSNotificationDetails()));
  }
}
