import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_notification/src/controller/notification_controller.dart';
import 'package:vncitizens_notification/src/widget/pages/index/notification_list_default_app_bar.dart';
import 'package:vncitizens_notification/src/widget/pages/index/notification_list_selector_app_bar.dart';

class NotificationListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationController controller = Get.put(NotificationController());
    return Obx(() {
      if (controller.isSelectedMode.value) {
        return NotificationListSelectorAppBar();
      } else {
        if (controller.notifications.isNotEmpty) {
          return NotificationListDefaultAppBar();
        } else {
          return const NotificationNoneAppBar();
        }
      }
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class NotificationNoneAppBar extends StatelessWidget {
  const NotificationNoneAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("thong bao".tr, style: AppBarStyle.title),
      backgroundColor: Colors.blue.shade800,
    );
  }
}
