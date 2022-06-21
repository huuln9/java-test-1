import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'notification_list_app_bar.dart';
import 'notification_list_body.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: NotificationListAppBar(),
        body: NotificationListBody(),
        bottomNavigationBar: MyBottomAppBar(index: 1));
  }
}
