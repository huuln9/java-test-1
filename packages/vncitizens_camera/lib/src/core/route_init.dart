import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import 'package:vncitizens_camera/src/binding/all_binding.dart';
import 'package:vncitizens_camera/src/config/camera_route_config.dart';
import 'package:vncitizens_camera/src/widget/camera_list.dart';
import 'package:vncitizens_camera/src/widget/camera_live.dart';
import 'package:vncitizens_camera/src/widget/camera_map.dart';

/// init application routes
initAppRoute() async {
  GetPageCenter.add(GetPage(name: CameraRouteConfig.listRoute, page: () => const CameraList(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: CameraRouteConfig.liveRoute, page: () => const CameraLive(), binding: AllBinding()));
  GetPageCenter.add(GetPage(name: CameraRouteConfig.mapRoute, page: () => const CameraMap(), binding: AllBinding()));
}
