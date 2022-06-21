import 'dart:developer' as dev;

import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_queue/src/binding/queue_binding.dart';
import 'package:vncitizens_queue/src/widget/queue.dart';
import 'package:vncitizens_queue/src/widget/queue_detail.dart';

import '../config/app_config.dart';
import '../config/route_config.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(GetPage(name: RouteConfig.listRoute, page: () => const Queue(), binding: QueueBinding()));
  GetPageCenter.add(GetPage(name: RouteConfig.detailRoute, page: () => const QueueDetail(), binding: QueueBinding()));

}
