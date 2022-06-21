import 'package:vncitizens_notification/src/model/fcm_content_model.dart';

class NotificationSelectorModel {
  NotificationSelectorModel({required this.data, this.isSelected = false});

  late FcmContentModel data;
  late bool isSelected;
}
