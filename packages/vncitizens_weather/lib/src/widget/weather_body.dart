import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_weather/src/config/app_config.dart';
import 'package:vncitizens_weather/src/widget/weather_body_bottom.dart';
import 'package:vncitizens_weather/src/widget/weather_body_top.dart';

import '../controller/weather_controller.dart';

class WeatherBody extends GetView<WeatherController> {
  const WeatherBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(WeatherController());
    final _internetController = Get.put(InternetController());
    return Obx(() => _internetController.hasConnected.value ? Stack(
      children: [
        controller.loading.value
            ? Container(
            child: DataLoading(message: "dang tai thoi tiet".tr)
        )
            :
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("${AppConfig.assetsRoot}/success.png"),
                fit: BoxFit.cover,
              ),
            ),
            child:  Center(
              // child: Positioned(
                child: Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    width: 343.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(children: const [WeatherBodyTop()]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    width: 343.0,
                    height: 417.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Row(children: const [WeatherBodyBottom()]),
                  ),
                ])),
            // ),
          ),
        )
      ],
    )
        : NoInternet(
      onPressed: () {
        _controller.onInit();
      },
    ));
  }
}
