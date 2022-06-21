import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_weather/src/config/app_config.dart';
import '../controller/weather_controller.dart';

class WeatherBodyBottom extends GetView<WeatherController> {
  const WeatherBodyBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: List.generate(controller.getListFeature.length, (index) {
            return  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 15.0,
                          left: 16.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 315.0,
                              child: Text(
                                _getParseDateTime(controller
                                    .getListFeature[index].feaTime
                                    .toString()),
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                            Container(
                              width: 315.0,
                              child: Row(
                                children: [
                                  Container(
                                      width: 50,
                                      height: 40,
                                      alignment: Alignment.topLeft,
                                      child: Image(
                                        image: AssetImage(
                                            "${AppConfig.assetsRoot}/weather/" +
                                                    controller
                                                        .getListFeature[index]
                                                        .feaIcon
                                                        .toString() +
                                                    ".png"),
                                      )),
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.getListFeature[index]
                                              .feaTemperature
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
                                  Container(
                                    width: 80,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "(" +
                                          controller.getListFeature[index]
                                              .feaMinTemperature
                                              .toString() +
                                          "\u2103" +
                                          " - " +
                                          controller.getListFeature[index]
                                              .feaMaxTemperature
                                              .toString() +
                                          "\u2103" +
                                          ")",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      controller
                                              .getListFeature[index].feaHumidity
                                              .toString() +
                                          "%",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      controller
                                              .getListFeature[index].feaWinSpeed
                                              .toString() +
                                          " m/s",
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
                              padding: const EdgeInsets.all(3.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Color(0xFFC4C4C4)))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ));
  }

  _getParseDateTime(dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    String formattedDate = DateFormat("dd/MM/yyyy").format(dateTime);
    return _formatDate(dateTime.weekday) + ", " + formattedDate;
  }

  _formatDate(int weekday) {
    switch (weekday) {
      case 1:
        return "Thứ hai";
      case 2:
        return "Thứ ba";
      case 3:
        return "Thứ tư";
      case 4:
        return "Thứ năm";
      case 5:
        return "Thứ sáu";
      case 6:
        return "Thứ bảy";
      case 7:
        return "Chủ nhật";
      default:
        return "Thứ hai";
    }
  }
}
