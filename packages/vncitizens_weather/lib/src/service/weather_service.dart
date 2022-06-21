import 'dart:developer';

import 'package:get/get_connect/connect.dart';

import '../config/app_config.dart';


class WeatherService extends GetConnect {
  Future<Response> getWeather({required double latitude, required double longitude}) async {
    Map<String, String> headers = {'Authorization': 'Bearer ${AppConfig.accessToken}'};
    return await get("${AppConfig.vnccApiEndpoint}/vncc/weather?latitude=$latitude&longitude=$longitude", headers: headers);
  }
}
