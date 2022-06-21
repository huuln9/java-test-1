import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_queue/src/widget/queue_body.dart';

class Queue extends StatelessWidget {
  const Queue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("lay so thu tu nop ho so".tr)),
      body: const QueueBody(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }


}
