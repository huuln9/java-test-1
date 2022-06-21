import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_weather/src/widget/weather_body.dart';
import '../controller/weather_controller.dart';

class Weather extends GetView<WeatherController
> {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("du bao thoi tiet".tr)),
      body: const WeatherBody(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const MyBottomAppBar(index: -1),
    );
  }
}
