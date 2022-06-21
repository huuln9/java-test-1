import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_garbage_schedule/src/widget/garbage_schedule_body.dart';

class GarbageSchedule extends StatelessWidget {
  const GarbageSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("lich thu gom rac".tr)),
      body: GarbageScheduleBody(),
      resizeToAvoidBottomInset: false,
      // floatingActionButton: const MyFloatingActionButton(),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }
}
