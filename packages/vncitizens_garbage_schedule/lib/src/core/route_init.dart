import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:vncitizens_garbage_schedule/src/binding/garbage_schedule_binding.dart';
import 'package:vncitizens_garbage_schedule/src/widget/garbage_schedule.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(
    GetPage(
      name: '/vncitizens_garbage_schedule',
      page: () => const GarbageSchedule(),
      binding: GarbageScheduleBinding(),
    ),
  );
}
