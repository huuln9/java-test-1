import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_notification/src/config/app_config.dart';
import 'package:vncitizens_notification/src/config/firebase_options.dart';
import 'package:vncitizens_notification/src/model/place_model.dart';

class FcmUtil {
  static subscribe() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    for (var topic in AppConfig.fcmTopics) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    }
    String personalTopic = AuthUtil.userId ?? "";
    if (personalTopic != "") {
      await FirebaseMessaging.instance.subscribeToTopic(personalTopic);
    }
    await Hive.box(AppConfig.storageBox).put("unsubscribe", false);
  }

  static unsubscribe() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    for (var topic in AppConfig.fcmTopics) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
    String personalTopic = AuthUtil.userId ?? "";
    if (personalTopic != "") {
      await FirebaseMessaging.instance.unsubscribeFromTopic(personalTopic);
    }
    await Hive.box(AppConfig.storageBox).put("unsubscribe", true);
  }

  static bool isUnsubscribed() {
    return Hive.box(AppConfig.storageBox).get("unsubscribe") ?? false;
  }

  static List<String> get fcmTopics {
    List<String> topics = [...AppConfig.fcmTopics];

    if (AuthUtil.userId != null && AuthUtil.userId != '') {
      topics = [...topics, AuthUtil.userId!];
    }

    if (AuthUtil.placeId != null && AuthUtil.placeId != '') {
      topics = [...topics, AuthUtil.placeId!];
    }

    if (GetStorage(AppConfig.storageBox)
            .read(AppConfig.placeDetailResStorageKey) !=
        null) {
      PlaceModel place = PlaceModel.fromJson(GetStorage(AppConfig.storageBox)
          .read(AppConfig.placeDetailResStorageKey));
      for (var item in place.ancestors) {
        topics = [...topics, item.id];
      }
    }

    return topics;
  }
}
