import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_weather/src/config/app_config.dart';

import '../controller/weather_controller.dart';

class WeatherBodyTop extends GetView<WeatherController> {
  const WeatherBodyTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView( child:Column(
          children: [
            Container(
              width: 315.0,
              margin: const EdgeInsets.only(top: 16.0, left: 10),
              child: Obx(() => Text(
                    controller.locationName.value,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Color(0xFF333333),
                    ),
                  )),
            ),
            Container(
              width: 315.0,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                _getCurrentDateStr(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                  color: Color(0xFF828282),
                ),
              ),
            ),
            SizedBox(
              width: 315.0,
              child: Row(
                children: [
                  Container(
                      width: 70,
                      height: 70,
                      margin: const EdgeInsets.only(top: 5.0, right: 5.0),
                      child: Image(
                        image: AssetImage("${AppConfig.assetsRoot}/weather/" +
                            controller.iconWeather.value +
                            ".png"),
                        width: 70,
                        height: 70,
                      )),
                  Container(
                    width: 145,
                    margin: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            controller.celsiusStr.value + "\u2103",
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 30.0,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            controller.descriptionWeather.value,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: Color(0xFF828282),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: 25,
                      margin: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(),
                                    alignment: Alignment.topLeft,
                                    child: const Image(
                                        image: AssetImage(
                                            "${AppConfig.assetsRoot}/doam.png"),
                                        width: 20)),
                                Container(
                                    margin: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    alignment: Alignment.topLeft,
                                    child: const Image(
                                        image: AssetImage(
                                            "${AppConfig.assetsRoot}/windspeed.png"),
                                        width: 20))
                              ],
                            ),
                          ),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    controller.humidity.value + " %",
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Color(0xFF828282),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    controller.windSpeed.value + " m/s",
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Color(0xFF828282),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Container(
                width: 320,
                margin: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.getListChildren.length,
                        (index) {
                      return controller.loading.value
                          ? Container(
                              margin: const EdgeInsets.only(top: 100, left: 30),
                              child: const DataLoading(
                                  message: "Đang tải thời tiết"))
                          : Container(
                              width: 64,
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      _getParseHour(controller
                                          .getListChildren[index].timeChildren
                                          .toString()),
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                        color: Color(0xFF828282),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                        image: AssetImage(
                                            "${AppConfig.assetsRoot}/weather/" +
                                                controller
                                                    .getListChildren[index]
                                                    .iconChildren
                                                    .toString() +
                                                ".png"),
                                      )),
                                  Container(
                                    margin: const EdgeInsets.all(0.0),
                                    child: Text(
                                      controller.getListChildren[index]
                                              .temperatureChildren
                                              .toString() +
                                          "\u2103",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                ))
          ],
        )));
  }

  _getCurrentDateStr() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("dd/MM/yyyy").format(now);
    return _formatDate(now.weekday) + ", " + formattedDate;
  }

  _formatDate(int weekday) {
    switch (weekday) {
      case 1:
        return "T2";
      case 2:
        return "T3";
      case 3:
        return "T4";
      case 4:
        return "T5";
      case 5:
        return "T6";
      case 6:
        return "T7";
      case 7:
        return "CN";
      default:
        return "T2";
    }
  }
}

class ItemContent extends GetView<WeatherController> {
  const ItemContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      margin: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Text(
            _getParseHour(
                controller.getListChildren[0].timeChildren.toString()),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
              color: Color(0xFF828282),
            ),
          ),
          Container(
              width: 35,
              height: 35,
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              alignment: Alignment.topLeft,
              child: Image(
                image: AssetImage("${AppConfig.assetsRoot}/weather/" +
                    controller.getListChildren[0].iconChildren.toString() +
                    ".png"),
              )),
          Container(
            margin: const EdgeInsets.all(0.0),
            child: Text(
              controller.getListChildren[0].temperatureChildren.toString() +
                  "\u2103",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_getParseHour(dateStr) {
  DateTime dateTime = DateTime.parse(dateStr).toLocal();
  String formattedDate = DateFormat.Hm().format(dateTime);
  return formattedDate;
}
