import 'dart:developer' as dev;
import 'package:digo_common/digo_common.dart';
import 'package:get/get.dart';
import '../binding/weather_binding.dart';
import '../config/app_config.dart';
import '../config/route_config.dart';
import '../widget/weather.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: AppConfig.packageName);
  GetPageCenter.add(GetPage(name: RouteConfig.listRoute, page: () => const Weather(), binding: WeatherBinding()));

}
