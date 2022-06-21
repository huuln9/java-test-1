import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'package:vncitizens_queue/src/widget/queue_detail_body.dart';

class QueueDetail extends StatelessWidget {
  const QueueDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("so thu tu nop ho so".tr)),
        body: const QueueDetailBody(),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: const MyBottomAppBar(index: -1),
      ),
    );
  }
}
